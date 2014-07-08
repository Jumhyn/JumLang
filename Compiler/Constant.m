//
//  Constant.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/2/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Constant.h"
#import "NumToken.h"
#import "FloatToken.h"
#import "TypeToken.h"
#import "WordToken.h"

@implementation Constant

-(id)initWithInteger:(NSInteger)integer {
    return self = [super initWithOperator:[[NumToken alloc] initWithValue:integer] type:TypeToken.intType];
}

-(id)initWithFloat:(double)value {
    return self = [super initWithOperator:[[FloatToken alloc] initWithValue:value] type:TypeToken.floatType];
}

-(Expression *)convert:(TypeToken *)to {
    if (self.type == to) {
        return [self reduce];
    }
    else if (self.type == TypeToken.intType && to == TypeToken.floatType) {
        return [[Constant alloc] initWithOperator:[[FloatToken alloc] initWithValue:(double)[(NumToken *)self.operator value]] type:TypeToken.floatType];
    }
    else if (self.type == TypeToken.floatType && to == TypeToken.intType) {
        return [[Constant alloc] initWithOperator:[[NumToken alloc] initWithValue:(NSInteger)[(FloatToken *)self.operator value]] type:TypeToken.intType];
    }
    else {
        [self error:[NSString stringWithFormat:@"type error when trying to convert %@ to %@", self.type, to]];
        return nil;
    }
}

-(void)jumpingForTrueLabelNumber:(NSUInteger)trueLabelNumber falseLabelNumber:(NSUInteger)falseLabelNumber {
    if (self == Constant.trueConstant && trueLabelNumber != 0) {
        printf("goto L%lu", trueLabelNumber);
    }
    else if (self == Constant.falseConstant && falseLabelNumber != 0) {
        printf("goto L%lu", falseLabelNumber);
    }
}

+(Constant *)trueConstant {
    static Constant *trueConstant = nil;
    if (trueConstant == nil) {
        trueConstant = [[Constant alloc] initWithOperator:WordToken.trueToken type:TypeToken.boolType];
    }
    return trueConstant;
}

+(Constant *)falseConstant {
    static Constant *falseConstant = nil;
    if (falseConstant == nil) {
        falseConstant = [[Constant alloc] initWithOperator:WordToken.falseToken type:TypeToken.boolType];
    }
    return falseConstant;
}

@end
