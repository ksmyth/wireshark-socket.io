# wireshark-socket.io
Wireshark dissector for Socket.IO traffic

![image](https://cloud.githubusercontent.com/assets/1047813/6901697/a3391036-d6d4-11e4-887a-aa583014debc.png)

## Install:
Append this to `C:\Program Files\Wireshark\init.lua`

    dofile("C:\\Users\\kevin\\Documents\\wireshark-socket.io\\socketio_proto.lua")

Optional: enter `websocket` in the Wirshark filter (and press enter).  
Optional: customize the column display by adding `SocketIO.msgno` and/or `SocketIO.reply_duration.`  
