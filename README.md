# tll

Experimental Dart DSL that compiles to LLVM IR (and hence native code)

# Dart DSL to TLang

```
main(List<String> arguments) {
  // func add => 5 + 5;
  final a = tlI8Arg('a');
  final b = tlI8Arg('b');

  print(new TlFunc('add')
      .argument(a)
      .argument(b)
      .returns(tlI8)
      .statement(new TlReturn(new TlAddExpression(a.toVar, b.toVar)))
      .toTl());
}

/// Prints:
///>func add(a: I8, b: I8): I8{
///>ret a + b;
///>}
```

# Dart DSL to LLVM IR

> TODO