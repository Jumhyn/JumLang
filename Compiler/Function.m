//
//  Function.m
//  Kaleidoscope
//
//  Created by Freddy Kellison-Linn on 6/29/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Function.h"
#import "Prototype.h"
#import "Statement.h"

@implementation Function

@synthesize signature;
@synthesize body;

-(id)initWithSignature:(Prototype *)newSignature body:(Statement *)newBody {
    if (self = [super init]) {
        self.signature = newSignature;
        self.body = newBody;
    }
    return self;
}

-(void)generateCode {
    [self emit:[NSString stringWithFormat:@"%@:", self.signature.identifier]];
    NSUInteger before = [self newLabel], after = [self newLabel];
    [self emitLabel:before];
    [body generateCodeWithBeforeLabelNumber:before afterLabelNumber:after];
    [self emitLabel:after];
    [self emit:@"return"];
}

@end
