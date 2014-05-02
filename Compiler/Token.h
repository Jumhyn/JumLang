//
//  Token.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/1/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TOK_PLUS = '+',
    TOK_MINUS = '-',
    TOK_NUM,
    TOK_ID,
    TOK_TRUE,
    TOK_FALSE,
} tokenType;

@interface Token : NSObject

@property(nonatomic, assign) tokenType type;

-(id)initWithType:(tokenType)newType;

+(Token *)tokenWithType:(tokenType)type;

@end