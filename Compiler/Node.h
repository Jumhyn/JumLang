//
//  Node.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/3/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Node : NSObject

@property(nonatomic, assign) NSUInteger lineNumber;

-(void)error:(NSString *)error;
-(NSUInteger)newLabel;
-(void)emitLabel:(NSUInteger)label;
-(void)emit:(NSString *)string;

@end
