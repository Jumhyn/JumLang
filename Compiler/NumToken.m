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

@end
