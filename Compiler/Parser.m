//
//  Parser.m
//  Compiler
//
//  Created by Freddy Kellison-Linn on 5/1/14.
//  Copyright (c) 2014 Jumhyn. All rights reserved.
//

#define match(x) [self match:x]
#define move() [self match:TOK_ANY]

#import "Parser.h"
#import "NumToken.h"
#import "Expression.h"
#import "IfStatement.h"
#import "WhileStatement.h"
#import "DoStatement.h"
#import "Sequence.h"
#import "Environment.h"
#import "Token.h"
#import "FloatToken.h"
#import "TokenStream.h"
#import "Statement.h"
#import "Identifier.h"
#import "AssignStatement.h"
#import "Unary.h"
#import "Not.h"
#import "Constant.h"
#import "Arithmetic.h"
#import "Relation.h"
#import "And.h"
#import "Or.h"
#import "Function.h"
#import "Prototype.h"
#import "CallExpression.h"
#import "ReturnStatement.h"
#import "FunctionIdentifier.h"
#import "ExpressionStatement.h"
#import "ArrayType.h"
#import "PointerType.h"
#import "Access.h"
#import "SetElementStatement.h"

@implementation Parser

@synthesize lookahead;
@synthesize stream;
@synthesize topEnvironment;
@synthesize currentFunc;
@synthesize usedSpace;

-(void)error:(NSString *)error {
    [NSException raise:@"Syntax Error" format:@"%@ near line %lu", error, lookahead.line];
}

-(id)initWithTokenStream:(TokenStream *)newStream {
    if (self = [super init]) {
        self.stream = newStream;
        self.lookahead = [self.stream nextToken];
        self.usedSpace = 0;
    }
    return self;
}

-(NSArray *)program {
    NSMutableArray *functionArray = [[NSMutableArray alloc] init];
    do {
        if (lookahead.type == '[') {
            [functionArray addObject:[self function]];
        }
        else if (lookahead.type == TOK_TYPE) {
            [self matchGlobalDeclaration];
        }
    } while (lookahead.type == '[' || lookahead.type == TOK_TYPE);
    return functionArray;
}

-(void)matchGlobalDeclaration {
    TypeToken *type = [self type];
    WordToken *idTok = (WordToken *)lookahead;
    Identifier *globalIdentifier = [[Identifier alloc] initWithOperator:idTok type:type offset:0];
    globalIdentifier.global = YES;
    [self match:TOK_ID];
    [self match:'='];
    Constant *constant = [self constant];
    if (!constant) {
        [self error:@"initializer for global variable must be compile time constant"];
    }
    [Environment.globalScope setIdentifier:globalIdentifier forToken:idTok];
    [self match:';'];
    printf("%s\n", [NSString stringWithFormat:@"%@ = global %@ %@", globalIdentifier, type, constant].UTF8String);
}

-(Constant *)constant {
    Constant *expr = nil;
    switch (lookahead.type) {
        case TOK_NUM: {
            NSInteger value = [(NumToken *)lookahead value];
            expr = [[Constant alloc] initWithInteger:[(NumToken *)lookahead value]];
            if (value <= CHAR_MAX && value >= CHAR_MIN) {
                expr.type = TypeToken.charType;
            }
            [self match:TOK_NUM];
            return expr;
        }
        case TOK_FLOAT:
            expr = [[Constant alloc] initWithFloat:[(FloatToken *)lookahead value]];
            [self match:TOK_FLOAT];
            return expr;

        case TOK_TRUE:
            expr = Constant.trueConstant;
            [self match:TOK_TRUE];
            return expr;

        case TOK_FALSE:
            expr = Constant.falseConstant;
            [self match:TOK_FALSE];
        default:
            return expr;

    }
}

-(Function *)function {
    [Environment resetScopeCount];
    Environment *savedEnvironment = topEnvironment;
    topEnvironment = [[Environment alloc] initWithPreviousEnvironment:topEnvironment];
    Prototype *proto = [self prototype];
    currentFunc = proto;
    [Environment.globalScope setPrototype:proto forToken:proto.identifier.operator];
    [self match:'{'];
    Statement *stmt = [self sequence];
    [self match:'}'];
    topEnvironment = savedEnvironment;
    Function *ret = [[Function alloc] initWithSignature:proto body:stmt stackSpace:-usedSpace];
    usedSpace = 0;
    return ret;
}

