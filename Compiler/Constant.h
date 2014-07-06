//
//  Constant.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/2/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Expression.h"

@interface Constant : Expression

-(id)initWithInteger:(NSInteger)integer;
-(id)initWithFloat:(double)value;

+(Constant *)trueConstant;
+(Constant *)falseConstant;

@end