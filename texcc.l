%{
  #include <stdlib.h>
  #include <string.h>
  #include "y.tab.h"
%}

%s texsci

begin     "\\begin{texsci}"
end       "\\end{texsci}"
blankline "\\BlankLine"
id        "[a-zA-Z_][a-zA-Z0-9_]*"
var       "\$[a-zA-Z][a-zA-Z0-9]*"
number    "[0-9]+\$"
leftarr   "\\[a-z]+"
keyword   "\\[A-Z][a-z]*"
comment   "\\tcc{[A-z0-9_]}$"

%%

{begin}             { BEGIN(texsci);   // Start TexSci scanning mode
                      return TEXSCI_BEGIN;
                    }

<texsci>{end}       { BEGIN(INITIAL); // Reset to default scanning mode
                      return TEXSCI_END;
        }
<texsci>{id}        { yylval.name = strdup(yytext);
                      return ID;
                    }
<texsci>{blankline} { return BLANKLINE; }
<texsci>{var}       { yylval.name = strdup(yytext+1);
                      return VAR; }
<texsci>{number}    { return NUMBER; }
<texsci>{leftarr}   { return LEFTARR; }
<texsci>[{}]        { return yytext[0]; }
<texsci>{comment}   { }
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
