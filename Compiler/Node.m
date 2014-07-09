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
#if LLVM == 1
static BOOL blockEnd = YES;
static BOOL codeReachable = YES;

@implementation NSString (LLVMExtensions)

-(BOOL)endsBasicBlock {
    return [self hasPrefix:@"ret"] || [self hasPrefix:@"br"] || [self hasPrefix:@"switch"] || [self hasPrefix:@"indirectbr"] || [self hasPrefix:@"invoke"] || [self hasPrefix:@"resume"] || [self hasPrefix:@"unreachable"];
}

@end
#endif

@implementation Node

@synthesize lineNumber;

-(void)error:(NSString *)error {
    [NSException raise:@"Syntax Error" format:@"ERROR:%@ near line %lu", error, self.lineNumber];
}

-(Label *)newLabel {
    return [[Label alloc] initWithNumber:++labels];
}

-(void)emitLabel:(Label *)label {
#if LLVM == 0
    printf("L%lu:\n", (unsigned long)label.number);
#elif LLVM == 1
    if (label.referenced) {
        if (!blockEnd) {
            printf("br label %%L%lu\n", (unsigned long)label.number);
        }
        printf("L%lu:\n", (unsigned long)label.number);
        codeReachable = YES;
    }
#endif
}

-(void)emit:(NSString *)string {
#if LLVM == 1
    if ([string hasPrefix:@"}"]) {
        codeReachable = YES;
    }
    if (!codeReachable) {
        printf("unreachable\n");
    }
    if ([string endsBasicBlock]) {
        if ([string hasPrefix:@"ret"]) {
            codeReachable = NO;
        }
        blockEnd = YES;
    }
    else if (!([string hasPrefix:@"define"] || [string hasPrefix:@"}"])) {
        blockEnd = NO;
    }
#endif
    printf("%s\n", string.UTF8String);
}

@end
