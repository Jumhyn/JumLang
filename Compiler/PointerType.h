//
//  PointerType.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/10/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "TypeToken.h"

@interface PointerType : TypeToken

@property(nonatomic, assign) TypeToken *to;

-(id)initWithReferencedType:(TypeToken *)newType;

@end
