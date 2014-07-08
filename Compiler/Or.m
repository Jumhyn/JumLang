//
//  Or.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/2/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Or.h"

@implementation Or

-(void)jumpingForTrueLabel:(Label *)trueLabel falseLabel:(Label *)falseLabel {
    Label *label = (trueLabel) ? trueLabel : [self newLabel];
    [self.expr1 jumpingForTrueLabel:label falseLabel:nil];
    [self.expr2 jumpingForTrueLabel:trueLabel falseLabel:falseLabel];
    if (!trueLabel) {
        [self emitLabel:label];
    }
}

@end
