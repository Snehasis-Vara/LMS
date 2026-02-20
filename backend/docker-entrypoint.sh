#!/bin/sh
set -e

echo "Running database migrations..."
npx prisma migrate deploy

echo "Seeding database..."
node -e "
const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcrypt');

const prisma = new PrismaClient();

async function seed() {
  try {
    const hashedPassword = await bcrypt.hash('admin123', 10);
    const admin = await prisma.user.upsert({
      where: { email: 'admin@lms.com' },
      update: {},
      create: {
        email: 'admin@lms.com',
        name: 'Admin User',
        password: hashedPassword,
        role: 'ADMIN',
      },
    });
    console.log('✅ Seeded admin user:', admin.email);
  } catch (e) {
    console.log('Seed already exists or failed:', e.message);
  } finally {
    await prisma.\$disconnect();
  }
}

seed();
"

echo "Starting application..."
exec node dist/main
