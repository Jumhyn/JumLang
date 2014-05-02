//
//  Parser.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/1/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Parser.h"
#import "NumToken.h"

@implementation Parser

@synthesize lookahead;
@synthesize stream;

-(id)initWithTokenStream:(TokenStream *)newStream {
    if (self = [super init]) {
        self.stream = newStream;
        self.lookahead = [self.stream nextToken];
    }
    return self;
}

-(void)expr {
    [self term];
    while (true) {
        if (lookahead.type == TOK_PLUS) {
            [self match:TOK_PLUS];
            [self term];
            putchar('+');
        }
        else if (lookahead.type == TOK_MINUS) {
            [self match:TOK_MINUS];
            [self term];
            putchar('-');
        }
        else return;
    }
  
}

-(void)term {
    if (lookahead.type == TOK_NUM) {
        putchar((int)((NumToken *)lookahead).value+'0');
        [self match:TOK_NUM];
    }
}

-(void)match:(tokenType)toMatch {
    if (lookahead.type == toMatch) {
        lookahead = [stream nextToken];
    }
    else {
        NSException *exception = [[NSException alloc] initWithName:@"Syntax error" reason:@"Error in syntax" userInfo:nil];
        [exception raise];
    }
}

@end
