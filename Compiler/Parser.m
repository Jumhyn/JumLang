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
        [functionArray addObject:[self function]];
    } while (lookahead.type == '[');
    return functionArray;
}

-(Function *)function {
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
    Statement *stmt1, *stmt2;
    switch (lookahead.type) {
        case TOK_IF:
            [self match:TOK_IF];
            expr = [self expression];
            return [[IfStatement alloc] initWithExpression:expr statement:[self statement]];

        case TOK_WHILE:
            [self match:TOK_WHILE];
            expr = [self expression];
            return [[WhileStatement alloc] initWithExpression:expr statement:[self statement]];

        case TOK_DO:
            [self match:TOK_DO];
            stmt1 = [self statement];
            [self match:TOK_WHILE];
            expr = [self expression];
            [self match:';'];
            return [[DoStatement alloc]initWithStatement:stmt1 expression:expr];

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
            usedSpace -= t.width;
            Identifier *identifier = [[Identifier alloc] initWithOperator:idTok type:t offset:usedSpace];
            [topEnvironment setIdentifier:identifier forToken:idTok];
            if (lookahead.type == ';') {
                [self match:';'];
                return [self statement];
            }
            else {
                [self match:'='];
                expr = [self or];
                [self match:';'];
                return [[AssignStatement alloc] initWithIdentifier:identifier expression:expr];
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
    [self match:TOK_ASSIGN];
    stmt = [[AssignStatement alloc] initWithIdentifier:identifier expression:[self or]];
    [self match:';'];
    return stmt;
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
            expr = [[Constant alloc] initWithInteger:[(NumToken *)lookahead value]];
            [self match:TOK_NUM];
            return expr;

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
            return expr;

        case '[':
            return [self call];

        case TOK_ID: {
            Identifier *identifier = [topEnvironment identifierForToken:lookahead];
            [self match:TOK_ID];
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
