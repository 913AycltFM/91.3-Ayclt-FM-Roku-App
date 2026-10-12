sub init()
    m.stations = [
        { name: "91.3 Ayclt FM", shortName: "MAIN", slug: "91.3_ayclt_fm", stream: "https://radio.913aycltfm.com/listen/91.3_ayclt_fm/roku" },
        { name: "91.3 Ayclt FM HD2", shortName: "HD2", slug: "91.3_ayclt_fm_hd2", stream: "https://radio.913aycltfm.com/listen/91.3_ayclt_fm_hd2/roku" },
        { name: "91.3 Ayclt FM HD3", shortName: "HD3", slug: "91.3_ayclt_fm_hd3", stream: "https://radio.913aycltfm.com/listen/91.3_ayclt_fm_hd3/roku" }
    ]
    m.stationIndex = 0

    m.audio = m.top.findNode("audio")
    m.stationName = m.top.findNode("stationName")
    m.channelSelector = m.top.findNode("channelSelector")
    m.statusLabel = m.top.findNode("statusLabel")
    m.nowPlayingLabel = m.top.findNode("nowPlayingLabel")
    m.djLabel = m.top.findNode("djLabel")
    m.nowPlayingTask = m.top.findNode("nowPlayingTask")
    m.refreshTimer = m.top.findNode("refreshTimer")

    m.audio.observeField("state", "onAudioStateChanged")
    m.nowPlayingTask.observeField("result", "onNowPlayingResult")
    m.refreshTimer.observeField("fire", "onRefreshTimer")

    updateStationDisplay()
    m.top.setFocus(true)
    refreshNowPlaying()
    m.refreshTimer.control = "start"
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    if key = "OK" or key = "play"
        startRadio()
        return true
    else if key = "pause"
        pauseRadio()
        return true
    else if key = "left"
        changeStation(-1)
        return true
    else if key = "right"
        changeStation(1)
        return true
    else if key = "back"
        return false
    end if

    return false
end function

sub changeStation(direction as Integer)
    wasPlaying = (m.audio.state = "playing" or m.audio.state = "buffering")
    m.audio.control = "stop"

    m.stationIndex = m.stationIndex + direction
    if m.stationIndex < 0 then m.stationIndex = m.stations.Count() - 1
    if m.stationIndex >= m.stations.Count() then m.stationIndex = 0

    updateStationDisplay()
    m.nowPlayingLabel.text = "Now Playing: Loading station information..."
    m.djLabel.text = ""
    refreshNowPlaying()

    if wasPlaying then startRadio()
end sub

sub updateStationDisplay()
    station = m.stations[m.stationIndex]
    m.stationName.text = station.name
    m.channelSelector.text = "◀   MAIN   •   HD2   •   HD3   ▶"
    if m.stationIndex = 0
        m.channelSelector.text = "◀   [ MAIN ]   •   HD2   •   HD3   ▶"
    else if m.stationIndex = 1
        m.channelSelector.text = "◀   MAIN   •   [ HD2 ]   •   HD3   ▶"
    else
        m.channelSelector.text = "◀   MAIN   •   HD2   •   [ HD3 ]   ▶"
    end if
end sub

sub startRadio()
    station = m.stations[m.stationIndex]
    content = CreateObject("roSGNode", "ContentNode")
    content.url = station.stream
    content.streamFormat = "mp3"
    content.title = station.name + " Live"
    m.audio.content = content
    m.audio.control = "play"
    m.statusLabel.text = "Connecting to " + station.name + "..."
end sub

sub pauseRadio()
    m.audio.control = "pause"
    m.statusLabel.text = "Radio paused. Press OK or Play to resume."
end sub

sub onAudioStateChanged()
    state = m.audio.state
    station = m.stations[m.stationIndex]
    if state = "playing"
        m.statusLabel.text = "LIVE — You are listening to " + station.name
    else if state = "buffering"
        m.statusLabel.text = "Buffering " + station.name + "..."
    else if state = "paused"
        m.statusLabel.text = "Radio paused. Press OK or Play to resume."
    else if state = "error"
        m.statusLabel.text = "Could not play this stream. Try OK or select another station."
    else if state = "finished"
        m.statusLabel.text = "The stream stopped. Press OK to reconnect."
    end if
end sub

sub onRefreshTimer()
    refreshNowPlaying()
end sub

sub refreshNowPlaying()
    if m.nowPlayingTask.state <> "RUN"
        m.nowPlayingTask.stationSlug = m.stations[m.stationIndex].slug
        m.nowPlayingTask.control = "RUN"
    end if
end sub

sub onNowPlayingResult()
    body = m.nowPlayingTask.result
    if body = invalid or body = "" then return

    data = ParseJson(body)
    if data = invalid then return

    now = data.now_playing
    if now <> invalid
        song = now.song
        if song <> invalid
            artist = song.artist
            title = song.title
            if artist = invalid then artist = ""
            if title = invalid or title = "" then title = "Live radio"

            if artist <> ""
                m.nowPlayingLabel.text = "Now Playing: " + title + " — " + artist
            else
                m.nowPlayingLabel.text = "Now Playing: " + title
            end if
        end if

        if now.streamer_name <> invalid and now.streamer_name <> ""
            m.djLabel.text = "On air: " + now.streamer_name
        else
            m.djLabel.text = ""
        end if
    end if
end sub
