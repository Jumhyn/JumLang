//
//  IfStatement.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/3/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "IfStatement.h"
#import "Label.h"

@implementation IfStatement

@synthesize expr;
@synthesize stmt;
@synthesize elseStmt;

-(id)initWithExpression:(Expression *)newExpr statement:(Statement *)newStmt elseStatement:(Statement *)newElseStmt {
    if (self = [super init]) {
        self.expr = newExpr;
        self.stmt = newStmt;
        self.elseStmt = newElseStmt;
    }
    return self;
}

-(void)generateCodeWithBeforeLabel:(Label *)beforeLabel afterLabel:(Label *)afterLabel {
    Label *label = [self newLabel];
    label.referenced = YES;
    if (!elseStmt) {
        [expr jumpingForTrueLabel:label falseLabel:afterLabel];
        [self emitLabel:label];
        [stmt generateCodeWithBeforeLabel:label afterLabel:afterLabel];
    }
    else {
        Label *elseLabel = [self newLabel];
        elseLabel.referenced = YES;
        [expr jumpingForTrueLabel:label falseLabel:elseLabel];
        [self emitLabel:label];
        [stmt generateCodeWithBeforeLabel:label afterLabel:elseLabel];
        [self emit:[NSString stringWithFormat:@"br label %%L%lu", afterLabel.number]];
        [self emitLabel:elseLabel];
        [elseStmt generateCodeWithBeforeLabel:elseLabel afterLabel:afterLabel];
    }
}

-(BOOL)needsAfterLabel {
    return YES;
}

@end
