//
//  FloatToken.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/1/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "FloatToken.h"

@implementation FloatToken

-(id)initWithValue:(double)newValue {
    if (self = [super initWithType:TOK_FLOAT]) {
        self.value = newValue;
    }
    return self;
}

+(FloatToken *)tokenWithValue:(double)value {
    return [[FloatToken alloc] initWithValue:value];
}

-(NSString *)description {
    return [NSString stringWithFormat:@"%f", self.value];
}

-(BOOL)isEqual:(id)object {
    if ([super isEqual:object]) {
        if ([object isKindOfClass:[FloatToken class]]) {
            if(((FloatToken *)object).value == self.value) {
                return YES;
            }
        }
    }
    return NO;
}

-(id)copyWithZone:(NSZone *)zone {
    FloatToken *copy = [super copyWithZone:zone];
    if (copy) {
        copy.value = self.value;
    }
    return copy;
}

@end
