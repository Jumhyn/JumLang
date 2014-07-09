//
//  IfStatement.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/3/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Statement.h"
#import "Expression.h"

@interface IfStatement : Statement

@property(nonatomic, retain) Expression *expr;
@property(nonatomic, retain) Statement *stmt;
@property(nonatomic, retain) Statement *elseStmt;

-(id)initWithExpression:(Expression *)newExpr statement:(Statement *)newStmt elseStatement:(Statement *)newElseStmt;

@end
