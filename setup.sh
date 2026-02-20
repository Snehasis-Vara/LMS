#!/bin/bash

echo "🔧 Setting up Library Management System with Forgot Password Feature..."
echo ""

# Check if .env exists
if [ ! -f .env ]; then
    echo "📝 Creating .env file from .env.example..."
    cp .env.example .env
    echo "⚠️  Please edit .env file and add your SMTP credentials:"
    echo "   - SMTP_USER: Your Gmail address"
    echo "   - SMTP_PASS: Your Gmail App Password"
    echo ""
    echo "   To generate Gmail App Password:"
    echo "   1. Go to https://myaccount.google.com/apppasswords"
    echo "   2. Enable 2-Factor Authentication if not enabled"
    echo "   3. Generate a new App Password"
    echo "   4. Copy the 16-character password to .env"
    echo ""
    read -p "Press Enter after updating .env file..."
fi

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

echo "🚀 Starting all services..."
./start.sh

echo ""
echo "✅ Setup complete!"
echo ""
echo "📧 Forgot Password Feature is now available!"
echo "   - Visit http://localhost:3001/login"
echo "   - Click 'Forgot Password?' link"
echo "   - Enter your email to receive OTP"
echo ""
echo "⚠️  Note: Make sure you've configured SMTP credentials in .env file"
echo "   Otherwise, email sending will fail."
