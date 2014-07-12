//
//  ArrayToken.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/10/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "ArrayType.h"

@implementation ArrayType

@synthesize elements;
@synthesize to;

-(id)initWithType:(TypeToken *)newType elements:(size_t)newElements {
    if (self = [super initWithReferencedType:newType]) {
        self.elements = newElements;
        self.type = TOK_ARRAY;
    }
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"[%zu x %@]*", self.elements, self.to];
}

-(BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[ArrayType class]]) {
        return [self.to isEqual:[(ArrayType *)object to]] && [(ArrayType *)object elements] == self.elements;
    }
    return NO;
}

@end
