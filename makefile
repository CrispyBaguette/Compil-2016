CC = gcc
LEX = flex
YACC = bison -d
CFLAGS = -O2 -Wall -g
LDFLAGS = -ly -lfl # Linux: -lfl / OSX: -ll
EXEC = texcc
SRC = 
OBJ = $(SRC:.c=.o)

all: $(OBJ) texcc.tab.c lex.yy.c lib.c texsci.c
	$(CC) -o $(EXEC) $^ $(LDFLAGS)

texcc.tab.c: $(EXEC).y
	$(YACC) $(EXEC).y

lex.yy.c: $(EXEC).l
	$(LEX) $(EXEC).l

%.o: %.c %.h
	$(CC) -o $@ -c $< $(CFLAGS)

clean:
	/bin/rm $(EXEC) *.o y.tab.c y.tab.h lex.yy.c
