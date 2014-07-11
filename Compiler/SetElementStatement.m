//
//  SetElementStatement.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/10/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "SetElementStatement.h"
#import "ArrayType.h"
#import "Identifier.h"
#import "Temporary.h"

@implementation SetElementStatement

@synthesize element;
@synthesize expr;

-(id)initWithElement:(Access *)newElement expression:(Expression *)newExpr {
    if (self = [super init]) {
        self.element = newElement;
        self.expr = newExpr;
    }
    return self;
}

-(void)generateCodeWithBeforeLabel:(Label *)beforeLabel afterLabel:(Label *)afterLabel {
    if (!self.element.array.isAllocated) {
        [self emit:[NSString stringWithFormat:@"%@ = alloca [%zu x %@]", self.element.array, [(ArrayType *)self.element.array.type elements], [(ArrayType *)self.element.array.type to]]];
        self.element.array.allocated = YES;
    }

    Temporary *index = [[Temporary alloc] initWithType:[[PointerType alloc] initWithReferencedType:self.element.type]];
    [self emit:[NSString stringWithFormat:@"%@ = getelementptr %@ %@, i32 0, %@ %@", index, self.element.array.type, self.element.array, self.element.index.type, [self.element.index reduce]]];
    Expression *reduced = [self.expr reduce];
    [self emit:[NSString stringWithFormat:@"store %@ %@, %@ %@", reduced.type, reduced, index.type, index]];
}

@end
