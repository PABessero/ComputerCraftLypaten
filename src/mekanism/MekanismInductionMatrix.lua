-- BaseControl
-- (c) 2022 PABessero
-- Version 1.0

conf = require('config')

local MekanismInductionMatrix = {}

function MekanismInductionMatrix.getEnergy(matrix)
    return matrix.peripheral.getEnergy()/2.5
end

function MekanismInductionMatrix.getMaxEnergy(matrix)
    return matrix.peripheral.getMaxEnergy()/2.5
end

function MekanismInductionMatrix.getPercentage(matrix)
    return math.floor(MekanismInductionMatrix.getEnergy(matrix) / MekanismInductionMatrix.getMaxEnergy(matrix) * 100)
end

function MekanismInductionMatrix.getPercentagePrecise(matrix)
    return MekanismInductionMatrix.getEnergy(matrix) / MekanismInductionMatrix.getMaxEnergy(matrix) * 100
end

function MekanismInductionMatrix.sendData(matrix)
    conf.ws.send(matrix)
end

function MekanismInductionMatrix.getAllMatrix()
    for i, v in pairs(peripheral.getNames()) do
        if string.find(v, 'inductionPort') then
            for i2, v2 in pairs(conf.inductionMatrix) do
                if string.find(v, v2.id) then
                    v2.wrapper = peripheral.wrap(v)
                else
                    table.insert(conf.inductionMatrix, {id = v, wrapper = peripheral.wrap(v)})
                end
            end
        end
    end
end

function MekanismInductionMatrix.mainLoop()
    for i, v in pairs(conf.inductionMatrix) do
        v.energy = MekanismInductionMatrix.getEnergy(matrix)
        v.maxEnergy = MekanismInductionMatrix.getMaxEnergy(matrix)
        v.percentage = MekanismInductionMatrix.getEnergy(matrix)
        v.percentagePrecise = MekanismInductionMatrix.getPercentagePrecise(matrix)

        MekanismInductionMatrix.sendData(matrix)
    end
end

return MekanismInductionMatrix
