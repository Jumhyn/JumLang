//
//  Prototype.h
//  Kaleidoscope
//
//  Created by Freddy Kellison-Linn on 6/29/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Identifier;

@interface Prototype : NSObject

@property(nonatomic, retain) Identifier *identifier;
@property(nonatomic, retain) NSArray *arguments;
@property(nonatomic, assign) BOOL isEntry;

-(id)initWithIdentifier:(Identifier *)newIdentifier arguments:(NSArray *)newArguments isEntry:(BOOL)newIsEntry;

@end
