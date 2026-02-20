#!/bin/bash

echo "🧪 Testing Forgot Password Feature"
echo "===================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}📧 Step 1: Request OTP${NC}"
echo "Testing forgot-password endpoint..."
RESPONSE=$(curl -s -X POST http://localhost:3000/api/auth/forgot-password \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@lms.com"}')

echo "Response: $RESPONSE"
echo ""

if echo "$RESPONSE" | grep -q "OTP sent to your email"; then
    echo -e "${GREEN}✅ OTP request successful!${NC}"
    echo ""
    echo -e "${YELLOW}⚠️  NOTE: Email sending will fail if SMTP is not configured.${NC}"
    echo "   To configure SMTP:"
    echo "   1. Edit .env file in project root"
    echo "   2. Set SMTP_USER and SMTP_PASS"
    echo "   3. Restart services: docker-compose restart backend"
    echo ""
    echo "   For testing without email, check the database for OTP:"
    echo "   docker exec lms-db psql -U postgres -d lms -c \"SELECT * FROM password_resets;\""
else
    echo -e "${YELLOW}⚠️  OTP request failed or email not found${NC}"
fi

echo ""
echo -e "${BLUE}🔍 Step 2: Check Database for OTP${NC}"
echo "Fetching OTP from database..."
OTP_DATA=$(docker exec lms-db psql -U postgres -d lms -t -c "SELECT email, otp, \"expiresAt\" FROM password_resets ORDER BY \"createdAt\" DESC LIMIT 1;")

if [ ! -z "$OTP_DATA" ]; then
    echo -e "${GREEN}✅ OTP found in database:${NC}"
    echo "$OTP_DATA"
    
    # Extract OTP (assuming format: email | otp | expires_at)
    OTP=$(echo "$OTP_DATA" | awk -F'|' '{print $2}' | xargs)
    echo ""
    echo -e "${GREEN}📋 OTP Code: $OTP${NC}"
    echo ""
    
    echo -e "${BLUE}🔐 Step 3: Verify OTP${NC}"
    VERIFY_RESPONSE=$(curl -s -X POST http://localhost:3000/api/auth/verify-otp \
      -H "Content-Type: application/json" \
      -d "{\"email\":\"admin@lms.com\",\"otp\":\"$OTP\"}")
    
    echo "Response: $VERIFY_RESPONSE"
    echo ""
    
    if echo "$VERIFY_RESPONSE" | grep -q "OTP verified successfully"; then
        echo -e "${GREEN}✅ OTP verification successful!${NC}"
        echo ""
        
        echo -e "${BLUE}🔑 Step 4: Reset Password${NC}"
        RESET_RESPONSE=$(curl -s -X POST http://localhost:3000/api/auth/reset-password \
          -H "Content-Type: application/json" \
          -d "{\"email\":\"admin@lms.com\",\"otp\":\"$OTP\",\"newPassword\":\"newpass123\"}")
        
        echo "Response: $RESET_RESPONSE"
        echo ""
        
        if echo "$RESET_RESPONSE" | grep -q "Password reset successfully"; then
            echo -e "${GREEN}✅ Password reset successful!${NC}"
            echo ""
            
            echo -e "${BLUE}🔓 Step 5: Test Login with New Password${NC}"
            LOGIN_RESPONSE=$(curl -s -X POST http://localhost:3000/api/auth/login \
              -H "Content-Type: application/json" \
              -d '{"email":"admin@lms.com","password":"newpass123"}')
            
            if echo "$LOGIN_RESPONSE" | grep -q "access_token"; then
                echo -e "${GREEN}✅ Login successful with new password!${NC}"
                echo ""
                
                # Reset password back to original
                echo -e "${BLUE}🔄 Resetting password back to admin123...${NC}"
                
                # Request new OTP
                curl -s -X POST http://localhost:3000/api/auth/forgot-password \
                  -H "Content-Type: application/json" \
                  -d '{"email":"admin@lms.com"}' > /dev/null
                
                sleep 1
                
                # Get new OTP
                NEW_OTP=$(docker exec lms-db psql -U postgres -d lms -t -c "SELECT otp FROM password_resets ORDER BY \"createdAt\" DESC LIMIT 1;" | xargs)
                
                # Reset to original password
                curl -s -X POST http://localhost:3000/api/auth/reset-password \
                  -H "Content-Type: application/json" \
                  -d "{\"email\":\"admin@lms.com\",\"otp\":\"$NEW_OTP\",\"newPassword\":\"admin123\"}" > /dev/null
                
                echo -e "${GREEN}✅ Password restored to admin123${NC}"
            else
                echo -e "${YELLOW}⚠️  Login failed${NC}"
            fi
        else
            echo -e "${YELLOW}⚠️  Password reset failed${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  OTP verification failed${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  No OTP found in database${NC}"
fi

echo ""
echo "===================================="
echo -e "${GREEN}✅ Testing Complete!${NC}"
echo ""
echo "Frontend URLs to test manually:"
echo "  - Forgot Password: http://localhost:3001/forgot-password"
echo "  - Verify OTP: http://localhost:3001/verify-otp"
echo "  - Reset Password: http://localhost:3001/reset-password"
echo ""
echo "API Documentation:"
echo "  - Swagger: http://localhost:3000/api/docs"
