//
//  Not.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/2/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Logical.h"

@interface Not : Logical

-(id)initWithOperator:(Token *)newOperator expression:(Expression *)newExpr;

@end