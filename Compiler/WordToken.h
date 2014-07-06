//
//  WordToken.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/1/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Token.h"

@interface WordToken : Token

@property(nonatomic, retain) NSString *lexeme;

-(id)initWithType:(tokenType)newType lexeme:(NSString *)newLexeme;
+(WordToken *)tokenWithType:(tokenType)type lexeme:(NSString *)lexeme;

+(WordToken *)trueToken;
+(WordToken *)falseToken;

@end
