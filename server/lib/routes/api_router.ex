defmodule Routes.ApiRouter do
  use Routes.Base

  @database [%{"id" => 1, "title" => "Hello"}, %{"id" => 2, "title" => "world!"}]

  get "/" do
    send(conn, 200, @database)
  end

  post "/" do
    send(conn, :ok, %{"id" => 3, "title" => "just been added"})
  end

  put "/:id" do
    send(conn, :ok, %{"id" => id, "title" => "Just been updated"})
  end

  delete "/:id" do
    send(conn, :ok, %{"id" => id, "title" => "Just been deleted"})
  end

  get "/load/:name_proto" do
    System.cmd("protoc", ["-I","priv/protos", "--elixir_out=plugins=grpc:./priv/lib/","priv/protos/#{name_proto}.proto"])
    {_,content} = File.read("./priv/lib/#{name_proto}.pb.ex")
    Code.compiler_options(ignore_module_conflict: true)
    {_result, _binding} = Code.eval_string(content, file: __ENV__.file, line: __ENV__.line)
    {_,dynamic} = File.read("./priv/dynamic/#{name_proto}.ex")
    {result, _binding} = Code.eval_string(dynamic, [conn: conn, name_proto: name_proto,content: content], file: __ENV__.file, line: __ENV__.line)

    send(conn, 200, result)

  end

end
