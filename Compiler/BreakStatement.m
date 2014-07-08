//
//  BreakStatement.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/4/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "BreakStatement.h"
#import "Label.h"

@implementation BreakStatement

@synthesize stmt;

-(id)init {
    if (self = [super init]) {
        if (!Statement.enclosing) {
            [self error:@"unenclosed break"];
        }
        self.stmt = Statement.enclosing;
    }
    return self;
}

-(void)generateCodeWithBeforeLabel:(Label *)beforeLabel afterLabel:(Label *)afterLabel {
#if LLVM == 0
    [self emit:[NSString stringWithFormat:@"goto L%lu", self.stmt.savedAfterLabel]];
#elif LLVM == 1
    [self emit:[NSString stringWithFormat:@"br label %%L%lu", self.stmt.savedAfterLabel.number]];
#endif
}

@end
