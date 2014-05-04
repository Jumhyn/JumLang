//
//  Expression.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/3/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Node.h"
#import "Token.h"
#import "TypeToken.h"

@interface Expression : Node

@property(nonatomic, retain) Token *operator;
@property(nonatomic, retain) TypeToken *type;

-(id)initWithOperator:(Token *)newOperator type:(TypeToken *)newType;

@end
