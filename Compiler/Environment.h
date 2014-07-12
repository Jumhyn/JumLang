//
//  Environment.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/2/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Identifier;
@class Token;
@class Prototype;
@class WordToken;

@interface Environment : NSObject

@property(nonatomic, retain) NSMutableDictionary *symbolTable;
@property(nonatomic, retain) Environment *previousEnvironment;

-(id)initWithPreviousEnvironment:(Environment *)newPreviousEnvironment;

-(Identifier *)identifierForToken:(Token *)token;
-(void)setIdentifier:(Identifier *)identifier forToken:(Token *)token;

-(Prototype *)prototypeForToken:(Token *)token;
-(void)setPrototype:(Prototype *)prototype forToken:(Token *)token;

-(void)setIdentifier:(Identifier*)identifier forString:(WordToken *)string;
-(void)initializeStrings;

+(Environment *)globalScope;

@end
