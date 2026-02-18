#!/bin/bash

echo "🚀 Starting Library Management System Backend Setup..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

echo "📦 Building and starting containers..."
docker-compose up --build -d

echo "⏳ Waiting for database to be ready..."
sleep 10

echo "✅ Backend is running!"
echo ""
echo "📚 API: http://localhost:3000"
echo "📖 Swagger Docs: http://localhost:3000/api/docs"
echo "🏥 Health Check: http://localhost:3000/api/health"
echo ""
echo "🔑 Default Admin Credentials:"
echo "   Email: admin@lms.com"
echo "   Password: admin123"
echo ""
echo "To view logs: docker-compose logs -f backend"
echo "To stop: docker-compose down"
