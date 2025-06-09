#!/bin/bash

set -e

# === CONFIGURATION ===
AWS_REGION="eu-north-1"
ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
REPO_NAME="threat-model"
LOCAL_IMAGE="threat-composer-app"

# Derived values
ECR_URI="${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO_NAME}"
GIT_COMMIT=$(git rev-parse --short HEAD)
DATE_TAG=$(date +%Y-%m-%d)

# === STEP 1: Authenticate with ECR ===
echo "🔐 Logging into AWS ECR..."
aws ecr get-login-password --region "$AWS_REGION" | \
  docker login --username AWS --password-stdin "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

# === STEP 2: Tag the image ===
echo "🏷️ Tagging Docker image..."
docker tag $LOCAL_IMAGE "${ECR_URI}:latest"
docker tag $LOCAL_IMAGE "${ECR_URI}:${GIT_COMMIT}"
docker tag $LOCAL_IMAGE "${ECR_URI}:${DATE_TAG}"

# === STEP 3: Push to ECR ===
echo "📤 Pushing to AWS ECR..."
docker push "${ECR_URI}:latest"
docker push "${ECR_URI}:${GIT_COMMIT}"
docker push "${ECR_URI}:${DATE_TAG}"

echo "✅ Done! Image pushed to:"
echo " - ${ECR_URI}:latest"
echo " - ${ECR_URI}:${GIT_COMMIT}"
echo " - ${ECR_URI}:${DATE_TAG}"
