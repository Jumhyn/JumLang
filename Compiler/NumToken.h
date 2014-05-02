//
//  NumToken.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/1/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Token.h"

@interface NumToken : Token

@property(nonatomic, assign) NSInteger value;

-(id)initWithValue:(NSInteger)newValue;

+(NumToken *)tokenWithValue:(NSInteger)value;

@end
