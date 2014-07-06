//
//  AssignStatement.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/4/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Statement.h"

@class Identifier, Expression;

@interface AssignStatement : Statement

@property(nonatomic, retain) Identifier *identifier;
@property(nonatomic, retain) Expression *expr;

-(id)initWithIdentifier:(Identifier *)newIdentifier expression:(Expression *)newExpr;

@end
