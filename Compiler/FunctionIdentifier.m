//
//  FunctionIdentifier.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/6/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "FunctionIdentifier.h"

@implementation FunctionIdentifier

-(NSString *)description {
    return [NSString stringWithFormat:@"@%@", [(WordToken *)self.operator lexeme]];
}

@end
