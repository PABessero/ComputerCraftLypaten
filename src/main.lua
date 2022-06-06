-- BaseControl
-- (c) 2022 PABessero
-- Version 1.0

inductionMatrix = require('mekanism.MekanismInductionMatrix')
conf = require('config')

local ws = http.websocket(conf.websocketServer)

inductionMatrix.getAllMatrix()

ws.send(conf.inductionMatrix)
ws.close()
