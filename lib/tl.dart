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

class TlI8 implements TlType {
  @override
  String toTl() => 'I8';

  @override
  TlVar declare(String name) => new TlVar(name, this);
}

final tlI8 = new TlI8();

final tlVoid = new TlVoid();

abstract class TlStatement implements ToTl {}

class TlArgument implements ToTl, ToVar {
  TlType type;

  String name;

  TlArgument(this.name, this.type);

  String toTl() {
    StringBuffer sb = new StringBuffer();
    sb.write(name);
    sb.write(': ');
    sb.write(type.toTl());
    return sb.toString();
  }

  TlVar get toVar => new TlVar(name, type);
}

TlArgument tlI8Arg(String name) => new TlArgument(name, tlI8);

abstract class TlTopBlock implements ToTl {}

class TlFunc implements TlTopBlock {
  TlType returnType;

  String name;

  List<TlArgument> arguments = <TlArgument>[];

  // TODO List<TlType> optionalArguments;

  List<TlStatement> statements = <TlStatement>[];

  TlFunc(this.name);

  bool get hasArguments => arguments.length != 0;

  TlFunc returns(TlType returnType) {
    this.returnType = returnType;
    return this;
  }

  TlFunc argument(TlArgument arg) {
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

  List<TlArgument> arguments = <TlArgument>[];

  // TODO List<TlType> optionalArguments;

  TlRhsExpression expression;

  TlLambda(this.name);

  bool get hasArguments => arguments.length != 0;

  TlLambda returns(TlType returnType) {
    this.returnType = returnType;
    return this;
  }

  TlLambda argument(TlArgument arg) {
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

abstract class ToVar {
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

abstract class TlField implements ToTl {
  String get name;
}

class TlProperty implements TlField, ToVar {
  TlType type;

  String name;

  @override
  TlVar get toVar => new TlVar(name, type);

  @override
  String toTl() {
    StringBuffer sb = new StringBuffer();
    sb.write('var ');
    sb.write(name);
    sb.write(': ');
    sb.write(type.toTl());
    sb.write(';');
    return sb.toString();
  }
}

abstract class TlMethodBase implements TlField {
  String get name;

  TlType get returnType;

  List<TlArgument> get arguments;

  // TODO List<TlType> get optionalArguments;
}

class TlMethod implements TlMethodBase {
  TlType returnType;

  String name;

  List<TlArgument> arguments = <TlArgument>[];

  // TODO List<TlType> optionalArguments;

  List<TlStatement> statements = <TlStatement>[];

  TlMethod(this.name);

  bool get hasArguments => arguments.length != 0;

  TlMethod returns(TlType returnType) {
    this.returnType = returnType;
    return this;
  }

  TlMethod argument(TlArgument arg) {
    this.arguments.add(arg);
    return this;
  }

  TlMethod statement(TlStatement st) {
    this.statements.add(st);
    return this;
  }

  @override
  String toTl() {
    StringBuffer sb = new StringBuffer();
    sb.write('method ');
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

class TlLambdaMethod implements TlMethodBase {
  TlType returnType;

  String name;

  List<TlArgument> arguments = <TlArgument>[];

  // TODO List<TlType> optionalArguments;

  TlRhsExpression expression;

  TlLambdaMethod(this.name);

  bool get hasArguments => arguments.length != 0;

  TlLambdaMethod returns(TlType returnType) {
    this.returnType = returnType;
    return this;
  }

  TlLambdaMethod argument(TlArgument arg) {
    this.arguments.add(arg);
    return this;
  }

  TlLambdaMethod setExpression(TlRhsExpression exp) {
    this.expression = exp;
    return this;
  }

  @override
  String toTl() {
    StringBuffer sb = new StringBuffer();
    sb.write('method ');
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

class TlTypeDecl implements ToTl {
  String name;

  List<TlType> traits = <TlType>[];

  // TODO List<TlMixin> mixins = <TlMixin>[];

  List<TlVar> fields = <TlVar>[];

  List<TlMethodBase> methods = <TlMethodBase>[];

  TlTypeDecl(this.name);

  @override
  String toTl() {

  }
}