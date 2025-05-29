# Shell-Scripting
Shell Scripting
ðŸ“Œ AWK Command

		   Fields
		F1		F2
Row 1	word1	word2

Row 2	word3	word4


++Terms used in AWK:-

NR - No of record/row (if scanning first row then NR will be 1 and so on..)
NF - No of fields
$0 - Print everything
$1,$2 - Everything in the field. 

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ðŸ“Œ Space Delimited++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	Data:- space_del_data.txt
	id firstname lastname email email2 profession
    100 Allis Zaslow Allis.Zaslow@yopmail.com Allis.Zaslow@gmail.com doctor
    101 Gisela Lorenz Gisela.Lorenz@yopmail.com Gisela.Lorenz@gmail.com firefighter
    102 Bill O'Neill Bill.O'Neill@yopmail.com Bill.O'Neill@gmail.com doctor
    103 Teddie Liebermann Teddie.Liebermann@yopmail.com Teddie.Liebermann@gmail.com firefighter
    104 Vita Ade Vita.Ade@yopmail.com Vita.Ade@gmail.com police officer


1) âœ… Print only a specific column 

    awk '{print $2}' space_del_data.txt
	
	firstname
	Allis 
	Gisela 
	Bill 
	Teddie 
	Vita 
	
	--> To print two columns together.
	awk '{print $2, $1}' space_del_data.txt  
	
	firstname id 
	Allis 100
	Gisela 101
	Bill 102
	Teddie 103
	Vita 104
	
	
2) âœ… Print last coloumn

	awk '{print $NF}' space_del_data
	
	profession
	doctor
	firefighter
	doctor
	firefighter
	officer
	
	
3) âœ… Search a word

	awk '/Allis/{print $0}' space_del_data
	
	100 Allis Zaslow Allis.Zaslow@yopmail.com Allis.Zaslow@gmail.com doctor


4) âœ… Print only a given line number

	awk 'NR==4{print $0}' space_del_data
	102 Bill O'Neill Bill.O'Neill@yopmail.com Bill.O'Neill@gmail.com doctor

	--> To print range of lines.
	awk 'NR==4,NR==6{print $0}' space_del_data
	
	102 Bill O'Neill Bill.O'Neill@yopmail.com Bill.O'Neill@gmail.com doctor
	103 Teddie Liebermann Teddie.Liebermann@yopmail.com Teddie.Liebermann@gmail.com firefighter
	104 Vita Ade Vita.Ade@yopmail.com Vita.Ade@gmail.com police officer


5) âœ… Print row or line number at start of each line. 

	awk '{print NR, $0}' space_del_data

	1 id firstname lastname email email2 profession
	2 100 Allis Zaslow Allis.Zaslow@yopmail.com Allis.Zaslow@gmail.com doctor
	3 101 Gisela Lorenz Gisela.Lorenz@yopmail.com Gisela.Lorenz@gmail.com firefighter
	4 102 Bill O'Neill Bill.O'Neill@yopmail.com Bill.O'Neill@gmail.com doctor
	5 103 Teddie Liebermann Teddie.Liebermann@yopmail.com Teddie.Liebermann@gmail.com firefighter
	6 104 Vita Ade Vita.Ade@yopmail.com Vita.Ade@gmail.com police officer

	--> To print Gisela's data and line number
	awk '/Gisela/{print NR, $0}' space_del_data
	
	3 101 Gisela Lorenz Gisela.Lorenz@yopmail.com Gisela.Lorenz@gmail.com firefighter
	
6) âœ… Print blank line

	awk 'NF==0 {print NR}' space_del_data
	
	[6                                                             ]
	
7) âœ… Ignore case while searching name

	awk 'BEGIN{IGNORECASE=1} /BILL/ {print $0}' space_del_data
	
	102 Bill O'Neill Bill.O'Neill@yopmail.com Bill.O'Neill@gmail.com doctor


