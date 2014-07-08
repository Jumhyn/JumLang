//
//  Function.h
//  Kaleidoscope
//
//  Created by Freddy Kellison-Linn on 6/29/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Node.h"

@class Prototype;
@class Statement;

@interface Function : Node

@property(nonatomic, retain) Prototype *signature;
@property(nonatomic, retain) Statement *body;
@property(nonatomic, assign) size_t stackSpace;

-(id)initWithSignature:(Prototype *)newSignature body:(Statement *)newBody stackSpace:(size_t)newStackSpace;
-(void)generateCode;

@end
