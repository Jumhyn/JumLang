//
//  Or.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/2/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Or.h"

@implementation Or

-(void)jumpingForTrueLabelNumber:(NSUInteger)trueLabelNumber falseLabelNumber:(NSUInteger)falseLabelNumber {
    NSUInteger label = (trueLabelNumber != 0) ? trueLabelNumber : [self newLabel];
    [self.expr1 jumpingForTrueLabelNumber:label falseLabelNumber:0];
    [self.expr2 jumpingForTrueLabelNumber:trueLabelNumber falseLabelNumber:falseLabelNumber];
    if (trueLabelNumber == 0) {
        [self emitLabel:label];
    }
}

@end
