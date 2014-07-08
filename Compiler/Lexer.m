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
#import "TypeToken.h"
#import "TokenStream.h"

#define isws(x) x==' '||x=='\t'||x=='\n'||x=='\r'

@implementation Lexer

@synthesize buffer;

-(void)error:(NSString *)error {
    [NSException raise:@"Syntax Error" format:@"%@ near line %lu", error, line];
}

-(id)init {
    if (self = [super init]) {
        line = 0;
        characterIndex = 0;
        wordDict = [[NSMutableDictionary alloc] init];
        stream = [[TokenStream alloc] init];
        [self reserveWord:WordToken.trueToken];
        [self reserveWord:WordToken.falseToken];
        [self reserveWord:[WordToken tokenWithType:TOK_IF lexeme:@"if"]];
        [self reserveWord:[WordToken tokenWithType:TOK_ELSE lexeme:@"else"]];
        [self reserveWord:[WordToken tokenWithType:TOK_WHILE lexeme:@"while"]];
        [self reserveWord:[WordToken tokenWithType:TOK_DO lexeme:@"do"]];
        [self reserveWord:[WordToken tokenWithType:TOK_BREAK lexeme:@"break"]];
        [self reserveWord:[WordToken tokenWithType:TOK_RETURN lexeme:@"return"]];
        [self reserveWord:[WordToken tokenWithType:TOK_ENTRY lexeme:@"entry"]];
        [self reserveWord:TypeToken.charType];
        [self reserveWord:TypeToken.intType];
        [self reserveWord:TypeToken.floatType];
        [self reserveWord:TypeToken.boolType];
    }
    return self;
}

-(id)initWithString:(NSString *)string {
    if (self = [self init]) {
        self.buffer = string;
    }
    return self;
}

-(id)initWithContentsOfFile:(NSString *)path {
    return [self initWithString:[[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil]];
}

-(void)reserveWord:(WordToken *)word {
    [wordDict setObject:word forKey:word.lexeme];
}

-(TokenStream *)lex {
    Token *tok;
    while ((tok = [self nextToken])) {
        tok.line = line;
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
        do {
            if (currentChar == '\t' || currentChar == ' ') {
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
    } while ((currentChar == '/' && characterIndex < [buffer length] - 1) || isws(currentChar));
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
        WordToken *tok = [[wordDict objectForKey:wordBuffer] copy];
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
            [self error:@"unary '!' is not yet supported"];
        }
    }
    else if (currentChar == '&') {
        if ((currentChar = [self nextCharacter]) == '&') {
            characterIndex++;
            return [Token tokenWithType:TOK_AND];
        }
    }
    else if (currentChar == '&') {
        if ((currentChar = [self nextCharacter]) == '&') {
            characterIndex++;
            return [Token tokenWithType:TOK_AND];
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
