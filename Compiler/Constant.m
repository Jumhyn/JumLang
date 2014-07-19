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
#import "Label.h"

@implementation Constant

-(id)initWithInteger:(NSInteger)integer {
    return self = [super initWithOperator:[[NumToken alloc] initWithValue:integer] type:TypeToken.intType];
}

-(id)initWithFloat:(double)value {
    return self = [super initWithOperator:[[FloatToken alloc] initWithValue:value] type:TypeToken.floatType];
}

-(Expression *)convert:(TypeToken *)to {
    if ([self.type isEqual:to]) {
        return [self reduce];
    }
    else if (self.type == TypeToken.intType) {
        if (to == TypeToken.floatType) {
            return [[Constant alloc] initWithFloat:(double)[(NumToken *)self.operator value]];
        }
        else if (to == TypeToken.charType) {
            NSInteger value = [(NumToken *)self.operator value];
            if (value <= CHAR_MAX && value >= CHAR_MIN) {
                self.type = TypeToken.charType;
                return self;
            }
            else {
                return [super convert:to];
            }
        }
        else {
            return [super convert:to];
        }
    }
    else if (self.type == TypeToken.floatType) {
        if (to == TypeToken.intType) {
            return [[Constant alloc] initWithInteger:(NSInteger)[(FloatToken *)self.operator value]];
        }
        else if (to == TypeToken.charType) {
            Constant *ret = [[Constant alloc] initWithInteger:(NSInteger)[(FloatToken *)self.operator value]];
            return [ret convert:to];
        }
        else {
            return [super convert:to];
        }
    }
    else if (self.type == TypeToken.charType) {
        if (to == TypeToken.intType) {
            self.type = TypeToken.intType;
            return self;
        }
        else if (to == TypeToken.floatType) {
            return [[Constant alloc] initWithFloat:(double)[(NumToken *)self.operator value]];
        }
        else {
            return [super convert:to];
        }
    }
    else {
        return [super convert:to];
    }
}

-(void)jumpingForTrueLabel:(Label *)trueLabel falseLabel:(Label *)falseLabel {
#if LLVM == 0
    if (self == Constant.trueConstant && trueLabel) {
        printf("goto L%lu", trueLabel.number);
    }
    else if (self == Constant.falseConstant && falseLabel) {
        printf("goto L%lu", falseLabel.number);
    }
#elif LLVM == 1
    if (self == Constant.trueConstant && trueLabel) {
        printf("br %%L%lu", trueLabel.number);
    }
    else if (self == Constant.falseConstant && falseLabel) {
        printf("br %%L%lu", falseLabel.number);
    }
#endif
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
