#!/bin/bash

# Processing lexical and syntactic analyser
lex src/analyzer.l
bison -dy src/parser.y

# Create the 'out' executables directory if not exist
mkdir -p out

# Compile analyzer program
echo "Buiding..."
while sleep 0.1; do printf "..."; done &
gcc lex.yy.c y.tab.c -lfl -o out/test.exec
kill $!
echo -e "\n$(tput setaf 2)Done!$(tput sgr 0)"
