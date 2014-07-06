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

@implementation Parser

@synthesize lookahead;
@synthesize stream;
@synthesize topEnvironment;
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

-(Statement *)program {
    Statement *program = [self block];
    NSUInteger begin = program.newLabel;
    NSUInteger after = program.newLabel;
    [program emitLabel:begin];
    [program generateCodeWithBeforeLabelNumber:begin afterLabelNumber:after];
    [program emitLabel:after];
    return program;
}

-(Statement *)block {
    [self match:TOK_LCURL];
    Environment *savedEnvironment = topEnvironment;
    topEnvironment = [[Environment alloc] initWithPreviousEnvironment:topEnvironment];
    [self declarations];
    Statement *stmt = [self sequence];
    [self match:TOK_RCURL];
    topEnvironment = savedEnvironment;
    return stmt;
}

-(void)declarations {
    while (lookahead.type == TOK_TYPE) {
        TypeToken *t = [self type];
        Token *idTok = lookahead;
        [self match:TOK_ID];
        [self match:';'];
        Identifier *identifier = [[Identifier alloc] initWithOperator:idTok type:t offset:usedSpace];
        [topEnvironment setIdentifier:identifier forToken:idTok];
        usedSpace += t.width;
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
            break;
        case TOK_WHILE:
            [self match:TOK_WHILE];
            expr = [self expression];
            return [[WhileStatement alloc] initWithExpression:expr statement:[self statement]];
            break;
        case TOK_DO:
            [self match:TOK_DO];
            stmt1 = [self statement];
            [self match:TOK_WHILE];
            expr = [self expression];
            [self match:';'];
            return [[DoStatement alloc]initWithStatement:stmt1 expression:expr];
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
        return [NSString stringWithFormat:@"%c", (char)type];
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
