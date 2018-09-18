import 'tlang/tlang.dart';
import 'package:llvmir/llvmir.dart';

class ModuleContext {
  Map<String, String> mapping = <String, String>{};
}

class FunctionCtx {
  Map<String, String> mapping = <String, String>{};
}

class IrFunctionContext {
  Map<int, dynamic> unnamed = <int, dynamic>{};

  Map<String, dynamic> named = <String, dynamic>{};

  Map<String, dynamic> all = <String, dynamic>{};

  int count = 0;

  IrVarBase allocateUnnamedI8(String name) {
    final ret = new IrVarI8('%$count');
    unnamed[count] = ret;
    return ret;
  }
}

IrI8Decl compileI8VarDecl(ModuleContext ctx, I8VarDecl decl) {
  final ret = new IrI8Decl('${decl.name}');
  if(decl.init is IntLiteral) {
    ret.value = (decl.init as IntLiteral).value;
  } else {
    throw new UnimplementedError();
  }
  return ret;
}

List<IrTopLevel> compileLambda(ModuleContext ctx, Lambda lambda) {
  final ret = new IrFunc(lambda.name);

  if(lambda.returnType is I8) {
    ret.returns = irI8;
  } else {
    throw new UnimplementedError();
  }

  IrFunctionContext irfctx = new IrFunctionContext();
  FunctionCtx tlfctx = new FunctionCtx();
  tlfctx.mapping.addAll(ctx.mapping);
  for(Arg arg in lambda.arguments) {
    if(arg.type is I8) {
      final a = irfctx.allocateUnnamedI8(arg.name);
      ret.addArg(new IrArg(a.name, irI8));
      tlfctx.mapping[arg.name] = a.name;
    } else {
      throw new UnimplementedError();
    }
  }

  ret.addStatement(new IrRet(compileAddExpression(tlfctx, lambda.expression)));

  return <IrTopLevel>[ret];
}

List<IrStatement> getVariables(RhsExpression exp) {
  if(exp is AddExpression) {
    if(exp.op1 is Var) {
      op1 = new IrVarI8(ctx.mapping[(exp.op1 as Var).name]);
    }
    if(exp.op1 is Var) {
      op1 = new IrVarI8(ctx.mapping[(exp.op1 as Var).name]);
    }
  } else {
    throw new UnimplementedError();
  }
}

IrRhsExpression compileAddExpression(FunctionCtx ctx, AddExpression exp) {
  if(exp.op1.type is I8 && exp.op2.type is I8) {
    IrIntData op1;
    if(exp.op1 is I8) {
      op1 = new IrLiteralI8((exp.op1 as IntLiteral).value);
    } else if(exp.op1 is Var) {
      op1 = new IrVarI8(ctx.mapping[(exp.op1 as Var).name]);
    } else {
      throw new UnimplementedError();
    }
    IrIntData op2;
    if(exp.op1 is IntLiteral) {
      op2 = new IrLiteralI8((exp.op1 as IntLiteral).value);
    } else if(exp.op1 is Var) {
      op2 = new IrVarI8(ctx.mapping[(exp.op1 as Var).name]);
    } else {
      throw new UnimplementedError();
    }
    return new IrAdd(irI8, op1, op2);
  } else {
    throw new UnimplementedError();
  }
}