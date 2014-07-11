//
//  PointerType.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/10/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "PointerType.h"

@implementation PointerType

@synthesize to;

-(id)initWithReferencedType:(TypeToken *)newType {
    if (self = [super initWithType:TOK_TYPE lexeme:[newType.lexeme stringByAppendingString:@"*"] width:TypeToken.intType.width]) {
        self.to = newType;
    }
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"%@*", self.to];
}

@end
