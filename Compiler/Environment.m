//
//  Environment.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/2/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Environment.h"
#import "Identifier.h"

@implementation Environment

@synthesize symbolTable;
@synthesize previousEnvironment;

-(void)error:(NSString *)error line:(NSUInteger)line {
    [NSException raise:@"Sematic Error" format:@"%@ near line %lu", error, line];
}

-(id)initWithPreviousEnvironment:(Environment *)newPreviousEnvironment {
    if (self = [super init]) {
        self.symbolTable = [[NSMutableDictionary alloc] init];
        self.previousEnvironment = newPreviousEnvironment;
    }
    return self;
}

-(Identifier *)identifierForToken:(Token *)token {
    for (Environment *env = self; env != nil; env = env.previousEnvironment) {
        Identifier *ret;
        if ((ret = [env.symbolTable objectForKey:token])) {
            return ret;
        }
    }
    [self error:[NSString stringWithFormat:@"use of undeclared identifier %@", [(WordToken *)token lexeme]] line:token.line];
    return nil;
}

-(void)setIdentifier:(Identifier *)identifier forToken:(Token *)token {
    [self.symbolTable setObject:identifier forKey:token];
}

@end
