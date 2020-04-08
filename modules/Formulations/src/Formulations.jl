module Formulations

using JuMP
#using Gurobi
using CPLEX
using Data
using Parameters

mutable struct stdFormVars
	xp
	xr
	xw
	yp
	yr
	yw
	sp
	sr
	sw
end


export standardFormulation, stdFormVars

function standardFormulation(inst::InstanceData, params::ParameterData)
	println("Running Formulations.standardFormulation")
	
#	if params.solver == "Gurobi"
#		env = Gurobi.Env()
#		model = Model(with_optimizer(Gurobi.Optimizer,TimeLimit=params.maxtime,MIPGap=params.tolgap))
#	else
#	if params.solver == "Cplex"
		#env = Cplex.Env()
		#model = Model(with_optimizer(CPLEX.Optimizer, CPX_PARAM_TILIM=params.maxtime,CPX_PARAM_EPGAP=params.tolgap))
		model = Model(solver = CplexSolver())
#	else
#		println("No solver selected")
#		return 0
#	end

	### Defining variables ###
	@variable(model,0 <= xp[i=1:inst.NP,t=1:inst.NT] <= Inf) #sum(inst.DP[i,t] for t=1:inst.NT))
	@variable(model,0 <= xr[i=1:inst.NR,t=1:inst.NT] <= Inf) #sum(inst.DR[i,t] for t=1:inst.NT))
	@variable(model,0 <= xw[i=1:inst.NW,t=1:inst.NT] <= Inf) #sum(inst.D[i,t] for t=1:inst.NT))
	@variable(model, yp[i=1:inst.NP,t=1:inst.NT], Bin)
	@variable(model, yr[i=1:inst.NR,t=1:inst.NT], Bin)
	@variable(model, yw[i=1:inst.NW,t=1:inst.NT], Bin)
	@variable(model,0 <= sp[i=1:inst.NP,t=1:inst.NT] <= Inf) #sum(inst.DP[i,t] for t=1:inst.NT))
	@variable(model,0 <= sr[i=1:inst.NR,t=1:inst.NT] <= Inf) #sum(inst.DR[i,t] for t=1:inst.NT))
	@variable(model,0 <= sw[i=1:inst.NW,t=1:inst.NT] <= Inf)

	### Objective function ###
	@objective(model, Min,
		sum(inst.SCP[i,t]*yp[i,t] + inst.HCP[i]*sp[i,t] for i=1:inst.NP, t=1:inst.NT)
		+ sum(inst.SCR[i,t]*yr[i,t] + inst.HCR[i]*sr[i,t] for i=1:inst.NR, t=1:inst.NT)
		+ sum(#inst.SCW[i,t]*yw[i,t] 
		+ inst.HCW[i]*sw[i,t] for i=1:inst.NW, t=1:inst.NT) 
	)

	### Setup constraints ###
#	@constraint(model, 
#		setup0[t=1:inst.NT], xp[1,t] <= sum(inst.DP[1,k] for k in t:inst.NT)*yp[1,t] 
#	)
#	@constraint(model, 
#		setup1[i=1:inst.NP, t=1:inst.NT], xr[i,t] <= sum(inst.D[i,k] for k in t:inst.NT)*yr[i,t] 
#)
				
	### Balance constraints ###
#	@constraint(model, balance0[i=1:inst.NP], xp[i,1] == sum(xp[j,1] for j in 1:inst.NW) + sp[i,1])
#	@constraint(model, balance1[i=1:inst.NP, t=1:inst.NT], sp[i,t-1] + xp[i,t] == #sum(xp[j,t] for j in 1:inst.NW) + sp[i,t])

#	@constraint(model, balance2[i=1:inst.NW], xw[i,1] == sum(xw[j,1] for j in 10*(i-1)+1:10*i) + sw[i,1])
#	@constraint(model, balance3[t=1:inst.NT,i=1:inst.NW], sw[i,t-1] + xw[i,t] == sum(xw[j,t] for j in 10*(i-1)+1:10*i) + sw[i,t])

#	@constraint(model, balance4[i=1:inst.NR], xr[i,1] == inst.D[i,1] + sr[i,1])
#	@constraint(model, balance5[t=1:inst.NT,i=1:inst.NR],sr[i,t-1] + xr[i,t] == inst.D[i,t] + sr[i,t])

	### Capacity constraints ###
#	@constraint(model, capacity[i=1:inst.NP, t=1:inst.NT], xp[i,t] <= min(inst.DP[i,t],inst.C[t])*yp[i,t])

	#writeLP(model,"modelo.lp",genericnames=false)

	t1 = time_ns()
	status = solve(model)
	t2 = time_ns()
	elapsedtime = (t2-t1)/1.0e9

	bestsol = getobjectivevalue(model)
	bestbound = getobjbound(model)
	println("bestsol = ", bestsol)
	println("Elapsed = ", elapsedtime)

#	open("saida.txt","a") do f
#		write(f,";$bestsol;$elapsedtime \n")
#	end

#	if params.printsol == 1
#		printStandardFormulationSolution(inst,xp,xr,xw,yp,yr,yw,sp,sr,sw)
#	end

end #function standardFormulation()

end
