library tlang;

part 'trait.dart';
part 'class.dart';

class ForTimeBeing {
  const ForTimeBeing();
}

abstract class ToTl {
  String toTl();
}

abstract class TlType implements ToTl {
  TlVar declare(String name);
}

class TlVoid implements TlType {
  @override
  String toTl() => 'void';

  @override
  TlVar declare(String name) => new TlVar(name, this);
}

class TlBool implements TlType {
  @override
  String toTl() => 'Bool';

  @override
  TlVar declare(String name) => new TlVar(name, this);
}

class TlI8 implements TlType {
  @override
  String toTl() => 'I8';

  @override
  TlVar declare(String name) => new TlVar(name, this);
}

class TlCustomType implements TlType {
  String name;

  TlCustomType(this.name);

  @override
  String toTl() => name;

  @override
  TlVar declare(String name) => new TlVar(name, this);
}

final tlI8 = new TlI8();

final tlBool = new TlBool();

final tlVoid = new TlVoid();

abstract class TlStatement implements ToTl {}

class TlArg implements ToTl, ToTlVar {
  TlType type;

  String name;

  TlArg(this.name, this.type);

  String toTl() {
    StringBuffer sb = new StringBuffer();
    sb.write(name);
    sb.write(': ');
    sb.write(type.toTl());
    return sb.toString();
  }

  TlVar get toVar => new TlVar(name, type);
}

TlArg tlI8Arg(String name) => new TlArg(name, tlI8);

abstract class TlTopBlock implements ToTl {}

class TlFunc implements TlTopBlock {
  TlType returnType;

  String name;

  List<TlArg> arguments = <TlArg>[];

  // TODO List<TlType> optionalArguments;

  List<TlStatement> statements = <TlStatement>[];

  TlFunc(this.name);

  bool get hasArguments => arguments.length != 0;

  TlFunc returns(TlType returnType) {
    this.returnType = returnType;
    return this;
  }

  TlFunc argument(TlArg arg) {
    this.arguments.add(arg);
    return this;
  }

  TlFunc statement(TlStatement st) {
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
    if (returnType is! TlVoid) {
      sb.write(': ');
      sb.write(returnType.toTl());
    }
    sb.writeln('{');
    statements.map((s) => s.toTl()).forEach(sb.writeln);
    sb.write('}');
    return sb.toString();
  }
}

class TlLambda implements TlTopBlock {
  TlType returnType;

  String name;

  List<TlArg> arguments = <TlArg>[];

  // TODO List<TlType> optionalArguments;

  TlRhsExpression expression;

  TlLambda(this.name);

  bool get hasArguments => arguments.length != 0;

  TlLambda returns(TlType returnType) {
    this.returnType = returnType;
    return this;
  }

  TlLambda argument(TlArg arg) {
    this.arguments.add(arg);
    return this;
  }

  TlLambda setExpression(TlRhsExpression exp) {
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
    if (returnType is! TlVoid) {
      sb.write(': ');
      sb.write(returnType.toTl());
    }
    sb.writeln(' => ');
    sb.write(expression.toTl());
    sb.write(';');
    return sb.toString();
  }
}

abstract class TlRhsExpression implements ToTl {}

abstract class ToTlVar {
  TlVar get toVar;
}

class TlVar implements TlRhsExpression {
  TlType type;

  String name;

  TlVar(this.name, this.type);

  @override
  String toTl() => name;
}

TlVar tlVar(String name, TlType type) => new TlVar(name, type);

TlVar tlI8Var(String name) => new TlVar(name, tlI8);

@ForTimeBeing()
class TlAddExpression implements TlRhsExpression {
  TlRhsExpression op1;

  TlRhsExpression op2;

  TlAddExpression(this.op1, this.op2);

  @override
  String toTl() {
    StringBuffer sb = new StringBuffer();
    sb.write(op1.toTl());
    sb.write(' + ');
    sb.write(op2.toTl());
    return sb.toString();
  }
}

class TlReturn implements TlStatement {
  TlRhsExpression expression;

  TlReturn(this.expression);

  @override
  String toTl() {
    StringBuffer sb = new StringBuffer();
    sb.write('ret ');
    sb.write(expression.toTl());
    sb.write(';');
    return sb.toString();
  }
}