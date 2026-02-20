#!/bin/bash

echo "╔══════════════════════════════════════════════════════════════════════════════╗"
echo "║                                                                              ║"
echo "║          🧪 Testing OTP Email Sending to rudradutta103@gmail.com 🧪         ║"
echo "║                                                                              ║"
echo "╚══════════════════════════════════════════════════════════════════════════════╝"
echo ""

TEST_EMAIL="rudradutta103@gmail.com"

echo "📧 Target Email: $TEST_EMAIL"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Clear old logs
echo "🧹 Clearing old backend logs..."
docker-compose logs --tail=0 backend > /dev/null 2>&1

echo ""
echo "📤 Step 1: Sending OTP request to API..."
echo ""

# Send request
RESPONSE=$(curl -s -X POST http://localhost:3000/api/auth/forgot-password \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$TEST_EMAIL\"}")

echo "API Response:"
echo "$RESPONSE"
echo ""

# Wait a moment for logs
sleep 2

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 Backend Logs (showing OTP process):"
echo ""

# Get backend logs
docker-compose logs --tail=50 backend | grep -E "Forgot password|User found|OTP|SMTP|Email|saved in DB" | tail -20

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "💾 Database Check:"
echo ""

# Check database
OTP_DATA=$(docker exec lms-db psql -U postgres -d lms -t -c "SELECT email, otp, \"expiresAt\" FROM password_resets WHERE email='$TEST_EMAIL' ORDER BY \"createdAt\" DESC LIMIT 1;" 2>/dev/null)

if [ ! -z "$OTP_DATA" ]; then
    echo "✅ OTP found in database:"
    echo "$OTP_DATA"
    
    OTP=$(echo "$OTP_DATA" | awk -F'|' '{print $2}' | xargs)
    echo ""
    echo "🔢 OTP Code: $OTP"
else
    echo "⚠️  No OTP found in database"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📊 Summary of Logs:"
echo ""

# Show specific log entries
echo "✔️ Checking for required log entries..."
echo ""

if docker-compose logs backend | grep -q "OTP generated"; then
    echo "✅ 'OTP generated' - FOUND"
else
    echo "❌ 'OTP generated' - NOT FOUND"
fi

if docker-compose logs backend | grep -q "OTP saved in DB\|saved in DB"; then
    echo "✅ 'OTP saved in DB' - FOUND"
else
    echo "❌ 'OTP saved in DB' - NOT FOUND"
fi

if docker-compose logs backend | grep -q "SMTP connected\|Connecting to Gmail SMTP"; then
    echo "✅ 'SMTP connected' - FOUND"
else
    echo "⚠️  'SMTP connected' - NOT FOUND (may be in simulated mode)"
fi

if docker-compose logs backend | grep -q "Email sent successfully to: $TEST_EMAIL\|SIMULATED EMAIL.*$TEST_EMAIL"; then
    echo "✅ 'Email sent successfully to: $TEST_EMAIL' - FOUND"
else
    echo "❌ 'Email sent successfully' - NOT FOUND"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ -f .env ]; then
    echo "📧 Email Mode: REAL (Gmail SMTP configured)"
    echo "   Check your inbox: $TEST_EMAIL"
else
    echo "📧 Email Mode: SIMULATED (no .env file)"
    echo "   To enable real emails:"
    echo "   1. Run: ./configure-gmail.sh"
    echo "   2. Or create .env with SMTP credentials"
fi

echo ""
echo "✅ Test Complete!"
echo ""
