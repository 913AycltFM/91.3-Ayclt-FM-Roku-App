sub init()
    m.stations = [
        { name: "91.3 Ayclt FM", shortName: "MAIN", kind: "radio", slug: "91.3_ayclt_fm", stream: "https://radio.913aycltfm.com/listen/91.3_ayclt_fm/roku" },
        { name: "91.3 Ayclt FM HD2", shortName: "HD2", kind: "radio", slug: "91.3_ayclt_fm_hd2", stream: "https://radio.913aycltfm.com/listen/91.3_ayclt_fm_hd2/roku" },
        { name: "91.3 Ayclt FM HD3", shortName: "HD3", kind: "radio", slug: "91.3_ayclt_fm_hd3", stream: "https://radio.913aycltfm.com/listen/91.3_ayclt_fm_hd3/roku" },
        { name: "91.3 Ayclt FM TV", shortName: "TV", kind: "tv", slug: "", stream: "https://tv.913aycltfm.com/memfs/37c1cf56-8954-42d5-b7a4-7c80abb86c48.m3u8" }
    ]
    m.stationIndex = 0

    m.audio = m.top.findNode("audio")
    m.video = m.top.findNode("videoPlayer")
    m.stationName = m.top.findNode("stationName")
    m.tagline = m.top.findNode("tagline")
    m.channelSelector = m.top.findNode("channelSelector")
    m.channelHint = m.top.findNode("channelHint")
    m.statusLabel = m.top.findNode("statusLabel")
    m.nowPlayingLabel = m.top.findNode("nowPlayingLabel")
    m.djLabel = m.top.findNode("djLabel")
    m.nowPlayingTask = m.top.findNode("nowPlayingTask")
    m.refreshTimer = m.top.findNode("refreshTimer")

    m.audio.observeField("state", "onAudioStateChanged")
    m.video.observeField("state", "onVideoStateChanged")
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
        startSelectedStation()
        return true
    else if key = "pause"
        pauseSelectedStation()
        return true
    else if key = "left"
        changeStation(-1)
        return true
    else if key = "right"
        changeStation(1)
        return true
    else if key = "back"
        if m.video.visible and m.video.state <> "stopped"
            m.video.control = "stop"
            m.video.visible = false
            m.statusLabel.text = "TV stopped. Press OK or Play to watch again."
            return true
        end if
        return false
    end if

    return false
end function

sub changeStation(direction as Integer)
    station = m.stations[m.stationIndex]
    if station.kind = "tv"
        wasPlaying = (m.video.state = "playing" or m.video.state = "buffering")
    else
        wasPlaying = (m.audio.state = "playing" or m.audio.state = "buffering")
    end if

    m.audio.control = "stop"
    m.video.control = "stop"
    m.video.visible = false

    m.stationIndex = m.stationIndex + direction
    if m.stationIndex < 0 then m.stationIndex = m.stations.Count() - 1
    if m.stationIndex >= m.stations.Count() then m.stationIndex = 0

    updateStationDisplay()
    refreshNowPlaying()

    if wasPlaying then startSelectedStation()
end sub

sub updateStationDisplay()
    station = m.stations[m.stationIndex]
    m.stationName.text = station.name

    if station.kind = "tv"
        m.tagline.text = "Live video feed"
        m.channelSelector.text = "◀   MAIN   •   HD2   •   HD3   •   [ TV ]   ▶"
        m.channelHint.text = "Press OK or Play to watch the live TV feed"
        m.nowPlayingLabel.text = "91.3 Ayclt FM TV"
        m.djLabel.text = ""
        m.nowPlayingLabel.visible = false
        m.djLabel.visible = false
        m.video.visible = false
    else
        m.tagline.text = "Dickinson's Texas #1 Hit Music Station"
        m.channelHint.text = "Use LEFT / RIGHT to change stations"
        m.nowPlayingLabel.visible = true
        m.djLabel.visible = true
        if m.stationIndex = 0
            m.channelSelector.text = "◀   [ MAIN ]   •   HD2   •   HD3   •   TV   ▶"
        else if m.stationIndex = 1
            m.channelSelector.text = "◀   MAIN   •   [ HD2 ]   •   HD3   •   TV   ▶"
        else
            m.channelSelector.text = "◀   MAIN   •   HD2   •   [ HD3 ]   •   TV   ▶"
        end if
    end if
end sub

sub startSelectedStation()
    station = m.stations[m.stationIndex]
    if station.kind = "tv"
        startTV()
    else
        startRadio()
    end if
end sub

sub startRadio()
    station = m.stations[m.stationIndex]
    m.video.control = "stop"
    m.video.visible = false

    content = CreateObject("roSGNode", "ContentNode")
    content.url = station.stream
    content.streamFormat = "mp3"
    content.title = station.name + " Live"
    m.audio.content = content
    m.audio.control = "play"
    m.statusLabel.text = "Connecting to " + station.name + "..."
end sub

sub startTV()
    station = m.stations[m.stationIndex]
    m.audio.control = "stop"
    m.nowPlayingLabel.visible = false
    m.djLabel.visible = false
    m.video.visible = true

    content = CreateObject("roSGNode", "ContentNode")
    content.url = station.stream
    content.streamFormat = "hls"
    content.title = station.name
    m.video.content = content
    m.video.control = "play"
    m.statusLabel.text = "Connecting to live TV..."
end sub

sub pauseSelectedStation()
    station = m.stations[m.stationIndex]
    if station.kind = "tv"
        m.video.control = "pause"
        m.statusLabel.text = "TV paused. Press OK or Play to resume."
    else
        m.audio.control = "pause"
        m.statusLabel.text = "Radio paused. Press OK or Play to resume."
    end if
end sub

sub onAudioStateChanged()
    station = m.stations[m.stationIndex]
    if station.kind = "tv" then return

    state = m.audio.state
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

sub onVideoStateChanged()
    station = m.stations[m.stationIndex]
    if station.kind <> "tv" then return

    state = m.video.state
    if state = "playing"
        m.statusLabel.text = "LIVE — 91.3 Ayclt FM TV"
    else if state = "buffering"
        m.statusLabel.text = "Buffering live TV..."
    else if state = "paused"
        m.statusLabel.text = "TV paused. Press OK or Play to resume."
    else if state = "error"
        m.statusLabel.text = "Could not play the TV feed. Check the stream URL and format."
    else if state = "finished"
        m.statusLabel.text = "The TV stream stopped. Press OK to reconnect."
    end if
end sub

sub onRefreshTimer()
    refreshNowPlaying()
end sub

sub refreshNowPlaying()
    station = m.stations[m.stationIndex]
    if station.kind = "tv"
        m.nowPlayingLabel.text = "Live video feed"
        m.djLabel.text = ""
        return
    end if

    if m.nowPlayingTask.state <> "RUN"
        m.nowPlayingTask.stationSlug = station.slug
        m.nowPlayingTask.control = "RUN"
    end if
end sub

sub onNowPlayingResult()
    station = m.stations[m.stationIndex]
    if station.kind = "tv" then return

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
