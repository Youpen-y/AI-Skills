---
name: logging-helper
description: Add structured logging to code. Use when user wants to add logging, improve existing logs, set up logging infrastructure, or asks about logging best practices.
---

# Logging Helper

Add structured, meaningful logging to code following best practices for observability and debugging.

## When to Use

- User wants to add logging to their code
- User asks "how do I log this?"
- User wants to improve existing logging
- User needs to set up logging infrastructure
- User types `/log` or similar

## Logging Best Practices

### Log Levels

Use appropriate log levels to indicate severity:

| Level | Purpose | Example |
|-------|---------|---------|
| **TRACE** | Most detailed, usually disabled | Function entry/exit with params |
| **DEBUG** | Detailed diagnosis | Loop iterations, variable states |
| **INFO** | Normal, significant events | Application started, user logged in |
| **WARN** | Unexpected but recoverable | Retry attempt, fallback used |
| **ERROR** | Error but app continues | Failed API call with retry |
| **FATAL** | Critical, app may crash | Database connection lost |

### What to Log

Follow the **5 Ws of Logging**:

1. **WHAT** - What happened? (event/action)
2. **WHEN** - Timestamp (usually automatic)
3. **WHERE** - Source location (file, function, line)
4. **WHO** - User ID, request ID, session ID
5. **WHY** - Context, error messages, stack traces

### Structured Logging

Use structured formats (JSON) for machine parsing:

```javascript
// Bad: Unstructured
logger.info("User logged in: user_123 from 192.168.1.1");

// Good: Structured
logger.info({
  event: "user_login",
  user_id: "user_123",
  ip_address: "192.168.1.1",
  timestamp: "2025-01-08T10:30:00Z"
});
```

## Language-Specific Implementations

### JavaScript/Node.js

```javascript
// Using winston
const winston = require('winston');

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  transports: [
    new winston.transports.Console(),
    new winston.transports.File({ filename: 'app.log' })
  ]
});

// Usage
logger.info('User login', { user_id: 123, ip: '10.0.0.1' });
logger.error('Database error', { error: err.message, code: err.code });
```

### Python

```python
# Using structlog
import structlog

logger = structlog.get_logger()

# Usage
logger.info("user_login", user_id=123, ip="10.0.0.1")
logger.error("database_error", error=str(err), code=err.code)

# Standard library logging
import logging

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

logger = logging.getLogger(__name__)
logger.info("User %s logged in from %s", user_id, ip)
```

### Go

```go
// Using logrus
import "github.com/sirupsen/logrus"

logger := logrus.New()
logger.SetFormatter(&logrus.JSONFormatter{})

// Usage
logger.WithFields(logrus.Fields{
  "user_id": 123,
  "ip":      "10.0.0.1",
}).Info("User login")

logger.WithError(err).WithField("code", err.Code).Error("Database error")
```

### Rust

```rust
// Using tracing
use tracing::{info, error, instrument};
use tracing_subscriber;

#[instrument]
async fn process_user(user_id: u64) -> Result<(), Error> {
    info!(user_id, "Processing user");
    // ...
}

// Initialize
tracing_subscriber::fmt::init();
```

### Java

```java
// Using SLF4J with Logback
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

private static final Logger logger = LoggerFactory.getLogger(MyClass.class);

// Usage
logger.info("User login: userId={}, ip={}", userId, ip);
logger.error("Database error: {}", err.getMessage(), err);
```

## Common Logging Patterns

### Request/Response Logging

```javascript
logger.info({
  event: "api_request",
  method: "POST",
  path: "/api/users",
  request_id: "req_abc123",
  user_id: 123,
  duration_ms: 45
});
```

### Error Logging with Context

```javascript
logger.error({
  event: "payment_failed",
  user_id: 123,
  amount: 99.99,
  error: err.message,
  stack: err.stack,
  payment_gateway: "stripe",
  retry_count: 3
});
```

### Performance Logging

```javascript
const startTime = Date.now();
// ... operation ...
logger.info({
  event: "operation_completed",
  operation: "process_order",
  duration_ms: Date.now() - startTime,
  records_processed: 1000
});
```

## Logging Checklist

When adding logging, ensure:

- [ ] Appropriate log level used
- [ ] Structured format for key-value data
- [ ] No sensitive data (passwords, tokens, PII)
- [ ] Request/correlation IDs included
- [ ] Error messages include actionable context
- [ ] Performance metrics where relevant
- [ ] Consistent field names across codebase

## Security Considerations

**Never log sensitive information:**
- Passwords (even hashed)
- API keys or secrets
- Credit card numbers
- Personal identification (SSN, passport)
- Session tokens
- Private user data

```javascript
// Bad
logger.info({ user: { email, password, ssn } });

// Good
logger.info({
  user_id: user.id,
  has_email: !!user.email,
  has_password: !!user.password_hash
});
```

## Configuration

Environment-based log levels:

```javascript
const level = process.env.NODE_ENV === 'production' ? 'info' : 'debug';
const level = process.env.LOG_LEVEL || 'info';
```

Log rotation to prevent disk issues:

```javascript
new winston.transports.File({
  filename: 'app.log',
  maxsize: 10 * 1024 * 1024, // 10MB
  maxFiles: 5
});
```

## Response Template

```
## Logging Analysis

[Assess current logging situation]

## Recommended Log Points

1. [Location 1]: Log [what] at [level]
2. [Location 2]: Log [what] at [level]

## Implementation

[Code examples for the specific language]

## Configuration

[Setup instructions for logging infrastructure]
```

---

**Need more?** See `reference.md` for detailed logging strategies.
