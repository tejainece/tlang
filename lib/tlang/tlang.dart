library tlang;

part 'trait.dart';
part 'class.dart';
part 'expression.dart';
part 'primitive_type.dart';
part 'var_decl.dart';
part 'literal.dart';

class ForTimeBeing {
  const ForTimeBeing();
}

abstract class ToTl {
  String toTl();
}

abstract class TlStatement implements ToTl {}

class Arg implements ToTl, ToVar {
  TlType type;

  String name;

  Arg(this.name, this.type);

  String toTl() {
    StringBuffer sb = new StringBuffer();
    sb.write(name);
    sb.write(': ');
    sb.write(type.toTl());
    return sb.toString();
  }

  Var get toVar => new Var(name, type);
}

Arg tlI8Arg(String name) => new Arg(name, tlI8);

abstract class TlTopBlock implements ToTl {}

class Func implements TlTopBlock {
  TlType returnType;

  String name;

  List<Arg> arguments = <Arg>[];

  // TODO List<TlType> optionalArguments;

  List<TlStatement> statements = <TlStatement>[];

  Func(this.name);

  bool get hasArguments => arguments.length != 0;

  Func returns(TlType returnType) {
    this.returnType = returnType;
    return this;
  }

  Func argument(Arg arg) {
    this.arguments.add(arg);
    return this;
  }

  Func statement(TlStatement st) {
    this.statements.add(st);
    return this;
  }

  @override
  String toTl() {
    StringBuffer sb = new StringBuffer();
    sb.write('func ');
    sb.write(name);
    if (hasArguments) {
      sb.write('(');
      sb.write(arguments.map((a) => a.toTl()).join(', '));
      sb.write(')');
    }
    if (returnType is! Void) {
      sb.write(': ');
      sb.write(returnType.toTl());
    }
    sb.writeln('{');
    statements.map((s) => s.toTl()).forEach(sb.writeln);
    sb.write('}');
    return sb.toString();
  }
}

class Lambda implements TlTopBlock {
  TlType returnType;

  String name;

  List<Arg> arguments = <Arg>[];

  // TODO List<TlType> optionalArguments;

  RhsExpression expression;

  Lambda(this.name);

  bool get hasArguments => arguments.length != 0;

  Lambda returns(TlType returnType) {
    this.returnType = returnType;
    return this;
  }

  Lambda argument(Arg arg) {
    this.arguments.add(arg);
    return this;
  }

  Lambda setExpression(RhsExpression exp) {
    this.expression = exp;
    return this;
  }

  @override
  String toTl() {
    StringBuffer sb = new StringBuffer();
    sb.write('func ');
    sb.write(name);
    if (hasArguments) {
      sb.write('(');
      sb.write(arguments.map((a) => a.toTl()).join(', '));
      sb.write(')');
    }
    if (returnType is! Void) {
      sb.write(': ');
      sb.write(returnType.toTl());
    }
    sb.write(' => ');
    sb.write(expression.toTl());
    sb.write(';');
    return sb.toString();
  }
}

abstract class RhsExpression implements ToTl {
  TlType get type;
}

abstract class ToVar {
  Var get toVar;
}

class Var implements RhsExpression {
  TlType type;

  String name;

  Var(this.name, this.type);

  @override
  String toTl() => name;
}

Var tlVar(String name, TlType type) => new Var(name, type);

Var tlI8Var(String name) => new Var(name, tlI8);

class Return implements TlStatement {
  RhsExpression expression;

  Return(this.expression);

  @override
  String toTl() {
    StringBuffer sb = new StringBuffer();
    sb.write('ret ');
    sb.write(expression.toTl());
    sb.write(';');
    return sb.toString();
  }
}