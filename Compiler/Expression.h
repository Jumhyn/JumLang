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

@class Label;

@interface Expression : Node

@property(nonatomic, retain) Token *operator;
@property(nonatomic, retain) TypeToken *type;

-(id)initWithOperator:(Token *)newOperator type:(TypeToken *)newType;

-(Expression *)generateRHS;
-(Expression *)reduce;
-(Expression *)convert:(TypeToken *)to;
-(void)jumpingForTrueLabel:(Label *)trueLabel falseLabel:(Label *)falseLabel;
-(void)emitJumpsForTest:(NSString *)test trueLabel:(Label *)trueLabel falseLabel:(Label *)falseLabel;

@end
