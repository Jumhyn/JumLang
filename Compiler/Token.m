//
//  Token.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/1/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Token.h"

@implementation Token

@synthesize type;

-(id)initWithType:(tokenType)newType {
    if (self = [super init]) {
        self.type = newType;
    }
    return self;
}

+(Token *)tokenWithType:(tokenType)type {
    return [[Token alloc] initWithType:type];
}

-(BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[Token class]]) {
        if(((Token *)object).type == self.type) {
            return YES;
        }
        return NO;
    }
    return NO;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"<%d>", self.type];
}

@end