const STREAM_URL = "https://radio.913aycltfm.com/listen/91.3_ayclt_fm/roku"

sub init()
    m.audio = m.top.findNode("audio")
    m.statusLabel = m.top.findNode("statusLabel")
    m.nowPlayingLabel = m.top.findNode("nowPlayingLabel")
    m.djLabel = m.top.findNode("djLabel")
    m.nowPlayingTask = m.top.findNode("nowPlayingTask")
    m.refreshTimer = m.top.findNode("refreshTimer")

    m.audio.observeField("state", "onAudioStateChanged")
    m.nowPlayingTask.observeField("result", "onNowPlayingResult")
    m.refreshTimer.observeField("fire", "onRefreshTimer")

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
    else if key = "back"
        return false
    end if

    return false
end function

sub startRadio()
    content = CreateObject("roSGNode", "ContentNode")
    content.url = STREAM_URL
    content.streamFormat = "mp3"
    content.title = "91.3 Ayclt FM Live"
    m.audio.content = content
    m.audio.control = "play"
    m.statusLabel.text = "Connecting to 91.3 Ayclt FM..."
end sub

sub pauseRadio()
    m.audio.control = "pause"
    m.statusLabel.text = "Radio paused. Press OK or Play to resume."
end sub

sub onAudioStateChanged()
    state = m.audio.state
    if state = "playing"
        m.statusLabel.text = "LIVE — You are listening to 91.3 Ayclt FM"
    else if state = "buffering"
        m.statusLabel.text = "Buffering live radio..."
    else if state = "paused"
        m.statusLabel.text = "Radio paused. Press OK or Play to resume."
    else if state = "error"
        m.statusLabel.text = "Could not play the stream. Press OK to try again."
    else if state = "finished"
        m.statusLabel.text = "The stream stopped. Press OK to reconnect."
    end if
end sub

sub onRefreshTimer()
    refreshNowPlaying()
end sub

sub refreshNowPlaying()
    if m.nowPlayingTask.state <> "RUN"
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
