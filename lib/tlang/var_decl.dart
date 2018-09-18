part of tlang;

abstract class VarDecl implements ToTl {
  TlType get type;
}

class I8VarDecl implements ToTl, VarDecl, ToVar {
  final TlType type = tlI8;

  String name;

  RhsExpression init;

  I8VarDecl(this.name, [this.init]);

  @override
  Var get toVar => tlI8Var(name);

  @override
  String toTl() {
    StringBuffer sb = new StringBuffer();
    sb.write('var $name: ${type.toTl()}');
    if(init != null) {
      sb.write(' = ${init.toTl()}');
    }
    sb.write(';');
    return sb.toString();
  }
}