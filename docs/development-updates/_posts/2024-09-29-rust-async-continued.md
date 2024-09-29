---
layout: post
title: Async Rust (Part 3?)
---

We are now using the [Service trait from
Tokio](https://tokio.rs/blog/2021-05-14-inventing-the-service-trait)
via the [tower crate](https://crates.io/crates/tower) for writing
async code in [FROST
Federation](https://github.com/pool2win/frost-federation). I have
slowly gotten around to this taking my time writing async code using
futures, then actor model and now the Service trait.

### Service Trait and Composition

I think of the Service trait as a an advanced future interface that
allows services to be composed in a clear and reusable manner.


#### Service A

Here is a simple example of a Service called `A`.

```rust
#[derive(Debug, Clone)]
pub struct A;

impl Service<String> for A {
    type Response = String;
    type Error = BoxError;
    type Future = Pin<Box<dyn Future<Output = Result<Self::Response, Self::Error>>>>;

    fn poll_ready(&mut self, _cx: &mut Context<'_>) -> Poll<Result<(), Self::Error>> {
        Poll::Ready(Ok(()))
    }

    fn call(&mut self, msg: String) -> Self::Future {
        let res = format!("Hello {}", msg);
        async move { Ok(res) }.boxed()
    }
}
```

#### Service B

Let's write another service `B`. Later we show how it can be composed
with `A`.

```rust
#[derive(Debug, Clone)]
pub struct B<T>
where
    T: Clone,
{
    inner: T,
}

impl<T, Request> Service<Request> for B<T>
where
    Request: 'static,
    T: Service<Request> + Clone + 'static,
    T::Future: 'static,
    T::Error: Into<BoxError>,
    T::Response: Display + 'static,
{
    type Response = String;
    type Error = T::Error;
    type Future = Pin<Box<dyn Future<Output = Result<String, T::Error>>>>;

    fn poll_ready(&mut self, _cx: &mut Context<'_>) -> Poll<Result<(), Self::Error>> {
        Poll::Ready(Ok(()))
    }

    fn call(&mut self, msg: Request) -> Self::Future {
        let mut this = self.clone();

        println!("In B's call");
        // Box::pin(this.inner.call(msg))
        Box::pin(async move {
            match this.inner.call(msg).await {
                Ok(res) => {
                    println!("Result from inner: {}", res);
                    Ok("From B as Ok".to_string())
                }
                Err(e) => Err(e),
            }
        })
    }
}
```

#### Composition - Explicit

Here is a simple composition example, using only the Service
constructor.

```rust
    let a = A {};
    let b = B { inner: a };
    let res = b.oneshot("... calling B".to_string()).await.unwrap();
```

In the above example, we explicitly construct `B` to use `A`.

#### Composition - Layering

The tower crates provide another abstraction to make this layering
even cleaner, so that things are further decouple and can be
developed independently without tight coupling.

```rust
    let b = BLayer {}.layer(A {});
    let r = bb.oneshot("... from layer".to_string()).await.unwrap();
    println!("Layer wrap services {}", r);
```

The difference between the first and the second is subtle - we don't
have to construct services passing the inner service as an argument,
instead we can use the Layer trait to compose services.

Let's see how we can add a timeout layer around `b` so that if either
`B` or `A` do not respond in time, the timeout is triggered.

```rust
    let timeout_layer = TimeoutLayer::new(Duration::from_millis(100));
    let b = BLayer {}.layer(A {});
    let r = timeout_layer
        .layer(b)
        .oneshot("... with timeout".to_string())
        .await
        .or_else(|_| Err("timeout expired".to_string()));
```

#### Tower Middlewares

Tower doesn't stop here, it provides a
[ServiceBuilder](https://docs.rs/tower/latest/tower/builder/struct.ServiceBuilder.html)
interface and a bunch of [application independent
services](https://docs.rs/tower/0.5.1/tower/index.html#modules) and
[Service
extensions](https://docs.rs/tower/0.5.1/tower/trait.ServiceExt.html#)
that make is easy to compose powerful async services.

I think I will be using a fair few of those middlewares in FROST
Federation.

#### Structuring Service Interactions

The next question I want to address is how to best structure a system
that uses Services. My intuition at the moment is to attach long
running spawned services using channels. I'll spend time doing that
next and follow up with another blog post.
