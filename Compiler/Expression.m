//
//  Expression.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/3/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Expression.h"

@implementation Expression

@synthesize operator;
@synthesize type;

-(id)initWithOperator:(Token *)newOperator type:(TypeToken *)newType {
    if (self = [super init]) {
        operator = newOperator;
        type = newType;
    }
    return self;
}

@end
