//
//  Token.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/1/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Token.h"

@implementation Token

@synthesize line;
@synthesize type;

-(id)initWithType:(tokenType)newType {
    if (self = [super init]) {
        self.type = newType;
    }
    return self;
}

+(Token *)tokenWithType:(tokenType)type {
    return [[Token alloc] initWithType:type];
}

-(BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[Token class]]) {
        if(((Token *)object).type == self.type) {
            return YES;
        }
        return NO;
    }
    return NO;
}

-(NSUInteger)hash {
    return (NSUInteger)type;
}

-(NSString *)description {
    if (type < 128) {
        return [NSString stringWithFormat:@"%c", (char)self.type];
    }
    else {
        switch (self.type) {
            case TOK_LEQUAL:
                return @"'<='";
            case TOK_AND:
                return @"'&&'";
            case TOK_OR:
                return @"'||'";
            case TOK_GEQUAL:
                return @"'>='";
            case TOK_EQUAL:
                return @"'=='";
            case TOK_NEQUAL:
                return @"'!='";
            case TOK_IF:
                return @"'if'";
            case TOK_ELSE:
                return @"'else'";
            case TOK_WHILE:
                return @"'while'";
            case TOK_DO:
                return @"'do'";
            case TOK_BREAK:
                return @"'break'";

            case TOK_NUM:
                return @"integer constant";
            case TOK_FLOAT:
                return @"float constant";
            case TOK_ID:
                return @"identifier";
            case TOK_TYPE:
                return @"type specifier";

            case TOK_TRUE:
            case TOK_FALSE:
                return @"boolean constant";

            default:
                return @"unrecognized token";
        }
    }
}

-(id)copyWithZone:(NSZone *)zone {
    Token *copy = [[[self class] alloc] init];
    if (copy) {
        copy.type = self.type;
    }
    return copy;
}

@end