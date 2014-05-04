//
//  Arithmetic.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/3/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Arithmetic.h"

@implementation Arithmetic

-(id)initWithOperator:(Token *)newOperator expression1:(Expression *)newExpr1 expression2:(Expression *)newExpr2 {
    if (self = [super initWithOperator:newOperator type:nil]) {
        expr1 = newExpr1;
        expr2 = newExpr2;
        TypeToken *newType = Type_max(newExpr1.type, newExpr2.type);
        if (!newType) {
            [self error:@"type error"];
        }
        self.type = newType;
    }
    return self;
}

@end
