//
//  Relation.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/2/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Relation.h"
#import "Temporary.h"

@implementation Relation

-(void)jumpingForTrueLabelNumber:(NSUInteger)trueLabelNumber falseLabelNumber:(NSUInteger)falseLabelNumber {
    Expression *firstReduced = [self.expr1 reduce];
    Expression *secondReduced = [self.expr2 reduce];
#if LLVM == 0
    NSString *test = [NSString stringWithFormat:@"%@ %@ %@", firstReduced, self.operator, secondReduced];
    [self emitJumpsForTest:test TrueLabelNumber:trueLabelNumber falseLabelNumber:falseLabelNumber];
#elif LLVM == 1
    Temporary *temp = [[Temporary alloc] initWithType:TypeToken.boolType];
    char typechar = 'i';
    if (firstReduced.type == TypeToken.floatType || secondReduced.type == TypeToken.floatType) {
        typechar = 'f';
    }
    [self emit:[NSString stringWithFormat:@"%@ = %ccmp %@ %@ %@, %@", temp, typechar, self.operator, Type_max(firstReduced.type, secondReduced.type), firstReduced, secondReduced]];
    [self emitJumpsForTest:temp.description TrueLabelNumber:trueLabelNumber falseLabelNumber:falseLabelNumber];
#endif
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
