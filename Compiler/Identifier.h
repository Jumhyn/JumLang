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
@property(nonatomic, assign, getter = isAllocated) BOOL allocated;
@property(nonatomic, assign, getter = isArgument) BOOL isArgument;
@property(nonatomic, assign, getter = isGlobal) BOOL global;
@property(nonatomic, assign) NSString *enclosingFuncName;
@property(nonatomic, assign) NSUInteger scopeNumber;

-(id)initWithOperator:(Token *)newOperator type:(TypeToken *)newType offset:(NSInteger)newOffset;

@end
