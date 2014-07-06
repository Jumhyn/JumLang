//
//  NumToken.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/1/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "NumToken.h"

@implementation NumToken

@synthesize value;

-(id)initWithValue:(NSInteger)newValue {
    if (self = [super initWithType:TOK_NUM]) {
        self.value = newValue;
    }
    return self;
}

+(NumToken *)tokenWithValue:(NSInteger)value {
    return [[NumToken alloc] initWithValue:value];
}

-(NSString *)description {
    return [NSString stringWithFormat:@"<%@: %ld>", [super description], self.value];
}

-(BOOL)isEqual:(id)object {
    if ([super isEqual:object]) {
        if ([object isKindOfClass:[NumToken class]]) {
            if(((NumToken *)object).value == self.value) {
                return YES;
            }
        }
    }
    return NO;
}

-(id)copyWithZone:(NSZone *)zone {
    NumToken *copy = [super copyWithZone:zone];
    if (copy) {
        copy.value = self.value;
    }
    return copy;
}

@end
