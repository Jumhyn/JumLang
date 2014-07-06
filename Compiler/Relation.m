//
//  Relation.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/2/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Relation.h"

@implementation Relation

-(void)jumpingForTrueLabelNumber:(NSUInteger)trueLabelNumber falseLabelNumber:(NSUInteger)falseLabelNumber {
    Expression *firstReduced = [self.expr1 reduce];
    Expression *secondReduced = [self.expr2 reduce];

    NSString *test = [NSString stringWithFormat:@"%@ %@ %@", firstReduced, self.operator, secondReduced];
    [self emitJumpsForTest:test TrueLabelNumber:trueLabelNumber falseLabelNumber:falseLabelNumber];
}

-(TypeToken *)checkType1:(TypeToken *)type1 againstType2:(TypeToken *)type2 {
    if (type1 == type2) {
        return TypeToken.boolType;
    }
    else {
        [self error:@"type error"];
        return nil;
    }
}

@end
