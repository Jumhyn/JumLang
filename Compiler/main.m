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

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Lexer *lex = [[Lexer alloc] initWithString:@"hello+9+true-false"];
        TokenStream *stream = [lex lex];
        Token *t;
        while ((t = [stream nextToken])) {
            NSLog(@"%@", t);
        }
    }
    return 0;
}

