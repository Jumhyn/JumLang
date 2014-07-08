//
//  Label.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/7/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Label : NSObject

@property(nonatomic, assign) NSUInteger number;
@property(nonatomic, assign) BOOL referenced;

-(id)initWithNumber:(NSUInteger)newNumber;

@end
