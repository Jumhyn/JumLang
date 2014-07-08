//
//  Node.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/3/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Node.h"
#import "Label.h"

static NSUInteger labels = 0;

@implementation Node

@synthesize lineNumber;

-(void)error:(NSString *)error {
    [NSException raise:@"Syntax Error" format:@"ERROR:%@ near line %lu", error, self.lineNumber];
}

-(Label *)newLabel {
    return [[Label alloc] initWithNumber:++labels];
}

-(void)emitLabel:(Label *)label {
    if (label.referenced) {
        printf("L%lu:\n", (unsigned long)label.number);
    }
}

-(void)emit:(NSString *)string {
    printf("%s\n", string.UTF8String);
}

@end
