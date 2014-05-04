//
//  DoStatement.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/3/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Statement.h"
#import "Expression.h"

@interface DoStatement : Statement


@property(nonatomic, retain) Statement *stmt;
@property(nonatomic, retain) Expression *expr;

-(id)initWithStatement:(Statement *)newStmt expression:(Expression *)newExpr;

@end
