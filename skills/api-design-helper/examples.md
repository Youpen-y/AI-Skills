# API Design Examples

Real-world RESTful API design examples to guide your implementations.

## Blog API

A simple content management system for blog posts.

### Endpoints

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| GET    | /posts | List all posts | Public |
| POST   | /posts | Create new post | Required |
| GET    | /posts/:id | Get single post | Public |
| PUT    | /posts/:id | Replace post | Required |
| PATCH  | /posts/:id | Update post | Required |
| DELETE | /posts/:id | Delete post | Required |
| GET    | /posts/:id/comments | Get post comments | Public |
| POST   | /posts/:id/comments | Add comment | Required |

### Example Requests

#### Create Post
```http
POST /posts HTTP/1.1
Authorization: Bearer eyJhbGciOiJIUzI1NiIs...
Content-Type: application/json

{
  "title": "Introduction to REST APIs",
  "content": "REST APIs are designed around resources...",
  "tags": ["api", "rest", "tutorial"],
  "published": true
}
```

#### Response (201)
```json
{
  "data": {
    "id": "post_abc123",
    "title": "Introduction to REST APIs",
    "content": "REST APIs are designed around resources...",
    "tags": ["api", "rest", "tutorial"],
    "published": true,
    "author": {
      "id": "user_456",
      "name": "Jane Developer"
    },
    "createdAt": "2024-01-15T10:30:00Z",
    "updatedAt": "2024-01-15T10:30:00Z"
  }
}
```

#### List Posts with Filters
```http
GET /posts?tag=api&published=true&sort=createdAt:desc&page=1&limit=10 HTTP/1.1
```

#### Response (200)
```json
{
  "data": [
    {
      "id": "post_abc123",
      "title": "Introduction to REST APIs",
      "excerpt": "REST APIs are designed around resources...",
      "author": { "id": "user_456", "name": "Jane Developer" },
      "createdAt": "2024-01-15T10:30:00Z"
    }
  ],
  "meta": {
    "page": 1,
    "limit": 10,
    "total": 45,
    "totalPages": 5
  },
  "links": {
    "self": "/posts?page=1&limit=10",
    "next": "/posts?page=2&limit=10",
    "last": "/posts?page=5&limit=10"
  }
}
```

#### Update Post (Partial)
```http
PATCH /posts/post_abc123 HTTP/1.1
Authorization: Bearer eyJhbGciOiJIUzI1NiIs...
Content-Type: application/json

{
  "title": "Introduction to RESTful APIs",
  "content": "RESTful APIs are designed around resources..."
}
```

#### Response (200)
```json
{
  "data": {
    "id": "post_abc123",
    "title": "Introduction to RESTful APIs",
    "content": "RESTful APIs are designed around resources...",
    "updatedAt": "2024-01-15T11:00:00Z"
  }
}
```

#### Error Response
```http
POST /posts HTTP/1.1
Authorization: Bearer eyJhbGciOiJIUzI1NiIs...
Content-Type: application/json

{
  "title": "",
  "content": "Too short"
}
```

#### Response (422)
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Validation failed",
    "details": [
      {
        "field": "title",
        "message": "Title is required and must be at least 5 characters"
      },
      {
        "field": "content",
        "message": "Content must be at least 50 characters"
      }
    ],
    "requestId": "req_xyz789",
    "timestamp": "2024-01-15T11:00:00Z"
  }
}
```

## E-Commerce API

An e-commerce platform with products, orders, and payments.

### Core Resources

```
/products        # Product catalog
/categories      # Product categories
/orders          # Customer orders
/payments        # Payment processing
/users           # User accounts
/reviews         # Product reviews
/cart            # Shopping cart
```

### Endpoints

#### Products
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET    | /products | List products (with filters) |
| GET    | /products/:id | Get product details |
| GET    | /categories/:categoryId/products | Products by category |
| GET    | /products/:id/reviews | Get product reviews |

#### Orders
| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| GET    | /users/:userId/orders | Get user's orders | Required |
| POST   | /orders | Create order | Required |
| GET    | /orders/:id | Get order details | Required |
| PATCH  | /orders/:id/cancel | Cancel order | Required |

### Example: Create Order

```http
POST /orders HTTP/1.1
Authorization: Bearer <token>
Content-Type: application/json

