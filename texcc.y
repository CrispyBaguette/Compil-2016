%{
  #include <stdio.h>
  #include <stdlib.h>
  #define TEXCC_ERROR_GENERAL 4

  void yyerror(char*);

  // Functions and global variables provided by Lex.
  int yylex();
  void texcc_lexer_free();
  extern FILE* yyin;
%}

%union {
  char* name;
  int value;
}

%token TEXSCI_BEGIN TEXSCI_END BLANKLINE LEFTARR
%token <name> ID
%token <value> NUMBER 

%right LEFTARR
%left '+' '-'
%left '*' '/'

%%

algorithm_list:
    algorithm_list algorithm
  | algorithm
  ;

algorithm:
    TEXSCI_BEGIN '{' ID '}' statement_list TEXSCI_END
    {
      fprintf(stderr, "[texcc] info: algorithm \"%s\" parsed\n", $3);
      free($3);
    }
  ;

statement_list:
    statement_list statement
  | statement
  ;

statement:
    '$' ID LEFTARR exp
  ;

exp : NUMBER '$'
  | '$' ID '$'
  | exp '+' exp
  | exp '-' exp
  | exp '*' exp
  | exp '/' exp
  | '(' exp ')'
  ;

%%

int main(int argc, char* argv[]) {
  if (argc == 2) {
    if ((yyin = fopen(argv[1], "r")) == NULL) {
      fprintf(stderr, "[texcc] error: unable to open file %s\n", argv[1]);
      exit(TEXCC_ERROR_GENERAL);
    }
  } else {
    fprintf(stderr, "[texcc] usage: %s input_file\n", argv[0]);
    exit(TEXCC_ERROR_GENERAL);
  }

  yyparse();
  fclose(yyin);
  texcc_lexer_free();
  return EXIT_SUCCESS;
}
