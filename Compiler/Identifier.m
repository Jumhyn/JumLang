//
//  Identifier.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/3/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Identifier.h"
#import "Temporary.h"

@implementation Identifier

@synthesize offset;
@synthesize allocated;
@synthesize isArgument;

-(id)initWithOperator:(Token *)newOperator type:(TypeToken *)newType offset:(NSInteger)newOffset {
    if (self = [super initWithOperator:newOperator type:newType]) {
        self.offset = newOffset;
        self.allocated = NO;
        self.isArgument = NO;
    }
    return self;
}

-(Expression *)reduce {
    if (self.isArgument) {
        return self;
    }
    Temporary *temp = [[Temporary alloc] initWithType:self.type];
    [self emit:[NSString stringWithFormat:@"%@ = load %@* %@", temp, self.type, self]];
    return temp;
}

-(Expression *)generateRHS {
    return self.reduce;
}

-(NSString *)description {
#if LLVM == 0
    return [NSString stringWithFormat:@"%ld(base)", self.offset];
#elif LLVM == 1
    return [NSString stringWithFormat:@"%%%@", [super description]];
#endif
}

@end
