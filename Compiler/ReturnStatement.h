//
//  ReturnStatement.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/6/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Statement.h"
#import "Prototype.h"

@class Expression;

@interface ReturnStatement : Statement

@property(nonatomic, retain) Expression *expr;
@property(nonatomic, retain) Prototype *func;

-(id)initWithExpression:(Expression *)newExpr function:(Prototype *)newFunc;

@end