8) âœ… Find and print any single character having in it

	Finding 's'
	
	awk '$2 ~ /s/ {print $0}' space_del_data.txt
	
	id firstname lastname email email2 profession
	100 Allis Zaslow Allis.Zaslow@yopmail.com Allis.Zaslow@gmail.com doctor
	101 Gisela Lorenz Gisela.Lorenz@yopmail.com Gisela.Lorenz@gmail.com firefighter
	110 Hannis Abernon Hannis.Abernon@yopmail.com Hannis.Abernon@gmail.com doctor
	112 Susette Judye Susette.Judye@yopmail.com Susette.Judye@gmail.com police officer
	
	

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ðŸ“Œ Comma Delimited++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	Data:- comma_del.csv
id,firstname,lastname,email,salary,profession
100,Jany,Ioab,Jany.Ioab@yopmail.com,17957,developer
101,Lynde,Horan,Lynde.Horan@yopmail.com,29601,doctor
102,Kathy,Gombach,Kathy.Gombach@yopmail.com,42936,police officer
103,Alleen,O'Carroll,Alleen.O'Carroll@yopmail.com,57352,doctor
104,Jacenta,Miru,Jacenta.Miru@yopmail.com,11312,doctor
105,Dagmar,Hylan,Dagmar.Hylan@yopmail.com,52623,developer
106,Roxane,Serilda,Roxane.Serilda@yopmail.com,27332,doctor
107,Kelly,Carmena,Kelly.Carmena@yopmail.com,44550,developer
108,Vevay,Winnick,Vevay.Winnick@yopmail.com,15371,worker
109,Corene,Capello,Corene.Capello@yopmail.com,37961,worker




1) âœ…Print only a specific column 

    awk -F, '{print $2}' comma_del.csv
	
	firstname
	Livvyy
	Betta
	Clementine
	Wilma
	Magdalena


2) âœ… Print data of guys having salary greater than 20000

	awk -F, '$5>20000 {print $0}' comma_del.csv
	
	id,firstname,lastname,email,salary,profession
	101,Lynde,Horan,Lynde.Horan@yopmail.com,29601,doctor
	102,Kathy,Gombach,Kathy.Gombach@yopmail.com,42936,police officer
	103,Alleen,O'Carroll,Alleen.O'Carroll@yopmail.com,57352,doctor
	105,Dagmar,Hylan,Dagmar.Hylan@yopmail.com,52623,developer
	106,Roxane,Serilda,Roxane.Serilda@yopmail.com,27332,doctor
	107,Kelly,Carmena,Kelly.Carmena@yopmail.com,44550,developer
	109,Corene,Capello,Corene.Capello@yopmail.com,37961,worker
	
	awk -F, '$5>20000 && $5<=40000 {print $0}' comma_del.csv
	
	101,Lynde,Horan,Lynde.Horan@yopmail.com,29601,doctor
	106,Roxane,Serilda,Roxane.Serilda@yopmail.com,27332,doctor
	109,Corene,Capello,Corene.Capello@yopmail.com,37961,worker

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ðŸ“Œ Print ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
1) âœ… To print a specific word from output

	PORUNAI:cbsprodm:/home/cbsprodm:-)systemctl status httpd
	h: systemctl:  not found.
	ORUNAI:cbsprodm:/home/cbsprodm:-)lsnrctl status
	
	SNRCTL for HPUX: Version 19.0.0.0.0 - Production on 25-MAY-2025 02:24:14
	
	opyright (c) 1991, 2021, Oracle.  All rights reserved.
	
	onnecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
	NS-12541: TNS:no listener
	TNS-12560: TNS:protocol adapter error
	TNS-00511: No listener
	HPUX Error: 239: Connection refused
	
	PORUNAI:cbsprodm:/home/cbsprodm:-)lsnrctl status | awk 'NR==10 {print $5}'
	refused
	PORUNAI:cbsprodm:/home/cbsprodm:-)

	awk -F, '$5>20000 && $5<=40000 {print $0}' comma_del.csv
	
