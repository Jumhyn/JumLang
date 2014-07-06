//
//  BreakStatement.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/4/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "BreakStatement.h"

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

-(void)generateCodeWithBeforeLabelNumber:(NSUInteger)beforeLabelNumber afterLabelNumber:(NSUInteger)afterLabelNumber {
    [self emit:[NSString stringWithFormat:@"goto L%lu", self.stmt.savedAfterLabelNumber]];
}

@end
