import 'package:tll/tlang/tl.dart';
import 'package:tll/tll.dart';

main(List<String> arguments) {
  // lambda:
  //   name: add
  //   returns: I8
  //   args:
  //     a: I8
  //     b: I8
  //   ret:
  //     [+]:
  //       a
  //       b

  // func add => 5 + 5;
  final a = tlI8Arg('a');
  final b = tlI8Arg('b');

  print(new TlFunc('add')
      .argument(a)
      .argument(b)
      .returns(tlI8)
      .statement(new TlReturn(new TlAddExpression(a.toVar, b.toVar)))
      .toTl());

  print(new TlTraitDecl('Shape')
      .addField(new TlTraitProperty('sides', tlI8))
      .addField(new TlTraitProperty('closed', tlI8))
      .toTl());

  print(new TlClassDecl('Rectangle')
      .addTrait(new TlCustomType('Shape'))
      .addField(new TlProperty('sides', tlI8))
      .addField(new TlProperty('closed', tlI8))
      .toTl());
}
