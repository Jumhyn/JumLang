//
//  WhileStatement.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/3/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "WhileStatement.h"

@implementation WhileStatement

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
    self.savedAfterLabelNumber = afterLabelNumber;
    [expr jumpingForTrueLabelNumber:0 falseLabelNumber:afterLabelNumber];
    NSUInteger label = [self newLabel];
    [self emitLabel:label];
    [stmt generateCodeWithBeforeLabelNumber:label afterLabelNumber:beforeLabelNumber];
    [self emit:[NSString stringWithFormat:@"goto L%lu", beforeLabelNumber]];
}

@end
