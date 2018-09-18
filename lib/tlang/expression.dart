part of tlang;

@ForTimeBeing()
class AddExpression implements RhsExpression {
  RhsExpression op1;

  RhsExpression op2;

  TlType type;

  AddExpression(this.op1, this.op2);

  @override
  String toTl() {
    StringBuffer sb = new StringBuffer();
    sb.write(op1.toTl());
    sb.write(' + ');
    sb.write(op2.toTl());
    return sb.toString();
  }
}