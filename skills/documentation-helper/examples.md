# Documentation Examples

Real-world examples of documentation using the Documentation Helper framework.

## Example 1: API Documentation

### Context
Documenting an authentication service API.

### Documentation

```markdown
## AuthService

Handles user authentication, session management, and token refresh.

### Methods

#### login(email, password)

Authenticates a user with email and password credentials.

**Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `email` | `string` | Yes | User email address |
| `password` | `string` | Yes | User password (min 8 characters) |

**Returns:**

`Promise<Session>` - Object containing session token and user info:
```typescript
{
  token: string;      // JWT token valid for 24 hours
  user: {
    id: string;
    email: string;
    name: string;
  };
}
```

**Throws:**

- `AuthenticationError` - Invalid credentials
- `NetworkError` - Unable to reach authentication server
- `ValidationError` - Invalid email format or password too short

**Example:**

```typescript
import { AuthService } from './auth';

const auth = new AuthService();

try {
  const session = await auth.login('user@example.com', 'password123');
  console.log('Logged in as:', session.user.name);
} catch (error) {
  if (error instanceof AuthenticationError) {
    console.error('Invalid credentials');
  }
}
```

**Notes:**
- Failed login attempts are logged for security monitoring
- Tokens are stored securely in httpOnly cookies
- Session expires after 24 hours of inactivity

---

#### logout()

Ends the current user session and clears stored credentials.

**Returns:**

`Promise<void>` - Resolves when logout is complete

**Example:**

```typescript
await auth.logout();
console.log('Logged out successfully');
```

---

#### refreshToken()

Refreshes an expired session token without requiring re-authentication.

**Returns:**

`Promise<string>` - New session token

**Throws:**

- `TokenExpiredError` - Refresh token is also expired
- `InvalidTokenError` - Token format is invalid

**Example:**

```typescript
try {
  const newToken = await auth.refreshToken();
  console.log('Token refreshed');
} catch (error) {
  // User must log in again
  await auth.login(email, password);
}
```
```

---

## Example 2: Code Comments

### Context
Adding comments to a data processing function.

### Before (Poor Documentation)

```javascript
function processUserData(users) {
  // Filter out inactive users
  const active = users.filter(u => u.active);

  // Sort by last login
  const sorted = active.sort((a, b) => {
    return new Date(b.lastLogin) - new Date(a.lastLogin);
  });

  // Add score
  const scored = sorted.map(u => {
    // Calculate engagement score
    const score = u.logins * 0.5 + u.posts * 2;
    return { ...u, score };
  });

  return scored;
}
```

### After (Good Documentation)

```javascript
/**
 * Processes user data for analytics dashboard.
 *
 * Filters inactive users, sorts by engagement, and calculates
 * an engagement score based on login frequency and post count.
 *
 * @param users - Array of user objects from database
 * @returns Sorted array with computed engagement scores
 *
 * @example
 * ```ts
 * const processed = processUserData(await User.findAll());
 * displayLeaderboard(processed.slice(0, 10));
 * ```
 */
function processUserData(users) {
  // Exclude inactive users to focus on engaged community members
  const active = users.filter(u => u.active);

  // Sort by most recent login to prioritize recently active users
  const sorted = active.sort((a, b) => {
    return new Date(b.lastLogin) - new Date(a.lastLogin);
  });

  // Engagement formula: weighted sum of logins (0.5) and posts (2.0)
  // Posts weighted higher as they indicate more meaningful engagement
  const scored = sorted.map(u => {
    const score = u.logins * 0.5 + u.posts * 2;
    return { ...u, score };
  });

  return scored;
}
```

---

## Example 3: README Documentation

### Context
Creating a README for an npm package.

### Documentation

```markdown
# react-form-validator

A lightweight, type-safe form validation library for React applications.

## Features

- Declarative validation rules
- TypeScript support with full type inference
- Zero dependencies
- Custom validator support
- Async validation

## Installation

```bash
npm install react-form-validator
# or
yarn add react-form-validator
```

## Quick Start

```tsx
import { useForm, validate } from 'react-form-validator';

function LoginForm() {
  const { register, handleSubmit, errors } = useForm({
    email: {
      required: 'Email is required',
      pattern: {
        value: /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i,
        message: 'Invalid email address'
      }
    },
    password: {
      required: 'Password is required',
      minLength: {
        value: 8,
        message: 'Password must be at least 8 characters'
      }
    }
  });

  const onSubmit = (data) => {
    console.log(data);
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <input {...register('email')} />
      {errors.email && <span>{errors.email.message}</span>}

      <input type="password" {...register('password')} />
      {errors.password && <span>{errors.password.message}</span>}

      <button type="submit">Submit</button>
    </form>
  );
}
```

## API Reference

### useForm

Hook for managing form state and validation.

```typescript
useForm(schema: ValidationSchema): FormContext
```

### validate

Utility function for one-time validation.

```typescript
validate(data: unknown, schema: ValidationSchema): ValidationResult
```

See full API documentation at [docs.example.com](https://docs.example.com).

## Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) before submitting PRs.

## License

MIT
```

---

## Example 4: Architecture Documentation

### Context
Documenting a microservices architecture.

### Documentation

```markdown
# Payment Service Architecture

## Overview

The payment service handles all payment processing, including credit card transactions, refunds, and payment method management.

## System Architecture

```
                     ┌─────────────┐
                     │   API GW    │
                     └──────┬──────┘
                            │
                     ┌──────▼──────┐
                     │ Payment API │ ◄──────┐
                     └──────┬──────┘        │
                            │               │
                ┌───────────┼───────────┐   │
                │           │           │   │
        ┌───────▼────┐ ┌───▼────┐ ┌───▼────▼────┐
        │ Card Store │ │ Stripe │ │   Database  │
        │  (Redis)  │ │  API   │ │ PostgreSQL  │
        └───────────┘ └────────┘ └─────────────┘
