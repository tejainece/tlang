part of tlang;

abstract class TlType implements ToTl {
  Var declare(String name);
}

class Void implements TlType {
  @override
  String toTl() => 'void';

  @override
  Var declare(String name) => new Var(name, this);
}

class Bool implements TlType {
  @override
  String toTl() => 'Bool';

  @override
  Var declare(String name) => new Var(name, this);
}

class I8 implements TlType {
  @override
  String toTl() => 'I8';

  @override
  Var declare(String name) => new Var(name, this);
}

class TlCustomType implements TlType {
  String name;

  TlCustomType(this.name);

  @override
  String toTl() => name;

  @override
  Var declare(String name) => new Var(name, this);
}

final tlI8 = new I8();

final tlBool = new Bool();

final tlVoid = new Void();
