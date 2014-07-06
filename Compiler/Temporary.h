//
//  Temporary.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/2/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Expression.h"

@class TypeToken;

@interface Temporary : Expression

@property(nonatomic, assign) NSUInteger number;

-(id)initWithType:(TypeToken *)newType;

@end
