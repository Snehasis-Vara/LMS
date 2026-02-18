# 🚀 QUICK START GUIDE

## ✅ System is Running!

**Access:** http://localhost:3001  
**Login:** admin@lms.com / admin123

---

## 📋 6-Step Workflow

### 1️⃣ Login
- Open http://localhost:3001
- Enter credentials
- Click "Login"

### 2️⃣ Add Books
- Sidebar → "Books"
- Click "+ Add New Book"
- Fill: Title, Author, ISBN, Category, Year
- Click "Save Book"

### 3️⃣ Add Inventory
- Sidebar → "Inventory"
- **Option A:** Bulk Add (recommended)
  - Scroll to "Bulk Add Copies"
  - Click "Bulk Add Copies" on any book
  - Enter quantity (e.g., 5)
- **Option B:** Single Add
  - Click "+ Add Single Copy"
  - Select book and status

### 4️⃣ Issue Books
- Sidebar → "Transactions"
- Click "+ Issue Book"
- Select user
- Select book copy
- Click "Issue Book"

### 5️⃣ Return Books
- Find issued transaction
- Click "Return"
- Confirm
- Fine shown if overdue (₹10/day)

### 6️⃣ Renew Books
- Find issued transaction (0/1 renewals)
- Click "Renew"
- Confirm
- +7 days added

---

## 🎯 Key Features

✅ **Books:** Add, Edit, Delete, Search  
✅ **Inventory:** Single/Bulk add, Status tracking  
✅ **Transactions:** Issue, Return, Renew  
✅ **Users:** Create, Delete (Admin only)  
✅ **Dashboard:** Statistics & Quick actions  

---

## 🔧 Commands

```bash
# Start
./start.sh

# Verify
./verify.sh

# Stop
docker-compose down

# Logs
docker-compose logs -f backend
docker-compose logs -f frontend
```

---

## 📚 Lending Policy

- **Period:** 14 days
- **Renewals:** Max 1 (7 days)
- **Fine:** ₹10 per overdue day

---

**Ready to use! Open http://localhost:3001** 🎉
