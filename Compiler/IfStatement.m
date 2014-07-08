//
//  IfStatement.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/3/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "IfStatement.h"

@implementation IfStatement

@synthesize expr;
@synthesize stmt;

-(id)initWithExpression:(Expression *)newExpr statement:(Statement *)newStmt {
    if (self = [super init]) {
        self.expr = newExpr;
        self.stmt = newStmt;
    }
    return self;
}

-(void)generateCodeWithBeforeLabelNumber:(NSUInteger)beforeLabelNumber afterLabelNumber:(NSUInteger)afterLabelNumber {
    NSUInteger label = [self newLabel];
    [expr jumpingForTrueLabelNumber:label falseLabelNumber:afterLabelNumber];
    [self emitLabel:label];
    [stmt generateCodeWithBeforeLabelNumber:label afterLabelNumber:afterLabelNumber];
}

@end
