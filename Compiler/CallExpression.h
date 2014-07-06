//
//  CallExpression.h
//  Kaleidoscope
//
//  Created by Freddy Kellison-Linn on 6/29/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Expression.h"

@class Identifier;

@interface CallExpression : Expression

@property(nonatomic, retain) Identifier *identifier;
@property(nonatomic, retain) NSArray *arguments;

-(id)initWithIdentifier:(Identifier *)newIdentifier arguments:(NSArray *)newArguments;

@end
