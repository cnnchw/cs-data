import sys
f = ''
if sys.argv[1] == 'hltv':
	f = open("hltv_parser.pl","r")
	flines = f.readlines()
	f.close()
	g = open("hltv_parser.pl","w")
	for line in flines:
		if "my $maxmatch = " in line:
			line = "my $maxmatch = "+sys.argv[2]+";\n"
			g.write(line)
		else:
			g.write(line)
	g.close()	






elif sys.argv[1] == 'esea':
	print "LET'S FUCKIN LOSE IT"
	f = open("esea_parser.pl","r")
	flines = f.readlines()
	f.close()
	g = open("esea_parser.pl","w")
	for line in flines:
		if "my $maxmatch = " in line:
			line = "my $maxmatch = "+sys.argv[2]+";\n"
			g.write(line)
		else:
			g.write(line)
	g.close()	


