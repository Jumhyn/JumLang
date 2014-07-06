//
//  Unary.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/2/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Unary.h"

@implementation Unary

-(id)initWithOperator:(Token *)newOperator expression:(Expression *)newExpr {
    if (self = [super initWithOperator:newOperator type:nil]) {
        self.expr = newExpr;
        self.type = Type_max(TypeToken.intType, self.expr.type);
    }
    return self;
}

-(Expression *)generateRHS {
    return [[Unary alloc] initWithOperator:self.operator expression:[self.expr reduce]];
}

-(NSString *)description {
    return [NSString stringWithFormat:@"%@ %@", self.operator, self.expr];
}

@end
