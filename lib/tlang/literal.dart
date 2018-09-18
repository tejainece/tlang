part of tlang;

abstract class Literal implements ToTl {}

class IntLiteral implements Literal, ToTl, RhsExpression {
  int value;

  // TODO
  TlType get type => tlI8;

  IntLiteral(this.value);

  @override
  String toTl() => value.toString();
}