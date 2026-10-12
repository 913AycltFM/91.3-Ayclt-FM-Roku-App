sub Main()
    screen = CreateObject("roSGScreen")
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)

    screen.CreateScene("RadioScene")
    screen.Show()

    while true
        message = wait(0, port)
        if type(message) = "roSGScreenEvent"
            if message.IsScreenClosed()
                return
            end if
        end if
    end while
end sub
