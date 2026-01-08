# Logging Helper Skill

> Add structured, meaningful logging to code following best practices for observability and debugging.

## Overview

This skill helps you implement proper logging in your applications. Good logging is essential for:
- **Debugging** - Quickly identify issues in production
- **Observability** - Understand system behavior and performance
- **Audit trails** - Track user actions and system events
- **Compliance** - Meet regulatory requirements

## Quick Start

When using Claude Code, simply ask for help with logging:

```
Add logging to this function
```

```
Help me set up logging for my Node.js app
```

```
Review and improve the logging in this module
```

Claude will use this skill to add structured logging following best practices.

## Supported Languages

| Language | Recommended Library |
|----------|---------------------|
| JavaScript/Node.js | winston, pino |
| Python | structlog, standard logging |
| Go | logrus, zap |
| Rust | tracing, slog |
| Java | SLF4J + Logback |

## Log Levels Explained

```
FATAL → Application cannot continue
ERROR  → Error occurred, but app continues
WARN   → Unexpected situation, handled gracefully
INFO   → Normal, significant events
DEBUG  → Detailed diagnostic information
TRACE  → Extremely detailed, usually disabled
```

## Usage Examples

### JavaScript (Node.js)

**Request:**
```
Add logging to this user authentication function
```

**Generated Code:**
```javascript
const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [new winston.transports.Console()]
});

async function authenticateUser(email, password) {
  logger.debug('Authentication attempt', { email });

  const user = await db.users.findOne({ email });
  if (!user) {
    logger.warn('Authentication failed', { email, reason: 'user_not_found' });
    throw new AuthError('Invalid credentials');
  }

  const isValid = await bcrypt.compare(password, user.passwordHash);
  if (!isValid) {
    logger.warn('Authentication failed', { email, user_id: user.id, reason: 'invalid_password' });
    throw new AuthError('Invalid credentials');
  }

  logger.info('User authenticated', { user_id: user.id, email });
  return user;
}
```

### Python

**Request:**
```
Add structured logging to this API handler
```

**Generated Code:**
```python
import structlog

logger = structlog.get_logger()

@app.post("/api/users")
async def create_user(user_data: UserCreate):
    logger.info("user_creation_started", email=user_data.email)

    try:
        user = await db.create_user(user_data)
        logger.info("user_created", user_id=user.id, email=user.email)
        return user
    except ValidationError as e:
        logger.warning("user_creation_failed",
                       email=user_data.email,
                       error=str(e))
        raise
    except Exception as e:
        logger.error("user_creation_error",
                     email=user_data.email,
                     error=str(e),
                     error_type=type(e).__name__)
        raise
```

## What Gets Logged

Generated logging typically includes:

- **Entry/exit logs** for significant functions
- **Error context** with stack traces and relevant data
- **Performance metrics** (duration, records processed)
- **Business events** (user actions, state changes)
- **Request tracking** (request IDs, correlation IDs)

## Structured Logging

Structured logging uses key-value pairs for better filtering and analysis:

```javascript
// Instead of:
logger.info(`User ${userId} logged in from ${ip} at ${time}`);

// Use:
logger.info({
  event: "user_login",
  user_id: userId,
  ip_address: ip,
  timestamp: time
});
```

Benefits:
- Machine-parseable for log aggregators
- Easy to filter and query
- Consistent field names
- Better for analysis

## Further Documentation

See [SKILL.md](./SKILL.md) for:
- Complete logging framework
- Security considerations
- Configuration options
- Language-specific patterns

## License

MIT
