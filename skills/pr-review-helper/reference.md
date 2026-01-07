# PR Review Reference

Comprehensive reference guide for conducting Pull Request reviews.

## Table of Contents

1. [Review Process](#review-process)
2. [Issue Categories](#issue-categories)
3. [Code Patterns](#code-patterns)
4. [Language-Specific Guidelines](#language-specific-guidelines)
5. [Security Checklist](#security-checklist)
6. [Performance Checklist](#performance-checklist)

---

## Review Process

### Step 1: Preparation

1. **Read the PR description** - Understand the purpose and context
2. **Check linked issues** - Review related tickets/discussions
3. **View files changed** - Get an overview of scope
4. **Run locally** (if applicable) - Verify the changes work

### Step 2: First Pass

- **Read for understanding** - Don't comment yet, just understand
- **Note major concerns** - Keep track of big issues
- **Identify strengths** - Note what's done well

### Step 3: Detailed Review

- **Line-by-line review** - Now add specific comments
- **Check edge cases** - What happens with null, empty, error?
- **Verify tests** - Are they adequate and correct?

### Step 4: Synthesis

- **Organize feedback** - Group related comments
- **Prioritize issues** - Critical, high, medium, low
- **Write summary** - Overall assessment and next steps

---

## Issue Categories

### Correctness

| Issue | Example | Location Pattern |
|-------|---------|------------------|
| Off-by-one errors | `for (i = 0; i <= arr.length)` | Loops, array access |
| Null/undefined | No null check before access | Object property access |
| Type mismatches | String used as number | Type boundaries |
| Race conditions | Missing await | Async operations |

### Security

| Issue | Example | Severity |
|-------|---------|----------|
| SQL Injection | Unsanitized input in query | Critical |
| XSS | Unescaped user input in HTML | Critical |
| CSRF | No token on state-changing requests | High |
| Hardcoded secrets | API keys in code | Critical |
| Weak crypto | MD5 for passwords | Critical |

### Performance

| Issue | Example | Impact |
|-------|---------|--------|
| N+1 queries | Query inside loop | High |
| Missing index | Slow database queries | High |
| Unnecessary re-renders | Missing memoization | Medium |
| Memory leaks | Unclosed connections | High |
| Inefficient algorithm | O(n²) where O(n) possible | Medium |

### Maintainability

| Issue | Example | Impact |
|-------|---------|--------|
| Long functions | 100+ line function | Medium |
| Deep nesting | 4+ levels deep | Low |
| Magic numbers | Unnamed constants | Low |
| Code duplication | Copy-pasted logic | Medium |
| Poor naming | `tmp`, `data`, `handle` | Low |

---

## Code Patterns

### Good Patterns

#### Early Return
```javascript
// Good
function processUser(user) {
  if (!user) return null;
  if (!user.isActive) return null;
  return transform(user);
}

// Avoid
function processUser(user) {
  if (user) {
    if (user.isActive) {
      return transform(user);
    }
  }
  return null;
}
```

#### Guard Clauses
```javascript
// Good
function divide(a, b) {
  if (b === 0) throw new Error("Division by zero");
  return a / b;
}
```

#### Destructuring
```javascript
// Good
const { name, email } = user;

// Verbose
const name = user.name;
const email = user.email;
```

### Bad Patterns

#### Magic Numbers
```javascript
// Bad
setTimeout(callback, 86400000);

// Good
const DAY_IN_MS = 86400000;
setTimeout(callback, DAY_IN_MS);
```

#### Nested Ternary
```javascript
// Bad - hard to read
const result = a > 0 ? (b > 0 ? "both" : "a") : "none";

// Good
if (a > 0 && b > 0) return "both";
if (a > 0) return "a";
return "none";
```

#### Primitive Obsession
```javascript
// Bad
function createOrder(customerId, amount, status) { ... }

// Good
function createOrder(customer, amount, status) { ... }
// Where customer is a Customer object, not an ID
```

---

## Language-Specific Guidelines

### JavaScript/TypeScript

#### Async/Await
```typescript
// Good - proper error handling
async function fetchUser(id: string) {
  try {
    const response = await fetch(`/api/users/${id}`);
    if (!response.ok) throw new Error("Not found");
    return await response.json();
  } catch (error) {
    logger.error("Failed to fetch user", error);
    throw error;
  }
}
```

#### Type Safety
```typescript
// Good - discriminated unions
type Result<T, E> =
  | { success: true; data: T }
  | { success: false; error: E };

function handleResult(result: Result<User, Error>) {
  if (result.success) {
    console.log(result.data.name); // Type-safe!
  }
}
```

### Python

#### Context Managers
```python
# Good - automatic cleanup
with open("file.txt") as f:
    data = f.read()

# Bad - manual cleanup required
f = open("file.txt")
data = f.read()
f.close()
```

#### Type Hints
```python
# Good
def process_items(items: list[str]) -> dict[str, int]:
    return {item: len(item) for item in items}
```

### Go

#### Error Handling
```go
// Good - always check errors
file, err := os.Open("file.txt")
if err != nil {
    return fmt.Errorf("failed to open file: %w", err)
}
defer file.Close()
```

---

## Security Checklist

### Input Validation
- [ ] All user input is validated
- [ ] Type checking on input boundaries
- [ ] Length limits enforced
- [ ] Allow-list validation (not block-list)

### Output Encoding
- [ ] HTML output is escaped
- [ ] JSON output is properly encoded
- [ ] SQL queries use parameterized statements
- [ ] Command arguments are escaped

### Authentication
- [ ] Passwords are hashed (bcrypt/argon2)
- [ ] Sessions use httpOnly cookies
- [ ] CSRF tokens on state changes
- [ ] Rate limiting on auth endpoints

### Authorization
- [ ] Every endpoint checks permissions
- [ ] Least privilege principle
- [ ] No hidden admin endpoints

### Secrets Management
- [ ] No secrets in code
- [ ] Environment variables for config
- [ ] Secrets encrypted at rest
- [ ] Key rotation strategy

---

## Performance Checklist

### Database
- [ ] Indexes on query columns
- [ ] No N+1 queries
- [ ] Pagination on large result sets
- [ ] Connection pooling configured

### API
- [ ] Response compression enabled
- [ ] Caching headers set
- [ ] Batch operations available
- [ ] Rate limiting configured

### Frontend
- [ ] Images optimized
- [ ] Code splitting implemented
- [ ] Lazy loading for images/components
- [ ] Memoization for expensive computations

### Algorithms
- [ ] Time complexity considered
- [ ] Space complexity considered
- [ ] Appropriate data structures used

---

## Quick Reference

### Git Diff Syntax
- `file.ts:42` - Line 42
- `file.ts:42-56` - Lines 42-56
- `file.ts` - Entire file

### Severity Levels
- **Critical** - Security vulnerabilities, data loss
- **High** - Breaking changes, major bugs
- **Medium** - Code smells, minor bugs
- **Low** - Style, naming, optimization

### Review Outcomes
- **LGTM** - Looks Good To Me (approve)
- **Approve with Changes** - Merge after fixes
- **Request Changes** - Needs more work
- **Comment** - Non-blocking feedback

### Common Acronyms
- **LGTM** - Looks Good To Me
- **WIP** - Work In Progress
- **TBR** - To Be Reviewed
- **PTAL** - Please Take A Look
- **SSIA** - Subject Says It All
