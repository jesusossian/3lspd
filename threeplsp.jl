push!(LOAD_PATH, "modules/")
# push!(DEPOT_PATH, JULIA_DEPOT_PATH)
using Pkg
Pkg.activate(".")
# Pkg.instantiate()
# Pkg.build()

using JuMP
#using Gurobi
using CPLEX

import Data
import Parameters
import Formulations

# Read the parameters from command line
params = Parameters.readInputParameters(ARGS)

# Read instance data
inst = Data.readData(params.instName)

#if params.solver == "Gurobi"
#    model = Model(with_optimizer(Gurobi.Optimizer, TimeLimit=params.maxtime, MIPGap=params.tolgap))
#else
#if params.solver == "Cplex"
#    model = Model(with_optimizer(CPLEX.Optimizer, CPX_PARAM_TILIM=params.maxtime, CPX_PARAM_EPGAP=params.tolgap))
#else
#    println("No solver selected")
#    return 0
#end


#if params.method == "exact"
#    if params.form == "std"
        Formulations.standardFormulation(inst, params)
#    elseif params.form == "fl"
#        Formulations.facilityLocationFormulation(inst, params)
#    end
#elseif (params.method == "rf" || params.method ==  "rffo")
#    paramsrf = Parameters.readInputParametersRF(ARGS)
#    ysol,bestsol = RelaxAndFix.RelaxAndFixStandardFormulation(inst, params, paramsrf)
#   if params.method == "rffo"
#       paramsfo = Parameters.readInputParametersFO(ARGS)
#       FixAndOptimize.FixAndOptimizeStandardFormulation(inst, params, paramsfo, ysol, bestsol)
#   end
#end

