//
//  Identifier.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/3/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Identifier.h"
#import "Temporary.h"
#import "Load.h"
#import "PointerType.h"

@implementation Identifier

@synthesize offset;
@synthesize allocated;
@synthesize isArgument;
@synthesize global;
@synthesize enclosingFuncName;

-(id)initWithOperator:(Token *)newOperator type:(TypeToken *)newType offset:(NSInteger)newOffset {
    if (self = [super initWithOperator:newOperator type:newType]) {
        self.offset = newOffset;
        self.allocated = NO;
        self.isArgument = NO;
        self.global = NO;
        self.enclosingFuncName = @"";
        self.scopeNumber = 0;
    }
    return self;
}

-(Expression *)reduce {
    Temporary *temp = [[Temporary alloc] initWithType:self.type];
    [self emit:[NSString stringWithFormat:@"%@ = load %@* %@", temp, self.type, self]];
    return temp;
}

-(Expression *)generateRHS {
    return [[Load alloc] initWithIdentifier:self];
}

-(NSString *)description {
#if LLVM == 0
    return [NSString stringWithFormat:@"%ld(base)", self.offset];
#elif LLVM == 1
    NSString *prefix = (self.isGlobal) ? @"@" : @"%";
    NSString *postfix = (self.isArgument) ? @".arg" : [NSString stringWithFormat:@".%@.%lu", self.enclosingFuncName, self.scopeNumber];
    return [NSString stringWithFormat:@"%@%@%@", prefix, [super description], postfix];
#endif
}

@end
