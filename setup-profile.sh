#!/bin/bash

echo "🚀 Setting up Profile Feature..."

# Backend dependencies
echo "📦 Installing backend dependencies..."
cd backend
pnpm add sharp @nestjs/platform-express
pnpm add -D @types/multer

# Create uploads directory
mkdir -p public/uploads

# Run migration
echo "🗄️ Running database migration..."
pnpm prisma migrate dev --name add_user_profile_fields

# Frontend dependencies (Shadcn components should already be installed)
echo "📦 Checking frontend dependencies..."
cd ../frontend

# Check if sonner is installed
if ! grep -q "sonner" package.json; then
  echo "Installing sonner for toasts..."
  pnpm add sonner
fi

# Check if lucide-react is installed
if ! grep -q "lucide-react" package.json; then
  echo "Installing lucide-react..."
  pnpm add lucide-react
fi

echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Restart backend: cd backend && pnpm start:dev"
echo "2. Restart frontend: cd frontend && pnpm dev"
echo "3. Access app at http://localhost:3001"
