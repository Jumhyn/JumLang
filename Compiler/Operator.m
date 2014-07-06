//
//  Operator.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/3/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Operator.h"
#import "Temporary.h"

@implementation Operator

-(Expression *)reduce {
    Expression *RHS = [self generateRHS];
    Temporary *LHS = [[Temporary alloc] initWithType:self.type];
    [self emit:[NSString stringWithFormat:@"%@ = %@", LHS, RHS]];
    return LHS;
}

@end
