import { check, sleep } from 'k6';
import grpc from 'k6/net/grpc';

// k6 gRPC load test (native gRPC, not gRPC-Web).
//
// Usage (local):
//   k6 run -e TARGET=localhost:50051 loadtest/tempconv-grpc.js
//
// Usage (in-cluster, via Service DNS):
//   k6 run -e TARGET=tempconv-backend.tempconv.svc.cluster.local:50051 loadtest/tempconv-grpc.js

export const options = {
  vus: 50,
  duration: '30s',
};

const client = new grpc.Client();
client.load(['./proto'], 'tempconv/v1/tempconv.proto');

export default () => {
  const target = __ENV.TARGET || 'localhost:50051';

  client.connect(target, { plaintext: true });

  const res = client.invoke('tempconv.v1.TempConvService/CelsiusToFahrenheit', { value: 100 });

  check(res, {
    'status is OK': (r) => r && r.status === grpc.StatusOK,
    'value is 212': (r) => r && r.message && Math.abs(r.message.value - 212) < 1e-9,
  });

  client.close();
  sleep(0.1);
};

