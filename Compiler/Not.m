//
//  Not.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/2/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Not.h"

@implementation Not

-(id)initWithOperator:(Token *)newOperator expression:(Expression *)newExpr {
    return self = [super initWithOperator:newOperator expression1:newExpr expression2:newExpr];
}

-(void)jumpingForTrueLabelNumber:(NSUInteger)trueLabelNumber falseLabelNumber:(NSUInteger)falseLabelNumber {
    [self.expr2 jumpingForTrueLabelNumber:falseLabelNumber falseLabelNumber:trueLabelNumber];
}

-(NSString *)description {
    return [NSString stringWithFormat:@"%@ %@", self.operator, self.expr2];
}

@end