2) âœ… To print specific files containing specific text

	PORUNAI:cbsprodm:/home/cbsprodm/SUYOGG:-)ll
	total 64
	-rw-r--r--   1 cbsprodm   users            0 May 25 03:01 a
	-rw-r--r--   1 cbsprodm   users          627 May 16 20:25 comma_del.csv
	-rwxr-xr-x   1 cbsprodm   users         9806 May 16 16:27 pipe_del_data.txt
	-rwxr-xr-x   1 cbsprodm   users         2822 May 16 18:46 space_del_data.txt
	PORUNAI:cbsprodm:/home/cbsprodm/SUYOGG:-)ll | awk '$7=="16"'
	-rw-r--r--   1 cbsprodm   users          627 May 16 20:25 comma_del.csv
	-rwxr-xr-x   1 cbsprodm   users         9806 May 16 16:27 pipe_del_data.txt
	-rwxr-xr-x   1 cbsprodm   users         2822 May 16 18:46 space_del_data.txt

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ðŸ“Œ Useful Functions ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	
1) âœ… To replace a word temporary using "gsub" command.

	awk '{gsub("Vita","Rita")} space_del_data.txt
	
	PORUNAI:cbsprodm:/home/cbsprodm/SUYOGG:-)cat space_del_data.txt
	id firstname lastname email email2 profession
	100 Allis Zaslow Allis.Zaslow@yopmail.com Allis.Zaslow@gmail.com doctor
	101 Gisela Lorenz Gisela.Lorenz@yopmail.com Gisela.Lorenz@gmail.com firefighter
	102 Bill O'Neill Bill.O'Neill@yopmail.com Bill.O'Neill@gmail.com doctor
	103 Teddie Liebermann Teddie.Liebermann@yopmail.com Teddie.Liebermann@gmail.com firefighter
	
	104 ðŸ”´Vita Ade Vita.Ade@yopmail.com Vita.Ade@gmail.com police officer
	

	PORUNAI:cbsprodm:/home/cbsprodm/SUYOGG:-)awk '{gsub("Vita","Rita"); print $0}' space_del_data.txt
	id firstname lastname email email2 profession
	100 Allis Zaslow Allis.Zaslow@yopmail.com Allis.Zaslow@gmail.com doctor
	101 Gisela Lorenz Gisela.Lorenz@yopmail.com Gisela.Lorenz@gmail.com firefighter
	102 Bill O'Neill Bill.O'Neill@yopmail.com Bill.O'Neill@gmail.com doctor
	103 Teddie Liebermann Teddie.Liebermann@yopmail.com Teddie.Liebermann@gmail.com firefighter
	
	104 ðŸ”´Rita Ade Rita.Ade@yopmail.com Rita.Ade@gmail.com police officer
	

2) âœ… To find length of line/field.

	awk '{length($2)}' space_del_data.txt

	PORUNAI:cbsprodm:/home/cbsprodm/SUYOGG:-)awk '{print length($2)}' space_del_data.txt
	9
	5
	6
	4
	6
	0
	4

3) âœ… To find Index/position of a word in a given line

	PORUNAI:cbsprodm:/home/cbsprodm/SUYOGG:-)awk '/Allis/{print NR, index ($0, "Allis")}' space_del_data.txt
	2 5

4) âœ… Lower & Upper case

	PORUNAI:cbsprodm:/home/cbsprodm/SUYOGG:-)awk '{print tolower($2)}' space_del_data.txt
	firstname
	allis
	gisela
	bill
	teddie
	
	vita
	
	
	PORUNAI:cbsprodm:/home/cbsprodm/SUYOGG:-)awk '{print toupper($2)}' space_del_data.txt
	FIRSTNAME
	ALLIS
	GISELA
	BILL
	TEDDIE
	
	VITA

	
	
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ðŸ“Œ AWK scripting ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
1) âœ… BEGIN, MAIN & END Block in AWK Scripting.
	PORUNAI:cbsprodm:/home/cbsprodm/SUYOGG:-)awk 'BEGIN{print "------Employees Data-----"} {print $0} END{print "-------------"}' space_del_data.txt

------Employees Data-----
id firstname lastname email email2 profession
100 Allis Zaslow Allis.Zaslow@yopmail.com Allis.Zaslow@gmail.com doctor
101 Gisela Lorenz Gisela.Lorenz@yopmail.com Gisela.Lorenz@gmail.com firefighter
102 Bill O'Neill Bill.O'Neill@yopmail.com Bill.O'Neill@gmail.com doctor
103 Teddie Liebermann Teddie.Liebermann@yopmail.com Teddie.Liebermann@gmail.com firefighter

104 Vita Ade Vita.Ade@yopmail.com Vita.Ade@gmail.com police officer
-------------


