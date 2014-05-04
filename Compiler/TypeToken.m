//
//  TypeToken.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/3/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "TypeToken.h"

@implementation TypeToken

-(id)initWithType:(tokenType)newType lexeme:(NSString *)newLexeme width:(size_t)newWidth {
    if (self = [super initWithType:newType lexeme:newLexeme]) {
        width = newWidth;
    }
    return self;
}

+(TypeToken *)charType {
    static TypeToken *charType = nil;
    if (charType == nil) {
        charType = [[TypeToken alloc] initWithType:TOK_TYPE lexeme:@"char" width:1];
    }
    return charType;
}

+(TypeToken *)intType {
    static TypeToken *intType = nil;
    if (intType == nil) {
        intType = [[TypeToken alloc] initWithType:TOK_TYPE lexeme:@"int" width:4];
    }
    return intType;
}

+(TypeToken *)floatType {
    static TypeToken *floatType = nil;
    if (floatType == nil) {
        floatType = [[TypeToken alloc] initWithType:TOK_TYPE lexeme:@"float" width:8];
    }
    return floatType;
}

@end
