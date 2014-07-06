//
//  Unary.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/2/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Operator.h"

@class Expression;

@interface Unary : Operator

@property(nonatomic, retain) Expression *expr;

-(id)initWithOperator:(Token *)newOperator expression:(Expression *)newExpr;

@end
