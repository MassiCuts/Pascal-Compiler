%{

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "lexconstants.h"
#include "parsetree.h"
#include "y.tab.h"

void processLex(int type, char * lexString, bool hasAttribute);
void setLexDebugMode(bool isDebugModeOn);

extern int lineNumber;
extern int lineIndex;
static bool lexDebugMode = false;



%}

comment \(\*(.|\n)*\*\)|\/\/.*
spaces [ \t]+

mulop [*/]|div|mod|and
relop =|\<\>|\<|\<=|\>=|\>

assignop :=

id [a-zA-Z]([a-zA-Z]|[0-9])*
num [0-9]+(E[+-]?[0-9]+)?

%%

"program"			{if(lexDebugMode) printf("[PROGRAM]"); processLex(LL_PROGRAM, yytext, false);return L_PROGRAM;}
"function"			{if(lexDebugMode) printf("[FUNCTION]"); processLex(LL_FUNCTION, yytext, false);return L_FUNCTION;}
"procedure"			{if(lexDebugMode) printf("[PROCEDURE]"); processLex(LL_PROCEDURE, yytext, false);return L_PROCEDURE;}
"if"				{if(lexDebugMode) printf("[IF]"); processLex(LL_IF, yytext, false);return L_IF;}
"then"				{if(lexDebugMode) printf("[THEN]");  processLex(LL_THEN, yytext, false);return L_THEN;}
"else"				{if(lexDebugMode) printf("[ELSE]");  processLex(LL_ELSE, yytext, false);return L_ELSE;}
"while"				{if(lexDebugMode) printf("[WHILE]");  processLex(LL_WHILE, yytext, false);return L_WHILE;}
"for"				{if(lexDebugMode) printf("[FOR]");  processLex(LL_FOR, yytext, false);return L_FOR;}
"to"				{if(lexDebugMode) printf("[TO]");  processLex(LL_TO, yytext, false);return L_TO;}
"do"				{if(lexDebugMode) printf("[DO]");  processLex(LL_DO, yytext, false);return L_DO;}
"begin"				{if(lexDebugMode) printf("[BEGIN]");  processLex(LL_BEGIN, yytext, false);return L_BEGIN;}
"end"				{if(lexDebugMode) printf("[END]");  processLex(LL_END, yytext, false);return L_END;}
"integer"			{if(lexDebugMode) printf("[INTEGER]");  processLex(LL_INTEGER, yytext, false);return L_INTEGER;}
"real"				{if(lexDebugMode) printf("[REAL]");  processLex(LL_REAL, yytext, false);return L_REAL;}
"var"				{if(lexDebugMode) printf("[VAR]");  processLex(LL_VAR, yytext, false);return L_VAR;}
"array"				{if(lexDebugMode) printf("[ARRAY]");  processLex(LL_ARRAY, yytext, false);return L_ARRAY;}
"of"				{if(lexDebugMode) printf("[OF]");  processLex(LL_OF, yytext, false);return L_OF;}
"not"				{if(lexDebugMode) printf("[NOT]");  processLex(LL_NOT, yytext, true);return L_NOT;}
"+"					{if(lexDebugMode) printf("[ADD]");  processLex(LL_ADD, yytext, true);return L_ADD;}
"-"					{if(lexDebugMode) printf("[SUB]");  processLex(LL_SUB, yytext, true);return L_SUB;}
"or"				{if(lexDebugMode) printf("[OR]");  processLex(LL_OR, yytext, true);return L_OR;}
{mulop}				{if(lexDebugMode) printf("[MULOP:%s]",yytext); 	processLex(LL_MULOP, yytext, true);return L_MULOP;}
{relop}				{if(lexDebugMode) printf("[RELOP:%s]",yytext);  	processLex(LL_RELOP, yytext, true);return L_RELOP;}
{assignop}			{if(lexDebugMode) printf("[ASSIGNOP]");  processLex(LL_ASSIGNOP, yytext, false);return L_ASSIGNOP;}
{id}				{if(lexDebugMode) printf("[ID:%s]",yytext);  processLex(LL_ID, yytext, true);return L_ID;}
{num}				{if(lexDebugMode) printf("[NUM:%s]",yytext);  processLex(LL_NUM, yytext, true);return L_NUM;}
"("					{if(lexDebugMode) printf("[LP]");  processLex(LL_LP, yytext, false);return L_LP;}
")"					{if(lexDebugMode) printf("[RP]");  processLex(LL_RP, yytext, false);return L_RP;}
"["					{if(lexDebugMode) printf("[LB]");  processLex(LL_LB, yytext, false);return L_LB;}
"]"					{if(lexDebugMode) printf("[RB]");  processLex(LL_RB, yytext, false);return L_RB;}
".."				{if(lexDebugMode) printf("[DD]");  processLex(LL_DD, yytext, false);return L_DD;}
"."					{if(lexDebugMode) printf("[D]");  processLex(LL_D, yytext, false);return L_D;}
","					{if(lexDebugMode) printf("[COM]");  processLex(LL_COM, yytext, false);return L_COM;}
";"					{if(lexDebugMode) printf("[SC]");  processLex(LL_SC, yytext, false);return L_SC;}
":"					{if(lexDebugMode) printf("[C]");  processLex(LL_C, yytext, false);return L_C;}
{spaces} 			{processLexString(yytext);}
{comment}			{processLexString(yytext);}
\n					{if(lexDebugMode) printf("[EOL]");  processLexString(yytext);}
. 					{lexError(yytext);}

%%



int yyerror(char * msg) {
   fprintf(stderr,"\n[ERROR] PARSER at (%i:%i): %s\n", lineNumber, lineIndex, msg);
   exit(1);
}

int yywrap(void) {
	return 1; 
}


void processLex(int type, char * lexString, bool hasAttribute) {
	TreeValue *  treeValue = parseTreeInitTreeValue(type, hasAttribute? lexString : 0, lineNumber, lineIndex);
	yylval.treeVal = treeValue;
	processLexString(yytext);
}


void setLexDebugMode(bool isDebugModeOn) {
	lexDebugMode = isDebugModeOn;
}