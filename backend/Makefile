PROTO_DIR=../proto
GEN_DIR=./gen

.PHONY: proto
proto:
	@echo "Generating Go gRPC code..."
	@protoc \
		--proto_path=$(PROTO_DIR) \
		--go_out=$(GEN_DIR) --go_opt=paths=source_relative \
		--go-grpc_out=$(GEN_DIR) --go-grpc_opt=paths=source_relative \
		$(PROTO_DIR)/tempconv/v1/tempconv.proto

.PHONY: test
test:
	go test ./...

.PHONY: run
run:
	go run ./cmd/server

