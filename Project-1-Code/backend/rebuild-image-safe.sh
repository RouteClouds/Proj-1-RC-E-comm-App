#!/usr/bin/env bash
# Safe backend image rebuild using existing backend/Dockerfile (non-destructive)
# Usage: ./rebuild-image-safe.sh [--push]
# Env (optional): DOCKER_IMAGE, TAG, EXTRA_TAG, PUSH
set -euo pipefail
cd "$(dirname "$0")"

DOCKER_IMAGE=${DOCKER_IMAGE:-awsfreetier30/routeclouds-backend}
TAG=${TAG:-latest}
EXTRA_TAG=${EXTRA_TAG:-}
PUSH=${PUSH:-0}

if [[ "${1:-}" == "--push" ]]; then PUSH=1; fi

echo "🔧 Building $DOCKER_IMAGE:$TAG from backend/Dockerfile"
docker build -t "$DOCKER_IMAGE:$TAG" -f Dockerfile .

if [[ -n "$EXTRA_TAG" ]]; then
  docker tag "$DOCKER_IMAGE:$TAG" "$DOCKER_IMAGE:$EXTRA_TAG"
fi

echo "🔎 Validating image (bash/npm/scripts)"
docker run --rm "$DOCKER_IMAGE:$TAG" sh -lc 'bash --version | head -1 || exit 1'
docker run --rm "$DOCKER_IMAGE:$TAG" node -v
docker run --rm "$DOCKER_IMAGE:$TAG" sh -lc 'test -f /app/dist/database/migrate.js && echo MIGRATE_OK || (echo MIGRATE_MISSING && exit 1)'
docker run --rm "$DOCKER_IMAGE:$TAG" sh -lc 'test -f /app/dist/database/seed.js && echo SEED_OK || (echo SEED_MISSING && exit 1)'

echo "✅ Build & validation success: $DOCKER_IMAGE:$TAG"

if [[ "$PUSH" == "1" ]]; then
  echo "📤 Pushing $DOCKER_IMAGE:$TAG"
  docker push "$DOCKER_IMAGE:$TAG"
  if [[ -n "$EXTRA_TAG" ]]; then
    docker push "$DOCKER_IMAGE:$EXTRA_TAG"
  fi
  echo "✅ Push complete"
else
  echo "⏭️  Skipping push (use --push or PUSH=1)"
fi

