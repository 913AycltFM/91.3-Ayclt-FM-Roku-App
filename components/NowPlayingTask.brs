sub init()
    m.top.functionName = "fetchNowPlaying"
end sub

sub fetchNowPlaying()
    request = CreateObject("roUrlTransfer")
    request.SetUrl("https://radio.913aycltfm.com/api/nowplaying/91.3_ayclt_fm")
    request.SetRequest("GET")
    request.AddHeader("Accept", "application/json")
    request.SetTimeout(10000)

    response = request.GetToString()
    if response <> invalid
        m.top.result = response
    else
        m.top.result = ""
    end if
end sub
