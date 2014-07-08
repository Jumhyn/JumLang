//
//  Sequence.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/3/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Sequence.h"
#import "Label.h"

@implementation Sequence

@synthesize stmt1;
@synthesize stmt2;

-(id)initWithStatement1:(Statement *)newStmt1 statement2:(Statement *)newStmt2; {
    if (self = [super init]) {
        self.stmt1 = newStmt1;
        self.stmt2 = newStmt2;
    }
    return self;
}

-(void)generateCodeWithBeforeLabel:(Label *)beforeLabel afterLabel:(Label *)afterLabel {
    if (self.stmt2) {
        Label *label = [self newLabel];
        label.referenced = [stmt1 needsAfterLabel] || [stmt2 needsBeforeLabel];
        [stmt1 generateCodeWithBeforeLabel:beforeLabel afterLabel:label];
        [self emitLabel:label];
        [stmt2 generateCodeWithBeforeLabel:label afterLabel:afterLabel];
    }
    else {
        [stmt1 generateCodeWithBeforeLabel:beforeLabel afterLabel:afterLabel];
    }
}

-(BOOL)needsAfterLabel {
    if (self.stmt2) {
        return [self.stmt2 needsAfterLabel];
    }
    else {
        return [self.stmt1 needsAfterLabel];
    }
}

-(BOOL)needsBeforeLabel {
    return [self.stmt1 needsBeforeLabel];
}

@end
