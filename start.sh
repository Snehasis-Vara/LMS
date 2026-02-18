#!/bin/bash

echo "🚀 Starting Library Management System..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

echo "📦 Building and starting all services..."
docker-compose up --build -d

echo "⏳ Waiting for services to be ready..."
sleep 15

echo ""
echo "✅ Library Management System is running!"
echo ""
echo "📚 Backend API: http://localhost:3000"
echo "📖 Swagger Docs: http://localhost:3000/api/docs"
echo "🌐 Frontend: http://localhost:3001"
echo ""
echo "🔑 Default Admin Credentials:"
echo "   Email: admin@lms.com"
echo "   Password: admin123"
echo ""
echo "To view logs:"
echo "  Backend: docker-compose logs -f backend"
echo "  Frontend: docker-compose logs -f frontend"
echo ""
echo "To stop: docker-compose down"
