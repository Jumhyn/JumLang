//
//  Sequence.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/3/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Sequence.h"

@implementation Sequence

@synthesize stmt1;
@synthesize stmt2;

-(id)initWithStatement1:(Statement *)newStmt1 statement2:(Statement *)newStmt2; {
    if (self = [super init]) {
        self.stmt1 = newStmt1;
        self.stmt2 = newStmt2;
    }
    return self;
}

-(void)generateCodeWithBeforeLabelNumber:(NSUInteger)beforeLabelNumber afterLabelNumber:(NSUInteger)afterLabelNumber {
    NSUInteger labelNumber = [self newLabel];
    [stmt1 generateCodeWithBeforeLabelNumber:beforeLabelNumber afterLabelNumber:labelNumber];
    [self emitLabel:labelNumber];
    [stmt2 generateCodeWithBeforeLabelNumber:labelNumber afterLabelNumber:afterLabelNumber];
}

@end