-(Prototype *)prototype {
    [self match:'['];
    TypeToken *typeTok = [self type];
    BOOL isEntry = NO;
    if (lookahead.type == TOK_ENTRY) {
        isEntry = YES;
        [self match:TOK_ENTRY];
    }
    WordToken *funcIdTok = (WordToken *)lookahead;
    [self match:TOK_ID];
    NSMutableArray *args = [[NSMutableArray alloc] init];
    usedSpace = __WORDSIZE / 8;
    if (lookahead.type == ':') {
        [self match:':'];
        do {
            TypeToken *t = [self type];
            Token *idTok = lookahead;
            [self match:TOK_ID];
            Identifier *identifier = [[Identifier alloc] initWithOperator:idTok type:t offset:usedSpace];
            identifier.isArgument = YES;
            usedSpace += t.width;
            [args addObject:identifier];
            [topEnvironment setIdentifier:identifier forToken:idTok];
            if (lookahead.type == ']') {
                break;
            }
            [self match:','];
        } while (lookahead.type == TOK_TYPE);
    }
    usedSpace = 0;
    [self match:']'];
    FunctionIdentifier *funcIdentifier = [[FunctionIdentifier alloc] initWithOperator:funcIdTok type:typeTok offset:0];
    return [[Prototype alloc] initWithIdentifier:funcIdentifier arguments:[NSArray arrayWithArray:args] isEntry:isEntry];
}

-(Statement *)block {
    [self match:'{'];
    Environment *savedEnvironment = topEnvironment;
    topEnvironment = [[Environment alloc] initWithPreviousEnvironment:topEnvironment];
    Statement *stmt = [self sequence];
    [self match:'}'];
    topEnvironment = savedEnvironment;
    return stmt;
}

-(void)declarations {
    while (lookahead.type == TOK_TYPE) {
        TypeToken *t = [self type];
        Token *idTok = lookahead;
        [self match:TOK_ID];
        [self match:';'];
        usedSpace -= t.width;
        Identifier *identifier = [[Identifier alloc] initWithOperator:idTok type:t offset:usedSpace];
        [topEnvironment setIdentifier:identifier forToken:idTok];
    }
}

-(TypeToken *)type {
    TypeToken *typeTok = (TypeToken *)lookahead;
    [self match:TOK_TYPE];
    return typeTok;
}

-(Statement *)sequence { //sequence -> statement sequence
    if (lookahead.type == '}') { //  | eps
        return nil;
    }
    else {
        return [[Sequence alloc] initWithStatement1:[self statement] statement2:[self sequence]];
    }
}

-(Statement *)statement {
    Expression *expr;
    Statement *stmt, *stmt2;
    switch (lookahead.type) {
        case TOK_IF:
            [self match:TOK_IF];
            expr = [self expression];
            stmt = [self statement];
            stmt2 = nil;
            if (lookahead.type == TOK_ELSE) {
                [self match:TOK_ELSE];
                stmt2 = [self statement];
            }
            return [[IfStatement alloc] initWithExpression:expr statement:stmt elseStatement:stmt2];

        case TOK_WHILE:
            [self match:TOK_WHILE];
            expr = [self expression];
            return [[WhileStatement alloc] initWithExpression:expr statement:[self statement]];

        case TOK_DO:
            [self match:TOK_DO];
            stmt = [self statement];
            [self match:TOK_WHILE];
            expr = [self expression];
            [self match:';'];
            return [[DoStatement alloc]initWithStatement:stmt expression:expr];

        case TOK_RETURN:
            [self match:TOK_RETURN];
            if (currentFunc.identifier.type == TypeToken.voidType) {
                if (lookahead.type != ';') {
                    [self error:@"returning value from function with void return type"];
                }
                [self match:';'];
                return [[ReturnStatement alloc] initWithExpression:[[Expression alloc] initWithOperator:nil type:TypeToken.voidType] function:currentFunc];
            }
            expr = [self or];
            [self match:';'];
            return [[ReturnStatement alloc] initWithExpression:expr function:currentFunc];

        case TOK_TYPE: {
            TypeToken *t = [self type];
            Token *idTok = lookahead;
            [self match:TOK_ID];
            if (lookahead.type == ';') {
                usedSpace -= t.width;
                Identifier *identifier = [[Identifier alloc] initWithOperator:idTok type:t offset:usedSpace];
                identifier.enclosingFuncName = [(WordToken *)currentFunc.identifier.operator lexeme];
                [topEnvironment setIdentifier:identifier forToken:idTok];
                [self match:';'];
                return [self statement];
            }
            else if (lookahead.type == '=') {
                usedSpace -= t.width;
                Identifier *identifier = [[Identifier alloc] initWithOperator:idTok type:t offset:usedSpace];
                identifier.enclosingFuncName = [(WordToken *)currentFunc.identifier.operator lexeme];
                [topEnvironment setIdentifier:identifier forToken:idTok];
                [self match:'='];
                expr = [self or];
                [self match:';'];
                return [[AssignStatement alloc] initWithIdentifier:identifier expression:expr];
            }
            else if (lookahead.type == '[') {
                [self match:'['];
                NSInteger value = [(NumToken *)lookahead value];
                [self match:TOK_NUM];
                if (value < 0) {
                    [self error:@"array index must be positive integer"];
                }
                ArrayType *array = [[ArrayType alloc] initWithType:t elements:(size_t)value];
                usedSpace -= t.width;
                [self match:']'];
                Identifier *identifier = [[Identifier alloc] initWithOperator:idTok type:array offset:usedSpace];
                identifier.enclosingFuncName = [(WordToken *)currentFunc.identifier.operator lexeme];
                if (lookahead.type == '=') {
                    [self match:'='];
                    if (lookahead.type != TOK_STR) {
                        [self error:@"array initializer must be string constant"];
                    }
                    if (array.to != TypeToken.charType) {
                        [self error:@"only char arrays may be initialized with string constants"];
                    }
                    WordToken *strTok = (WordToken *)lookahead;
                    [self match:TOK_STR];
                    if (strTok.lexeme.length != value) {
                        [self error:@"array and string length must agree (including trailing \\0)"];
                    }
                    identifier.global = YES;
                    [Environment.globalScope setIdentifier:identifier forString:strTok];
                }
                [topEnvironment setIdentifier:identifier forToken:idTok];
                [self match:';'];
                return [self statement];
            }
        }

        case '[':
            expr = [self call];
            return [[ExpressionStatement alloc] initWithExpression:expr];

        case '{':
            return [self block];
        default:
            return [self assignment];
            break;
    }
}

