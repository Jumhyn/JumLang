//
//  ElseStatement.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/8/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Statement.h"

@interface ElseStatement : Statement

@property(nonatomic, retain) Statement *stmt;

@end
