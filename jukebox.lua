while true do

    --Initialization--
    
    term.clear()
    term.setCursorPos(1,1)
    local numberOfDrives = 0
    local numberOfSongs = 0
    local songNumber = 0
    local previousSongNumber = 0
    local maxPlayTime = 185
    local listOfPeripherals = peripheral.getNames()
    local listOfDrives = {}
    local listOfSongs = {}
    local currentSong = nil
    local setup = false
    local shufflePlay = true
    local systemStartTime = os.clock()
    local songStartTime = 0
    print("Initializing Jukebox.lua...")
    for i, v in pairs(listOfPeripherals) do
        if (string.match(v, "drive") ~= nil) then
            print("Detected: ", v)
            numberOfDrives = numberOfDrives + 1
            listOfDrives[numberOfDrives] = v
        end
    end
    print(numberOfDrives, " drives detected.")
    os.sleep(1)
    print("Checking songs...")
    for l, k in pairs(listOfDrives) do
        if (peripheral.call(k, "hasAudio") == true) then
            print(k, peripheral.call(k, "getAudioTitle"))
            numberOfSongs = numberOfSongs + 1 
            listOfSongs[numberOfSongs] = peripheral.call(k, "getAudioTitle") 
        else
            print(k, "does not contain a Music Disc.")
        end
    end
    print(numberOfSongs, " songs found .")
    os.sleep(1)
    if (numberOfSongs >= 1) then
        print("Begining... ")
        setup = true
        os.sleep(1) 
    else
        print("No songs detected.")
        os.sleep(10)
    end
    while (setup) do --Drawing the screen, managing songs and buttons.
    
        --Screen Drawing--
        
        term.clear()
        term.setBackgroundColor(colors.cyan )
        term.setCursorPos(1,1)
        print("Date-Time: ", os.date())
        term.setBackgroundColor(colors.green)
        term.setCursorPos(1,2)
        print("Now Playing: ", currentSong)
        print("Seconds Elasped: ", os.clock() - songStartTime, "/", maxPlayTime)
        term.setBackgroundColor(colors.blue)
        term.setCursorPos(1, 6)
        for n, m in pairs(listOfSongs) do
            print(n, m)
        end
        term.setBackgroundColor(colors.black)
        os.sleep(0)
        
        --Audio Management--
        
        if (shufflePlay) then
            if (((os.clock() - songStartTime) >= maxPlayTime) or (currentSong ==  nil)) then
                for g, h in pairs(listOfDrives) do
                   peripheral.call(h, "stopAudio") 
                end
                songNumber = math.random(1, numberOfSongs)
                currentSong = nil
                for b, o in pairs(listOfSongs) do
                    if (tonumber (b) == songNumber) then
                        for y, t in pairs(listOfDrives) do
                            if (peripheral.call(t, "getAudioTitle") == o) then
                                currentSong = peripheral.call(t, "getAudioTitle")
                                print("Playing: ", currentSong, " from ", t)
                                peripheral.call(t, "playAudio")
                                songStartTime = os.clock()
                                os.sleep(0)
                                break
                            end
                        end
                    end                
                end 
            end
        end
        os.sleep(0)
    end
end