```

## Components

### Payment API
- **Purpose**: HTTP API for payment operations
- **Tech**: Node.js, Express
- **Port**: 3001

### Card Store
- **Purpose**: Cache payment tokens for quick reuse
- **Tech**: Redis
- **TTL**: 24 hours

### Stripe Integration
- **Purpose**: Payment processor
- **API Version**: 2023-10-16
- **Webhooks**: /api/webhooks/stripe

### Database
- **Purpose**: Persistent payment records
- **Tech**: PostgreSQL 15
- **Tables**: payments, payment_methods, refunds

## Data Flow

### Payment Processing Flow

1. Client sends payment request to API Gateway
2. API Gateway routes to Payment API
3. Payment API checks Card Store for existing token
4. If token exists: use cached token
5. If not: tokenize card via Stripe API
6. Create charge via Stripe API
7. Save payment record to Database
8. Cache token in Card Store
9. Return success response to client

## Error Handling

| Error Type | Handling | Retry |
|------------|----------|-------|
| Network Error | Exponential backoff | Yes (3x) |
| Card Declined | Return to user | No |
| Invalid Amount | Validation error | No |
| Stripe Timeout | Queue for retry | Yes (5x) |

## Security

- All card data handled via Stripe (PCI compliance)
- Tokens stored in encrypted Redis
- API authentication via JWT
- Webhook signatures verified

## Monitoring

- Metrics: Prometheus (port 9090)
- Logs: ELK Stack
- Alerts: PagerDuty for payment failures > 1%

## Deployment

- **Environment**: Kubernetes
- **Replicas**: 3 (auto-scaling up to 10)
- **Health Check**: /health
- **Graceful Shutdown**: 30 second drain
```

---

## Example 5: Library Function Documentation

### Context
Documenting a utility function for date handling.

### Documentation

```markdown
## formatRelativeTime

Formats a date as a relative time string (e.g., "5 minutes ago").

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `date` | `Date \| string \| number` | Yes | The date to format |
| `baseDate` | `Date \| string \| number` | No | Reference date. Default: current time |
| `locale` | `string` | No | Locale for translations. Default: `"en"` |

### Returns

`string` - Relative time representation

### Examples

```typescript
// Recent times
formatRelativeTime(new Date(Date.now() - 300000));
// Returns: "5 minutes ago"

formatRelativeTime(new Date(Date.now() - 3600000));
// Returns: "1 hour ago"

// Future times
formatRelativeTime(new Date(Date.now() + 86400000));
// Returns: "in 1 day"

// Custom base date
formatRelativeTime('2024-01-15', '2024-01-01');
// Returns: "14 days ago"

// Different locale
formatRelativeTime(new Date(Date.now() - 3600000), new Date(), 'es');
// Returns: "hace 1 hora"
```

### Notes

- Times less than 1 minute return "just now"
- Times greater than 1 year return absolute date
- Supports 20+ languages via `locale` parameter
- Handles timezone conversions automatically
```

---

## Example 6: Migration Guide

### Context
Documenting a breaking API change.

> **Why this matters:** Breaking changes can frustrate users and erode trust.
> A well-written migration guide transforms a painful upgrade into a
> smooth transition, showing users you respect their time and investment.
> Good migration docs reduce support burden and demonstrate professionalism.

### Documentation

```markdown
# Migration Guide: v2.0 to v3.0

## Breaking Changes

### 1. Authentication Headers

**Before (v2.0):**
```typescript
headers: {
  'X-API-Key': 'your-key'
}
```

**After (v3.0):**
```typescript
headers: {
  'Authorization': 'Bearer your-key'
}
```

**Migration:** Replace `X-API-Key` with `Authorization: Bearer` prefix.

---

### 2. User Endpoint

**Before (v2.0):**
```typescript
const user = await api.getUser('user-123');
```

**After (v3.0):**
```typescript
const user = await api.users.retrieve('user-123');
```

**Migration:** Update method name and use nested resource objects.

---

### 3. Error Response Format

**Before (v2.0):**
```json
{
  "error": "Invalid request",
  "code": 400
}
```

**After (v3.0):**
```json
{
  "errors": [
    {
      "message": "Invalid request",
      "code": "INVALID_REQUEST",
      "field": "email"
    }
  ]
}
```

**Migration:** Error response is now an array. Access via `errors[0].message`.

---

## Deprecated Features

The following features are deprecated and will be removed in v4.0:

| Feature | Replacement | Removal Version |
|---------|-------------|-----------------|
| `api.oldMethod()` | `api.newMethod()` | v4.0 |
| XML response format | JSON only | v4.0 |

---

## Migration Script

We provide an automated migration tool:

```bash
npx @your-package/migrate-v3
```

This will:
- Update authentication header format
- Rename method calls
- Transform error handling code
- Generate a migration report

---

## Testing Your Migration

After migrating, verify with:

```typescript
import { runHealthCheck } from '@your-package/testing';

const result = await runHealthCheck();
console.log(result.status); // Should be "healthy"
```

---

## Need Help?

- Documentation: [docs.example.com](https://docs.example.com)
- Support: support@example.com
- Issues: [GitHub Issues](https://github.com/your-package/issues)
```

---

## Key Takeaways

1. **Be specific** - Include concrete examples for every API
2. **Document errors** - List all possible error conditions
3. **Test your examples** - Code samples should be runnable
4. **Think about the user** - What do they need to know?
5. **Keep it updated** - Outdated docs are worse than no docs
