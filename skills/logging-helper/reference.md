# Logging Reference Guide

Comprehensive guide to logging best practices, patterns, and strategies.

## Table of Contents

- [Core Principles](#core-principles)
- [Log Level Guidelines](#log-level-guidelines)
- [Structured Logging](#structured-logging)
- [Context Propagation](#context-propagation)
- [Security and Privacy](#security-and-privacy)
- [Performance Considerations](#performance-considerations)
- [Log Aggregation and Analysis](#log-aggregation-and-analysis)
- [Anti-Patterns](#anti-patterns)

---

## Core Principles

### 1. Log for Humans and Machines

Logs serve two audiences:
- **Humans**: Need readable, meaningful messages for debugging
- **Machines**: Need structured data for analysis and alerting

```javascript
// Good: Both readable and parseable
logger.info({
  message: "User payment processed",
  event: "payment_completed",
  user_id: 123,
  amount: 99.99,
  currency: "USD"
});

// Bad: Only readable
logger.info("User 123 paid 99.99 USD");

// Bad: Only parseable
logger.info({ e: "pc", uid: 123, a: 99.99, c: "USD" });
```

### 2. The Five Ws of Logging

Every significant log should answer:

| W | Question | Example Field |
|---|----------|---------------|
| **What** | What happened? | `event: "user_login"` |
| **When** | When did it happen? | `timestamp: "2025-01-08T10:30:00Z"` |
| **Where** | Where in the code? | `module: "auth.service"`, `line: 42` |
| **Who** | Who triggered it? | `user_id: 123`, `request_id: "abc-123"` |
| **Why** | Why did it happen? | `reason: "invalid_credentials"` |

### 3. Semantic Log Levels

Use log levels consistently:

```
FATAL → Application must terminate
ERROR  → Action failed, system degraded
WARN   → Unexpected but handled
INFO   → Normal business events
DEBUG  → Detailed diagnostics
TRACE  → Extremely verbose details
```

**Production recommendation:** Log at INFO level by default. DEBUG/TRACE should be opt-in.

---

## Log Level Guidelines

### When to Use Each Level

#### FATAL
Application cannot continue operating:
- Database connection lost with no recovery
- Critical configuration missing
- Out of memory with no heap available
- Security breach detected

```python
logger.critical("database_connection_lost", error=str(e))
# Application should exit after this log
```

#### ERROR
Action failed but application can continue:
- API call failed after retries
- Database query timeout
- File write permission denied
- Unhandled exception in request handler

```javascript
logger.error({
  event: "api_call_failed",
  endpoint: "/api/payment",
  error: err.message,
  attempts: 3,
  will_retry: false
});
```

#### WARN
Unexpected but handled situations:
- Fallback to default value
- Deprecated API used
- High latency detected
- Retry attempt made

```javascript
logger.warn({
  event: "cache_miss",
  key: "user:123",
  fallback: "database",
  latency_ms: 500
});
```

#### INFO
Normal business events:
- User actions (login, logout, purchase)
- State changes (order created, payment processed)
- System events (server started, job queued)
- Milestones (batch processing 50% complete)

```javascript
logger.info({
  event: "order_created",
  order_id: 999,
  user_id: 123,
  total: 199.99
});
```

#### DEBUG
Detailed diagnostic information:
- Function parameters and return values
- Loop iterations (for small loops)
- Conditional branch taken
- Variable state at key points

```javascript
logger.debug({
  event: "fetching_user",
  user_id: 123,
  cache_enabled: true
});
```

#### TRACE
Extremely detailed execution flow:
- Every function entry/exit
- Each iteration of large loops
- Network request/response details
- SQL query execution plans

```javascript
logger.trace({
  event: "function_entered",
  function: "processOrder",
  params: { orderId: 999 }
});
```

---

## Structured Logging

### Benefits Over Unstructured Logging

| Aspect | Unstructured | Structured |
|--------|-------------|------------|
| Searching | Text grep | Field queries |
| Filtering | String matching | Boolean logic |
| Aggregation | Regex parsing | Native JSON |
| Alerting | Pattern matching | Threshold rules |
| Analysis | Difficult | Easy |

### Field Naming Conventions

Use consistent, snake_case field names:

```javascript
// Good: Consistent naming
logger.info({
  event: "user_login",
  user_id: 123,
  ip_address: "10.0.0.1",
  timestamp: "2025-01-08T10:30:00Z",
  request_id: "abc-123"
});

// Bad: Inconsistent
logger.info({
  event: "user_login",
  userId: 123,           // camelCase
  ipAddress: "10.0.0.1", // camelCase
  time: "2025-01-08T10:30:00Z", // inconsistent name
  reqid: "abc-123"       // abbreviation
});
```

### Standard Fields

| Field | Type | Description |
|-------|------|-------------|
| `event` | string | Event name (e.g., `user_login`) |
| `timestamp` | ISO8601 | Event timestamp |
| `level` | string | Log level |
| `request_id` | string | Request/correlation ID |
| `user_id` | string/int | User identifier |
| `error` | string | Error message |
| `error_code` | string | Machine-readable error code |
| `duration_ms` | number | Duration in milliseconds |

---

## Context Propagation

### Request/Correlation IDs

Propagate identifiers through the entire request chain:

```javascript
import { v4 as uuidv4 } from 'uuid';

// Middleware
app.use((req, res, next) => {
  req.id = req.headers['x-request-id'] || uuidv4();
  res.setHeader('x-request-id', req.id);

  // Add to all logs in this request
  logger.defaultContext = { request_id: req.id };

  next();
});

// Usage in handlers
app.get('/api/users', async (req, res) => {
  logger.info('fetching_users', { request_id: req.id });
  // All logs now include request_id
});
```

### Distributed Tracing

For microservices, use distributed tracing:

```javascript
const { trace } = require('@opentelemetry/api');

app.get('/api/orders', async (req, res) => {
  const span = trace.getActiveSpan();
  const traceId = span.spanContext().traceId;

  logger.info('processing_order', {
    trace_id: traceId,
    span_id: span.spanContext().spanId
  });
});
```

---

## Security and Privacy

### What NOT to Log

**Never log:**
- Passwords (even hashed)
- API keys or secrets
- Session tokens
- Credit card numbers (PAN)
- SSN or national IDs
- Private medical data
- Encryption keys

```javascript
// Bad
logger.info({
  event: "user_created",
  email: user.email,
  password: user.password_hash,  // NEVER
  ssn: user.ssn,                 // NEVER
  api_key: user.api_key          // NEVER
});

// Good
logger.info({
  event: "user_created",
  user_id: user.id,
  has_email: !!user.email,
  has_password_hash: !!user.password_hash,
  ssn_provided: !!user.ssn,
  api_key_configured: !!user.api_key
});
```

### Data Sanitization

Create sanitization helpers:

```javascript
function sanitizeUser(user) {
  return {
    id: user.id,
    email: maskEmail(user.email),
    has_password: !!user.password_hash,
    created_at: user.created_at
  };
}

function maskEmail(email) {
  const [local, domain] = email.split('@');
  return `${local[0]}***@${domain}`;
}

// Usage
logger.info('user_login', {
  user: sanitizeUser(user)
});
// Log: { user: { id: 123, email: "j***@example.com", ... } }
```

### Sensitive Operations

Log sensitive operations without exposing data:

```javascript
// Good: Log that validation happened, not the password
logger.info('password_validation', {
  user_id: user.id,
  validation_result: 'success',
  password_strength: 'strong'
});

// Bad: Never log the password
logger.info('password_validation', {
  user_id: user.id,
  password: password  // NEVER!
});
```

---

## Performance Considerations

### Asynchronous Logging

Always use async logging in production:

```javascript
const winston = require('winston');

const logger = winston.createLogger({
  transports: [
    new winston.transports.Console(),
    new winston.transports.File({
      filename: 'app.log',
      // Async write
      handleExceptions: true,
      handleRejections: true
    })
  ],
  // Don't block on logs
  exitOnError: false
});
```

### Conditional Logging

Avoid expensive operations when not needed:

```javascript
// Bad: Always performs expensive operation
logger.debug(`User data: ${JSON.stringify(expensiveUserData)}`);

// Good: Only when needed
if (logger.isDebugEnabled()) {
  logger.debug({ user_data: expensiveUserData });
}
```

### Sampling

For high-volume events, use sampling:

```javascript
let counter = 0;

function logSampled(message, data, rate = 100) {
  if (counter % rate === 0) {
    logger.info(message, {
      ...data,
      sampled: true,
      sample_rate: rate
    });
  }
  counter++;
}

// Use for high-frequency events
for (const item of items) {
  processItem(item);
  logSampled('item_processed', { item_id: item.id });
}
```

### Log Rotation

Prevent disk exhaustion:

```javascript
new winston.transports.File({
  filename: 'app.log',
  maxsize: 10 * 1024 * 1024,  // 10MB
  maxFiles: 5,                 // Keep 5 files
  tailable: true               // Wrap around
})
```

---

## Log Aggregation and Analysis

### Recommended Tools

| Tool | Best For | Cost |
|------|----------|------|
| **ELK Stack** | Full-featured, self-hosted | Free (self-hosted) |
| **Grafana Loki** | Kubernetes, Prometheus | Free |
| **Datadog** | All-in-one monitoring | Paid |
| **CloudWatch** | AWS environments | Pay-per-use |
| **Splunk** | Enterprise logging | Expensive |
| **Papertrail** | Simple, hosted | Paid |
| **Logtail** | Developer-friendly | Freemium |

### Log Formats for Aggregation

Use consistent formats:

```javascript
// Standard JSON format
{
  "timestamp": "2025-01-08T10:30:00Z",
  "level": "info",
  "service": "payment-api",
  "environment": "production",
  "event": "payment_completed",
  "request_id": "abc-123",
  "trace_id": "def-456",
  "user_id": 123,
  "amount": 99.99,
  "currency": "USD",
  "duration_ms": 234
}
```

### Alerting Examples

```javascript
// Based on error rate
if (errorRate > 0.05) {
  alert("High error rate detected");
}

// Based on latency
if (p95Latency > 1000) {
  alert("P95 latency exceeds 1 second");
}

// Based on business metrics
if (paymentFailureRate > 0.01) {
  alert("Payment failure rate above 1%");
}
```

---

## Anti-Patterns

### 1. Logging Without Context

```javascript
// Bad
logger.info("User logged in");

// Good
logger.info({
  event: "user_login",
  user_id: 123,
  method: "oauth",
  provider: "google"
});
```

### 2. Logging at Wrong Level

```javascript
// Bad: INFO for debug data
logger.info(`Debug: ${JSON.stringify(data)}`);

// Good
logger.debug({ data });
```

### 3. Not Logging Errors

```javascript
// Bad: Silent failure
try {
  await riskyOperation();
} catch (err) {
  // Nothing logged
}

// Good
try {
  await riskyOperation();
} catch (err) {
  logger.error('operation_failed', {
    error: err.message,
    stack: err.stack
  });
}
```

### 4. Logging Sensitive Data

```javascript
// Bad
logger.info(`User ${email} logged in with ${password}`);

// Good
logger.info({
  event: "user_login",
  user_id: user.id,
  email_masked: maskEmail(email)
});
```

### 5. Excessive Logging

```javascript
// Bad: Logging every iteration
for (let i = 0; i < 1000000; i++) {
  logger.debug(`Processing item ${i}`);
  processItem(i);
}

// Good: Sample or batch logging
for (let i = 0; i < 1000000; i++) {
  if (i % 10000 === 0) {
    logger.debug({ progress: i, total: 1000000 });
  }
  processItem(i);
}
```

### 6. Not Using Structured Logging

```javascript
// Bad: Hard to parse
logger.info(`Payment of $${amount} ${currency} for order ${orderId}`);

// Good: Easy to query
logger.info({
  event: "payment",
  amount: amount,
  currency: currency,
  order_id: orderId
});
```

---

## Quick Reference Checklist

- [ ] Appropriate log level used
- [ ] Structured format (key-value pairs)
- [ ] Consistent field naming (snake_case)
- [ ] Request/correlation IDs included
- [ ] No sensitive data logged
- [ ] Error context included
- [ ] Performance metrics added
- [ ] Log rotation configured
- [ ] Async logging in production
- [ ] Sampling for high-volume events
