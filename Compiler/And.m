//
//  And.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/2/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "And.h"
#import "Label.h"

@implementation And

-(void)jumpingForTrueLabel:(Label *)trueLabel falseLabel:(Label *)falseLabel {
    Label *label = (falseLabel != 0) ? falseLabel : [self newLabel];

    [self.expr1 jumpingForTrueLabel:0 falseLabel:label];
    [self.expr2 jumpingForTrueLabel:trueLabel falseLabel:falseLabel];

    if (falseLabel == 0) {
        [self emitLabel:label];
    }
}

@end
