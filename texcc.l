%{
  #include <stdlib.h>
  #include <string.h>
  #include "texcc.tab.h"
  #include "lib.h"
%}

%s texsci

begin     "\\begin{texsci}"
end       "\\end{texsci}"
blankline "\\BlankLine"
id        [a-zA-Z_][a-zA-Z0-9_]*
number    0|[1-9][0-9]*
leftarr   "\\leftarr"
keyword   \\[A-Z][a-z]*
comment   \\tcc{[A-z0-9_]}$

%%

{begin}             { BEGIN(texsci);   // Start TexSci scanning mode
                      printf("texsci ON\n");
                      return TEXSCI_BEGIN;
                    }
<texsci>{id}        { yylval.strval=strdup(yytext);
                      printf("new id: %s\n", strdup(yytext));
                      return ID;
                    }
<texsci>{number}    { yylval.intval = atoi(yytext);
                      printf("number: %d\n", atoi(yytext));
                      return NUMBER;
                    }
<texsci>{leftarr}   { return LEFTARR; }
<texsci>{end}       { BEGIN(INITIAL); // Reset to default scanning mode
                      printf("texsci OFF\n");
                      return TEXSCI_END;
                    }
<texsci>[{}$+*-/]   { return yytext[0]; }
<texsci>"\\;"       { return SEMICOLON; }
<texsci>"\\print"   { return PRINT; }
[\n]                { }
.                   { }

%%

/**
 * texcc_lexer_free function:
 * this function frees the memory allocated for the lexer. It frees
 * flex's buffer (it supposes there is only one buffer) since flex does
 * never free it itself.
 */
void texcc_lexer_free() {
  yy_delete_buffer(YY_CURRENT_BUFFER);
  free(yy_buffer_stack);
}