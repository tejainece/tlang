part of tlang;

abstract class TlTraitField implements ToTl {
  String get name;
}

class TlTraitProperty implements TlTraitField, ToVar {
  TlType type;

  String name;

  TlTraitProperty(this.name, this.type);

  @override
  Var get toVar => new Var(name, type);

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

class TlTraitMethod implements TlTraitField {
  String name;

  TlType returnType;

  List<Arg> arguments = <Arg>[];

  // TODO List<TlType> optionalArguments;

  TlTraitMethod(this.name);

  bool get hasArguments => arguments.length != 0;

  TlTraitMethod returns(TlType returnType) {
    this.returnType = returnType;
    return this;
  }

  TlTraitMethod argument(Arg arg) {
    this.arguments.add(arg);
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
    if (returnType is! Void) {
      sb.write(': ');
      sb.write(returnType.toTl());
    }
    sb.write(';');
    return sb.toString();
  }
}

class TlTraitDecl implements TlTopBlock {
  String name;

  List<TlType> traits = <TlType>[];

  List<TlTraitField> fields = <TlTraitField>[];

  TlTraitDecl(this.name);

  TlTraitDecl addTrait(TlType trait) {
    traits.add(trait);
    return this;
  }

  TlTraitDecl addField(TlTraitField field) {
    fields.add(field);
    return this;
  }

  @override
  String toTl() {
    StringBuffer sb = new StringBuffer();
    sb.write('trait ');
    sb.write(name);
    if(traits.length > 0) {
      sb.write(' implements ');
      sb.write(traits.map((t) => t.toTl()).join(', '));
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