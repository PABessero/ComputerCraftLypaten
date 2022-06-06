-- BaseControl
-- (c) 2022 PABessero
-- Version 1.0

conf = require('config')

local MekanismInductionMatrix = {}

function MekanismInductionMatrix.getEnergy(matrix)
    return matrix.getEnergy()/2.5
end

function MekanismInductionMatrix.getMaxEnergy(matrix)
    return matrix.getMaxEnergy()/2.5
end

function MekanismInductionMatrix.getPercentage(matrix)
    return math.floor(MekanismInductionMatrix.getEnergy(matrix) / MekanismInductionMatrix.getMaxEnergy(matrix) * 100)
end

function MekanismInductionMatrix.getPercentagePrecise(matrix)
    return MekanismInductionMatrix.getEnergy(matrix) / MekanismInductionMatrix.getMaxEnergy(matrix) * 100
end

function MekanismInductionMatrix.getLastInput(matrix)
    return matrix.getLastInput() / 2.5
end

function MekanismInductionMatrix.getLastOutput(matrix)
    return matrix.getLastOutput() / 2.5
end

function MekanismInductionMatrix.sendData(matrix)
    conf.ws.send(matrix)
end

function MekanismInductionMatrix.setupAllMatrix()
    for i, peripheralId in pairs(peripheral.getNames()) do
        print(peripheralId)
        if string.find(peripheralId, 'inductionPort') then
            print('entered')
            local toInsert = true
            for i2, v2 in pairs(conf.inductionMatrix) do
                if string.find(peripheralId, v2.id) then
                    v2.wrapper = peripheral.wrap(peripheralId)
                    toInsert = false
                    print('found')
                    break
                end
                if toInsert then
                    print('not found')
                    table.insert(conf.inductionMatrix, { name = peripheralId, id = peripheralId, wrapper = peripheral.wrap(peripheralId)})
                end
            end
        end
    end
end

function MekanismInductionMatrix.setupAllScreens(parent)
    line = 0

    for i, matrix in pairs(conf.inductionMatrix) do
        --print('Induction Matrix: '..matrix.id)
        --print(matrix.wrapper)


        if matrix.monitor then
            matrix.monitor.wrapper = peripheral.wrap(matrix.monitor.id)
        end

        parentWidth, parentHeight = parent.getSize()


        matrix.nameWindow = window.create(parent, 1, i+line+3, parentWidth, 1)
        matrix.nameWindow.setBackgroundColor(colors.blue)
        matrix.nameWindow.clear()
        matrix.nameWindow.setCursorPos(2 , 1)
        matrix.nameWindow.write(matrix.name)

        matrix.powerStorageWindow = window.create(parent, 1, i+line+4, parentWidth, 1)
        matrix.powerStorageWindow.setBackgroundColor(colors.lightBlue)
        matrix.powerStorageWindow.clear()
        matrix.powerStorageWindow.setCursorPos(2 , 1)
        matrix.powerStorageWindow.write('powerStorageWindow')

        line = line+3
    end
end

function MekanismInductionMatrix.mainLoop()
    for i, v in pairs(conf.inductionMatrix) do
        matrix = v.wrapper
        v.energy = MekanismInductionMatrix.getEnergy(matrix)
        v.maxEnergy = MekanismInductionMatrix.getMaxEnergy(matrix)
        v.percentage = MekanismInductionMatrix.getEnergy(matrix)
        v.percentagePrecise = MekanismInductionMatrix.getPercentagePrecise(matrix)
        v.lastInput = MekanismInductionMatrix.getLastInput(matrix)
        v.lastOutput = MekanismInductionMatrix.getLastOutput(matrix)

        MekanismInductionMatrix.sendData(v)
    end
end

return MekanismInductionMatrix
