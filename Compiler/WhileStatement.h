//
//  WhileStatement.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/3/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Expression.h"
#import "Statement.h"

@interface WhileStatement : Statement


@property(nonatomic, retain) Expression *expr;
@property(nonatomic, retain) Statement *stmt;

-(id)initWithExpression:(Expression *)newExpr statement:(Statement *)newStmt;

@end
