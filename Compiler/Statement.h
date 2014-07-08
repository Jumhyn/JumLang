//
//  Statement.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/3/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Node.h"

@interface Statement : Node

@property(nonatomic, assign) Label *savedAfterLabel;

-(void)generateCodeWithBeforeLabel:(Label *)beforeLabel afterLabel:(Label *)afterLabel;
-(BOOL)needsAfterLabel;
-(BOOL)needsBeforeLabel;

+(Statement *)enclosing;
+(void)setEnclosing:(Statement *)newEnclosing;

@end
