//
//  DoStatement.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/3/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "DoStatement.h"
#import "Label.h"

@implementation DoStatement

@synthesize stmt;
@synthesize expr;

-(id)initWithStatement:(Statement *)newStmt expression:(Expression *)newExpr {
    if (self = [super init]) {
        self.stmt = newStmt;
        self.expr = newExpr;
    }
    return self;
}

-(void)generateCodeWithBeforeLabel:(Label *)beforeLabel afterLabel:(Label *)afterLabel {
#if LLVM == 0
    self.savedAfterLabel = afterLabel;
    [expr jumpingForTrueLabel:0 falseLabel:afterLabel];
    NSUInteger label = [self newLabel];
    [self emitLabel:label];
    [stmt generateCodeWithBeforeLabel:label afterLabel:beforeLabel];
    [self emit:[NSString stringWithFormat:@"goto L%lu", beforeLabel.number]];
#elif LLVM == 1
    self.savedAfterLabel = afterLabel;
    Label *label = [self newLabel];
    label.referenced = [stmt needsAfterLabel];
    [stmt generateCodeWithBeforeLabel:beforeLabel afterLabel:label];
    [self emitLabel:label];
    [expr jumpingForTrueLabel:beforeLabel falseLabel:afterLabel];
    [self emit:[NSString stringWithFormat:@"br label %%L%lu", beforeLabel.number]];
#endif
}

-(BOOL)needsAfterLabel {
    return YES;
}

-(BOOL)needsBeforeLabel {
    return YES;
}

@end
