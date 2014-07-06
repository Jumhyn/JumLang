//
//  ReturnStatement.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/6/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Statement.h"

@class Expression;

@interface ReturnStatement : Statement

@property(nonatomic, retain) Expression *expr;

-(id)initWithExpression:(Expression *)newExpr;

@end