-(Statement *)assignment {
    Statement *stmt;
    Token *idTok = lookahead;
    [self match:TOK_ID];
    Identifier *identifier = [topEnvironment identifierForToken:idTok];
    if (lookahead.type == '=') {
        [self match:'='];
        stmt = [[AssignStatement alloc] initWithIdentifier:identifier expression:[self or]];
        [self match:';'];
        return stmt;
    }
    else if (lookahead.type == '[') {
        [self match:'['];
        if (identifier.type.type != TOK_ARRAY) {
            [self error:@"attempt to access index of non-array type"];
        }
        Expression *indexExpr = [self or];
        [self match:']'];
        [self match:'='];
        Expression *expr = [self or];
        [self match:';'];
        Access *element = [[Access alloc] initWithIdentifier:identifier indexExpression:indexExpr type:[(ArrayType *)identifier.type to]];
        return [[SetElementStatement alloc] initWithElement:element expression:expr];
    }
    else {
        [self error:@"expected array access or assignment epression"];
        return nil;
    }
}

-(Expression *)or {
    Expression *LHS = [self and];
    while (lookahead.type == TOK_OR) {
        Token *opTok = lookahead;
        match(TOK_OR);
        LHS = [[Or alloc] initWithOperator:opTok expression1:LHS expression2:[self and]];
    }
    return LHS;
}

-(Expression *)and {
    Expression *LHS = [self equality];
    while (lookahead.type == TOK_AND) {
        Token *opTok = lookahead;
        match(TOK_AND);
        LHS = [[And alloc] initWithOperator:opTok expression1:LHS expression2:[self equality]];
    }
    return LHS;
}

-(Expression *)equality {
    Expression *LHS = [self inequality];
    while (lookahead.type == TOK_EQUAL || lookahead.type == TOK_NEQUAL) {
        Token *opTok = lookahead;
        [self match:TOK_ANY];
        LHS = [[Relation alloc] initWithOperator:opTok expression1:LHS expression2:[self inequality]];
    }
    return LHS;
}

-(Expression *)inequality {
    Expression *LHS = [self addition];
    if (lookahead.type == '<' || lookahead.type == TOK_LEQUAL || lookahead.type == TOK_GEQUAL || lookahead.type == '>') {
        Token *opTok = lookahead;
        [self match:TOK_ANY];
        LHS = [[Relation alloc] initWithOperator:opTok expression1:LHS expression2:[self addition]];
    }
    return LHS;
}

-(Expression *)addition {
    Expression *LHS = [self multiplication];
    while (lookahead.type == '+' || lookahead.type == '-') {
        Token *opTok = lookahead;
        [self match:TOK_ANY];
        LHS = [[Arithmetic alloc] initWithOperator:opTok expression1:LHS expression2:[self multiplication]];
    }
    return LHS;
}

