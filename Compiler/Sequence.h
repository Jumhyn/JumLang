//
//  Sequence.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/3/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Statement.h"

@interface Sequence : Statement

@property(nonatomic, retain) Statement *stmt1;
@property(nonatomic, retain) Statement *stmt2;

-(id)initWithStatement1:(Statement *)newStmt1 statement2:(Statement *)newStmt2;

@end
