# 🚀 Quick Start Guide

## Option 1: Docker (Recommended - Fastest)

```bash
cd backend
./start.sh
```

That's it! The script will:
- Start PostgreSQL database
- Build and run the backend
- Run migrations automatically
- Seed the default admin user

Access the API at: http://localhost:3000
Swagger docs at: http://localhost:3000/api/docs

**Default Admin:**
- Email: `admin@lms.com`
- Password: `admin123`

---

## Option 2: Local Development

### Prerequisites
- Node.js 20+
- PostgreSQL 16
- pnpm

### Steps

1. **Install dependencies**
```bash
cd backend
pnpm install
```

2. **Setup database**
```bash
# Update .env with your local PostgreSQL credentials
# DATABASE_URL="postgresql://user:password@localhost:5432/lms?schema=public"
```

3. **Run migrations**
```bash
pnpm db:migrate
```

4. **Seed admin user**
```bash
pnpm db:seed
```

5. **Start development server**
```bash
pnpm start:dev
```

---

## Testing the API

### 1. Register a Student
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "password": "password123"
  }'
```

### 2. Login as Admin
```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@lms.com",
    "password": "admin123"
  }'
```

Copy the `access_token` from the response.

### 3. Create a Book (Admin only)
```bash
curl -X POST http://localhost:3000/api/books \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -d '{
    "title": "Clean Code",
    "author": "Robert C. Martin",
    "isbn": "9780132350884",
    "category": "Programming",
    "publishedYear": 2008
  }'
```

### 4. Add Book Copies (Admin/Librarian)
```bash
# Add 5 copies of a book
curl -X POST "http://localhost:3000/api/inventory/bulk/BOOK_ID?count=5" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### 5. Issue a Book (Admin/Librarian)
```bash
curl -X POST http://localhost:3000/api/transactions/issue \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -d '{
    "userId": "USER_ID",
    "bookCopyId": "BOOK_COPY_ID"
  }'
```

---

## Project Structure

```
backend/
├── prisma/
│   ├── schema.prisma          # Database schema
│   └── seed.ts                # Seed script
├── src/
│   ├── auth/                  # Authentication (JWT, login, register)
│   ├── books/                 # Books catalog CRUD
│   ├── common/                # Shared utilities (guards, decorators, filters)
│   ├── inventory/             # Book copies management
│   ├── prisma/                # Prisma service
│   ├── transactions/          # Issue/return/renew logic
│   ├── users/                 # User management
│   ├── app.module.ts          # Root module
│   └── main.ts                # Entry point
├── test/                      # E2E tests
├── docker-compose.yml         # Docker setup
├── Dockerfile                 # Container image
└── README.md                  # Full documentation
```

---

## Available Scripts

```bash
pnpm start:dev          # Start dev server with hot reload
pnpm build              # Build for production
pnpm start:prod         # Start production server
pnpm db:migrate         # Run database migrations
pnpm db:seed            # Seed default admin
pnpm db:studio          # Open Prisma Studio (DB GUI)
pnpm test               # Run unit tests
pnpm test:e2e           # Run E2E tests
```

---

## Docker Commands

```bash
docker-compose up --build    # Build and start
docker-compose down          # Stop and remove containers
docker-compose logs -f       # View logs
docker-compose restart       # Restart services
```

---

## API Endpoints Summary

### Auth (Public)
- `POST /api/auth/register` - Register student
- `POST /api/auth/login` - Login

### Users (ADMIN)
- `POST /api/users` - Create user
- `GET /api/users` - List users
- `GET /api/users/:id` - Get user
- `PATCH /api/users/:id` - Update user
- `DELETE /api/users/:id` - Delete user

### Books (Public read, ADMIN write)
- `POST /api/books` - Create book
- `GET /api/books` - List books
- `GET /api/books/:id` - Get book
- `PATCH /api/books/:id` - Update book
- `DELETE /api/books/:id` - Delete book

### Inventory (ADMIN, LIBRARIAN)
- `POST /api/inventory` - Add book copy
- `POST /api/inventory/bulk/:bookId?count=N` - Add multiple copies
- `GET /api/inventory` - List copies
- `GET /api/inventory/summary` - Get summary
- `PATCH /api/inventory/:id` - Update copy
- `DELETE /api/inventory/:id` - Delete copy

### Transactions (ADMIN, LIBRARIAN)
- `POST /api/transactions/issue` - Issue book
- `POST /api/transactions/return` - Return book
- `POST /api/transactions/renew` - Renew book
- `GET /api/transactions` - List transactions
- `GET /api/transactions/overdue` - Get overdue
- `GET /api/transactions/active/:userId` - User's active transactions

---

## Troubleshooting

### Port already in use
```bash
# Change port in .env
PORT=3001

# Or kill process on port 3000
lsof -ti:3000 | xargs kill -9
```

### Database connection error
```bash
# Check PostgreSQL is running
docker-compose ps

# Restart database
docker-compose restart db
```

### Prisma client not generated
```bash
pnpm prisma generate
```

---

## Production Deployment

1. Update environment variables in `.env`
2. Change `JWT_SECRET` to a strong random string
3. Use production database URL
4. Build and deploy:

```bash
pnpm build
pnpm start:prod
```

Or use Docker:
```bash
docker-compose -f docker-compose.prod.yml up -d
```

---

## Support

For issues or questions, check:
- Swagger docs: http://localhost:3000/api/docs
- Health check: http://localhost:3000/api/health
- Logs: `docker-compose logs -f backend`
