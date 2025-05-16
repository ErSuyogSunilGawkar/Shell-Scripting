# Shell-Scripting
Shell Scripting
AWK Command

		   Fields
		F1		F2
Row 1	word1	word2

Row 2	word3	word4


++Terms used in AWK:-

NR - No of record/row (if scanning first row then NR will be 1 and so on..)
NF - No of fields
$0 - Print everything
$1,$2 - Everything in the field. 

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++Space Delimited++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	Data:- space_del_data.txt
	id firstname lastname email email2 profession
    100 Allis Zaslow Allis.Zaslow@yopmail.com Allis.Zaslow@gmail.com doctor
    101 Gisela Lorenz Gisela.Lorenz@yopmail.com Gisela.Lorenz@gmail.com firefighter
    102 Bill O'Neill Bill.O'Neill@yopmail.com Bill.O'Neill@gmail.com doctor
    103 Teddie Liebermann Teddie.Liebermann@yopmail.com Teddie.Liebermann@gmail.com firefighter
    104 Vita Ade Vita.Ade@yopmail.com Vita.Ade@gmail.com police officer


1) Print only a specific column 

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
	
	
2) Print last coloumn

	awk '{print $NF}' space_del_data
	
	profession
	doctor
	firefighter
	doctor
	firefighter
	officer
	
	
3) Search a word

	awk '/Allis/{print $0}' space_del_data
	
	100 Allis Zaslow Allis.Zaslow@yopmail.com Allis.Zaslow@gmail.com doctor


4) Print only a given line number

	awk 'NR==4{print $0}' space_del_data
	102 Bill O'Neill Bill.O'Neill@yopmail.com Bill.O'Neill@gmail.com doctor

	--> To print range of lines.
	awk 'NR==4,NR==6{print $0}' space_del_data
	
	102 Bill O'Neill Bill.O'Neill@yopmail.com Bill.O'Neill@gmail.com doctor
	103 Teddie Liebermann Teddie.Liebermann@yopmail.com Teddie.Liebermann@gmail.com firefighter
	104 Vita Ade Vita.Ade@yopmail.com Vita.Ade@gmail.com police officer


5) Print row or line number at start of each line. 

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
	
6) Print blank line

	awk 'NF==0 {print NR}' space_del_data
	
	[6                                                             ]
	
7) Ignore case while searching name

	awk 'BEGIN{IGNORECASE=1} /BILL/ {print $0}' space_del_data
	
	102 Bill O'Neill Bill.O'Neill@yopmail.com Bill.O'Neill@gmail.com doctor


8) Find and print any single character having in it

	Finding 's'
	
	awk '$2 ~ /s/ {print $0}' space_del_data.txt
	
	id firstname lastname email email2 profession
	100 Allis Zaslow Allis.Zaslow@yopmail.com Allis.Zaslow@gmail.com doctor
	101 Gisela Lorenz Gisela.Lorenz@yopmail.com Gisela.Lorenz@gmail.com firefighter
	110 Hannis Abernon Hannis.Abernon@yopmail.com Hannis.Abernon@gmail.com doctor
	112 Susette Judye Susette.Judye@yopmail.com Susette.Judye@gmail.com police officer
	
	

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++Comma Delimited++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
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




1) Print only a specific column 

    awk -F, '{print $2}' comma_del.csv
	
	firstname
	Livvyy
	Betta
	Clementine
	Wilma
	Magdalena


2) Print data of guys having salary greater than 20000

	awk -F, '$5>20000 {print $0}' comma_del.csv
	
	id,firstname,lastname,email,salary,profession
	101,Lynde,Horan,Lynde.Horan@yopmail.com,29601,doctor
	102,Kathy,Gombach,Kathy.Gombach@yopmail.com,42936,police officer
	103,Alleen,O'Carroll,Alleen.O'Carroll@yopmail.com,57352,doctor
	105,Dagmar,Hylan,Dagmar.Hylan@yopmail.com,52623,developer
	106,Roxane,Serilda,Roxane.Serilda@yopmail.com,27332,doctor
	107,Kelly,Carmena,Kelly.Carmena@yopmail.com,44550,developer
	109,Corene,Capello,Corene.Capello@yopmail.com,37961,worker
