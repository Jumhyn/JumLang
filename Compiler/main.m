//
//  main.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/1/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Lexer.h"
#import "TokenStream.h"
#import "Statement.h"
#import "Parser.h"
#import "Function.h"
#import "Environment.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        //Lexer *lex = [[Lexer alloc] initWithString:@"int test(int a, float b) {\
                                                          int hello;\
                                                          hello = 5;\
                                                          hello = test(b-2, a-1);\
                                                          if (hello + 3 > hello*-4) {\
                                                              int test;\
                                                              float testalso;\
                                                              test = hello + 3;\
                                                              testalso = 3.0 * test + 3 / 5.0;\
                                                              hello = 6;\
                                                          }\
                                                     }"];
        Lexer *lex = [[Lexer alloc] initWithContentsOfFile:@"/Users/freddy/Development/Xcode Projects/Compiler/Compiler/JumTest.jum"];
        TokenStream *stream = [lex lex];
        printf("target triple = \"x86_64-apple-macosx10.10.0\"\n");
        NSArray *program = [[[Parser alloc] initWithTokenStream:stream] program];
        [Environment.globalScope initializeStrings];
        for (Function *func in program) {
            [func generateCode];
        }
        Token *t;
        while ((t = [stream nextToken])) {
            NSLog(@"%@", t);
        }
    }
    return 0;
}

