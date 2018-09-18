import 'package:tll/tlang/tlang.dart';
import 'package:tll/tll.dart';

main() {
  final five = new I8VarDecl('five', new IntLiteral(5));
  print(five.toTl());

  Lambda plusFive;
  {
    final inp = tlI8Arg('inp');
    plusFive = new Lambda('plusFive')
        .argument(inp)
        .returns(tlI8)
        .setExpression(new AddExpression(five.toVar, inp.toVar));
    print(plusFive.toString());
  }

  ModuleContext mod = new ModuleContext()..mapping['five'] = '@five';
  print(compileI8VarDecl(null, five).toIr());
  compileLambda(null, plusFive).forEach((f) => print(f.toIr()));
}
