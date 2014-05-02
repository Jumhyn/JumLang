//
//  FloatToken.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/1/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Token.h"

@interface FloatToken : Token

@property(nonatomic, assign) double value;

-(id)initWithValue:(double)newValue;

+(FloatToken *)tokenWithValue:(double)value;

@end