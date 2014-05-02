//
//  Parser.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/1/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Token.h"
#import "TokenStream.h"

@interface Parser : NSObject

@property(nonatomic, retain) Token *lookahead;
@property(nonatomic, retain) TokenStream *stream;

@end
