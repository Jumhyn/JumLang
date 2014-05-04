//
//  DoStatement.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/3/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "DoStatement.h"

@implementation DoStatement

@synthesize stmt;
@synthesize expr;

-(id)initWithStatement:(Statement *)newStmt expression:(Expression *)newExpr {
    if (self = [super init]) {
        self.stmt = newStmt;
        self.expr = newExpr;
    }
    return self;
}

@end
