//
//  Node.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/3/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Token.h"

@class Label;

@interface Node : NSObject

@property(nonatomic, assign) NSUInteger lineNumber;

-(void)error:(NSString *)error;
-(Label *)newLabel;
-(void)emitLabel:(Label *)label;
-(void)emit:(NSString *)string;

@end
