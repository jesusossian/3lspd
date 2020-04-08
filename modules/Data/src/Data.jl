module Data

struct InstanceData
	NR::Int #number of retailers
	NT::Int #number of periods
	NI::Int #number of the instance
	NP::Int #number of plants
	NW::Int #number of warehouses
	#NS::Int #number of sucessor

	# For the production plant:
	HCP 	#holding_cost_for_plant
	SCP 	#setup costs for each period
	DP		# demand for each period
	# For each warehouse:
	HCW 	# holding_cost_of_warehouse
	SCW  	# setup costs for each period

	# For each retailer:
	HCR 	# holding_cost_of_retailer
	SCR 	# setup costs for each period
	D  		# demand for each period
	
	# Capacity
	C

	#Set delta
	DeltaR
	DeltaW
end

export InstanceData, readData

function readData(instanceFile)

	println("Running Data.readData with file $(instanceFile)")
	file = open(instanceFile)
	fileText = read(file, String)
	tokens = split(fileText) #tokens will have all the tokens of the input file in a single vector. We will get the input token by token
	
	# read the problem's dimensions NR, NT, NI, NP and NW
	aux = 1
	NR = parse(Int,tokens[aux])
	aux = aux+1
	NT = parse(Int,tokens[aux])
	aux = aux+1
	NI = parse(Int,tokens[aux])
	aux = aux+1
    NP = parse(Int,tokens[aux])
	aux = aux+1
    NW = parse(Int,tokens[aux])

	print("NR = $(NR) NT = $(NT) NI = $(NI) NP = $(NP) NW = $(NW) \n")

	#resize data structures according to NI, NT and NP
	HCP = zeros(Float64,NP)	# holding_cost_of_plant
	SCP = zeros(Int,NP,NT)	# setup costs for each period
	HCW = zeros(Float64,NW)	# holding_cost_of_warehouse
	SCW = zeros(Int,NW,NT)	# setup costs for each period
	HCR = zeros(Float64,NR) # holding_cost_of_retailer
  	SCR = zeros(Int,NR,NT) 	# setup costs for each period
  	D = zeros(Int,NR,NT)  	# retailer demand for each period
  	DP = zeros(Int,NP,NT)  	# plant demand for each period
	C = zeros(Float64, NT)	# capacity for each period

	DeltaR = zeros(Int,NR,10)
	DeltaW = zeros(Int,NR)

	for p in 1:NP
		aux = aux+1
		#plant number in instance ignored
		aux = aux+1
		HCP[p] = parse(Float64,tokens[aux])
		print("$(HCP[p]) \n")

		for q in 1:NT
			aux = aux + 1
			SCP[p,q] = parse(Int,tokens[aux])
			print("$(SCP[p,q]) ")
		end
		print("\n")
	end

	for p in 1:NW
		aux = aux + 1
		#string w? in instance ignored
		aux = aux + 1
		HCW[p] = parse(Float64,tokens[aux])
		print("$(HCW[p]) \n")
		for q in 1:NT
			aux = aux + 1
			SCW[p,q] = parse(Int,tokens[aux])
			print("$(SCW[p,q]) ")
		end
		print("\n")
	end

	for p in 1:NR
		aux = aux + 1
		#string r? in instance ignored
		aux = aux + 1 
		HCR[p] = parse(Float64,tokens[aux])
		print("$(HCR[p]) \n")
		for q in 1:NT
			aux = aux + 1
			SCR[p,q] = parse(Int,tokens[aux])
			print("$(SCR[p,q]) ")
		end
		print("\n")
		for q in 1:NT
			aux = aux + 1
			D[p,q] = parse(Int,tokens[aux])
			print("$(D[p,q]) ")
		end
		print("\n")
	end

	close(file)


	for t in 1:NT
		for r=1:NR
			DP[1,t] += D[r,t]
		end
	end

	aux = 2 #1.75 1.5
	for i in 1:NT
		for t in 1:NT
			C[i] += D[t]
		end
		C[i] = C[i] / NT
		C[i] = aux * C[i] 
	end

	for i in 1:NW
		for j in 1:10
			DeltaR[i,j] = 10*(i-1) + j
			DeltaW[10*(i-1) + j] = i
		end
	end

	print("DeltaR: ")
	for i in 1:NW
		for j in 1:10
			print("$(DeltaR[i,j]) ")
		end
		print("\n")
	end

	print("DeltaW: ")
	for i in 1:NR
		print("$(DeltaW[i]) ")
	end
	print("\n")



#	open("saida.txt","a") do f
#		write(f,"$instanceFile")
#	end

	inst = InstanceData(NR,NT,NI,NP,NW,HCP,SCP,HCW,SCW,HCR,SCR,D,DP,C,DeltaR,DeltaW)
	
	return inst

end

end
