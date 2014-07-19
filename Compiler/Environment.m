//
//  Environment.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 7/2/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "Environment.h"
#import "Identifier.h"
#import "Prototype.h"
#import "ArrayType.h"
#import "WordToken.h"

static NSMutableDictionary *funcTable = nil;
static NSMutableDictionary *stringTable = nil;
static NSUInteger scopeCount = 0;

@implementation Environment

@synthesize symbolTable;
@synthesize previousEnvironment;

-(void)error:(NSString *)error line:(NSUInteger)line {
    [NSException raise:@"Semantic Error" format:@"%@ near line %lu", error, line];
}

-(id)initWithPreviousEnvironment:(Environment *)newPreviousEnvironment {
    if (self = [super init]) {
        self.symbolTable = [[NSMutableDictionary alloc] init];
        self.previousEnvironment = newPreviousEnvironment;
        scopeCount++;
    }
    return self;
}

-(Identifier *)identifierForToken:(Token *)token {
    Identifier *ret;
    for (Environment *env = self; env != nil; env = env.previousEnvironment) {
        if ((ret = [env.symbolTable objectForKey:token])) {
            return ret;
        }
    }
    if ((ret = [Environment.globalScope.symbolTable objectForKey:token])) {
        return ret;
    }
    Prototype *proto = [self prototypeForToken:token];
    if (proto) {
        return proto.identifier;
    }
    [self error:[NSString stringWithFormat:@"use of undeclared identifier %@", [(WordToken *)token lexeme]] line:token.line];
    return nil;
}

-(void)setIdentifier:(Identifier *)identifier forToken:(Token *)token {
    if ([self.symbolTable objectForKey:token]) {
        [self error:[NSString stringWithFormat:@"redefinition of previously defined identifier %@", [(WordToken *)token lexeme]] line:token.line];
    }
    else {
        identifier.scopeNumber = scopeCount;
        [self.symbolTable setObject:identifier forKey:token];
    }
}

-(Prototype *)prototypeForToken:(Token *)token {
    Prototype *proto = [funcTable objectForKey:token];
    if (!proto) {
        [self error:[NSString stringWithFormat:@"use of undeclared function %@", [(WordToken *)token lexeme]] line:token.line];
    }
    return proto;
}

-(void)setPrototype:(Prototype *)prototype forToken:(Token *)token {
    if ([funcTable objectForKey:token]) {
        [self error:[NSString stringWithFormat:@"redefinition of function %@", prototype.identifier] line:token.line];
    }
    else {
        [funcTable setObject:prototype forKey:token];
    }
}

-(void)setIdentifier:(Identifier*)identifier forString:(WordToken *)string {
    if ([stringTable objectForKey:string]) {
        [self error:@"error defining string literal" line:identifier.lineNumber];
    }
    else {
        [stringTable setObject:identifier forKey:string];
    }
}

-(void)initializeStrings {
    for (WordToken *string in [stringTable allKeys]) {
        Identifier *identifier = [stringTable objectForKey:string];
        printf("%s = private unnamed_addr constant [%lu x i8] c\"%s\\00\"\n", identifier.description.UTF8String, [(ArrayType*)identifier.type elements], string.lexeme.UTF8String);
        identifier.allocated = YES;
    }
}

+(Environment *)globalScope {
    static Environment *globalScope = nil;
    if (globalScope == nil) {
        globalScope = [[Environment alloc] initWithPreviousEnvironment:nil];
        scopeCount--;
        funcTable = [[NSMutableDictionary alloc] init];
        stringTable = [[NSMutableDictionary alloc] init];
    }
    return globalScope;
}

+(void)resetScopeCount {
    scopeCount = 0;
}

@end
