# SME Regulator Compliance Navigator - Logic Blueprint

This document outlines the core logic and system architecture for mapping the current web platform to a mobile application (Flutter).

---

## 1. System Architecture
*   **Backend:** FastAPI (Python)
*   **Relational DB (NeonDB/PostgreSQL):** Stores users, business profiles, compliance documents, and notification logs.
*   **NoSQL DB (MongoDB):** Stores transient data like OTPs, password reset codes, and AI-extracted metadata.
*   **AI Engine:** Gemini 2.5 Flash (Primary) + Tesseract OCR (Fallback).
*   **Task Scheduling:** APScheduler for daily background compliance checks.

---

## 2. Authentication Logic
### 2.1 Registration & Verification
1.  **POST `/api/auth/register`**: User submits details.
2.  **OTP Generation**: System generates two 6-digit codes (one for SMS, one for Email).
3.  **Persistence**: Codes stored in MongoDB `otps` collection with a `createdAt` timestamp.
4.  **Verification**: User must call `/api/auth/verify-otp` with the code. Logic checks `createdAt` against a 15-minute expiry.

### 2.2 Password Recovery (Forgot Password)
1.  **Request**: `/api/auth/forgot-password` generates a reset OTP in MongoDB `password_resets`.
2.  **Validation**: `/api/auth/verify-reset-otp` acts as a gatekeeper.
3.  **Completion**: `/api/auth/reset-password` requires the valid OTP to update the Bcrypt hash in PostgreSQL.

---

## 3. Document Vault & AI Logic
### 3.1 The Upload Pipeline
1.  **Upload**: User sends a file (PDF/Image) via `POST /api/vault/documents`.
2.  **Background Processing**: The request returns immediately (201 Created), but triggers a `background_task`.
3.  **AI Scan**:
    *   **Primary**: Gemini 2.5 Flash analyzes the document for `authority`, `expiry_date`, and `title`.
    *   **Fallback**: If Gemini fails, the system uses Tesseract OCR to find date patterns via Regex.
4.  **Sync**: The results update the SQL database and create an entry in MongoDB `document_meta`.
5.  **Alert**: An immediate notification is sent via Email/SMS/Web to confirm the scan results.

### 3.2 Mobile Implementation Tip
*   Since AI processing is asynchronous, the Flutter app should implement a "Processing..." state or use a Pull-to-Refresh mechanism on the vault list until the status updates.

---

## 4. Compliance & Notification Logic
### 4.1 The "Watchman" Scheduler
*   **Frequency**: Runs daily at 08:00 AM.
*   **Query**: Finds all documents where `expiry_date` is in exactly `30`, `7`, or `0` days.
*   **Action**: 
    1. Creates a new record in the `notifications` table (NeonDB).
    2. Sends an SMS via DevSMS API.
    3. Sends an Email via FastMail.

### 4.2 Dashboard Scoring
*   **Compliance Score**: Calculated by checking the presence of active (non-expired) documents for four mandatory types:
    1. Single Business Permit
    2. KRA Compliance Certificate
    3. Public Health License
    4. Fire Safety Clearance
*   **Score Logic**: `(Active Required Documents / 4) * 100`.

---

## 5. Knowledge Base & Roadmap
*   **Discovery**: Users can search for specific requirements by industry or turnover.
*   **Roadmap Generation**: `POST /api/knowledge/compliance/check` takes a business profile and returns a prioritized list of requirements, simulating a "Checklist" for the user.

---

