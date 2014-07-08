//
//  Function.m
//  Kaleidoscope
//
//  Created by Freddy Kellison-Linn on 6/29/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Token.h"
#import "Function.h"
#import "Prototype.h"
#import "Statement.h"

#import "Identifier.h"

@implementation Function

@synthesize signature;
@synthesize body;

-(id)initWithSignature:(Prototype *)newSignature body:(Statement *)newBody stackSpace:(size_t)newStackSpace {
    if (self = [super init]) {
        self.signature = newSignature;
        self.body = newBody;
        self.stackSpace = newStackSpace;
    }
    return self;
}

-(void)generateCode {
#if LLVM == 0
    [self emit:[NSString stringWithFormat:@"%@:", self.signature.identifier]];
    [self emit:@"push base"];
    [self emit:@"mov stack -> base"];
    [self emit:[NSString stringWithFormat:@"sub %zu from stack", self.stackSpace]];
    Label *before = [self newLabel], *after = [self newLabel];
    [self emitLabel:before];
    [body generateCodeWithBeforeLabel:before afterLabel:after];
    [self emitLabel:after];
    [self emit:@"move base -> stack"];
    [self emit:@"pop base"];
    [self emit:@"return"];
#elif LLVM == 1
    NSMutableString *sig = [@"" mutableCopy];
    [sig appendString:[NSString stringWithFormat:@"define %@ %@(", self.signature.identifier.type, self.signature.identifier]];
    for (Identifier *arg in self.signature.arguments) {
        [sig appendString:[NSString stringWithFormat:@"%@ %@", arg.type, arg]];
        if ([self.signature.arguments indexOfObject:arg] < self.signature.arguments.count-1) {
            [sig appendString:@", "];
        }
    }
    [sig appendString:@") {"];
    [self emit:sig];
    if (self.signature.isEntry) {
        [self emit:@"entry:"];
    }
    Label *before = [self newLabel], *after = [self newLabel];
    [self emitLabel:before];
    [body generateCodeWithBeforeLabel:before afterLabel:after];
    if ([body needsAfterLabel]) {
        [self emitLabel:after];
    }
    [self emit:@"}"];
#endif
}

@end
