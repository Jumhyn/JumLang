//
//  Expression.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/3/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Expression.h"
#import "Temporary.h"
#import "Label.h"
#import "ArrayType.h"
#import "PointerType.h"

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
    if ([self.type isEqual:to]) {
        return [self reduce];
    }
    else if ((self.type == TypeToken.intType || self.type == TypeToken.charType) && to == TypeToken.floatType) {
        Temporary *temp = [[Temporary alloc] initWithType:to];
        [self emit:[NSString stringWithFormat:@"%@ = sitofp %@ %@ to %@", temp, self.type, [self reduce], to]];
        return temp;
    }
    else if (self.type == TypeToken.floatType && (self.type == TypeToken.intType || self.type == TypeToken.charType)) {
        Temporary *temp = [[Temporary alloc] initWithType:to];
        [self emit:[NSString stringWithFormat:@"%@ = fptosi %@ %@ to %@", temp, self.type, [self reduce], to]];
        return temp;
    }
    else if (self.type == TypeToken.intType && to == TypeToken.charType) {
        Temporary *temp = [[Temporary alloc] initWithType:to];
        [self emit:[NSString stringWithFormat:@"%@ = trunc %@ %@ to %@", temp, self.type, [self reduce], to]];
        return temp;
    }
    else if (self.type == TypeToken.charType && to == TypeToken.intType) {
        Temporary *temp = [[Temporary alloc] initWithType:to];
        [self emit:[NSString stringWithFormat:@"%@ = zext %@ %@ to %@", temp, self.type, [self reduce], to]];
        return temp;
    }
    else if ([self.type isKindOfClass:[ArrayType class]] && [to isKindOfClass:[PointerType class]]) {
        if (![[(ArrayType *)self.type to] isEqual:[(PointerType *)to to]]) {
            [self error:@"array type must be of the same type as pointer for conversion"];
        }
        Temporary *temp = [[Temporary alloc] initWithType:to];
        [self emit:[NSString stringWithFormat:@"%@ = getelementptr %@ %@, i32 0, i32 0", temp, self.type, self]];
        return temp;
    }
    else {
        [self error:[NSString stringWithFormat:@"type error when trying to convert %@ to %@", self.type, to]];
        return nil;
    }
}

-(void)jumpingForTrueLabel:(Label *)trueLabel falseLabel:(Label *)falseLabel {
    [self emitJumpsForTest:[self description] trueLabel:trueLabel falseLabel:falseLabel];
}

-(void)emitJumpsForTest:(NSString *)test trueLabel:(Label *)trueLabel falseLabel:(Label *)falseLabel {
#if LLVM == 0
    if (trueLabel && falseLabel) {
        [self emit:[NSString stringWithFormat:@"if %@ goto L%lu", test, trueLabel.number]];
        [self emit:[NSString stringWithFormat:@"goto L%lu", falseLabel.number]];
    }
    else if (!trueLabel) {
        [self emit:[NSString stringWithFormat:@"iffalse %@ goto L%lu", test, falseLabel.number]];
    }
    else if (!falseLabel) {
        [self emit:[NSString stringWithFormat:@"if %@ goto L%lu", test, trueLabel.number]];
    }
#elif LLVM == 1
    if (trueLabel && falseLabel) {
        [self emit:[NSString stringWithFormat:@"br i1 %@, label %%L%lu, label %%L%lu", test, trueLabel.number, falseLabel.number]];
        trueLabel.referenced = YES;
    }
    else if (!trueLabel) {
        [self emit:[NSString stringWithFormat:@"iffalse %@ goto L%lu", test, falseLabel.number]];
        falseLabel.referenced = YES;
    }
    else if (!falseLabel) {
        [self emit:[NSString stringWithFormat:@"if %@ goto L%lu", test, trueLabel.number]];
        trueLabel.referenced = YES;
    }
#endif
}

-(NSString *)description {
    return operator.description;
}

@end
