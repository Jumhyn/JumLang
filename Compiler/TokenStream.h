//
//  TokenStream.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/1/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Token.h"

@interface TokenStream : NSObject {
    NSMutableArray *tokenArray;
    int currentIndex;
}

-(void)addToken:(Token *)token;
-(Token *)nextToken;
-(Token *)currentToken;
-(Token *)peek;
-(Token *)peekAhead:(NSUInteger)ahead;

@end
