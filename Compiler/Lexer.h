//
//  Lexer.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/1/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TokenStream;
@class Token;

@interface Lexer : NSObject {
    NSUInteger line;
    NSUInteger characterIndex;
    NSMutableDictionary *wordDict;
    TokenStream *stream;
}

@property(nonatomic, retain) NSString *buffer;

-(id)initWithString:(NSString *)string;

-(TokenStream *)lex;
-(Token *)nextToken;

@end
