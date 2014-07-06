//
//  AssignStatement.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/4/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "AssignStatement.h"
#import "Expression.h"
#import "Identifier.h"
#import "TypeToken.h"

@implementation AssignStatement

-(id)initWithIdentifier:(Identifier *)newIdentifier expression:(Expression *)newExpr {
    if (self = [super init]) {
        self.identifier = newIdentifier;
        self.expr = newExpr;
        if (![self checkType1:self.identifier.type againstType2:self.expr.type]) {
            [self error:@"type error"];
        }
    }
    return self;
}

-(TypeToken *)checkType1:(TypeToken *)type1 againstType2:(TypeToken *)type2 {
    if (type1.isNumeric && type2.isNumeric) {
        return type1;
    }
    else if (type1 == TypeToken.boolType && type2 == TypeToken.boolType) {
        return type1;
    }
    return nil;
}

-(void)generateCodeWithBeforeLabelNumber:(NSUInteger)beforeLabelNumber afterLabelNumber:(NSUInteger)afterLabelNumber {
    [self emit:[NSString stringWithFormat:@"%@ = %@", self.identifier, [self.expr generateRHS]]];
}

@end
