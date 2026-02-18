# Library Management System - Backend

Production-grade Library Management System backend built with NestJS, Prisma, and PostgreSQL.

## Tech Stack

- **Framework**: NestJS 11
- **Database**: PostgreSQL 16
- **ORM**: Prisma 6
- **Auth**: JWT (Passport.js)
- **Validation**: class-validator, class-transformer
- **Runtime**: Docker Compose
- **Package Manager**: pnpm

## Features

- JWT Authentication with role-based access control (ADMIN, LIBRARIAN, STUDENT)
- Complete CRUD operations for Users, Books, Inventory, and Transactions
- Book lending system with 14-day borrowing period
- Renewal system (max 1 renewal, 7-day extension)
- Overdue tracking with ₹10/day fine calculation
- Bulk inventory management
- Swagger API documentation
- Global exception handling
- Request/Response logging
- Docker containerization

## Prerequisites

- Node.js 20+
- pnpm
- Docker & Docker Compose (for containerized setup)
- PostgreSQL 16 (for local development)

## Installation

### Local Development

1. **Install dependencies**
```bash
cd backend
pnpm install
```

2. **Setup environment**
```bash
cp .env.example .env
# Edit .env with your database credentials
```

3. **Run database migrations**
```bash
pnpm db:migrate
```

4. **Seed default admin user**
```bash
pnpm db:seed
```

Default admin credentials:
- Email: `admin@lms.com`
- Password: `admin123`

5. **Start development server**
```bash
pnpm start:dev
```

The API will be available at `http://localhost:3000`

### Docker Setup

1. **Build and run with Docker Compose**
```bash
docker-compose up --build
```

This will:
- Start PostgreSQL database
- Build and run the NestJS backend
- Run migrations automatically
- Expose API on port 3000

## API Documentation

Once the server is running, access Swagger documentation at:
```
http://localhost:3000/api/docs
```

## API Endpoints

### Auth
- `POST /api/auth/register` - Register new student
- `POST /api/auth/login` - Login and get JWT token

### Users (ADMIN only)
- `POST /api/users` - Create user
- `GET /api/users` - Get all users
- `GET /api/users/:id` - Get user by ID
- `PATCH /api/users/:id` - Update user
- `DELETE /api/users/:id` - Delete user

### Books
- `POST /api/books` - Create book (ADMIN)
- `GET /api/books` - Get all books
- `GET /api/books/:id` - Get book by ID
- `PATCH /api/books/:id` - Update book (ADMIN)
- `DELETE /api/books/:id` - Delete book (ADMIN)

### Inventory
- `POST /api/inventory` - Create book copy (ADMIN, LIBRARIAN)
- `POST /api/inventory/bulk/:bookId?count=N` - Create multiple copies
- `GET /api/inventory` - Get all book copies
- `GET /api/inventory/summary` - Get inventory summary
- `GET /api/inventory/:id` - Get book copy by ID
- `PATCH /api/inventory/:id` - Update book copy
- `DELETE /api/inventory/:id` - Delete book copy

### Transactions
- `POST /api/transactions/issue` - Issue book (ADMIN, LIBRARIAN)
- `POST /api/transactions/return` - Return book (ADMIN, LIBRARIAN)
- `POST /api/transactions/renew` - Renew book (ADMIN, LIBRARIAN)
- `GET /api/transactions` - Get all transactions
- `GET /api/transactions/overdue` - Get overdue transactions
- `GET /api/transactions/active/:userId` - Get active transactions by user
- `GET /api/transactions/:id` - Get transaction by ID

## User Roles & Permissions

- **ADMIN**: Full access to all endpoints
- **LIBRARIAN**: Inventory management + Transaction operations
- **STUDENT**: View books + own transactions

## Lending Policy

- **Borrowing Period**: 14 days
- **Max Renewals**: 1
- **Renewal Extension**: 7 days
- **Fine Rate**: ₹10 per overdue day
- Transactions automatically marked as OVERDUE when dueDate < now

## Database Schema

### User
- id, name, email, password, role (ADMIN/LIBRARIAN/STUDENT)

### Book
- id, title, author, isbn, category, publishedYear

### BookCopy
- id, bookId, status (AVAILABLE/ISSUED/LOST)

### Transaction
- id, userId, bookCopyId, issueDate, dueDate, returnDate, status (ISSUED/RETURNED/OVERDUE), renewCount

## Scripts

```bash
# Development
pnpm start:dev          # Start dev server with watch mode
pnpm build              # Build for production
pnpm start:prod         # Start production server

# Database
pnpm db:migrate         # Run migrations
pnpm db:push            # Push schema changes
pnpm db:seed            # Seed default admin
pnpm db:studio          # Open Prisma Studio

# Testing
pnpm test               # Run unit tests
pnpm test:e2e           # Run E2E tests
```

## Project Structure

```
src/
├── auth/              # JWT auth, login, register
├── books/             # Books catalog CRUD
├── common/            # Shared pipes, guards, interceptors, decorators
├── inventory/         # Book copies (physical inventory)
├── prisma/            # PrismaService + DB module
├── transactions/      # Issue/return/renew logic
└── users/             # User CRUD + roles
```

## Health Check

```bash
curl http://localhost:3000/api/health
```

## Environment Variables

```env
DATABASE_URL="postgresql://user:password@host:5432/lms?schema=public"
JWT_SECRET="your-super-secret-jwt-key-change-in-production"
JWT_EXPIRES_IN="7d"
PORT=3000
```

## License

MIT
