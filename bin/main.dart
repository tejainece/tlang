import 'package:tll/tl.dart';
import 'package:tll/tll.dart';



main(List<String> arguments) {
  // func add => 5 + 5;
  final a = tlI8Arg('a');
  final b = tlI8Arg('b');

  print(new TlFunc('add')
      .argument(a)
      .argument(b)
      .returns(tlI8)
      .statement(new TlReturn(new TlAddExpression(a.toVar, b.toVar)))
      .toTl());
}
