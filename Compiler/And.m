//
//  And.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/2/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "And.h"

@implementation And

-(void)jumpingForTrueLabelNumber:(NSUInteger)trueLabelNumber falseLabelNumber:(NSUInteger)falseLabelNumber {
    NSUInteger label = (falseLabelNumber != 0) ? falseLabelNumber : [self newLabel];

    [self.expr1 jumpingForTrueLabelNumber:0 falseLabelNumber:label];
    [self.expr2 jumpingForTrueLabelNumber:trueLabelNumber falseLabelNumber:falseLabelNumber];

    if (falseLabelNumber == 0) {
        [self emitLabel:label];
    }
}

@end
