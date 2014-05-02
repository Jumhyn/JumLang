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
#import "FloatToken.h"

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
    unichar currentChar = '\0';
    @try {
        currentChar = [buffer characterAtIndex:characterIndex];
    }
    @catch (NSException *exception) {
        if ([exception.name isEqualToString:@"NSRangeException"]) {
            return nil;
        }
    }
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
    while ((currentChar = [self nextCharacter]));
    if (currentChar == '/' && characterIndex < [buffer length] - 1) {
        if ([buffer characterAtIndex:characterIndex+1] == '/') {
            while ((currentChar = [self nextCharacter]) != '\n' && currentChar != '\0');
            line++;
            currentChar = [self nextCharacter];
        }
        else if ([buffer characterAtIndex:characterIndex+1] == '*') {
            currentChar = [self nextCharacter];
            while ((currentChar = [self nextCharacter]) != '\0') {
                if (currentChar == '*'  && characterIndex < [buffer length] - 1) {
                    if ((currentChar = [self nextCharacter]) == '/') {
                        currentChar = [self nextCharacter];
                        break;
                    }
                }
            }
        }
    }
    if (isdigit(currentChar)) {
        int val = 0;
        do {
            val = val*10 + (currentChar - '0');
            currentChar = [self nextCharacter];
        }
        while (isdigit(currentChar));
        if (currentChar == '.') {
            double doubleVal = (double) val;
            double tenPow = 1.0;
            while (isdigit((currentChar = [self nextCharacter]))) {
                doubleVal = doubleVal + (currentChar - '0')/pow(10.0, tenPow++);
            }
            return [FloatToken tokenWithValue:doubleVal];
        }
        return [NumToken tokenWithValue:val];
    }
    else if (isalpha(currentChar)) {
        NSMutableString *wordBuffer = [[NSMutableString alloc] initWithString:@""];
        do {
            [wordBuffer appendString:[NSString stringWithCharacters:&currentChar length:1]];
            currentChar = [self nextCharacter];
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
    else if (currentChar == '<') {
        if ((currentChar = [self nextCharacter]) == '=') {
            characterIndex++;
            return [Token tokenWithType:TOK_LEQUAL];
        }
        else {
            return [Token tokenWithType:'<'];
        }
    }
    else if (currentChar == '>') {
        if ((currentChar = [self nextCharacter]) == '=') {
            characterIndex++;
            return [Token tokenWithType:TOK_GEQUAL];
        }
        else {
            return [Token tokenWithType:'>'];
        }
    }
    else if (currentChar == '=') {
        if ((currentChar = [self nextCharacter]) == '=') {
            characterIndex++;
            return [Token tokenWithType:TOK_EQUAL];
        }
        else {
            return [Token tokenWithType:'='];
        }
    }
    else if (currentChar == '!') {
        if ((currentChar = [self nextCharacter]) == '=') {
            characterIndex++;
            return [Token tokenWithType:TOK_NEQUAL];
        }
        else {
            NSException *exception = [[NSException alloc] initWithName:@"Syntax error" reason:@"Error in syntax" userInfo:nil];
            [exception raise];
        }
    }
    else {
        characterIndex++;
        return [Token tokenWithType:currentChar];
    }
}

-(unichar)nextCharacter {
    @try {
        return [buffer characterAtIndex:++characterIndex];
    }
    @catch(NSException *exception) {
        if ([exception.name isEqualToString:@"NSRangeException"]) {
            return '\0';
        }
    }
}

@end
