//
//  Identifier.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/3/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Expression.h"

@interface Identifier : Expression

@property(nonatomic, assign) NSInteger offset;
@property(nonatomic, assign) BOOL allocated;

-(id)initWithOperator:(Token *)newOperator type:(TypeToken *)newType offset:(NSInteger)newOffset;

@end
