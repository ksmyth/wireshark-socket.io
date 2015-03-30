

tcp_stream = Field.new("tcp.stream")
websocket_payload = Field.new("websocket.payload.text")

socketio_proto = Proto("socketio", "Socket.IO Postdissector")
type_F = ProtoField.string("SocketIO.type", "Message type")
msgno_F = ProtoField.string("SocketIO.msgno", "Message number")
request_frame_F = ProtoField.new("In reply to", "SocketIO.requestframe", ftypes.FRAMENUM)
reply_duration_F = ProtoField.double("SocketIO.reply_duration", "Reply duration")
payload_F = ProtoField.string("SocketIO.payload", "Payload")
reply_payload_F = ProtoField.string("SocketIO.replay_payload", "Original request payload")
socketio_proto.fields = {type_F, msgno_F, request_frame_F, reply_duration_F, payload_F, reply_payload_F}

local message_types = { [string.byte("2")] = "send", [string.byte("3")] = "reply"}
local streams

function socketio_proto.init()
  streams = {}
end

-- create a function to "postdissect" each frame
function socketio_proto.dissector(buffer, pinfo, tree)
    -- obtain the current values the protocol fields
    local websocket_payload = websocket_payload()
    if websocket_payload and websocket_payload.value:byte() == string.byte("1") then
      -- connection inited
    end
    if websocket_payload and websocket_payload.value:byte() == string.byte("4") then
      local messages = streams[tcp_stream().value]
      if not messages then
        messages = {}
        streams[tcp_stream().value] = messages
      end

      local subtree = tree:add(socketio_proto, "Socket.IO message")
      local type_ = "";
      -- 4: proto message
      --  2: send
      --  3: reply
      local message_type = message_types[websocket_payload.value:byte(2)]
      local i,j = websocket_payload.value:sub(3):find("%d*")
      local msgno = tonumber(websocket_payload.value:sub(i+2, j+2))
      local extra_info = nil
      if message_type == "send" then
        messages[msgno] = { msgno = tostring(msgno), rel_ts = pinfo.rel_ts, frameno = tonumber(pinfo.number), websocket_payload = websocket_payload.value:sub(1, 100) }
      else
        -- TODO if messages[msgno] == nil (i.e. original packet is not in our capture)
        message_type = message_type .. " to " .. tostring(messages[msgno].msgno)
        extra_info = function()
          subtree:add(request_frame_F, messages[msgno].frameno)
          subtree:add(reply_duration_F, pinfo.rel_ts - messages[msgno].rel_ts)
          subtree:add(reply_payload_F, messages[msgno].websocket_payload)
        end
      end
      subtree:add(type_F, message_type)
      subtree:add(msgno_F, tostring(msgno))
      subtree:add(payload_F, websocket_payload.value:sub(1, 100))
      if extra_info ~= nil then
        extra_info()
      end
    end
end

register_postdissector(socketio_proto)
