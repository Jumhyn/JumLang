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

-(void)jumpingForTrueLabel:(Label *)trueLabel falseLabel:(Label *)falseLabel {
    TypeToken *max = Type_max(self.expr1.type, self.expr2.type);
    Expression *firstReduced = [self.expr1 convert:max];
    Expression *secondReduced = [self.expr2 convert:max];
#if LLVM == 0
    NSString *test = [NSString stringWithFormat:@"%@ %@ %@", firstReduced, self.operator, secondReduced];
    [self emitJumpsForTest:test trueLabel:trueLabel falseLabel:falseLabel];
#elif LLVM == 1
    Temporary *temp = [[Temporary alloc] initWithType:TypeToken.boolType];
    NSString *typePrefix = @"i";
    if (firstReduced.type == TypeToken.floatType) {
        typePrefix = @"f";
    }
    NSString *testPrefix = @"s";
    if (self.operator.type == TOK_EQUAL || self.operator.type == TOK_NEQUAL) {
        testPrefix = @"";
    }
    if (firstReduced.type == TypeToken.floatType) {
        testPrefix = @"o";
    }
    [self emit:[NSString stringWithFormat:@"%@ = %@cmp %@%@ %@ %@, %@", temp, typePrefix, testPrefix, self.operator, Type_max(firstReduced.type, secondReduced.type), firstReduced, secondReduced]];
    [self emitJumpsForTest:temp.description trueLabel:trueLabel falseLabel:falseLabel];
#endif
}

-(TypeToken *)checkType1:(TypeToken *)type1 againstType2:(TypeToken *)type2 {
    if (type1.isNumeric && type2.isNumeric) {
        return TypeToken.boolType;
    }
    else {
        [self error:@"type error"];
        return nil;
    }
}

@end
