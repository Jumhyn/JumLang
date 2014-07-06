//
//  Logical.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/2/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Expression.h"

@interface Logical : Expression

@property(nonatomic, retain) Expression *expr1;
@property(nonatomic, retain) Expression *expr2;

-(id)initWithOperator:(Token *)newOperator expression1:(Expression *)newExpr1 expression2:(Expression *)newExpr2;

@end
