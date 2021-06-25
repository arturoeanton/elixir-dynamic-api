
{:ok, channel} = GRPC.Stub.connect("localhost:50051")
request = Helloworld.HelloRequest.new(name: conn.params["name"])
{:ok, reply} = channel |> Helloworld.Greeter.Stub.say_hello(request)
%{"message" => reply.message}
