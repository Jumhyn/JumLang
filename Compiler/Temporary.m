//
//  Temporary.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/2/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Temporary.h"

static NSUInteger count = 0;

@implementation Temporary

@synthesize number;

-(id)initWithType:(TypeToken *)newType {
    return self = [super initWithOperator:[WordToken tokenWithType:TOK_TEMP lexeme:@"t"] type:newType];
    number = ++count;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"t%lu", (unsigned long) number];
}

@end
