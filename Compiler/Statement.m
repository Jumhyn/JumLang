//
//  Statement.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/3/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Statement.h"

@implementation Statement

@synthesize savedAfterLabelNumber;

-(void)generateCodeWithBeforeLabelNumber:(NSUInteger)beforeLabelNumber afterLabelNumber:(NSUInteger)afterLabelNumber {

}

static Statement *enclosing = nil;

+(Statement *)enclosing {
    return enclosing;
}

+(void)setEnclosing:(Statement *)newEnclosing {
    enclosing = newEnclosing;
}

@end
