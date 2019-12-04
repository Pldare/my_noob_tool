
if ARGV[0].to_s != ""
	smd_file_name=ARGV[0].to_s
	smd=File.readlines(smd_file_name)
	smd_split_key_max=ARGV[1].to_i
	raise "key max == 0" if smd_split_key_max == 0
	version_info=smd[0]
	st_wz=1
	nodes_info=[]
	loop do
		nodes_info[nodes_info.size]=smd[st_wz]
		print smd[st_wz]
		st_wz+=1
		if smd[st_wz] == "end\n"
			nodes_info[nodes_info.size]="end\n"
			break
		end
	end
	puts smd.size,st_wz
	all_size=smd.size
	bone_count=st_wz-3
	key_size=bone_count+1
	key_count=(all_size-st_wz-2)/key_size
	puts key_count
	#skeleton
	key_start=st_wz+2
	key_offset_table=[]
	loop do
		if smd[key_start] == "end\n"
			break
		end
		time_info=smd[key_start]
		key_offset_table[key_offset_table.size]=key_start
		key_start+=1
		#print time_info
		#puts key_start
		loop do
			if /time/ =~ smd[key_start]
				#key_start-=1
				break
			end
			if smd[key_start] == "end\n"
				break
			end
			key_start+=1
		end
	end
	max_key_va=smd[key_offset_table[key_offset_table.size-1]].chomp("\n").split(" ")[1].to_i
	split_count=max_key_va/smd_split_key_max
	split_size=[]
	for p in 0...split_count
		split_size[p]=smd_split_key_max
	end
	if max_key_va%smd_split_key_max != 0
		split_size[split_size.size]=max_key_va-(split_count*smd_split_key_max)+1
		split_count+=1
	end
	off_wz=0
	print split_size
	for i in 0...split_count
		if /_/ =~ smd_file_name
			new_smd_file=File.open("#{smd_file_name.split("_")[0]}_#{i}.motion.smd","wb")
		else
			new_smd_file=File.open("#{i}.motion.smd","wb")
		end
		#skeleton
		new_smd_file.print("version 1\n")
		for a in 0...nodes_info.size
			new_smd_file.print(nodes_info[a])
		end
		new_smd_file.print("skeleton\n")
		key_frame=smd[key_offset_table[off_wz]].chomp("\n").split(" ")[1].to_i
		for a in 0...split_size[i]#key count
			#key name
			#new_smd_file.print(smd[key_offset_table[off_wz]])
			new_smd_file.print("time #{a}\n")
			#key data
			ls_wz=key_offset_table[off_wz]+1
			for b in 0...key_size
				new_smd_file.print(smd[ls_wz])
				ls_wz+=1
			end
			off_wz+=1
		end
		new_smd_file.print("end\n")
	end
end