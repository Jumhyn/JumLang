//
//  SetElementStatement.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/10/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Statement.h"
#import "Access.h"

@interface SetElementStatement : Statement

@property(nonatomic, retain) Access *element;
@property(nonatomic, retain) Expression *expr;

-(id)initWithElement:(Access *)newElement expression:(Expression *)newExpr;

@end
