#
MID(text, start_num, num_chars)
=MID(A1,1,FIND(CHAR(1),SUBSTITUTE(A1,"\",CHAR(1),LEN(A1)-LEN(SUBSTITUTE(A1,"\",""))))-1)  # ref. https://stackoverflow.com/questions/37047544/how-to-split-using-the-last-backslash-character-as-delimiter-in-excel-2013