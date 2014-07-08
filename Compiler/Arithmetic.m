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

-(Expression *)generateRHS {
    TypeToken *max = Type_max(expr1.type, expr2.type);
    return [[Arithmetic alloc] initWithOperator:self.operator expression1:[expr1 convert:max] expression2:[expr2 convert:max]];
}

-(NSString *)description {
#if LLVM == 0
    return [NSString stringWithFormat:@"%@ %@ %@", expr1, self.operator, expr2];
#elif LLVM == 1
    NSString *prefix = @"";
    if (self.type == TypeToken.floatType) {
        prefix = @"f";
    }
    return [NSString stringWithFormat:@"%@%@ %@ %@, %@", prefix, self.operator, self.type, expr1, expr2];
#endif
}

@end