## 6. Mobile Mapping (Flutter Strategy)
| Web Feature | Flutter Equivalent | Logic Source |
| :--- | :--- | :--- |
| JWT in LocalStorage | Flutter Secure Storage | `/api/auth/login` |
| Form Data Upload | `http.MultipartRequest` | `/api/vault/documents` |
| USSD Logic | `url_launcher` (tel:*123#) | `/api/ussd` |
| Notification Feed | ListView with `refreshIndicator` | `/api/notifications/` |
| AI Processing | Shimmer Effect / Progress Bar | Background Task Logic |

---

## 7. API Endpoints Summary
### Auth
- `POST /api/auth/register`
- `POST /api/auth/login`
- `POST /api/auth/verify-otp`
- `POST /api/auth/forgot-password`
- `POST /api/auth/reset-password`
- `POST /api/auth/change-password`

### Vault & Dashboard
- `GET /api/vault/documents`
- `POST /api/vault/documents`
- `GET /api/dashboard/summary`

### Notifications & Profile
- `GET /api/notifications/`
- `PUT /api/notifications/{id}/read`
- `GET /api/profile/`
- `PUT /api/profile/`

### Knowledge & Admin
- `POST /api/knowledge/compliance/check`
- `GET /api/admin/errors` (Restricted to Role: ADMIN)

---

## 8. API Response Shapes (JSON)

### Auth - Login Token (`Token`)
```json
{
  "access_token": "string",
  "token_type": "bearer",
  "user_id": 0,
  "role": "customer"
}
```

### Dashboard - Summary (`DashboardSummary`)
```json
{
  "compliance_score": 85.5,
  "total_required_documents": 4,
  "total_active_documents": 3,
  "total_expired_or_missing": 1,
  "upcoming_expiries": [
    {
      "id": 1,
      "title": "Business Permit",
      "document_type": "SINGLE_BUSINESS_PERMIT",
      "expiry_date": "2026-12-31",
      "days_remaining": 45
    }
  ]
}
```

### Vault - Document Detail (`DocumentResponse`)
```json
{
  "id": 10,
  "user_id": 5,
  "title": "KRA TCC",
  "document_type": "TAX_COMPLIANCE",
  "issuing_authority": "KRA",
  "issue_date": "2025-01-01",
  "expiry_date": "2026-01-01",
  "file_path": "uploads/documents/user_5_kra.pdf"
}
```

### Profile - User Profile (`ProfileResponse`)
```json
{
  "id": 1,
  "user_id": 5,
  "email": "user@example.com",
  "role": "customer",
  "first_name": "Jane",
  "last_name": "Doe",
  "phone": "0712345678",
  "is_phone_verified": true,
  "role_title": "Director",
  "business_name": "Jane's Tech",
  "registration_number": "BN-12345",
  "industry": "IT Services",
  "county_location": "Nairobi",
  "updated_at": "2026-04-28T10:00:00"
}
```

### Notifications - Feed Item (`NotificationResponse`)
```json
[
  {
    "id": 101,
    "title": "KRA Compliance Expiring",
    "message": "URGENT: Your KRA TCC expires in 7 days.",
    "document_type": "TAX_COMPLIANCE",
    "expiry_date": "2026-05-05",
    "days_remaining": 7,
    "is_read": false
  }
]
```

### Knowledge Base - Compliance Report (`ComplianceReport`)
```json
{
  "business_name": "Jane's Tech",
  "industry": "IT Services",
  "total_requirements": 12,
  "high_priority": 4,
  "compliance_score": 75,
  "items": [
    {
      "id": "item_001",
      "title": "Data Protection Registration",
      "description": "Register with the ODPC...",
      "authority": "ODPC",
      "deadline": "Immediate",
      "penalty": "Fine up to 5M KES",
      "status": "required",
      "category": "Legal",
      "priority": "high",
      "steps": ["Step 1...", "Step 2..."],
      "links": ["https://..."]
    ],
    "upcoming_deadlines": [
      {
        "title": "VAT Return",
        "deadline": "20th Monthly",
        "authority": "KRA",
        "days_left": 12
      }
    ]
    }
    }

    ### Generic Success Message (Used in Auth, OTP, Deletion)
    ```json
    {
    "message": "Operation successful. (e.g., 'OTP verified successfully.')"
    }
    ```

    ### Knowledge Base - Industry/County Lists
    ```json
    {
    "industries": ["Manufacturing", "IT Services", "Agribusiness", "..."],
    "counties": ["Nairobi", "Mombasa", "Kisumu", "..."]
    }
    ```

    ### Knowledge Base - Search Results
    ```json
    {
    "results": [
    {
      "id": "item_001",
      "title": "KRA PIN Registration",
      "authority": "KRA"
    }
    ],
    "count": 1
    }
    ```

    ### Admin - Error Logs
    ```json
    [
    {
    "id": "mongo_id_string",
    "method": "POST",
    "path": "/api/vault/documents",
    "error": "ZeroDivisionError: division by zero",
    "traceback": "File '...', line ...",
    "timestamp": "2026-04-28T10:00:00"
    }
    ]
    ```

    ### USSD - Plain Text (Special Case)
    ```text
    CON Welcome to SME Portal.
    Please enter your 6-digit OTP:
    ```
    *(Note: USSD returns `text/plain`, not JSON)*

```
