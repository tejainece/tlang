part of tlang;

abstract class TlField implements ToTl {
  String get name;
}

class TlProperty implements TlField, ToTlVar {
  TlType type;

  String name;

  TlProperty(this.name, this.type);

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

  List<TlArg> get arguments;

// TODO List<TlType> get optionalArguments;
}

class TlMethod implements TlMethodBase {
  TlType returnType;

  String name;

  List<TlArg> arguments = <TlArg>[];

  // TODO List<TlType> optionalArguments;

  List<TlStatement> statements = <TlStatement>[];

  TlMethod(this.name);

  bool get hasArguments => arguments.length != 0;

  TlMethod returns(TlType returnType) {
    this.returnType = returnType;
    return this;
  }

  TlMethod argument(TlArg arg) {
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

  List<TlArg> arguments = <TlArg>[];

  // TODO List<TlType> optionalArguments;

  TlRhsExpression expression;

  TlLambdaMethod(this.name);

  bool get hasArguments => arguments.length != 0;

  TlLambdaMethod returns(TlType returnType) {
    this.returnType = returnType;
    return this;
  }

  TlLambdaMethod argument(TlArg arg) {
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

class TlClassDecl implements TlTopBlock {
  String name;

  List<TlType> traits = <TlType>[];

  List<TlType> mixins = <TlType>[];

  List<TlField> fields = <TlField>[];

  TlClassDecl(this.name);

  TlClassDecl addTrait(TlType trait) {
    traits.add(trait);
    return this;
  }

  TlClassDecl addMixin(TlType mixin) {
    mixins.add(mixin);
    return this;
  }

  TlClassDecl addField(TlField field) {
    fields.add(field);
    return this;
  }

  @override
  String toTl() {
    StringBuffer sb = new StringBuffer();
    sb.write('class ');
    sb.write(name);
    if(traits.length > 0) {
      sb.write(' implements ');
      sb.write(traits.map((t) => t.toTl()).join(', '));
    }
    if(mixins.length > 0) {
      sb.write(' mix ');
      sb.write(mixins.map((t) => t.toTl()).join(', '));
    }
    sb.writeln(' {');
    if(fields.length > 0) {
      sb.write(fields.map((f) => f.toTl()).join('\n'));
      sb.writeln();
    }
    sb.write('}');
    return sb.toString();
  }
}