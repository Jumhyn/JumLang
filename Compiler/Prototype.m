//
//  Prototype.m
//  Kaleidoscope
//
//  Created by Freddy Kellison-Linn on 6/29/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Prototype.h"

@implementation Prototype

@synthesize identifier;
@synthesize arguments;

-(id)initWithIdentifier:(Identifier *)newIdentifier arguments:(NSArray *)newArguments {
    if (self = [super init]) {
        self.identifier = newIdentifier;
        self.arguments = newArguments;
    }
    return self;
}

@end
