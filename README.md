# elixir-dynamic-api

This is a small dynamic GRPC client. You will be able to send your proto3 and use it by HTTP_POST.

## Example

``` http
POST http://127.0.0.1:8080/api/proto/run HTTP/1.1
Content-Type: application/json

{
    "package": "Helloworld",
    "url_server":"localhost:50051",
    "service": "Greeter",
    "method": "say_hello",
    "params": ["HelloRequest.new(name: 'Elixir!!')"],
    "reply":"'message' => reply.message",
    "proto":"syntax = \"proto3\";\n\noption java_multiple_files = true;\noption java_package = \"io.grpc.examples.helloworld\";\noption java_outer_classname = \"HelloWorldProto\";\noption objc_class_prefix = \"HLW\";\n\npackage helloworld;\n\nservice Greeter {\n  rpc SayHello (HelloRequest) returns (HelloReply) {}\n}\n\nmessage HelloRequest {\n  string name = 1;\n  string lastname = 2;\n\n}\n\nmessage HelloReply {\n  string message = 1;\n  string lastname = 2;\n}"
}

```