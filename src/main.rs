pub trait Optional<T>: Into<Option<T>> {}
impl<T> Optional<T> for T where T: Into<Option<T>> {}
impl<T> Optional<T> for Option<T> {}

fn main() {
    println!("{} {} {}", test(Some(799)), test(None), test(Some(799)));
}

fn test<T: Optional<u16>>(b: T) -> u16 {
    let b = match b.into() {
        Some(b) => b,
        None => 8000,
    };
    b
}
