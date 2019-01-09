#!bin/sh
echo -e "file name : \c"
read name
flex -o lex.yy.c $name.l
gcc -o $name lex.yy.c -lfl
rm -f lex.yy.c
if [ ! -f "$$name" ]; then
echo "start test."
./$name < test_data/01_1.lsp > output1.txt
./$name < test_data/01_2.lsp > output2.txt
./$name < test_data/02_1.lsp > output3.txt
./$name < test_data/02_2.lsp > output4.txt
./$name < test_data/03_1.lsp > output5.txt
./$name < test_data/03_2.lsp > output6.txt
./$name < test_data/04_1.lsp > output7.txt
./$name < test_data/04_2.lsp > output8.txt
./$name < test_data/05_1.lsp > output9.txt
./$name < test_data/05_2.lsp > output10.txt
./$name < test_data/06_1.lsp > output11.txt
./$name < test_data/06_2.lsp > output12.txt
./$name < test_data/07_1.lsp > output13.txt
./$name < test_data/07_2.lsp > output14.txt
./$name < test_data/08_1.lsp > output15.txt
./$name < test_data/08_2.lsp > output16.txt
./$name < test_data/b1_1.lsp > output17.txt
./$name < test_data/b1_2.lsp > output18.txt
./$name < test_data/b2_1.lsp > output19.txt
./$name < test_data/b2_2.lsp > output20.txt
./$name < test_data/b3_1.lsp > output21.txt
./$name < test_data/b3_2.lsp > output22.txt
./$name < test_data/b4_1.lsp > output23.txt
./$name < test_data/b4_2.lsp > output24.txt
cat test_data/01_1.lsp output1.txt test_data/01_2.lsp output2.txt test_data/02_1.lsp output3.txt test_data/02_2.lsp output4.txt test_data/03_1.lsp output5.txt test_data/03_2.lsp output6.txt test_data/04_1.lsp output7.txt test_data/04_2.lsp output8.txt test_data/05_1.lsp output9.txt test_data/05_2.lsp output10.txt test_data/06_1.lsp output11.txt test_data/06_2.lsp output12.txt test_data/07_1.lsp output13.txt test_data/07_2.lsp output14.txt test_data/08_1.lsp output15.txt test_data/08_2.lsp output16.txt test_data/b1_1.lsp output17.txt test_data/b1_2.lsp output18.txt test_data/b2_1.lsp output19.txt test_data/b2_2.lsp output20.txt test_data/b3_1.lsp output21.txt test_data/b3_2.lsp output22.txt  test_data/b4_1.lsp output23.txt test_data/b4_2.lsp output24.txt > output.txt
rm -f output1.txt output2.txt output3.txt output4.txt output5.txt output6.txt output7.txt output8.txt output9.txt output10.txt output11.txt output12.txt output13.txt output14.txt output15.txt output16.txt output17.txt output18.txt output19.txt output20.txt output21.txt output22.txt output23.txt output24.txt
fi

