//
//  Expression.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/3/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Expression.h"
#import "Temporary.h"

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

-(Expression *)convert:(TypeToken *)to {
    if (self.type == to) {
        return [self reduce];
    }
    else if (self.type == TypeToken.intType && to == TypeToken.floatType) {
        Temporary *temp = [[Temporary alloc] initWithType:to];
        [self emit:[NSString stringWithFormat:@"%@ = sitofp %@ %@ to %@", temp, self.type, [self reduce], to]];
        return temp;
    }
    else if (self.type == TypeToken.floatType && to == TypeToken.intType) {
        Temporary *temp = [[Temporary alloc] initWithType:to];
        [self emit:[NSString stringWithFormat:@"%@ = fptosi %@ %@ to %@", temp, self.type, [self reduce], to]];
        return temp;
    }
    else {
        [self error:[NSString stringWithFormat:@"type error when trying to convert %@ to %@", self.type, to]];
        return nil;
    }
}

-(void)jumpingForTrueLabelNumber:(NSUInteger)trueLabelNumber falseLabelNumber:(NSUInteger)falseLabelNumber {
    [self emitJumpsForTest:[self description] TrueLabelNumber:trueLabelNumber falseLabelNumber:falseLabelNumber];
}

-(void)emitJumpsForTest:(NSString *)test TrueLabelNumber:(NSUInteger)trueLabelNumber falseLabelNumber:(NSUInteger)falseLabelNumber {
#if LLVM == 0
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
#elif LLVM == 1
    if (trueLabelNumber != 0 && falseLabelNumber != 0) {
        [self emit:[NSString stringWithFormat:@"br i1 %@, label %%L%lu, label %%L%lu", test, trueLabelNumber, falseLabelNumber]];
    }
    else if (trueLabelNumber == 0) {
        [self emit:[NSString stringWithFormat:@"iffalse %@ goto L%lu", test, falseLabelNumber]];
    }
    else if (falseLabelNumber == 0) {
        [self emit:[NSString stringWithFormat:@"if %@ goto L%lu", test, trueLabelNumber]];
    }
#endif
}

-(NSString *)description {
    return operator.description;
}

@end
