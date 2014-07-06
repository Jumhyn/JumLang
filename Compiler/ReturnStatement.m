//
//  ReturnStatement.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/6/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "ReturnStatement.h"
#import "Expression.h"

@implementation ReturnStatement

@synthesize expr;

-(id)initWithExpression:(Expression *)newExpr {
    if (self = [super init]) {
        self.expr = newExpr;
    }
    return self;
}

-(void)generateCodeWithBeforeLabelNumber:(NSUInteger)beforeLabelNumber afterLabelNumber:(NSUInteger)afterLabelNumber {
    Expression *temp = [self.expr reduce];
    [self emit:[NSString stringWithFormat:@"return %@", temp]];
}

@end
