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

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Lexer *lex = [[Lexer alloc] initWithString:@"{\
                                                          int hello;\
                                                          hello = 5;\
                                                          if (hello + 3 > hello*-4) {\
                                                              int test;\
                                                              float testalso;\
                                                              test = hello + 3;\
                                                              testalso = 3.0 * test + 3 / 5.0;\
                                                              hello = 6;\
                                                          }\
                                                     }"];
        TokenStream *stream = [lex lex];
        Statement *s = [[[Parser alloc] initWithTokenStream:stream] program];
        Token *t;
        while ((t = [stream nextToken])) {
            NSLog(@"%@", t);
        }
    }
    return 0;
}

