//
//  Identifier.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/3/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Identifier.h"

@implementation Identifier

-(id)initWithOperator:(Token *)newOperator type:(TypeToken *)newType offset:(NSInteger)newOffset {
    if (self = [super initWithOperator:newOperator type:newType]) {
        offset = newOffset;
    }
    return self;
}

@end
