//
//  Node.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/3/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Node.h"

static NSUInteger labels = 0;

@implementation Node

@synthesize lineNumber;

-(void)error:(NSString *)error {
    [NSException raise:@"Syntax Error" format:@"ERROR:%@ near line %lu", error, self.lineNumber];
}

-(NSUInteger)newLabel {
    return ++labels;
}

-(void)emitLabel:(NSUInteger)label {
    printf("L%lu:\n", (unsigned long)label);
}

-(void)emit:(NSString *)string {
    printf("%s\n", string.UTF8String);
}

@end
