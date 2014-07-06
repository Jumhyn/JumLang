//
//  CallExpression.m
//  Kaleidoscope
//
//  Created by Freddy Kellison-Linn on 6/29/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "CallExpression.h"
#import "Identifier.h"
#import "Temporary.h"

@implementation CallExpression

@synthesize identifier;
@synthesize arguments;

-(id)initWithIdentifier:(Identifier *)newIdentifier arguments:(NSArray *)newArguments {
    if (self = [super init]) {
        self.identifier = newIdentifier;
        self.arguments = newArguments;
        self.type = newIdentifier.type;
    }
    return self;
}

-(Expression *)generateRHS {
    return self.reduce;
}

-(Expression *)reduce {
    for (Expression *arg in self.arguments) {
        [self emit:[NSString stringWithFormat:@"push %@", arg.reduce]];
    }
    Temporary *temp = [[Temporary alloc] initWithType:self.type];
    [self emit:[NSString stringWithFormat:@"%@ = %@", temp, self]];
    return temp;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"call %@", self.identifier];
}

@end
