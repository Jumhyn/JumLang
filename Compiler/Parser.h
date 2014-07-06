//
//  Parser.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/1/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Token;
@class Statement;
@class TokenStream;
@class Environment;
@class Prototype;

@interface Parser : NSObject

@property(nonatomic, retain) Token *lookahead;
@property(nonatomic, retain) TokenStream *stream;
@property(nonatomic, retain) Environment *topEnvironment;
@property(nonatomic, retain) Prototype *currentFunc;
@property(nonatomic, assign) NSInteger usedSpace;

-(id)initWithTokenStream:(TokenStream *)newStream;
-(NSArray *)program;

@end
