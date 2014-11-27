// Compute the nth Fibonacci number.
func fib (n:Int):Int {
  return if (n < 1) {
    1;
  } else {
    fib(n-1) + fib(n-2);
  };
}

/* Entry point for the program. */
entry func main():Int {
  println(fib(8));
  println(fib(9));
  println(fib(10));
  return 0;
}
