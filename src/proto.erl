-module(proto).

-export([decode/1, encode/1]).

%% @doc 将二进制消息解码成protobuf定义的消息结构
%% <<主协议号:6, 副协议号:10, 协议消息字节长度:16, 本协议内容或者包含下一条协议>>
%% @end
decode(<<Cmd:6, CCmd:10, Len:16, Bin/binary>>) ->
    BitSize = Len * 8,
    <<Bin0:BitSize, Bin1/binary>> = Bin,
    Msg = proto_parse:decode_msg(Cmd, CCmd, Bin0),
    {Cmd, CCmd, Msg, Bin1}.

%% @doc 将消息结构编码
encode(Msg) when is_tuple(Msg) andalso tuple_size(Msg) > 0 ->
    MsgName = element(1, Msg),
    {Cmd, CCmd, Bin0} = proto_parse:encode_msg(MsgName, Msg),
    Len = byte_size(Bin0),
    <<Cmd:6, CCmd:10, Len:16, Bin0/binary>>.
