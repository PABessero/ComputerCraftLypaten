-- BaseControl
-- (c) 2022 PABessero
-- Version 1.0

inductionMatrix = require('mekanism.MekanismInductionMatrix')
conf = require('config')

conf.ws = http.websocket(conf.websocketServer)

inductionMatrix.getAllMatrix()

while true do
    inductionMatrix.mainLoop()
    wait(0.1)
end
