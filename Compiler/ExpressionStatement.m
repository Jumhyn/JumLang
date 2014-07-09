//
//  ExpressionStatement.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/8/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "ExpressionStatement.h"
#import "Expression.h"

@implementation ExpressionStatement

@synthesize expr;

-(id)initWithExpression:(Expression *)newExpr {
    if (self = [super init]) {
        self.expr = newExpr;
    }
    return self;
}

-(void)generateCodeWithBeforeLabel:(Label *)beforeLabel afterLabel:(Label *)afterLabel {
    [self emit:[NSString stringWithFormat:@"%@",expr.reduce]];
}

@end
