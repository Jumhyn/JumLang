//
//  Access.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/10/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Access.h"
#import "Identifier.h"
#import "Temporary.h"
#import "ArrayType.h"

@implementation Access

-(id)initWithIdentifier:(Identifier *)newArray indexExpression:(Expression *)newIndex type:(TypeToken *)newType {
    if (self = [super initWithOperator:[WordToken tokenWithType:TOK_INDEX lexeme:@"[]"] type:newType]) {
        self.array = newArray;
        self.index = newIndex;
    }
    return self;
}

-(Expression *)generateRHS {
    return [[Access alloc] initWithIdentifier:self.array indexExpression:[self.index reduce] type:self.type];
}

-(Expression *)reduce {
    if (!self.array.isAllocated) {
        [self emit:[NSString stringWithFormat:@"%@ = alloca [%zu x %@]", self.array, [(ArrayType *)self.array.type elements], [(ArrayType *)self.array.type to]]];
        self.array.allocated = YES;
    }

    Temporary *index = [[Temporary alloc] initWithType:[[PointerType alloc] initWithReferencedType:self.type]];
    [self emit:[NSString stringWithFormat:@"%@ = getelementptr %@ %@, i32 0, %@ %@", index, self.array.type, self.array, self.index.type, [self.index reduce]]];
    Temporary *temp = [[Temporary alloc] initWithType:self.type];
    [self emit:[NSString stringWithFormat:@"%@ = load %@ %@", temp, index.type, index]];
    return temp;
}

@end
