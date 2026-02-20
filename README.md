# 📚 Library Management System - Complete Full Stack Application

Production-grade Library Management System with NestJS backend and Next.js 15 frontend.

## ✅ STATUS: FULLY DEPLOYED & RUNNING

All services are operational and ready to use!

## 🆕 NEW: Profile Management & Password Reset Features

Complete profile system with avatar upload and secure password reset! See `QUICKSTART_PROFILE.md` and `QUICK_REFERENCE.md` for details.

**Profile Features:**
- 👤 Profile dropdown in navbar with avatar
- 📸 Upload/change/remove profile photo
- ✏️ Edit name, email, phone
- ✅ Real-time validation & image preview
- 🎨 Shadcn UI components

**Password Reset Features:**
- 🔐 Change password from profile dropdown
- ✅ Current password verification
- 🔒 Secure bcrypt hashing
- 📝 Real-time validation (min 6 chars)
- 🎯 Immediate database update
- 🔔 Toast notifications for feedback

## 🚀 Quick Start

### Option 1: One Command Start (Recommended)

```bash
./start.sh
```

This will start:
- PostgreSQL database on port 5432
- Backend API on port 3000
- Frontend on port 3001

### Option 2: Manual Docker Start

```bash
docker-compose up -d
```

### Option 3: Local Development

#### Backend
```bash
cd backend
pnpm install
pnpm db:migrate
pnpm db:seed
pnpm start:dev
```

#### Frontend
```bash
cd frontend
pnpm install
pnpm dev
```

## 🌐 Access Points

- **Frontend**: http://localhost:3001
- **Backend API**: http://localhost:3000/api
- **Swagger Docs**: http://localhost:3000/api/docs

## 🔑 Default Credentials

- **Email**: admin@lms.com
- **Password**: admin123
- **Role**: ADMIN

## 🛠️ Tech Stack

### Backend
- **Framework**: NestJS 11
- **Database**: PostgreSQL 16
- **ORM**: Prisma 6
- **Auth**: JWT + Passport.js
- **Validation**: class-validator, class-transformer
- **Documentation**: Swagger/OpenAPI

### Frontend
- **Framework**: Next.js 15 (App Router)
- **Styling**: Tailwind CSS
- **State**: React 19 + Context API
- **Forms**: react-hook-form + zod
- **Auth**: JWT in cookies

## 📁 Project Structure

```
LMS/
├── backend/                 # NestJS backend
│   ├── prisma/             # Database schema & migrations
│   ├── src/
│   │   ├── auth/           # Authentication
│   │   ├── users/          # User management
│   │   ├── books/          # Books catalog
│   │   ├── inventory/      # Book copies
│   │   ├── transactions/   # Issue/return/renew
│   │   └── common/         # Shared utilities
│   └── docker-compose.yml
│
├── frontend/               # Next.js frontend
│   ├── app/
│   │   ├── login/         # Login page
│   │   ├── register/      # Registration
│   │   ├── dashboard/     # Dashboard
│   │   ├── books/         # Books management
│   │   ├── inventory/     # Inventory management
│   │   ├── transactions/  # Transactions
│   │   └── users/         # User management (Admin)
│   ├── components/        # Reusable components
│   ├── context/           # Auth context
│   ├── lib/               # API client
│   └── types/             # TypeScript types
│
├── docker-compose.yml     # Full stack orchestration
└── start.sh               # One-command startup
```

## 🎯 Features

### Authentication & Authorization
- ✅ JWT-based authentication
- ✅ Role-based access control (ADMIN, LIBRARIAN, STUDENT)
- ✅ Protected routes with middleware
- ✅ Secure password hashing

### User Management (Admin Only)
- ✅ Create users with any role
- ✅ View all users
- ✅ Delete users
- ✅ Role assignment

### Books Catalog
- ✅ Browse all books
- ✅ Search by title, author, ISBN
- ✅ View book details
- ✅ Add/Edit/Delete books (Admin)
- ✅ ISBN validation

### Inventory Management (Admin/Librarian)
- ✅ Track individual book copies
- ✅ Bulk copy creation
- ✅ Status tracking (AVAILABLE, ISSUED, LOST)
- ✅ Inventory summary

### Transaction System (Admin/Librarian)
- ✅ Issue books (14-day period)
- ✅ Return books with fine calculation
- ✅ Renew books (max 1 renewal, 7-day extension)
- ✅ Overdue tracking (₹10/day fine)
- ✅ Transaction history