{
  "items": [
    {
      "productId": "prod_abc123",
      "quantity": 2,
      "price": 2999
    },
    {
      "productId": "prod_def456",
      "quantity": 1,
      "price": 4999
    }
  ],
  "shippingAddress": {
    "name": "John Doe",
    "street": "123 Main St",
    "city": "San Francisco",
    "state": "CA",
    "zip": "94102",
    "country": "US"
  },
  "paymentMethod": "pm_stripe123"
}
```

#### Response (201)
```json
{
  "data": {
    "id": "order_xyz789",
    "status": "pending",
    "items": [
      {
        "productId": "prod_abc123",
        "quantity": 2,
        "price": 2999,
        "subtotal": 5998
      },
      {
        "productId": "prod_def456",
        "quantity": 1,
        "price": 4999,
        "subtotal": 4999
      }
    ],
    "subtotal": 10997,
    "tax": 880,
    "shipping": 500,
    "total": 12377,
    "currency": "USD",
    "createdAt": "2024-01-15T12:00:00Z"
  }
}
```

### Filtering and Sorting

```http
# Search products
GET /products?q=laptop&brand=apple&price[gte]=1000&price[lte]=3000

# Sort by price (ascending)
GET /products?sort=price:asc

# Sort by multiple fields
GET /products?sort=rating:desc,price:asc

# Pagination
GET /products?page=2&limit=20
```

## Authentication API

User authentication and authorization endpoints.

### Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST   | /auth/register | Create new account |
| POST   | /auth/login | Login with credentials |
| POST   /auth/refresh | Refresh access token |
| POST   | /auth/logout | Logout (invalidate token) |
| POST   | /auth/forgot-password | Request password reset |
| POST   | /auth/reset-password | Reset password |

### Example: Register

```http
POST /auth/register HTTP/1.1
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "SecurePass123!",
  "name": "John Doe"
}
```

#### Response (201)
```json
{
  "data": {
    "user": {
      "id": "user_abc123",
      "email": "user@example.com",
      "name": "John Doe",
      "emailVerified": false,
      "createdAt": "2024-01-15T13:00:00Z"
    },
    "tokens": {
      "accessToken": "eyJhbGciOiJIUzI1NiIs...",
      "refreshToken": "eyJhbGciOiJIUzI1NiIs...",
      "expiresIn": 3600
    }
  }
}
```

### Example: Login

```http
POST /auth/login HTTP/1.1
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "SecurePass123!"
}
```

#### Response (200)
```json
{
  "data": {
    "user": {
      "id": "user_abc123",
      "email": "user@example.com",
      "name": "John Doe"
    },
    "tokens": {
      "accessToken": "eyJhbGciOiJIUzI1NiIs...",
      "refreshToken": "eyJhbGciOiJIUzI1NiIs...",
      "expiresIn": 3600
    }
  }
}
```

#### Error Response (401)
```json
{
  "error": {
    "code": "INVALID_CREDENTIALS",
    "message": "Email or password is incorrect",
    "requestId": "req_err001"
  }
}
```

## File Upload API

Handling file uploads with multipart form data.

### Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST   | /files/upload | Upload file |
| GET    | /files/:id | Get file metadata |
| GET    | /files/:id/download | Download file |
| DELETE | /files/:id | Delete file |

### Example: Upload File

```http
POST /files/upload HTTP/1.1
Authorization: Bearer <token>
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW

------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="file"; filename="document.pdf"
Content-Type: application/pdf

<file content>
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="folder"

documents
------WebKitFormBoundary7MA4YWxkTrZu0gW--
```

#### Response (201)
```json
{
  "data": {
    "id": "file_abc123",
    "name": "document.pdf",
    "size": 2458624,
    "mimeType": "application/pdf",
    "url": "https://cdn.example.com/files/file_abc123.pdf",
    "folder": "documents",
    "uploadedAt": "2024-01-15T14:00:00Z"
  }
}
```

## Webhook API

Webhook management for event notifications.

### Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET    | /webhooks | List webhooks |
| POST   | /webhooks | Create webhook |
| GET    | /webhooks/:id | Get webhook details |
| PUT    | /webhooks/:id | Update webhook |
| DELETE | /webhooks/:id | Delete webhook |
| POST   | /webhooks/:id/rotate-secret | Rotate webhook secret |

### Example: Create Webhook

```http
POST /webhooks HTTP/1.1
Authorization: Bearer <token>
Content-Type: application/json

{
  "url": "https://example.com/webhooks",
  "events": ["order.created", "order.paid", "order.cancelled"],
  "secret": "wh_sec_abc123",
  "active": true
}
```

#### Response (201)
```json
{
  "data": {
    "id": "wh_abc123",
    "url": "https://example.com/webhooks",
    "events": ["order.created", "order.paid", "order.cancelled"],
    "active": true,
    "secret": "wh_sec_abc123",
    "createdAt": "2024-01-15T15:00:00Z"
  }
}
```

## Rate Limiting

Rate limit headers should be included in responses:

```http
HTTP/1.1 200 OK
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1705317600
```

#### Rate Limit Exceeded (429)

```json
{
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Too many requests. Please try again later.",
    "retryAfter": 60,
    "requestId": "req_rl_001"
  }
}
```
