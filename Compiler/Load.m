//
//  Load.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/10/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Load.h"
#import "Identifier.h"

@implementation Load

@synthesize identifier;

-(id)initWithIdentifier:(Identifier *)newIdentifier {
    if (self = [super initWithOperator:newIdentifier.operator type:newIdentifier.type]) {
        self.identifier = newIdentifier;
    }
    return self;
}

-(Expression *)generateRHS {
    return self;
}

-(Expression *)reduce {
    return self.identifier.reduce;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"load %@* %@", self.identifier.type, self.identifier];
}

@end