### Dashboard
- ✅ Role-specific dashboards
- ✅ Statistics and quick actions
- ✅ Real-time data

## 📊 User Roles & Permissions

| Feature | ADMIN | LIBRARIAN | STUDENT |
|---------|-------|-----------|---------|
| View Books | ✅ | ✅ | ✅ |
| Manage Books | ✅ | ❌ | ❌ |
| Manage Inventory | ✅ | ✅ | ❌ |
| Issue/Return Books | ✅ | ✅ | ❌ |
| Manage Users | ✅ | ❌ | ❌ |
| View Own Transactions | ✅ | ✅ | ✅ |

## 🔐 Security Features

- JWT token authentication
- Password hashing with bcrypt
- Role-based route protection
- Input validation on all forms
- SQL injection protection (Prisma ORM)
- CORS configuration
- Environment variable configuration

## 📝 API Endpoints

### Auth
- `POST /api/auth/register` - Register new student
- `POST /api/auth/login` - Login and get JWT token

### Users (ADMIN only)
- `POST /api/users` - Create user
- `GET /api/users` - List all users
- `GET /api/users/:id` - Get user by ID
- `PATCH /api/users/:id` - Update user
- `DELETE /api/users/:id` - Delete user

### Books
- `POST /api/books` - Create book (ADMIN)
- `GET /api/books` - List all books
- `GET /api/books/:id` - Get book by ID
- `PATCH /api/books/:id` - Update book (ADMIN)
- `DELETE /api/books/:id` - Delete book (ADMIN)

### Inventory (ADMIN, LIBRARIAN)
- `POST /api/inventory` - Add book copy
- `POST /api/inventory/bulk/:bookId?count=N` - Add multiple copies
- `GET /api/inventory` - List all copies
- `GET /api/inventory/summary` - Get inventory summary
- `PATCH /api/inventory/:id` - Update copy
- `DELETE /api/inventory/:id` - Delete copy

### Transactions (ADMIN, LIBRARIAN)
- `POST /api/transactions/issue` - Issue book
- `POST /api/transactions/return` - Return book
- `POST /api/transactions/renew` - Renew book
- `GET /api/transactions` - List all transactions
- `GET /api/transactions/overdue` - Get overdue transactions
- `GET /api/transactions/active/:userId` - Get user's active transactions

## ⚙️ Lending Policy

- **Borrowing Period**: 14 days
- **Max Renewals**: 1 per transaction
- **Renewal Extension**: 7 additional days
- **Fine Rate**: ₹10 per overdue day
- **Auto-Overdue**: Transactions automatically marked as OVERDUE when due date passes

## 🐳 Docker Commands

```bash
# Start all services
docker-compose up --build

# Stop all services
docker-compose down

# View logs
docker-compose logs -f backend
docker-compose logs -f frontend

# Restart services
docker-compose restart
```

## 💻 Development

### Backend Development
```bash
cd backend
pnpm start:dev          # Start with hot reload
pnpm build              # Build for production
pnpm test               # Run tests
pnpm db:studio          # Open Prisma Studio
```

### Frontend Development
```bash
cd frontend
pnpm dev                # Start dev server
pnpm build              # Build for production
pnpm start              # Start production server
pnpm lint               # Run linter
```

## 🧪 Testing

### Backend
```bash
cd backend
pnpm test               # Unit tests
pnpm test:e2e           # E2E tests
pnpm test:cov           # Coverage report
```

## 📈 Production Deployment

1. Update environment variables
2. Change `JWT_SECRET` to a strong random string
3. Use production database URL
4. Build and deploy:

```bash
docker-compose -f docker-compose.prod.yml up -d
```

## 🐛 Troubleshooting

### Port already in use
```bash
# Change ports in docker-compose.yml or .env files
```

### Database connection error
```bash
# Check PostgreSQL is running
docker-compose ps

# Restart database
docker-compose restart db
```

### Frontend can't connect to backend
```bash
# Ensure NEXT_PUBLIC_API_URL is set correctly in frontend/.env.local
```

## 📄 License

MIT

## 🤝 Support

For detailed documentation:
- Backend: See `backend/README.md`
- Frontend: See `frontend/README.md`
- API Examples: See `backend/API_EXAMPLES.md`

---

**Status**: ✅ 100% Complete & Production-Ready

Full stack application with authentication, authorization, and complete CRUD operations.
