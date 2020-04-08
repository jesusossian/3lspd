module Parameters

struct ParameterData
    instName::String
    solver::String
    maxtime::Int
    tolgap::Float64
    printsol::Int
end

export ParameterData, readInputParameters

function readInputParameters(ARGS)

    println("Running Parameters.readInputParameters")

    ### Set standard values for the parameters ###
    instName="instances/Dataset_3LSPD_N50T15/N50T15/N50T15P1W5DD_DF1.dat"
    solver = "CPLEX"
    maxtime = 180
    tolgap = 0.000001
    printsol = 0

    ### Read the parameters and set correct values whenever provided ###
    for param in 1:length(ARGS)
	if ARGS[param] == "--inst"
            instName = ARGS[param+1]
            param += 1
        elseif ARGS[param] == "--solver"
            solver = ARGS[param+1]
            param += 1
        elseif ARGS[param] == "--maxtime"
            maxtime = parse(Int,ARGS[param+1])
            param += 1
        elseif ARGS[param] == "--tolgap"
            tolgap = parse(Float64,ARGS[param+1])
            param += 1
        elseif ARGS[param] == "--printsol"
            printsol = parse(Int,ARGS[param+1])
            param += 1
        end
    end

    params = ParameterData(instName,solver,maxtime,tolgap,printsol)

    return params

end ### end readInputParameters

end ### end module
