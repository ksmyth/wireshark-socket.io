# wireshark-socket.io
Wireshark dissector for Socket.IO traffic

![image](https://cloud.githubusercontent.com/assets/1047813/6901697/a3391036-d6d4-11e4-887a-aa583014debc.png)

## Install:
Windows: append this to `C:\Program Files\Wireshark\init.lua`

    dofile("C:\\Users\\kevin\\Documents\\wireshark-socket.io\\socketio_proto.lua")

OSX: Put `socketio_proto.lua` in `~/.wireshark/plugins/`

## Use:
Select a Socket.IO packet. Extra information is displayed.  

Optional: enter `websocket` in the Wireshark filter (and press enter).  
Optional: customize the column display by adding `Custom` columns `SocketIO.msgno` and/or `SocketIO.reply_duration`.  
