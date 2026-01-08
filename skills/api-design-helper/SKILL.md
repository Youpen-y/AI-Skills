---
name: api-design-helper
description: Design RESTful APIs with best practices. Use when user asks to design an API, create API endpoints, or needs help with API structure and naming conventions.
---

# API Design Helper

Design RESTful APIs following industry best practices and conventions.

## When to Use

- User asks to design an API
- User wants to create API endpoints
- User needs help with API structure
- User asks about REST conventions
- User types `/api` or similar

## RESTful Design Principles

### 1. Resource-Based URLs

Use nouns, not verbs. Focus on resources:

```
Good                    Bad
GET /users             GET /getUsers
GET /users/123         GET /user?id=123
POST /users            GET /createUser
PUT /users/123         POST /updateUser
DELETE /users/123      GET /deleteUser
```

### 2. HTTP Methods

Map CRUD operations to HTTP verbs:

| Method | Operation | Idempotent | Safe |
|--------|-----------|------------|------|
| GET    | Read      | Yes        | Yes  |
| POST   | Create    | No         | No   |
| PUT    | Replace   | Yes        | No   |
| PATCH  | Modify    | No         | No   |
| DELETE | Delete    | Yes        | No   |

### 3. URL Structure

```
# Collection
GET    /users           # List users
POST   /users           # Create user

# Specific resource
GET    /users/123       # Get user 123
PUT    /users/123       # Replace user 123
PATCH  /users/123       # Modify user 123
DELETE /users/123       # Delete user 123

# Nested resources
GET    /users/123/posts # Get posts by user 123
POST   /users/123/posts # Create post for user 123
```

### 4. Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| URLs | kebab-case | `/user-profiles`, `/blog-posts` |
| JSON keys | camelCase | `firstName`, `isActive` |
| Query params | snake_case | `?page_size=20`, `?sort_by=created` |
| Enums | SCREAMING_SNAKE_CASE | `"PENDING"`, `"ACTIVE"` |

### 5. Response Format

#### Success Responses
```json
{
  "data": { ... },
  "meta": {
    "page": 1,
    "pageSize": 20,
    "total": 150
  }
}
```

#### Error Responses
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": [
      { "field": "email", "message": "Invalid email format" }
    ],
    "requestId": "req_abc123"
  }
}
```

### 6. Status Codes

| Code | Meaning | Use Case |
|------|---------|----------|
| 200  | OK      | Successful GET, PUT, PATCH |
| 201  | Created | Successful POST |
| 204  | No Content | Successful DELETE |
| 400  | Bad Request | Invalid input |
| 401  | Unauthorized | Missing/invalid auth |
| 403  | Forbidden | Authenticated but no permission |
| 404  | Not Found | Resource doesn't exist |
| 409  | Conflict | Resource already exists |
| 422  | Unprocessable Entity | Validation failed |
| 429  | Too Many Requests | Rate limit exceeded |
| 500  | Internal Server Error | Server error |

### 7. Pagination

#### Offset-based
```
GET /users?offset=20&limit=10
```

#### Cursor-based
```
GET /users?cursor=abc123&limit=10
```

Response:
```json
{
  "data": [...],
  "pagination": {
    "nextCursor": "def456",
    "hasMore": true
  }
}
```

### 8. Filtering and Sorting

```
# Filtering
GET /users?status=active&role=admin

# Multiple values
GET /users?tags=javascript,rust

# Range queries
GET /products?price[gte]=100&price[lte]=500

# Sorting
GET /users?sort=created_at:desc
GET /users?sort=name:asc,created_at:desc
```

### 9. Versioning

#### URL Versioning
```
/api/v1/users
/api/v2/users
```

#### Header Versioning
```
Accept: application/vnd.api.v1+json
```

## API Design Template

```
## API: [Resource Name]

### Endpoints

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| GET    | /users   | List users  | Required |

### Request/Response Examples

#### GET /users
**Request:**
```
GET /users?page=1&limit=20
Authorization: Bearer <token>
```

**Response (200):**
```json
{
  "data": [...]
}
```

### Validation Rules
- `email`: Required, valid email format
- `password`: Required, min 8 characters

### Rate Limits
- 100 requests per minute per user

```

## Design Questions to Ask

1. **Resources**: What entities does your API expose?
2. **Relationships**: How do resources relate (one-to-one, one-to-many)?
3. **Operations**: What actions are needed (CRUD, search, bulk)?
4. **Authentication**: What auth method (JWT, API key, OAuth)?
5. **Authorization**: What permissions/roles exist?
6. **Validation**: What rules apply to inputs?
7. **Rate Limiting**: What limits prevent abuse?
8. **Caching**: What can be cached and for how long?

## Best Practices

- **Plural nouns**: Use `/users`, not `/user`
- **Nesting depth**: Limit to 2-3 levels
- **Consistent naming**: Same field name across endpoints
- **Partial responses**: Allow field selection `?fields=id,name`
- **Bulk operations**: Support batch operations
- **HATEOAS**: Include links to related resources
- **Request ID**: Always return unique request ID
- **Timestamps**: Include created_at, updated_at
- **Soft deletes**: Use deleted_at instead of DELETE

## Common Mistakes

| Bad | Good | Reason |
|-----|------|--------|
| `GET /getUser` | `GET /users/123` | Use resource URLs |
| `POST /deleteUser` | `DELETE /users/123` | Use proper HTTP method |
| `200` on error | `400/422/500` | Use correct status codes |
| `GET /users?id=1` | `GET /users/1` | Put ID in path |
| Returning passwords | Never return secrets | Security issue |
| Nested too deep | Flatten or use IDs | `/users/1/posts/2/comments` |
