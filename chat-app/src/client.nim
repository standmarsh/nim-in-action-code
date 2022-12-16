import os, threadpool, asyncdispatch, asyncnet
import protocol

echo("Chat application started")

if paramCount() == 0:
    quit("Please specify the server address, e.g. ./client localhost")

let serverAddr = paramStr(1)
echo("Connecting to ", serverAddr)
var socket = newAsyncSocket()


proc connect(socket: AsyncSocket, serverAddr: string) {.async.} = 
    asyncCheck connect(socket, serverAddr)
    await socket.connect(serverAddr, 8000.Port)
    echo("Connected!")

    var messageFlowVar = spawn stdin.readLine()
    while true:
        if messageFlowVar.isReady():
            let message = createMessage("Anonymous", ^messageFlowVar)
            asyncCheck socket.send(message)
            messageFlowVar = spawn stdin.readLine()

        asyncdispatch.poll()

