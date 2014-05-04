//
//  Arithmetic.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/3/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Operator.h"

@interface Arithmetic : Operator {
    Expression *expr1;
    Expression *expr2;
}

-(id)initWithOperator:(Token *)newOperator expression1:(Expression *)newExpr1 expression2:(Expression *)expression2;

@end
