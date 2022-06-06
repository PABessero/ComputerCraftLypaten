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
    return math.floor(self:getEnergy(matrix) / self:getMaxEnergy(matrix) * 100)
end

function MekanismInductionMatrix.getPercentagePrecise(matrix)
    return self:getEnergy(matrix) / self:getMaxEnergy(matrix) * 100
end

sendData = function(matrix, websocket)
    websocket.send(matrix)
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

return MekanismInductionMatrix