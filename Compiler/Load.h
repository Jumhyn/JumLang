//
//  Load.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/10/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Expression.h"

@class Identifier;

@interface Load : Expression

@property(nonatomic, retain) Identifier *identifier;

-(id)initWithIdentifier:(Identifier *)newIdentifier;

@end
