defmodule Helloworld.HelloRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          lastname: String.t()
        }

  defstruct [:name, :lastname]

  field :name, 1, type: :string
  field :lastname, 2, type: :string
end

defmodule Helloworld.HelloReply do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          message: String.t(),
          lastname: String.t()
        }

  defstruct [:message, :lastname]

  field :message, 1, type: :string
  field :lastname, 2, type: :string
end

defmodule Helloworld.Greeter.Service do
  @moduledoc false
  use GRPC.Service, name: "helloworld.Greeter"

  rpc :SayHello, Helloworld.HelloRequest, Helloworld.HelloReply
end

defmodule Helloworld.Greeter.Stub do
  @moduledoc false
  use GRPC.Stub, service: Helloworld.Greeter.Service
end
