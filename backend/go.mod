module tempconv-grpc/backend

go 1.24.0

toolchain go1.24.13

require (
	github.com/improbable-eng/grpc-web v0.15.0
	google.golang.org/grpc v1.78.0
	google.golang.org/protobuf v1.36.11
)

require (
	github.com/cenkalti/backoff/v4 v4.1.1 // indirect
	github.com/desertbit/timer v0.0.0-20180107155436-c41aec40b27f // indirect
	github.com/golang/protobuf v1.5.4 // indirect
	github.com/klauspost/compress v1.11.7 // indirect
	github.com/rs/cors v1.7.0 // indirect
	golang.org/x/net v0.47.0 // indirect
	golang.org/x/sys v0.38.0 // indirect
	golang.org/x/text v0.31.0 // indirect
	google.golang.org/genproto v0.0.0-20210126160654-44e461bb6506 // indirect
	nhooyr.io/websocket v1.8.6 // indirect
)

// Fix "ambiguous import" between genproto root module and rpc submodule.
replace google.golang.org/genproto/googleapis/rpc => google.golang.org/genproto v0.0.0-20241202173237-19429a94021a
