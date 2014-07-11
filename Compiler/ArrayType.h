//
//  ArrayToken.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/10/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "PointerType.h"

@interface ArrayType : PointerType

@property(nonatomic, assign) size_t elements;

-(id)initWithType:(TypeToken *)newType elements:(size_t)newElements;

@end
