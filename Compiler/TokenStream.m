//
//  TokenStream.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/1/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "TokenStream.h"

@implementation TokenStream

-(id)init {
    if (self = [super init]) {
        tokenArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)addToken:(Token *)token {
    [tokenArray addObject:token];
}

-(Token *)nextToken {
    if (currentIndex >= [tokenArray count]) {
        return nil;
    }
    return [tokenArray objectAtIndex:currentIndex++];
}

-(Token *)currentToken {
    if (currentIndex >= [tokenArray count]) {
        return nil;
    }
    return [tokenArray objectAtIndex:currentIndex];
}
-(Token *)peek {
    if (currentIndex >= [tokenArray count]-1) {
        return nil;
    }
    return [tokenArray objectAtIndex:currentIndex+1];
}
-(Token *)peekAhead:(NSUInteger)ahead {
    if (currentIndex >= [tokenArray count]-ahead) {
        return nil;
    }
    return [tokenArray objectAtIndex:currentIndex+ahead];
}

@end
