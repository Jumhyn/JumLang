//
//  Access.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/10/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Operator.h"

@class Identifier;

@interface Access : Operator

@property(nonatomic, retain) Identifier *array;
@property(nonatomic, retain) Expression *index;

-(id)initWithIdentifier:(Identifier *)newArray indexExpression:(Expression *)newIndex type:(TypeToken *)newType;

@end
