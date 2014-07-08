//
//  Logical.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/2/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Logical.h"
#import "Temporary.h"
#import "Label.h"

@implementation Logical

@synthesize expr1;
@synthesize expr2;

-(id)initWithOperator:(Token *)newOperator expression1:(Expression *)newExpr1 expression2:(Expression *)newExpr2 {
    if (self = [super initWithOperator:newOperator type:nil]) {
        self.expr1 = newExpr1;
        self.expr2 = newExpr2;
        self.type = [self checkType1:self.expr1.type againstType2:self.expr2.type];
    }
    return self;
}

-(TypeToken *)checkType1:(TypeToken *)type1 againstType2:(TypeToken *)type2 {
    if (type1 == type2 && type1 == TypeToken.boolType) {
        return TypeToken.boolType;
    }
    else {
        [self error:@"type error"];
        return nil;
    }
}

-(Expression *)generateRHS {
    Label *falseLabel = [self newLabel];
    Label *afterLabel = [self newLabel];

    Temporary *temp = [[Temporary alloc] initWithType:self.type];
    [self jumpingForTrueLabel:nil falseLabel:falseLabel];
    [self emit:[NSString stringWithFormat:@"%@ = true", temp]];
    [self emit:[NSString stringWithFormat:@"goto L%lu", afterLabel.number]];
    [self emitLabel:falseLabel];
    [self emit:[NSString stringWithFormat:@"%@ = false", temp]];
    [self emitLabel:afterLabel];
    return temp;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"%@ %@ %@", self.expr1, self.operator, self.expr2];
}

@end
