//
//  TypeToken.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/3/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "TypeToken.h"

@implementation TypeToken

@dynamic isNumeric;
@dynamic width;

-(id)initWithType:(tokenType)newType lexeme:(NSString *)newLexeme width:(size_t)newWidth {
    if (self = [super initWithType:newType lexeme:newLexeme]) {
        width = newWidth;
    }
    return self;
}

-(BOOL)isNumeric {
    if (self == TypeToken.charType || self == TypeToken.intType || self == TypeToken.floatType) {
        return YES;
    }
    return NO;
}

-(size_t)width {
    return width;
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

+(TypeToken *)boolType {
    static TypeToken *boolType = nil;
    if (boolType == nil) {
        boolType = [[TypeToken alloc] initWithType:TOK_TYPE lexeme:@"boolean" width:1];
    }
    return boolType;
}

@end
