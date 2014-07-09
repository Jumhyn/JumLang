//
//  ReturnStatement.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/6/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "ReturnStatement.h"
#import "Expression.h"
#import "Environment.h"
#import "Identifier.h"

@implementation ReturnStatement

@synthesize expr;
@synthesize func;

-(id)initWithExpression:(Expression *)newExpr function:(Prototype *)newFunc {
    if (self = [super init]) {
        self.expr = newExpr;
        self.func = newFunc;
    }
    return self;
}

-(void)generateCodeWithBeforeLabel:(Label *)beforeLabel afterLabel:(Label *)afterLabel {
    Expression *temp = [self.expr convert:func.identifier.type];
#if LLVM == 0
    if (self.expr.type == TypeToken.voidType) {
        [self emit:@"return"];
    }
    else {
        [self emit:[NSString stringWithFormat:@"return %@", temp]];
    }
#elif LLVM == 1
    if (self.expr.type == TypeToken.voidType) {
        [self emit:@"ret void"];
    }
    else {
        [self emit:[NSString stringWithFormat:@"ret %@ %@", temp.type, temp]];
    }
#endif
}

@end
