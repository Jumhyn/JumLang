//
//  TypeToken.h
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/3/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#import "WordToken.h"

@interface TypeToken : WordToken {
    size_t width;
}

@property(nonatomic, readonly) BOOL isNumeric;
@property(nonatomic, readonly) size_t width;

+(TypeToken *)charType;
+(TypeToken *)intType;
+(TypeToken *)floatType;
+(TypeToken *)boolType;
+(TypeToken *)functionType;
+(TypeToken *)voidType;

@end

static inline TypeToken* Type_max(TypeToken *type1, TypeToken *type2) {
    if (!(type1 && type2)) {
        return nil;
    }
    else if (type1 == TypeToken.floatType || type2 == TypeToken.floatType) {
        return TypeToken.floatType;
    }
    else if (type1 == TypeToken.intType || type2 == TypeToken.intType) {
        return TypeToken.intType;
    }
    else {
        return TypeToken.charType;
    }
}
