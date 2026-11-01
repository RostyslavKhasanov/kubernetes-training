#!/bin/bash

set -e

# Build all services
./gradlew build

echo "🔨 Building Docker images..."
docker-compose build

echo "📦 Loading Docker images into Minikube..."
minikube image load resources-image
minikube image load songs-image

echo "📦 Adding manual StorageClass..."
kubectl apply -f k8s/manual-storageclass.yaml

echo ""
echo "🚀 Deploying to Kubernetes (namespace: k8s-program)..."
kubectl apply -f k8s/songs-pv.yml
kubectl apply -f k8s/manifest.yml

echo ""
echo "⏳ Waiting for pods to be ready..."
sleep 3

echo ""
echo "✅ Deployment status:"
kubectl get all -n=k8s-program

echo ""
echo "📋 Pod details:"
kubectl get pods -n=k8s-program -o wide
