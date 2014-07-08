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

-(void)generateCodeWithBeforeLabel:(Label *)beforeLabel afterLabel:(Label *)afterLabel {
    Label *label = [self newLabel];
    [expr jumpingForTrueLabel:label falseLabel:afterLabel];
    [self emitLabel:label];
    [stmt generateCodeWithBeforeLabel:label afterLabel:afterLabel];
}

-(BOOL)needsAfterLabel {
    return YES;
}

@end
