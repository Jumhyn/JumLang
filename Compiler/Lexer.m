//
//  Lexer.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/1/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Lexer.h"
#import "Token.h"
#import "NumToken.h"
#import "WordToken.h"

@implementation Lexer

@synthesize buffer;

-(id)initWithString:(NSString *)string {
    if (self = [super init]) {
        self.buffer = string;
        line = 0;
        characterIndex = 0;
        wordDict = [[NSMutableDictionary alloc] init];
        stream = [[TokenStream alloc] init];
        [self reserveWord:[WordToken tokenWithType:TOK_TRUE lexeme:@"true"]];
        [self reserveWord:[WordToken tokenWithType:TOK_FALSE lexeme:@"false"]];
    }
    return self;
}

-(void)reserveWord:(WordToken *)word {
    [wordDict setObject:word forKey:word.lexeme];
}

-(TokenStream *)lex {
    Token *tok;
    while ((tok = [self nextToken])) {
        [stream addToken:tok];
    }
    return stream;
}
            
-(Token *)nextToken {
    unichar currentChar = [buffer characterAtIndex:characterIndex];
    do {
        if (currentChar == ' ' || currentChar == '\t') {
            continue;
        }
        else if (currentChar == '\n') {
            line++;
            continue;
        }
        else {
            break;
        }
    }
    while ((currentChar = [buffer characterAtIndex:++characterIndex]));
    if (isdigit(currentChar)) {
        int val;
        do {
            val = val*10 + (currentChar - '0');
            currentChar = [buffer characterAtIndex:++characterIndex];
        }
        while (isdigit(currentChar));
        return [NumToken tokenWithValue:val];
    }
    else if (isalpha(currentChar)) {
        NSMutableString *wordBuffer = [[NSMutableString alloc] initWithString:@""];
        do {
            [wordBuffer appendString:[NSString stringWithCharacters:&currentChar length:1]];
            currentChar = [buffer characterAtIndex:++characterIndex];
        }
        while (isalpha(currentChar));
        WordToken *tok = [wordDict objectForKey:wordBuffer];
        if (tok) {
            return tok;
        }
        else {
            WordToken *ret = [WordToken tokenWithType:TOK_ID lexeme:[NSString stringWithString:wordBuffer]];
            [wordDict setObject:ret forKey:ret.lexeme];
            return ret;
        }
    }
    else {
        return [Token tokenWithType:currentChar];
    }
}

@end
