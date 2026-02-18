# API Testing Examples

## Setup
```bash
# Set your token after login
export TOKEN="your_jwt_token_here"
export API="http://localhost:3000/api"
```

---

## 1. Authentication

### Register Student
```bash
curl -X POST $API/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Alice Student",
    "email": "alice@example.com",
    "password": "password123"
  }'
```

### Login Admin
```bash
curl -X POST $API/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@lms.com",
    "password": "admin123"
  }' | jq
```

### Login Student
```bash
curl -X POST $API/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "alice@example.com",
    "password": "password123"
  }' | jq
```

---

## 2. Users (ADMIN only)

### Create Librarian
```bash
curl -X POST $API/users \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "name": "Bob Librarian",
    "email": "bob@lms.com",
    "password": "password123",
    "role": "LIBRARIAN"
  }' | jq
```

### List All Users
```bash
curl -X GET $API/users \
  -H "Authorization: Bearer $TOKEN" | jq
```

### Get User by ID
```bash
curl -X GET $API/users/USER_ID \
  -H "Authorization: Bearer $TOKEN" | jq
```

### Update User
```bash
curl -X PATCH $API/users/USER_ID \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "name": "Updated Name"
  }' | jq
```

### Delete User
```bash
curl -X DELETE $API/users/USER_ID \
  -H "Authorization: Bearer $TOKEN" | jq
```

---

## 3. Books

### Create Book (ADMIN)
```bash
curl -X POST $API/books \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "title": "Clean Code",
    "author": "Robert C. Martin",
    "isbn": "9780132350884",
    "category": "Programming",
    "publishedYear": 2008
  }' | jq
```

### Create Multiple Books
```bash
# The Pragmatic Programmer
curl -X POST $API/books \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "title": "The Pragmatic Programmer",
    "author": "Andrew Hunt, David Thomas",
    "isbn": "9780135957059",
    "category": "Programming",
    "publishedYear": 2019
  }' | jq

# Design Patterns
curl -X POST $API/books \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "title": "Design Patterns",
    "author": "Gang of Four",
    "isbn": "9780201633610",
    "category": "Software Engineering",
    "publishedYear": 1994
  }' | jq
```

### List All Books (Public)
```bash
curl -X GET $API/books | jq
```

### Get Book by ID
```bash
curl -X GET $API/books/BOOK_ID | jq
```

### Update Book (ADMIN)
```bash
curl -X PATCH $API/books/BOOK_ID \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "category": "Software Development"
  }' | jq
```

### Delete Book (ADMIN)
```bash
curl -X DELETE $API/books/BOOK_ID \
  -H "Authorization: Bearer $TOKEN" | jq
```

---

## 4. Inventory

### Add Single Book Copy
```bash
curl -X POST $API/inventory \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "bookId": "BOOK_ID",
    "status": "AVAILABLE"
  }' | jq
```

### Add Multiple Copies (Bulk)
```bash
# Add 10 copies of a book
curl -X POST "$API/inventory/bulk/BOOK_ID?count=10" \
  -H "Authorization: Bearer $TOKEN" | jq
```

### List All Copies
```bash
curl -X GET $API/inventory \
  -H "Authorization: Bearer $TOKEN" | jq
```

### Get Inventory Summary
```bash
curl -X GET $API/inventory/summary \
  -H "Authorization: Bearer $TOKEN" | jq
```

### Get Copy by ID
```bash
curl -X GET $API/inventory/COPY_ID \
  -H "Authorization: Bearer $TOKEN" | jq
```

### Update Copy Status
```bash
curl -X PATCH $API/inventory/COPY_ID \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "status": "LOST"
  }' | jq
```

### Delete Copy
```bash
curl -X DELETE $API/inventory/COPY_ID \
  -H "Authorization: Bearer $TOKEN" | jq
```

---

## 5. Transactions

### Issue Book
```bash
curl -X POST $API/transactions/issue \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "userId": "USER_ID",
    "bookCopyId": "COPY_ID"
  }' | jq
```

### Return Book
```bash
curl -X POST $API/transactions/return \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "transactionId": "TRANSACTION_ID"
  }' | jq
```

### Renew Book
```bash
curl -X POST $API/transactions/renew \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "transactionId": "TRANSACTION_ID"
  }' | jq
```

### List All Transactions
```bash
curl -X GET $API/transactions \
  -H "Authorization: Bearer $TOKEN" | jq
```

### Get Overdue Transactions
```bash
curl -X GET $API/transactions/overdue \
  -H "Authorization: Bearer $TOKEN" | jq
```

### Get Active Transactions by User
```bash
curl -X GET $API/transactions/active/USER_ID \
  -H "Authorization: Bearer $TOKEN" | jq
```

### Get Transaction by ID
```bash
curl -X GET $API/transactions/TRANSACTION_ID \
  -H "Authorization: Bearer $TOKEN" | jq
```

---

## Complete Workflow Example

```bash
# 1. Login as admin
ADMIN_TOKEN=$(curl -s -X POST $API/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@lms.com","password":"admin123"}' | jq -r '.access_token')

echo "Admin Token: $ADMIN_TOKEN"

# 2. Create a book
BOOK_ID=$(curl -s -X POST $API/books \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -d '{
    "title": "Clean Code",
    "author": "Robert C. Martin",
    "isbn": "9780132350884",
    "category": "Programming",
    "publishedYear": 2008
  }' | jq -r '.id')

echo "Book ID: $BOOK_ID"

# 3. Add 5 copies
curl -s -X POST "$API/inventory/bulk/$BOOK_ID?count=5" \
  -H "Authorization: Bearer $ADMIN_TOKEN" | jq

# 4. Get first available copy
COPY_ID=$(curl -s -X GET $API/inventory \
  -H "Authorization: Bearer $ADMIN_TOKEN" | jq -r '.[0].id')

echo "Copy ID: $COPY_ID"

# 5. Register a student
STUDENT_DATA=$(curl -s -X POST $API/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test Student",
    "email": "student@test.com",
    "password": "password123"
  }')

STUDENT_ID=$(echo $STUDENT_DATA | jq -r '.id')
echo "Student ID: $STUDENT_ID"

# 6. Issue book to student
TRANSACTION=$(curl -s -X POST $API/transactions/issue \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -d "{
    \"userId\": \"$STUDENT_ID\",
    \"bookCopyId\": \"$COPY_ID\"
  }")

TRANSACTION_ID=$(echo $TRANSACTION | jq -r '.id')
echo "Transaction ID: $TRANSACTION_ID"
echo $TRANSACTION | jq

# 7. Check active transactions
curl -s -X GET "$API/transactions/active/$STUDENT_ID" \
  -H "Authorization: Bearer $ADMIN_TOKEN" | jq

# 8. Return book
curl -s -X POST $API/transactions/return \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -d "{\"transactionId\": \"$TRANSACTION_ID\"}" | jq
```

---

## Health Check

```bash
curl -X GET $API/health | jq
```

---

## Notes

- Replace `USER_ID`, `BOOK_ID`, `COPY_ID`, `TRANSACTION_ID` with actual IDs
- Use `| jq` for pretty JSON output (requires jq installed)
- All protected endpoints require `Authorization: Bearer TOKEN` header
- ADMIN has full access
- LIBRARIAN can manage inventory and transactions
- STUDENT can only view books and their own transactions
