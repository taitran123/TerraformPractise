#!/bin/bash
docker build -t taitran89/svc-test:nginx -f Dockerfile .

docker push taitran89/svc-test:nginx