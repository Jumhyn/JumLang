//
//  Statement.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/3/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Node.h"

@interface Statement : Node

@property(nonatomic, assign) NSUInteger savedAfterLabelNumber;

-(void)generateCodeWithBeforeLabelNumber:(NSUInteger)beforeLabelNumber afterLabelNumber:(NSUInteger)afterLabelNumber;

+(Statement *)enclosing;
+(void)setEnclosing:(Statement *)newEnclosing;

@end
