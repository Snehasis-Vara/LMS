#!/bin/bash

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                                                              ║"
echo "║          📧 Gmail SMTP Configuration Setup 📧               ║"
echo "║                                                              ║"
echo "╔══════════════════════════════════════════════════════════════╝"
echo ""

# Check if .env already exists
if [ -f .env ]; then
    echo "⚠️  .env file already exists!"
    read -p "Do you want to overwrite it? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Setup cancelled."
        exit 0
    fi
fi

echo ""
echo "📝 Please provide your Gmail credentials:"
echo ""
echo "⚠️  IMPORTANT: You need a Gmail App Password, not your regular password!"
echo "   Generate one at: https://myaccount.google.com/apppasswords"
echo ""

# Get Gmail address
read -p "Enter your Gmail address: " GMAIL_USER

# Get App Password
echo ""
echo "Enter your Gmail App Password (16 characters, spaces will be removed):"
read -s GMAIL_PASS
echo ""

# Remove spaces from password
GMAIL_PASS=$(echo "$GMAIL_PASS" | tr -d ' ')

# Validate inputs
if [ -z "$GMAIL_USER" ] || [ -z "$GMAIL_PASS" ]; then
    echo "❌ Error: Email or password cannot be empty!"
    exit 1
fi

# Create .env file
cat > .env << EOF
# Gmail SMTP Configuration for Forgot Password Feature
SMTP_USER=$GMAIL_USER
SMTP_PASS=$GMAIL_PASS
EOF

echo ""
echo "✅ .env file created successfully!"
echo ""
echo "📧 Configuration:"
echo "   SMTP Host: smtp.gmail.com"
echo "   SMTP Port: 587"
echo "   SMTP User: $GMAIL_USER"
echo "   SMTP Pass: ****************"
echo ""

# Restart backend if running
if docker-compose ps | grep -q "lms-backend.*Up"; then
    echo "🔄 Restarting backend to apply changes..."
    docker-compose restart backend
    echo ""
    echo "⏳ Waiting for backend to be ready..."
    sleep 10
    echo ""
    echo "✅ Backend restarted successfully!"
else
    echo "⚠️  Backend is not running. Start it with: docker-compose up -d"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🎉 Gmail SMTP is now configured!"
echo ""
echo "🧪 Test the feature:"
echo "   1. Open: http://localhost:3001/forgot-password"
echo "   2. Enter: admin@lms.com"
echo "   3. Check your email for OTP"
echo "   4. Or run: ./test-forgot-password.sh"
echo ""
echo "📧 Real emails will now be sent to users!"
echo ""
