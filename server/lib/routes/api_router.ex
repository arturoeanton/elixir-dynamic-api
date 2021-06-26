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

  post "proto/run" do
    package = conn.params["package"]
    params_list = Enum.map(conn.params["params"], fn(x) -> "#{package}.#{x}" end)
    url_server = conn.params["url_server"]
    service = conn.params["service"]
    method = conn.params["method"]
    params = Enum.join params_list, ","
    reply = conn.params["reply"]
    code = """
      {:ok, channel} = GRPC.Stub.connect("#{url_server}")
      {:ok, reply} = channel |> #{package}.#{service}.Stub.#{method}(#{params})
      %{#{reply}}
    """

    File.write "priv/protos/#{package}.proto", conn.params["proto"]
    # export PATH=$PATH:/home/arturoanton/.mix/escripts
    System.cmd("protoc", ["-I","priv/protos", "--elixir_out=plugins=grpc:./priv/lib/","priv/protos/#{package}.proto"])
    {_,content} = File.read("./priv/lib/#{package}.pb.ex")
    Code.compiler_options(ignore_module_conflict: true)
    {_result, _binding} = Code.eval_string(content, file: __ENV__.file, line: __ENV__.line)
    {result, _binding} = Code.eval_string(code, [conn: conn], file: __ENV__.file, line: __ENV__.line)
    send(conn, 200, result)
  end

end
