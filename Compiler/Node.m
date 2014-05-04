//
//  Node.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/3/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Node.h"

@implementation Node

-(void)error:(NSString *)error {
    NSLog(@"ERROR:%@", error);
    exit(0);
}

@end
