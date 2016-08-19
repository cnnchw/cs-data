import re

matches_file = open("hltv_new.csv","r")
match_handles = open("handles_file.csv","r")
matches = matches_file.readlines()
handles = match_handles.readlines()
match_handles.close()
matches_file.close()


handle_dict = {}

for line in handles:
	line = re.sub("\n","",line)
	items = line.split(",")
	handle_dict[items[0]] = items[1:]

jdm_dict = {}
tarik_dict = {}

for match in matches[1:]:
	match = re.sub("\n","",match)
	items = match.split(",")
	total_rounds = int(items[5]) + int(items[6])
	this_match_handles = handle_dict[items[0]]
	clg_list = []
	for i in range(len(this_match_handles)):
		if "CLG" in this_match_handles[i]:
			clg_list.append(this_match_handles[i-1])
	print(items[0])
	jdm_spot = clg_list.index("jdm64")
	tarik_spot = clg_list.index("tarik")
	j_list = []
	t_list = []
	j_list.append(jdm_spot+1)
	j_list.append(total_rounds)
	t_list.append(tarik_spot+1)
	t_list.append(total_rounds)
	if "CLG" in items[2]: #TEAM A, 789,101112,131415,161718,192021
		if jdm_spot == 0:
			j_list.append(float(items[7]))
			j_list.append(float(items[8]))
			j_list.append(float(items[9]))
		elif jdm_spot == 1:
			j_list.append(float(items[10]))
			j_list.append(float(items[11]))
			j_list.append(float(items[12]))
		elif jdm_spot == 2:
			j_list.append(float(items[13]))
			j_list.append(float(items[14]))
			j_list.append(float(items[15]))
		elif jdm_spot == 3:
			j_list.append(float(items[16]))
			j_list.append(float(items[17]))
			j_list.append(float(items[18]))
		elif jdm_spot == 4:
			j_list.append(float(items[19]))
			j_list.append(float(items[20]))
			j_list.append(float(items[21]))
		

		if tarik_spot == 0:	 	
			t_list.append(float(items[7]))
			t_list.append(float(items[8]))
			t_list.append(float(items[9]))
		elif tarik_spot == 1:
			t_list.append(float(items[10]))
			t_list.append(float(items[11]))
			t_list.append(float(items[12]))
		elif tarik_spot == 2:
			t_list.append(float(items[13]))
			t_list.append(float(items[14]))
			t_list.append(float(items[15]))
		elif tarik_spot == 3:
			t_list.append(float(items[16]))
			t_list.append(float(items[17]))
			t_list.append(float(items[18]))
		elif tarik_spot == 4:
			t_list.append(float(items[19]))
			t_list.append(float(items[20]))
			t_list.append(float(items[21]))

	if "CLG" in items[3]: # TEAM B 222324,252627,282930,313233,343536
		if jdm_spot == 0:
			j_list.append(float(items[22]))
			j_list.append(float(items[23]))
			j_list.append(float(items[24]))
		elif jdm_spot == 1:
			j_list.append(float(items[25]))
			j_list.append(float(items[26]))
			j_list.append(float(items[27]))
		elif jdm_spot == 2:
			j_list.append(float(items[28]))
			j_list.append(float(items[29]))
			j_list.append(float(items[30]))
		elif jdm_spot == 3:
			j_list.append(float(items[31]))
			j_list.append(float(items[32]))
			j_list.append(float(items[33]))
		elif jdm_spot == 4:
			j_list.append(float(items[34]))
			j_list.append(float(items[35]))
			j_list.append(float(items[36]))
		

		if tarik_spot == 0:	 	
			t_list.append(float(items[22]))
			t_list.append(float(items[23]))
			t_list.append(float(items[24]))
		elif tarik_spot == 1:
			t_list.append(float(items[25]))
			t_list.append(float(items[26]))
			t_list.append(float(items[27]))
		elif tarik_spot == 2:
			t_list.append(float(items[28]))
			t_list.append(float(items[29]))
			t_list.append(float(items[30]))
		elif tarik_spot == 3:
			t_list.append(float(items[31]))
			t_list.append(float(items[32]))
			t_list.append(float(items[33]))
		elif tarik_spot == 4:
			t_list.append(float(items[34]))
			t_list.append(float(items[35]))
			t_list.append(float(items[36]))

	jdm_dict[items[0]] = j_list
	tarik_dict[items[0]] = t_list

j_file = open("jdm_matches.csv","w")
t_file = open("tarik_matches.csv","w")

for k in jdm_dict:
	j_file.write(k + ",")
	for i in jdm_dict[k]:
		j_file.write(str(i) + ",")
	j_file.write("\n")
j_file.close()

for k in tarik_dict:
	t_file.write(k + ",")
	for i in tarik_dict[k]:
		t_file.write(str(i) + ",")
	t_file.write("\n")
t_file.close()