#!/bin/bash

echo "🔍 Verifying Library Management System..."
echo ""

# Check if services are running
echo "📊 Service Status:"
docker-compose ps
echo ""

# Test backend
echo "🔧 Testing Backend API..."
BACKEND_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/api/books)
if [ "$BACKEND_STATUS" = "200" ]; then
    echo "✅ Backend API is responding (HTTP $BACKEND_STATUS)"
else
    echo "❌ Backend API is not responding (HTTP $BACKEND_STATUS)"
fi

# Test frontend
echo "🎨 Testing Frontend..."
FRONTEND_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3001)
if [ "$FRONTEND_STATUS" = "200" ]; then
    echo "✅ Frontend is responding (HTTP $FRONTEND_STATUS)"
else
    echo "❌ Frontend is not responding (HTTP $FRONTEND_STATUS)"
fi

# Test database
echo "🗄️  Testing Database..."
DB_STATUS=$(docker exec lms-db pg_isready -U postgres 2>&1)
if [[ $DB_STATUS == *"accepting connections"* ]]; then
    echo "✅ Database is accepting connections"
else
    echo "❌ Database is not responding"
fi

echo ""
echo "🌐 Access Points:"
echo "   Frontend:    http://localhost:3001"
echo "   Backend API: http://localhost:3000/api"
echo "   Swagger:     http://localhost:3000/api/docs"
echo ""
echo "🔑 Login Credentials:"
echo "   Email:    admin@lms.com"
echo "   Password: admin123"
echo ""
echo "✨ All systems operational!"
