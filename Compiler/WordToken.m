//
//  WordToken.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/1/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "WordToken.h"

@implementation WordToken

@synthesize lexeme;

-(id)initWithType:(tokenType)newType lexeme:(NSString *)newLexeme {
    if (self = [super initWithType:newType]) {
        self.lexeme = newLexeme;
    }
    return self;
}

+(WordToken *)tokenWithType:(tokenType)type lexeme:(NSString *)lexeme {
    return [[WordToken alloc] initWithType:type lexeme:lexeme];
}

@end
