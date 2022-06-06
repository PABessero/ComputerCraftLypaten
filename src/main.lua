-- BaseControl
-- (c) 2022 PABessero
-- Version 1.0

inductionMatrix = require('mekanism.MekanismInductionMatrix')
conf = require('config')

conf.ws = http.websocket(conf.websocketServer)


local mainScreen = peripheral.wrap(conf.mainMonitor.id)
conf.mainMonitor.width, conf.mainMonitor.height = mainScreen.getSize()

local menuWindow = window.create(mainScreen, 1, 1, conf.mainMonitor.width - conf.menuWindow.width, conf.mainMonitor.height)
menuWindow.clear()
menuWindow.setBackgroundColor(colors.gray)

local mekanismPowerWindow = window.create(mainScreen, conf.menuWindow.width + 2, 1, conf.mainMonitor.width - conf.menuWindow.width, conf.mainMonitor.height)
mekanismPowerWindow.clear()
mekanismPowerWindow.setBackgroundColor(colors.lightGray)

local oldTerm = term.redirect(mainScreen)
    paintutils.drawline(conf.menuWindow.width+1, 1, conf.menuWindow.width+1, conf.mainMonitor.height)
term.redirect(oldTerm)

inductionMatrix.setupAllMatrix()
inductionMatrix.setupAllScreens(mekanismPowerWindow)

while true do
    inductionMatrix.mainLoop()
    wait(0.1)
end
