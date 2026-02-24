package main

import (
	"context"
	"errors"
	"log"
	"net"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/improbable-eng/grpc-web/go/grpcweb"
	tempconvv1 "tempconv-grpc/backend/gen/tempconv/v1"
	"google.golang.org/grpc"
)

type tempConvServer struct {
	tempconvv1.UnimplementedTempConvServiceServer
}

func (s *tempConvServer) CelsiusToFahrenheit(ctx context.Context, req *tempconvv1.TemperatureRequest) (*tempconvv1.TemperatureReply, error) {
	if req == nil {
		return nil, errors.New("request is nil")
	}
	return &tempconvv1.TemperatureReply{Value: cToF(req.Value)}, nil
}

func (s *tempConvServer) FahrenheitToCelsius(ctx context.Context, req *tempconvv1.TemperatureRequest) (*tempconvv1.TemperatureReply, error) {
	if req == nil {
		return nil, errors.New("request is nil")
	}
	return &tempconvv1.TemperatureReply{Value: fToC(req.Value)}, nil
}

func cToF(c float64) float64 { return (c * 9.0 / 5.0) + 32.0 }
func fToC(f float64) float64 { return (f - 32.0) * 5.0 / 9.0 }

func main() {
	grpcPort := envOrDefault("GRPC_PORT", "50051")
	webPort := envOrDefault("WEB_PORT", "8080")

	grpcServer := grpc.NewServer()
	tempconvv1.RegisterTempConvServiceServer(grpcServer, &tempConvServer{})

	lis, err := net.Listen("tcp", ":"+grpcPort)
	if err != nil {
		log.Fatalf("listen gRPC: %v", err)
	}

	// gRPC-Web wrapper served over HTTP (for browsers).
	wrapped := grpcweb.WrapServer(
		grpcServer,
		grpcweb.WithOriginFunc(func(origin string) bool { return true }), // simple demo: allow all
	)
	httpServer := &http.Server{
		Addr:              ":" + webPort,
		ReadHeaderTimeout: 10 * time.Second,
		Handler: http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			// Required for gRPC-Web + CORS preflight.
			if wrapped.IsAcceptableGrpcCorsRequest(r) || wrapped.IsGrpcWebRequest(r) {
				wrapped.ServeHTTP(w, r)
				return
			}
			w.WriteHeader(http.StatusOK)
			_, _ = w.Write([]byte("tempconv backend: OK\n"))
		}),
	}

	errCh := make(chan error, 2)
	go func() {
		log.Printf("gRPC listening on :%s", grpcPort)
		errCh <- grpcServer.Serve(lis)
	}()
	go func() {
		log.Printf("gRPC-Web listening on :%s", webPort)
		errCh <- httpServer.ListenAndServe()
	}()

	// Graceful shutdown.
	sigCh := make(chan os.Signal, 1)
	signal.Notify(sigCh, syscall.SIGINT, syscall.SIGTERM)

	select {
	case sig := <-sigCh:
		log.Printf("shutting down: %v", sig)
	case err := <-errCh:
		log.Printf("server error: %v", err)
	}

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	grpcServer.GracefulStop()
	if err := httpServer.Shutdown(ctx); err != nil {
		log.Printf("http shutdown error: %v", err)
	}

	log.Printf("bye")
}

func envOrDefault(k, def string) string {
	v := os.Getenv(k)
	if v == "" {
		return def
	}
	return v
}

