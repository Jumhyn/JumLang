//
//  Expression.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/3/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Expression.h"

@implementation Expression

@synthesize operator;
@synthesize type;

-(id)initWithOperator:(Token *)newOperator type:(TypeToken *)newType {
    if (self = [super init]) {
        operator = newOperator;
        type = newType;
    }
    return self;
}

-(Expression *)generateRHS {
    return self;
}

-(Expression *)reduce {
    return self;
}

-(void)jumpingForTrueLabelNumber:(NSUInteger)trueLabelNumber falseLabelNumber:(NSUInteger)falseLabelNumber {
    [self emitJumpsForTest:[self description] TrueLabelNumber:trueLabelNumber falseLabelNumber:falseLabelNumber];
}

-(void)emitJumpsForTest:(NSString *)test TrueLabelNumber:(NSUInteger)trueLabelNumber falseLabelNumber:(NSUInteger)falseLabelNumber {
    if (trueLabelNumber != 0 && falseLabelNumber != 0) {
        [self emit:[NSString stringWithFormat:@"if %@ goto L%lu", test, trueLabelNumber]];
        [self emit:[NSString stringWithFormat:@"goto L%lu", falseLabelNumber]];
    }
    else if (trueLabelNumber == 0) {
        [self emit:[NSString stringWithFormat:@"iffalse %@ goto L%lu", test, falseLabelNumber]];
    }
    else if (falseLabelNumber == 0) {
        [self emit:[NSString stringWithFormat:@"if %@ goto L%lu", test, trueLabelNumber]];
    }
}

-(NSString *)description {
    return operator.description;
}

@end
