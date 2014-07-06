//
//  Token.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/1/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TOK_ANY = -1,
    TOK_PLUS = '+',
    TOK_MINUS = '-',
    TOK_LESS = '<',
    TOK_GREATER = '>',
    TOK_ASSIGN = '=',
    TOK_LCURL = '{',
    TOK_RCURL = '}',
    TOK_LPAREN = '(',
    TOK_RPAREN = ')',
    TOK_LBRACKET = '[',
    TOK_RBRACKET = ']',
    TOK_SEMI = ';',
    TOK_NOT = '!',
    TOK_LEQUAL = 256,
    TOK_AND,
    TOK_OR,
    TOK_GEQUAL,
    TOK_EQUAL,
    TOK_NEQUAL,
    TOK_NUM,
    TOK_FLOAT,
    TOK_ID,
    TOK_TRUE,
    TOK_FALSE,
    TOK_TYPE,
    TOK_IF,
    TOK_ELSE,
    TOK_WHILE,
    TOK_DO,
    TOK_BREAK,
    TOK_RETURN,
    TOK_TEMP,
} tokenType;

@interface Token : NSObject <NSCopying>

@property(nonatomic, assign) NSUInteger line;
@property(nonatomic, assign) tokenType type;

-(id)initWithType:(tokenType)newType;

+(Token *)tokenWithType:(tokenType)type;

@end
