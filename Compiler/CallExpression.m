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
#import "Environment.h"
#import "Prototype.h"

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
#if LLVM == 0
    for (Expression *arg in [self.arguments reverseObjectEnumerator]) {
        [self emit:[NSString stringWithFormat:@"push %@", arg.reduce]];
    }
    Temporary *temp = [[Temporary alloc] initWithType:self.type];
    [self emit:[NSString stringWithFormat:@"%@ = %@", temp, self]];
    return temp;
#elif LLVM == 1
    NSMutableArray *reducedArray = [[NSMutableArray alloc] init];
    NSUInteger index = 0;
    for (Expression *arg in self.arguments) {
        TypeToken *type = [(Expression *)[[[Environment.globalScope prototypeForToken:identifier.operator] arguments] objectAtIndex:index] type];
        [reducedArray addObject:[arg convert:type]];
        index++;
    }
    return [[CallExpression alloc] initWithIdentifier:self.identifier arguments:[NSArray arrayWithArray:reducedArray]];
#endif
}

-(Expression *)reduce {
    Temporary *temp = [[Temporary alloc] initWithType:self.type];
    [self emit:[NSString stringWithFormat:@"%@ = %@", temp, [self generateRHS]]];
    return temp;
}

-(NSString *)description {
#if LLVM == 0
    return [NSString stringWithFormat:@"call %@", self.identifier];
#elif LLVM == 1
    NSMutableString *call = [[NSString stringWithFormat:@"call %@ %@(", self.identifier.type, self.identifier] mutableCopy];
    for (Expression *arg in self.arguments) {
        [call appendFormat:@"%@ %@", arg.type, arg];
        if ([self.arguments indexOfObject:arg] < self.arguments.count-1) {
            [call appendString:@", "];
        }
    }
    [call appendString:@")"];
    return call;
#endif
}

@end