2) âœ… Sum of all Id's 
PORUNAI:cbsprodm:/home/cbsprodm/SUYOGG:-)cat small_data.txt
id firstname lastname email email2 profession
100 Allis Zaslow Allis.Zaslow@yopmail.com Allis.Zaslow@gmail.com doctor
101 Gisela Lorenz Gisela.Lorenz@yopmail.com Gisela.Lorenz@gmail.com firefighter
102 Bill O'Neill Bill.O'Neill@yopmail.com Bill.O'Neill@gmail.com doctor
103 Teddie Liebermann Teddie.Liebermann@yopmail.com Teddie.Liebermann@gmail.com firefighter

	PORUNAI:cbsprodm:/home/cbsprodm/SUYOGG:-)awk 'BEGIN{sum=0} {sum=sum+$1} END{print "sum of id :" sum}' small_data.txt
	sum of id :406

3) âœ… Ignore column name and blank line/row and count no of row entries.
PORUNAI:cbsprodm:/home/cbsprodm/SUYOGG:-)cat small_data.txt
id firstname lastname email email2 profession
100 Allis Zaslow Allis.Zaslow@yopmail.com Allis.Zaslow@gmail.com doctor
101 Gisela Lorenz Gisela.Lorenz@yopmail.com Gisela.Lorenz@gmail.com firefighter
102 Bill O'Neill Bill.O'Neill@yopmail.com Bill.O'Neill@gmail.com doctor
103 Teddie Liebermann Teddie.Liebermann@yopmail.com Teddie.Liebermann@gmail.com firefighter

	PORUNAI:cbsprodm:/home/cbsprodm/SUYOGG:-)awk 'NR>1{if ($NF>0) count++} END{print "Total employees are:" count}' small_data.txt
	Total employees are:4

4) âœ… To find average Id 
	PORUNAI:cbsprodm:/home/cbsprodm/SUYOGG:-)awk 'NR>1 {if ($NF>0)count++; sum+=$1} END{print "Average Id = " sum/count}' small_data.txt
	Average Id = 101.5

5) âœ… To find no of lines in file 

	PORUNAI:cbsprodm:/home/cbsprodm/SUYOGG:-)awk '{} END{print NR}' small_data.txt
	6



6) âœ… To print length of Longest line

	PORUNAI:cbsprodm:/home/cbsprodm/SUYOGG:-)awk '{if (length($0)>max) max=length($0)} END{print "The longest line length is : " max}' small_data.txt
	The longest line length is : 91


7) âœ… Print high for id greater than 101 else low

	PORUNAI:cbsprodm:/home/cbsprodm/SUYOGG:-)awk '{if ($1>101) $7="HIGH"; else $7="LOW"; print $0}' small_data.txt
	id firstname lastname email email2 profession HIGH
100 Allis Zaslow Allis.Zaslow@yopmail.com Allis.Zaslow@gmail.com doctor LOW
101 Gisela Lorenz Gisela.Lorenz@yopmail.com Gisela.Lorenz@gmail.com firefighter LOW
102 Bill O'Neill Bill.O'Neill@yopmail.com Bill.O'Neill@gmail.com doctor HIGH
103 Teddie Liebermann Teddie.Liebermann@yopmail.com Teddie.Liebermann@gmail.com firefighter HIGH
																							LOW
8) âœ… To print total salary paid in medical department

id firstname lastname email email2 profession department salary
100 Allis Zaslow Allis.Zaslow@yopmail.com Allis.Zaslow@gmail.com doctor medical 40000
101 Gisela Lorenz Gisela.Lorenz@yopmail.com Gisela.Lorenz@gmail.com firefighter government 65000
102 Bill O'Neill Bill.O'Neill@yopmail.com Bill.O'Neill@gmail.com doctor medical 25000
103 Teddie Liebermann Teddie.Liebermann@yopmail.com Teddie.Liebermann@gmail.com firefighter government 50000

104 Gaurav Mishra Gmishra@yahoo.com Mishraji@hotmail.com dentist medical 30000

	PORUNAI:cbsprodm:/home/cbsprodm/SUYOGG:-)awk '{if ($7=="medical")sum+=$NF} END{print "MEDICAL DEPT total salary: " sum}' small_data.txt
	MEDICAL DEPT total salary: 95000

9) âœ… How to add condition pattern in a file

	awk -f file.awk sample.txt
