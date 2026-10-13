sub init()
    m.stations = [
        { name: "91.3 Ayclt FM", shortName: "MAIN", kind: "radio", slug: "91.3_ayclt_fm", stream: "https://radio.913aycltfm.com/listen/91.3_ayclt_fm/roku" },
        { name: "91.3 Ayclt FM HD2", shortName: "HD2", kind: "radio", slug: "91.3_ayclt_fm_hd2", stream: "https://radio.913aycltfm.com/listen/91.3_ayclt_fm_hd2/roku" },
        { name: "91.3 Ayclt FM HD3", shortName: "HD3", kind: "radio", slug: "91.3_ayclt_fm_hd3", stream: "https://radio.913aycltfm.com/listen/91.3_ayclt_fm_hd3/roku" },
        { name: "TV Feed 1", shortName: "TV1", kind: "tv", slug: "", stream: "https://tv.913aycltfm.com/memfs/37c1cf56-8954-42d5-b7a4-7c80abb86c48.m3u8" },
        { name: "TV Feed 2", shortName: "TV2", kind: "tv", slug: "", stream: "https://tv.913aycltfm.com/memfs/b502bd6f-86eb-4ca0-91c0-f09fb6a8f76e.m3u8" },
        { name: "TV Feed 3", shortName: "TV3", kind: "tv", slug: "", stream: "https://tv.913aycltfm.com/memfs/c421623b-6171-4fc8-8514-86993233d910.m3u8" },
        { name: "TV Feed 4", shortName: "TV4", kind: "tv", slug: "", stream: "https://tv.913aycltfm.com/memfs/02f36ef2-64c7-446c-a5c8-ca2fca15d02e.m3u8" },
        { name: "TV Feed 5", shortName: "TV5", kind: "tv", slug: "", stream: "https://tv.913aycltfm.com/memfs/034825aa-0374-40a9-8ebb-5cf4d3b05dfe.m3u8" }
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
    m.helpLabel = m.top.findNode("helpLabel")
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
        if m.stations[m.stationIndex].kind = "tv"
            m.video.control = "stop"
            m.video.visible = false
            showAppUI(true)
            m.statusLabel.text = "TV stopped. Use LEFT / RIGHT to select a feed."
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
    showAppUI(true)

    m.stationIndex = m.stationIndex + direction
    if m.stationIndex < 0 then m.stationIndex = m.stations.Count() - 1
    if m.stationIndex >= m.stations.Count() then m.stationIndex = 0

    updateStationDisplay()
    refreshNowPlaying()
    if wasPlaying then startSelectedStation()
end sub

sub showAppUI(show as Boolean)
    m.stationName.visible = show
    m.tagline.visible = show
    m.channelSelector.visible = show
    m.channelHint.visible = show
    m.statusLabel.visible = show
    m.helpLabel.visible = show
end sub

sub updateStationDisplay()
    station = m.stations[m.stationIndex]
    m.stationName.text = station.name

    selectorText = "◀  "
    for i = 0 to m.stations.Count() - 1
        if i > 0 then selectorText = selectorText + " • "
        if i = m.stationIndex
            selectorText = selectorText + "[" + m.stations[i].shortName + "]"
        else
            selectorText = selectorText + m.stations[i].shortName
        end if
    end for
    m.channelSelector.text = selectorText + "  ▶"

    if station.kind = "tv"
        m.tagline.text = "Live video feed"
        m.channelHint.text = "Press OK or Play to watch this TV feed"
        m.nowPlayingLabel.visible = false
        m.djLabel.visible = false
    else
        m.tagline.text = "Dickinson's Texas #1 Hit Music Station"
        m.channelHint.text = "Use LEFT / RIGHT to change station or TV feed"
        m.nowPlayingLabel.visible = true
        m.djLabel.visible = true
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
    showAppUI(true)

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
    showAppUI(false)
    m.video.visible = true

    content = CreateObject("roSGNode", "ContentNode")
    content.url = station.stream
    content.streamFormat = "hls"
    content.title = station.name
    m.video.content = content
    m.video.control = "play"
end sub

sub pauseSelectedStation()
    station = m.stations[m.stationIndex]
    if station.kind = "tv"
        m.video.control = "pause"
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
    if state = "error"
        m.video.visible = false
        showAppUI(true)
        m.statusLabel.text = "Could not play " + station.name + ". Check the URL and Roku compatibility."
    else if state = "finished"
        m.video.visible = false
        showAppUI(true)
        m.statusLabel.text = station.name + " stopped. Press OK to reconnect."
    end if
end sub

sub onRefreshTimer()
    refreshNowPlaying()
end sub

sub refreshNowPlaying()
    station = m.stations[m.stationIndex]
    if station.kind = "tv" then return

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
