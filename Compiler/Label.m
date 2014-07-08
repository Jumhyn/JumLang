//
//  Label.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/7/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Label.h"

@implementation Label

-(id)initWithNumber:(NSUInteger)newNumber {
    if (self = [super init]) {
        self.number = newNumber;
    }
    return self;
}

@end
