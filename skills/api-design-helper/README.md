# API Design Helper Skill

> Design RESTful APIs with industry best practices and conventions.

## Overview

This skill helps you design well-structured RESTful APIs that follow industry standards. Good API design improves:
- **Developer Experience** - Intuitive, predictable endpoints
- **Client Integration** - Easy to understand and use
- **Maintainability** - Consistent patterns across endpoints
- **Documentation** - Self-describing APIs
- **Evolution** - Versioning and backward compatibility

## Quick Start

### As a Claude Code Skill

When using Claude Code, simply ask for API design help:

```
Help me design a REST API for a blog platform
```

```
Create API endpoints for user authentication
```

```
What should the URL structure be for an e-commerce API?
```

Claude will use this skill to generate properly structured API designs.

### Manual Reference

See the files in this directory:
- **SKILL.md** - Main skill documentation with design principles
- **examples.md** - Real-world API design examples

## Structure

```
api-design-helper/
├── SKILL.md           # Main skill file (required)
├── examples.md        # Usage examples
└── README.md          # This file
```

## Key Design Principles

### 1. Resource-Oriented

APIs should expose resources, not actions:

```
Good                    Bad
GET /users             GET /getUsers
POST /users            POST /createUser
PUT /users/123         POST /updateUser?id=123
```

### 2. HTTP Verb Semantics

Use HTTP methods correctly:

| Method | Purpose | Example |
|--------|---------|---------|
| GET    | Read resource | `GET /users/123` |
| POST   | Create resource | `POST /users` |
| PUT    | Replace resource | `PUT /users/123` |
| PATCH  | Modify resource | `PATCH /users/123` |
| DELETE | Delete resource | `DELETE /users/123` |

### 3. Consistent Response Format

Standardize success and error responses:

**Success:**
```json
{
  "data": { ... },
  "meta": { "page": 1 }
}
```

**Error:**
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input",
    "details": [...]
  }
}
```

### 4. Proper Status Codes

| Code | Usage |
|------|-------|
| 200  | Successful read/update |
| 201  | Successful create |
| 204  | Successful delete |
| 400  | Invalid input |
| 401  | Unauthorized |
| 404  | Not found |
| 422  | Validation error |
| 500  | Server error |

## Common Patterns

### Pagination

**Offset-based:**
```
GET /users?offset=0&limit=20
```

**Cursor-based:**
```
GET /users?cursor=abc123&limit=20
```

### Filtering

```
GET /users?status=active&role=admin
GET /products?category=electronics&price[gte]=100
```

### Sorting

```
GET /users?sort=created_at:desc
GET /users?sort=name:asc,created_at:desc
```

### Nested Resources

```
GET /users/123/posts           # Posts by user
GET /posts/456/comments        # Comments on post
```

## Best Practices Checklist

- [ ] Use plural nouns for resource URLs (`/users`, not `/user`)
- [ ] Use kebab-case in URLs (`/blog-posts`)
- [ ] Use camelCase for JSON keys (`firstName`)
- [ ] Return appropriate HTTP status codes
- [ ] Include request ID in responses
- [ ] Support pagination for list endpoints
- [ ] Use consistent error response format
- [ ] Never return sensitive data (passwords, tokens)
- [ ] Implement rate limiting
- [ ] Use API versioning

## Integration

### With OpenAPI/Swagger

Use the generated design to create `openapi.yaml`:

```yaml
openapi: 3.0.0
info:
  title: My API
  version: 1.0.0
paths:
  /users:
    get:
      summary: List users
      responses:
        '200':
          description: Success
```

### With API Gateway

Deploy to cloud API gateways:
- AWS API Gateway
- Azure API Management
- Google Cloud Endpoints

## See Also

- [REST API Tutorial](https://restfulapi.net/)
- [Microsoft REST Guidelines](https://github.com/Microsoft/api-guidelines)
- [Zalando RESTful API Guidelines](https://github.com/zalando/restful-api-guidelines)

## License

MIT
