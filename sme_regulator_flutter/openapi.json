{
  "openapi": "3.1.0",
  "info": {
    "title": "SME Regulatory Compliance Navigator",
    "description": "AI-Powered Compliance Management using FastAPI, NeonDB, and MongoDB.",
    "version": "1.1.0"
  },
  "paths": {
    "/api/auth/register": {
      "post": {
        "tags": [
          "Authentication",
          "Authentication"
        ],
        "summary": "Register",
        "operationId": "register_api_auth_register_post",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/UserCreate"
              }
            }
          },
          "required": true
        },
        "responses": {
          "201": {
            "description": "Successful Response",
            "content": {
              "application/json": {
                "schema": {

                }
              }
            }
          },
          "422": {
            "description": "Validation Error",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/HTTPValidationError"
                }
              }
            }
          }
        }
      }
    },
    "/api/auth/google": {
      "post": {
        "tags": [
          "Authentication",
          "Authentication"
        ],
        "summary": "Google Login",
        "operationId": "google_login_api_auth_google_post",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/GoogleLoginRequest"
              }
            }
          },
          "required": true
        },
        "responses": {
          "200": {
            "description": "Successful Response",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Token"
                }
              }
            }
          },
          "422": {
            "description": "Validation Error",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/HTTPValidationError"
                }
              }
            }
          }
        }
      }
    },
    "/api/auth/verify-otp": {
      "post": {
        "tags": [
          "Authentication",
          "Authentication"
        ],
        "summary": "Verify Otp",
        "operationId": "verify_otp_api_auth_verify_otp_post",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/OTPVerify"
              }
            }
          },
          "required": true
        },
        "responses": {
          "200": {
            "description": "Successful Response",
            "content": {
              "application/json": {
                "schema": {

                }
              }
            }
          },
          "422": {
            "description": "Validation Error",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/HTTPValidationError"
                }
              }
            }
          }
        }
      }
    },
    "/api/auth/login": {
      "post": {
        "tags": [
          "Authentication",
          "Authentication"
        ],
        "summary": "Login",
        "operationId": "login_api_auth_login_post",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/UserLogin"
              }
            }
          },
          "required": true
        },
        "responses": {
          "200": {
            "description": "Successful Response",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Token"
                }
              }
            }
          },
          "422": {
            "description": "Validation Error",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/HTTPValidationError"
                }
              }
            }
          }
        }
      }
    },
    "/api/auth/forgot-password": {
      "post": {
        "tags": [
          "Authentication",
          "Authentication"
        ],
        "summary": "Forgot Password",
        "operationId": "forgot_password_api_auth_forgot_password_post",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/ForgotPassword"
              }
            }
          },
          "required": true
        },
        "responses": {
          "200": {
            "description": "Successful Response",
            "content": {
              "application/json": {
                "schema": {

                }
              }
            }
          },
          "422": {
            "description": "Validation Error",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/HTTPValidationError"
                }
              }
            }
          }
        }
      }
    },
    "/api/auth/verify-reset-otp": {
      "post": {
        "tags": [
          "Authentication",
          "Authentication"
        ],
        "summary": "Verify Reset Otp",
        "operationId": "verify_reset_otp_api_auth_verify_reset_otp_post",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/VerifyResetOTPRequest"
              }
            }
          },
          "required": true
        },
        "responses": {
          "200": {
            "description": "Successful Response",
            "content": {
              "application/json": {
                "schema": {

                }
              }
            }
          },
          "422": {
            "description": "Validation Error",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/HTTPValidationError"
                }
              }
            }
          }
        }
      }
    },
    "/api/auth/reset-password": {
      "post": {
        "tags": [
          "Authentication",
          "Authentication"
        ],
        "summary": "Reset Password",
        "operationId": "reset_password_api_auth_reset_password_post",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/ResetPassword"
              }
            }
          },
          "required": true
        },
        "responses": {
          "200": {
            "description": "Successful Response",
            "content": {
              "application/json": {
                "schema": {

                }
              }
            }
          },
          "422": {
            "description": "Validation Error",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/HTTPValidationError"
                }
              }
            }
          }
        }
      }
    },
    "/api/auth/request-otp": {
      "post": {
        "tags": [
          "Authentication",
          "Authentication"
        ],
        "summary": "Request Otp",
        "operationId": "request_otp_api_auth_request_otp_post",
        "responses": {
          "200": {
            "description": "Successful Response",
            "content": {
              "application/json": {
                "schema": {

                }
              }
            }
          }
        },
        "security": [
          {
            "OAuth2PasswordBearer": []
          }
        ]
      }
    },
    "/api/auth/change-password": {
      "post": {
        "tags": [
          "Authentication",
          "Authentication"
        ],
        "summary": "Change Password",
        "operationId": "change_password_api_auth_change_password_post",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/ChangePasswordRequest"
              }
            }
          },
          "required": true
        },
        "responses": {
          "200": {
            "description": "Successful Response",
            "content": {
              "application/json": {
                "schema": {

                }
              }
            }
          },
          "422": {
            "description": "Validation Error",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/HTTPValidationError"
                }
              }
            }
          }
        },
        "security": [
          {
            "OAuth2PasswordBearer": []
          }
        ]
      }
    },
    "/api/profile/": {
      "get": {
        "tags": [
          "Profile",
          "Profile"
        ],
        "summary": "Get Profile",
        "operationId": "get_profile_api_profile__get",
        "responses": {
          "200": {
            "description": "Successful Response",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ProfileResponse"
                }
              }
            }
          }
        },
        "security": [
          {
            "OAuth2PasswordBearer": []
          }
        ]
      },
      "put": {
        "tags": [
          "Profile",
          "Profile"
        ],
        "summary": "Update Profile",
        "operationId": "update_profile_api_profile__put",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/ProfileUpdate"
              }
            }
          },
          "required": true
        },
        "responses": {
          "200": {
            "description": "Successful Response",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ProfileResponse"
                }
              }
            }
          },
          "422": {
            "description": "Validation Error",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/HTTPValidationError"
                }
              }
            }
          }
        },
        "security": [
          {
            "OAuth2PasswordBearer": []
          }
        ]
      }
    },
    "/api/dashboard/summary": {
      "get": {
        "tags": [
          "Dashboard",
          "Dashboard"
        ],
        "summary": "Get Dashboard Summary",
        "operationId": "get_dashboard_summary_api_dashboard_summary_get",
        "responses": {
          "200": {
            "description": "Successful Response",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/DashboardSummary"
                }
              }
            }
          }
        },
        "security": [
          {
            "OAuth2PasswordBearer": []
          }
        ]
      }
    },
    "/api/knowledge/industries": {
      "get": {
        "tags": [
          "Knowledge Base",
          "Knowledge Base"
        ],
        "summary": "Industries",
        "operationId": "industries_api_knowledge_industries_get",
        "responses": {
          "200": {
            "description": "Successful Response",
            "content": {
              "application/json": {
                "schema": {

                }
              }
            }
          }
        }
      }
    },
    "/api/knowledge/counties": {
      "get": {
        "tags": [
          "Knowledge Base",
          "Knowledge Base"
        ],
        "summary": "Counties",
        "operationId": "counties_api_knowledge_counties_get",
        "responses": {
          "200": {
            "description": "Successful Response",
            "content": {
              "application/json": {
                "schema": {

                }
              }
            }
          }
        }
      }
    },
    "/api/knowledge/items": {
      "get": {
        "tags": [
          "Knowledge Base",
          "Knowledge Base"
        ],
        "summary": "List Items",
        "operationId": "list_items_api_knowledge_items_get",
        "responses": {
          "200": {
            "description": "Successful Response",
            "content": {
              "application/json": {
                "schema": {
                  "items": {
                    "$ref": "#/components/schemas/ComplianceItem"
                  },
                  "type": "array",
                  "title": "Response List Items Api Knowledge Items Get"
                }
              }
            }
          }
        }
      }
    },
    "/api/knowledge/item/{item_id}": {
      "get": {
        "tags": [
          "Knowledge Base",
          "Knowledge Base"
        ],
        "summary": "Get Item",
        "operationId": "get_item_api_knowledge_item__item_id__get",
        "parameters": [
          {
            "name": "item_id",
            "in": "path",
            "required": true,
            "schema": {
              "type": "string",
              "title": "Item Id"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "Successful Response",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ComplianceItem"
                }
              }
            }
          },
          "422": {
            "description": "Validation Error",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/HTTPValidationError"
                }
              }
            }
          }
        }
      }
    },
    "/api/knowledge/search": {
      "get": {
        "tags": [
          "Knowledge Base",
          "Knowledge Base"
        ],
        "summary": "Search",
        "operationId": "search_api_knowledge_search_get",
        "parameters": [
          {
            "name": "q",
            "in": "query",
            "required": true,
            "schema": {
              "type": "string",
              "title": "Q"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "Successful Response",
            "content": {
              "application/json": {
                "schema": {

                }
              }
            }
          },
          "422": {
            "description": "Validation Error",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/HTTPValidationError"
                }
              }
            }
          }
        }
      }
    },
    "/api/knowledge/compliance/check": {
      "post": {
        "tags": [
          "Knowledge Base",
          "Knowledge Base"
        ],
        "summary": "Check Compliance",
        "operationId": "check_compliance_api_knowledge_compliance_check_post",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/BusinessProfile"
              }
            }
          },
          "required": true
        },
        "responses": {
          "200": {
            "description": "Successful Response",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ComplianceReport"
                }
              }
            }
          },
          "422": {
            "description": "Validation Error",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/HTTPValidationError"
                }
              }
            }
          }
        }
      }
    },
    "/api/vault/documents": {
      "get": {
        "tags": [
          "Document Vault",
          "Document Vault"
        ],
        "summary": "List Documents",
        "operationId": "list_documents_api_vault_documents_get",
        "responses": {
          "200": {
            "description": "Successful Response",
            "content": {
              "application/json": {
                "schema": {
                  "items": {
                    "$ref": "#/components/schemas/DocumentResponse"
                  },
                  "type": "array",
                  "title": "Response List Documents Api Vault Documents Get"
                }
              }
            }
          }
        },
        "security": [
          {
            "OAuth2PasswordBearer": []
          }
        ]
      },
      "post": {
        "tags": [
          "Document Vault",
          "Document Vault"
        ],
        "summary": "Upload Document",
        "operationId": "upload_document_api_vault_documents_post",
        "requestBody": {
          "content": {
            "multipart/form-data": {
              "schema": {
                "$ref": "#/components/schemas/Body_upload_document_api_vault_documents_post"
              }
            }
          },
          "required": true
        },
        "responses": {
          "201": {
            "description": "Successful Response",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/DocumentResponse"
                }
              }
            }
          },
          "422": {
            "description": "Validation Error",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/HTTPValidationError"
                }
              }
            }
          }
        },
        "security": [
          {
            "OAuth2PasswordBearer": []
          }
        ]
      }
    },
    "/api/vault/documents/{document_id}": {
      "get": {
        "tags": [
          "Document Vault",
          "Document Vault"
        ],
        "summary": "Get Document",
        "operationId": "get_document_api_vault_documents__document_id__get",
        "security": [
          {
            "OAuth2PasswordBearer": []
          }
        ],
        "parameters": [
          {
            "name": "document_id",
            "in": "path",
            "required": true,
            "schema": {
              "type": "integer",
              "title": "Document Id"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "Successful Response",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/DocumentResponse"
                }
              }
            }
          },
          "422": {
            "description": "Validation Error",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/HTTPValidationError"
                }
              }
            }
          }
        }
      }
    },
    "/api/notifications/": {
      "get": {
        "tags": [
          "Notifications",
          "Notifications"
        ],
        "summary": "Get User Notifications",
        "description": "Fetches all notifications for the logged-in user, sorted by newest first.",
        "operationId": "get_user_notifications_api_notifications__get",
        "responses": {
          "200": {
            "description": "Successful Response",
            "content": {
              "application/json": {
                "schema": {
                  "items": {
                    "$ref": "#/components/schemas/NotificationResponse"
                  },
                  "type": "array",
                  "title": "Response Get User Notifications Api Notifications  Get"
                }
              }
            }
          }
        },
        "security": [
          {
            "OAuth2PasswordBearer": []
          }
        ]
      }
    },
    "/api/notifications/{notification_id}/read": {
      "put": {
        "tags": [
          "Notifications",
          "Notifications"
        ],
        "summary": "Mark Notification Read",
        "description": "Allows the frontend to mark an alert as read.",
        "operationId": "mark_notification_read_api_notifications__notification_id__read_put",
        "security": [
          {
            "OAuth2PasswordBearer": []
          }
        ],
        "parameters": [
          {
            "name": "notification_id",
            "in": "path",
            "required": true,
            "schema": {
              "type": "integer",
              "title": "Notification Id"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "Successful Response",
            "content": {
              "application/json": {
                "schema": {

                }
              }
            }
          },
          "422": {
            "description": "Validation Error",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/HTTPValidationError"
                }
              }
            }
          }
        }
      }
    },
    "/api/admin/errors": {
      "get": {
        "tags": [
          "Admin",
          "Admin"
        ],
        "summary": "Get Error Logs",
        "operationId": "get_error_logs_api_admin_errors_get",
        "security": [
          {
            "OAuth2PasswordBearer": []
          }
        ],
        "parameters": [
          {
            "name": "limit",
            "in": "query",
            "required": false,
            "schema": {
              "type": "integer",
              "default": 50,
              "title": "Limit"
            }
          },
          {
            "name": "skip",
            "in": "query",
            "required": false,
            "schema": {
              "type": "integer",
              "default": 0,
              "title": "Skip"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "Successful Response",
            "content": {
              "application/json": {
                "schema": {

                }
              }
            }
          },
          "422": {
            "description": "Validation Error",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/HTTPValidationError"
                }
              }
            }
          }
        }
      },
      "delete": {
        "tags": [
          "Admin",
          "Admin"
        ],
        "summary": "Clear Error Logs",
        "operationId": "clear_error_logs_api_admin_errors_delete",
        "security": [
          {
            "OAuth2PasswordBearer": []
          }
        ],
        "responses": {
          "200": {
            "description": "Successful Response",
            "content": {
              "application/json": {
                "schema": {

                }
              }
            }
          }
        }
      }
    },
    "/api/admin/test-error": {
      "get": {
        "tags": [
          "Admin",
          "Admin"
        ],
        "summary": "Trigger Test Error",
        "description": "Temporary endpoint to test the error logging system.",
        "operationId": "trigger_test_error_api_admin_test_error_get",
        "responses": {
          "200": {
            "description": "Successful Response",
            "content": {
              "application/json": {
                "schema": {

                }
              }
            }
          }
        }
      }
    },
    "/api/health": {
      "get": {
        "tags": [
          "System"
        ],
        "summary": "Health Check",
        "operationId": "health_check_api_health_get",
        "responses": {
          "200": {
            "description": "Successful Response",
            "content": {
              "application/json": {
                "schema": {

                }
              }
            }
          }
        }
      }
    },
    "/": {
      "get": {
        "tags": [
          "System"
        ],
        "summary": "Root",
        "operationId": "root__get",
        "responses": {
          "200": {
            "description": "Successful Response",
            "content": {
              "application/json": {
                "schema": {

                }
              }
            }
          }
        }
      }
    }
  },
  "components": {
    "schemas": {
      "Body_upload_document_api_vault_documents_post": {
        "properties": {
          "title": {
            "type": "string",
            "title": "Title"
          },
          "document_type": {
            "type": "string",
            "title": "Document Type"
          },
          "issuing_authority": {
            "anyOf": [
              {
                "type": "string"
              },
              {
                "type": "null"
              }
            ],
            "title": "Issuing Authority"
          },
          "issue_date": {
            "anyOf": [
              {
                "type": "string"
              },
              {
                "type": "null"
              }
            ],
            "title": "Issue Date"
          },
          "expiry_date": {
            "anyOf": [
              {
                "type": "string"
              },
              {
                "type": "null"
              }
            ],
            "title": "Expiry Date"
          },
          "file": {
            "type": "string",
            "contentMediaType": "application/octet-stream",
            "title": "File"
          }
        },
        "type": "object",
        "required": [
          "title",
          "document_type",
          "file"
        ],
        "title": "Body_upload_document_api_vault_documents_post"
      },
      "BusinessProfile": {
        "properties": {
          "business_name": {
            "type": "string",
            "title": "Business Name"
          },
          "industry": {
            "type": "string",
            "title": "Industry"
          },
          "employee_count": {
            "type": "integer",
            "title": "Employee Count"
          },
          "annual_turnover_kes": {
            "type": "number",
            "title": "Annual Turnover Kes"
          },
          "years_in_operation": {
            "type": "integer",
            "title": "Years In Operation"
          },
          "county": {
            "type": "string",
            "title": "County"
          }
        },
        "type": "object",
        "required": [
          "business_name",
          "industry",
          "employee_count",
          "annual_turnover_kes",
          "years_in_operation",
          "county"
        ],
        "title": "BusinessProfile"
      },
      "ChangePasswordRequest": {
        "properties": {
          "current_password": {
            "type": "string",
            "title": "Current Password"
          },
          "new_password": {
            "type": "string",
            "title": "New Password"
          }
        },
        "type": "object",
        "required": [
          "current_password",
          "new_password"
        ],
        "title": "ChangePasswordRequest"
      },
      "ComplianceItem": {
        "properties": {
          "id": {
            "type": "string",
            "title": "Id"
          },
          "title": {
            "type": "string",
            "title": "Title"
          },
          "description": {
            "type": "string",
            "title": "Description"
          },
          "authority": {
            "type": "string",
            "title": "Authority"
          },
          "deadline": {
            "anyOf": [
              {
                "type": "string"
              },
              {
                "type": "null"
              }
            ],
            "title": "Deadline"
          },
          "penalty": {
            "type": "string",
            "title": "Penalty"
          },
          "status": {
            "type": "string",
            "title": "Status"
          },
          "category": {
            "type": "string",
            "title": "Category"
          },
          "priority": {
            "type": "string",
            "title": "Priority"
          },
          "steps": {
            "items": {
              "type": "string"
            },
            "type": "array",
            "title": "Steps"
          },
          "links": {
            "items": {
              "type": "string"
            },
            "type": "array",
            "title": "Links"
          }
        },
        "type": "object",
        "required": [
          "id",
          "title",
          "description",
          "authority",
          "penalty",
          "status",
          "category",
          "priority",
          "steps",
          "links"
        ],
        "title": "ComplianceItem"
      },
      "ComplianceReport": {
        "properties": {
          "business_name": {
            "type": "string",
            "title": "Business Name"
          },
          "industry": {
            "type": "string",
            "title": "Industry"
          },
          "total_requirements": {
            "type": "integer",
            "title": "Total Requirements"
          },
          "high_priority": {
            "type": "integer",
            "title": "High Priority"
          },
          "compliance_score": {
            "type": "integer",
            "title": "Compliance Score"
          },
          "items": {
            "items": {
              "$ref": "#/components/schemas/ComplianceItem"
            },
            "type": "array",
            "title": "Items"
          },
          "upcoming_deadlines": {
            "items": {
              "additionalProperties": true,
              "type": "object"
            },
            "type": "array",
            "title": "Upcoming Deadlines"
          }
        },
        "type": "object",
        "required": [
          "business_name",
          "industry",
          "total_requirements",
          "high_priority",
          "compliance_score",
          "items",
          "upcoming_deadlines"
        ],
        "title": "ComplianceReport"
      },
      "DashboardSummary": {
        "properties": {
          "compliance_score": {
            "type": "number",
            "title": "Compliance Score"
          },
          "total_required_documents": {
            "type": "integer",
            "title": "Total Required Documents"
          },
          "total_active_documents": {
            "type": "integer",
            "title": "Total Active Documents"
          },
          "total_expired_or_missing": {
            "type": "integer",
            "title": "Total Expired Or Missing"
          },
          "upcoming_expiries": {
            "items": {
              "$ref": "#/components/schemas/UpcomingExpiry"
            },
            "type": "array",
            "title": "Upcoming Expiries"
          }
        },
        "type": "object",
        "required": [
          "compliance_score",
          "total_required_documents",
          "total_active_documents",
          "total_expired_or_missing",
          "upcoming_expiries"
        ],
        "title": "DashboardSummary"
      },
      "DocumentResponse": {
        "properties": {
          "title": {
            "type": "string",
            "title": "Title"
          },
          "document_type": {
            "type": "string",
            "title": "Document Type"
          },
          "issuing_authority": {
            "anyOf": [
              {
                "type": "string"
              },
              {
                "type": "null"
              }
            ],
            "title": "Issuing Authority"
          },
          "issue_date": {
            "anyOf": [
              {
                "type": "string",
                "format": "date"
              },
              {
                "type": "null"
              }
            ],
            "title": "Issue Date"
          },
          "expiry_date": {
            "anyOf": [
              {
                "type": "string",
                "format": "date"
              },
              {
                "type": "null"
              }
            ],
            "title": "Expiry Date"
          },
          "id": {
            "type": "integer",
            "title": "Id"
          },
          "user_id": {
            "type": "integer",
            "title": "User Id"
          },
          "file_path": {
            "type": "string",
            "title": "File Path"
          }
        },
        "type": "object",
        "required": [
          "title",
          "document_type",
          "id",
          "user_id",
          "file_path"
        ],
        "title": "DocumentResponse"
      },
      "ForgotPassword": {
        "properties": {
          "email": {
            "type": "string",
            "format": "email",
            "title": "Email"
          }
        },
        "type": "object",
        "required": [
          "email"
        ],
        "title": "ForgotPassword"
      },
      "GoogleLoginRequest": {
        "properties": {
          "token": {
            "type": "string",
            "title": "Token"
          }
        },
        "type": "object",
        "required": [
          "token"
        ],
        "title": "GoogleLoginRequest"
      },
      "HTTPValidationError": {
        "properties": {
          "detail": {
            "items": {
              "$ref": "#/components/schemas/ValidationError"
            },
            "type": "array",
            "title": "Detail"
          }
        },
        "type": "object",
        "title": "HTTPValidationError"
      },
      "NotificationResponse": {
        "properties": {
          "id": {
            "type": "integer",
            "title": "Id"
          },
          "title": {
            "type": "string",
            "title": "Title"
          },
          "message": {
            "type": "string",
            "title": "Message"
          },
          "document_type": {
            "anyOf": [
              {
                "type": "string"
              },
              {
                "type": "null"
              }
            ],
            "title": "Document Type"
          },
          "expiry_date": {
            "anyOf": [
              {
                "type": "string"
              },
              {
                "type": "null"
              }
            ],
            "title": "Expiry Date"
          },
          "days_remaining": {
            "anyOf": [
              {
                "type": "integer"
              },
              {
                "type": "null"
              }
            ],
            "title": "Days Remaining"
          },
          "is_read": {
            "type": "boolean",
            "title": "Is Read"
          }
        },
        "type": "object",
        "required": [
          "id",
          "title",
          "message",
          "document_type",
          "expiry_date",
          "days_remaining",
          "is_read"
        ],
        "title": "NotificationResponse"
      },
      "OTPVerify": {
        "properties": {
          "user_id": {
            "type": "integer",
            "title": "User Id"
          },
          "otp_code": {
            "type": "string",
            "title": "Otp Code"
          },
          "verification_type": {
            "$ref": "#/components/schemas/VerificationType"
          }
        },
        "type": "object",
        "required": [
          "user_id",
          "otp_code",
          "verification_type"
        ],
        "title": "OTPVerify"
      },
      "ProfileResponse": {
        "properties": {
          "first_name": {
            "anyOf": [
              {
                "type": "string"
              },
              {
                "type": "null"
              }
            ],
            "title": "First Name"
          },
          "last_name": {
            "anyOf": [
              {
                "type": "string"
              },
              {
                "type": "null"
              }
            ],
            "title": "Last Name"
          },
          "phone": {
            "anyOf": [
              {
                "type": "string"
              },
              {
                "type": "null"
              }
            ],
            "title": "Phone"
          },
          "role_title": {
            "anyOf": [
              {
                "type": "string"
              },
              {
                "type": "null"
              }
            ],
            "title": "Role Title"
          },
          "business_name": {
            "anyOf": [
              {
                "type": "string"
              },
              {
                "type": "null"
              }
            ],
            "title": "Business Name"
          },
          "registration_number": {
            "anyOf": [
              {
                "type": "string"
              },
              {
                "type": "null"
              }
            ],
            "title": "Registration Number"
          },
          "industry": {
            "anyOf": [
              {
                "type": "string"
              },
              {
                "type": "null"
              }
            ],
            "title": "Industry"
          },
          "county_location": {
            "anyOf": [
              {
                "type": "string"
              },
              {
                "type": "null"
              }
            ],
            "title": "County Location"
          },
          "id": {
            "type": "integer",
            "title": "Id"
          },
          "user_id": {
            "type": "integer",
            "title": "User Id"
          },
          "email": {
            "type": "string",
            "title": "Email"
          },
          "role": {
            "type": "string",
            "title": "Role"
          },
          "is_phone_verified": {
            "type": "boolean",
            "title": "Is Phone Verified"
          },
          "updated_at": {
            "type": "string",
            "format": "date-time",
            "title": "Updated At"
          }
        },
        "type": "object",
        "required": [
          "id",
          "user_id",
          "email",
          "role",
          "is_phone_verified",
          "updated_at"
        ],
        "title": "ProfileResponse"
      },
      "ProfileUpdate": {
        "properties": {
          "first_name": {
            "anyOf": [
              {
                "type": "string"
              },
              {
                "type": "null"
              }
            ],
            "title": "First Name"
          },
          "last_name": {
            "anyOf": [
              {
                "type": "string"
              },
              {
                "type": "null"
              }
            ],
            "title": "Last Name"
          },
          "phone": {
            "anyOf": [
              {
                "type": "string"
              },
              {
                "type": "null"
              }
            ],
            "title": "Phone"
          },
          "role_title": {
            "anyOf": [
              {
                "type": "string"
              },
              {
                "type": "null"
              }
            ],
            "title": "Role Title"
          },
          "business_name": {
            "anyOf": [
              {
                "type": "string"
              },
              {
                "type": "null"
              }
            ],
            "title": "Business Name"
          },
          "registration_number": {
            "anyOf": [
              {
                "type": "string"
              },
              {
                "type": "null"
              }
            ],
            "title": "Registration Number"
          },
          "industry": {
            "anyOf": [
              {
                "type": "string"
              },
              {
                "type": "null"
              }
            ],
            "title": "Industry"
          },
          "county_location": {
            "anyOf": [
              {
                "type": "string"
              },
              {
                "type": "null"
              }
            ],
            "title": "County Location"
          }
        },
        "type": "object",
        "title": "ProfileUpdate"
      },
      "ResetPassword": {
        "properties": {
          "email": {
            "type": "string",
            "format": "email",
            "title": "Email"
          },
          "otp_code": {
            "type": "string",
            "title": "Otp Code"
          },
          "new_password": {
            "type": "string",
            "minLength": 8,
            "title": "New Password"
          }
        },
        "type": "object",
        "required": [
          "email",
          "otp_code",
          "new_password"
        ],
        "title": "ResetPassword"
      },
      "Token": {
        "properties": {
          "access_token": {
            "type": "string",
            "title": "Access Token"
          },
          "token_type": {
            "type": "string",
            "title": "Token Type"
          },
          "user_id": {
            "type": "integer",
            "title": "User Id"
          },
          "role": {
            "type": "string",
            "title": "Role",
            "default": "customer"
          }
        },
        "type": "object",
        "required": [
          "access_token",
          "token_type",
          "user_id"
        ],
        "title": "Token"
      },
      "UpcomingExpiry": {
        "properties": {
          "id": {
            "type": "integer",
            "title": "Id"
          },
          "title": {
            "type": "string",
            "title": "Title"
          },
          "document_type": {
            "type": "string",
            "title": "Document Type"
          },
          "expiry_date": {
            "anyOf": [
              {
                "type": "string",
                "format": "date"
              },
              {
                "type": "null"
              }
            ],
            "title": "Expiry Date"
          },
          "days_remaining": {
            "anyOf": [
              {
                "type": "integer"
              },
              {
                "type": "null"
              }
            ],
            "title": "Days Remaining"
          }
        },
        "type": "object",
        "required": [
          "id",
          "title",
          "document_type",
          "expiry_date",
          "days_remaining"
        ],
        "title": "UpcomingExpiry"
      },
      "UserCreate": {
        "properties": {
          "email": {
            "type": "string",
            "format": "email",
            "title": "Email"
          },
          "phone": {
            "type": "string",
            "title": "Phone"
          },
          "password": {
            "type": "string",
            "minLength": 8,
            "title": "Password"
          }
        },
        "type": "object",
        "required": [
          "email",
          "phone",
          "password"
        ],
        "title": "UserCreate"
      },
      "UserLogin": {
        "properties": {
          "email": {
            "type": "string",
            "format": "email",
            "title": "Email"
          },
          "password": {
            "type": "string",
            "title": "Password"
          }
        },
        "type": "object",
        "required": [
          "email",
          "password"
        ],
        "title": "UserLogin"
      },
      "ValidationError": {
        "properties": {
          "loc": {
            "items": {
              "anyOf": [
                {
                  "type": "string"
                },
                {
                  "type": "integer"
                }
              ]
            },
            "type": "array",
            "title": "Location"
          },
          "msg": {
            "type": "string",
            "title": "Message"
          },
          "type": {
            "type": "string",
            "title": "Error Type"
          },
          "input": {
            "title": "Input"
          },
          "ctx": {
            "type": "object",
            "title": "Context"
          }
        },
        "type": "object",
        "required": [
          "loc",
          "msg",
          "type"
        ],
        "title": "ValidationError"
      },
      "VerificationType": {
        "type": "string",
        "enum": [
          "registration",
          "password_reset"
        ],
        "title": "VerificationType"
      },
      "VerifyResetOTPRequest": {
        "properties": {
          "email": {
            "type": "string",
            "title": "Email"
          },
          "otp_code": {
            "type": "string",
            "title": "Otp Code"
          }
        },
        "type": "object",
        "required": [
          "email",
          "otp_code"
        ],
        "title": "VerifyResetOTPRequest"
      }
    },
    "securitySchemes": {
      "OAuth2PasswordBearer": {
        "type": "oauth2",
        "flows": {
          "password": {
            "scopes": {

            },
            "tokenUrl": "api/auth/login"
          }
        }
      }
    }
  }
}