-(Expression *)multiplication {
    Expression *LHS = [self unary];
    while (lookahead.type == '*' || lookahead.type == '/') {
        Token *opTok = lookahead;
        [self match:TOK_ANY];
        LHS = [[Arithmetic alloc] initWithOperator:opTok expression1:LHS expression2:[self unary]];
    }
    return LHS;
}

-(Expression *)unary {
    if (lookahead.type == '-') {
        Token *opTok = lookahead;
        [self match:'-'];
        if (lookahead.type == TOK_NUM) {
            NumToken *tok = [[NumToken alloc] initWithValue:-[(NumToken *)lookahead value]];
            [self match:TOK_NUM];
            return [[Constant alloc] initWithOperator:tok type:TypeToken.intType];
        }
        else if (lookahead.type == TOK_FLOAT) {
            FloatToken *tok = [[FloatToken alloc] initWithValue:-[(FloatToken *)lookahead value]];
            [self match:TOK_FLOAT];
            return [[Constant alloc] initWithOperator:tok type:TypeToken.floatType];
        }
        return [[Unary alloc] initWithOperator:opTok expression:[self unary]];
    }
    else if (lookahead.type == '!') {
        Token *opTok = lookahead;
        [self match:'!'];
        return [[Not alloc] initWithOperator:opTok expression:[self unary]];
    }
    else {
        return [self expression];
    }
}

-(Expression *)expression {
    Expression *expr = nil;
    switch (lookahead.type) {
        case '(':
            [self match:'('];
            expr = [self or];
            [self match:')'];
            return expr;

        case TOK_NUM:
        case TOK_FLOAT:
        case TOK_TRUE:
        case TOK_FALSE:
            return [self constant];

        case '[':
            return [self call];

        case TOK_ID: {
            Identifier *identifier = [topEnvironment identifierForToken:lookahead];
            [self match:TOK_ID];
            if (lookahead.type == '[') {
                [self match:'['];
                if (identifier.type.type != TOK_ARRAY) {
                    [self error:@"attempt to access index of non-array type"];
                }
                Expression *indexExpr = [self or];
                [self match:']'];
                Access *element = [[Access alloc] initWithIdentifier:identifier indexExpression:indexExpr type:[(ArrayType *)identifier.type to]];
                return element;
            }
            return identifier;
        }
        default:
            [self error:@"expected expression"];
            return expr;
            break;
    }
}

-(Expression *)call {
    [self match:'['];
    Token *idTok = lookahead;
    [self match:TOK_ID];
    Identifier *identifier = [topEnvironment identifierForToken:idTok];
    NSMutableArray *args = [[NSMutableArray alloc] init];
    if ([Environment.globalScope prototypeForToken:idTok].arguments.count > 0) {
        [self match:':'];
        while (1) {
            Expression *arg = [self or];
            [args addObject:arg];
            if (lookahead.type == ']') {
                break;
            }
            [self match:','];
        }
    }
    [self match:']'];
    return [[CallExpression alloc] initWithIdentifier:identifier arguments:args];
}

-(void)match:(tokenType)toMatch {
    if (lookahead.type == toMatch || toMatch == TOK_ANY) {
        lookahead = [stream nextToken];
    }
    else {
        [self error:[NSString stringWithFormat:@"expected %@ but found %@", [self stringForType:toMatch], [self stringForType:lookahead.type]]];
    }
}

-(NSString *)stringForType:(tokenType)type {
    if (type < 128) {
        return [NSString stringWithFormat:@"'%c'", (char)type];
    }
    else {
        switch (type) {
            case TOK_LEQUAL:
                return @"'<='";
            case TOK_AND:
                return @"'&&'";
            case TOK_OR:
                return @"'||'";
            case TOK_GEQUAL:
                return @"'>='";
            case TOK_EQUAL:
                return @"'=='";
            case TOK_NEQUAL:
                return @"'!='";
            case TOK_IF:
                return @"'if'";
            case TOK_ELSE:
                return @"'else'";
            case TOK_WHILE:
                return @"'while'";
            case TOK_DO:
                return @"'do'";
            case TOK_BREAK:
                return @"'break'";
            case TOK_ENTRY:
                return @"'entry'";

            case TOK_NUM:
                return @"integer constant";
            case TOK_FLOAT:
                return @"float constant";
            case TOK_ID:
                return @"identifier";
            case TOK_TYPE:
                return @"type specifier";

            case TOK_TRUE:
            case TOK_FALSE:
                return @"boolean constant";

            default:
                return @"unrecognized token";
        }
    }
}

@end
