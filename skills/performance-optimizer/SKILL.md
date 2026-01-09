---
name: performance-optimizer
description: Optimize code performance and reduce bottlenecks. Use when code is slow, needs profiling, has memory issues, or user asks about performance optimization.
---

# Performance Optimizer

Identify and resolve performance bottlenecks in code through systematic analysis and optimization techniques.

## When to Use

- Code runs slowly or has high latency
- Application consumes too much memory
- Database queries are slow
- User wants to profile or benchmark code
- User types `/perf`, `/optimize`, or similar

## Performance Optimization Framework

### 1. Measure First

**Don't optimize without measuring.** Use profiling tools to identify actual bottlenecks.

```javascript
// Node.js - built-in profiler
node --prof app.js
node --prof-process isolate-0xnnnnnnnnnnnn-v8.log > processed.txt

// Chrome DevTools for browser
performance.mark('start');
// ... code ...
performance.mark('end');
performance.measure('operation', 'start', 'end');
```

```python
# Python - cProfile
import cProfile
import pstats

profiler = cProfile.Profile()
profiler.enable()
# ... code ...
profiler.disable()
stats = pstats.Stats(profiler)
stats.sort_stats('cumulative').print_stats(20)
```

### 2. Common Bottlenecks

| Category | Typical Issues | Detection |
|----------|---------------|-----------|
| **CPU** | Inefficient algorithms, nested loops | High CPU usage |
| **Memory** | Memory leaks, large objects | OOM, high RSS |
| **I/O** | Slow disk, network calls | High wait time |
| **Database** | N+1 queries, missing indexes | Slow queries |
| **Network** | Round trips, large payloads | High latency |

### 3. Optimization Strategies

#### Algorithm Optimization

**O(n²) → O(n) or O(log n)**

```javascript
// Bad: O(n²) - nested loop
function findDuplicates(arr) {
  const duplicates = [];
  for (let i = 0; i < arr.length; i++) {
    for (let j = i + 1; j < arr.length; j++) {
      if (arr[i] === arr[j]) duplicates.push(arr[i]);
    }
  }
  return duplicates;
}

// Good: O(n) - using Set
function findDuplicates(arr) {
  const seen = new Set();
  const duplicates = new Set();
  for (const item of arr) {
    if (seen.has(item)) {
      duplicates.add(item);
    } else {
      seen.add(item);
    }
  }
  return Array.from(duplicates);
}
```

#### Caching

```javascript
// Memoization for expensive functions
const memo = new Map();

function expensiveOperation(n) {
  if (memo.has(n)) return memo.get(n);

  const result = // ... expensive computation ...
  memo.set(n, result);
  return result;
}

// Or use LRU cache
import LRU from 'lru-cache';
const cache = new LRU({ max: 1000 });
```

```python
# Python functools
from functools import lru_cache

@lru_cache(maxsize=128)
def fibonacci(n):
    if n < 2:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)
```

#### Database Optimization

```sql
-- Bad: N+1 query problem
-- First query gets users, then N queries for each user's posts

-- Good: Use JOIN
SELECT u.*, p.*
FROM users u
LEFT JOIN posts p ON u.id = p.user_id;

-- Better: Pagination + specific fields
SELECT u.id, u.name, COUNT(p.id) as post_count
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
GROUP BY u.id
LIMIT 20 OFFSET 0;
```

```javascript
// Bad: Query in loop
for (const userId of userIds) {
  const user = await db.query('SELECT * FROM users WHERE id = ?', [userId]);
}

// Good: Single query with IN clause
const users = await db.query(
  'SELECT * FROM users WHERE id IN (?)',
  [userIds]
);
```

#### Asynchronous Operations

```javascript
// Bad: Sequential async operations
for (const url of urls) {
  await fetch(url);
}

// Good: Parallel operations
await Promise.all(urls.map(url => fetch(url)));

// With concurrency limit
import pLimit from 'p-limit';
const limit = pLimit(10); // Max 10 concurrent
await Promise.all(urls.map(url => limit(() => fetch(url))));
```

#### Batch Processing

```javascript
// Bad: Process one by one
for (const item of items) {
  await processItem(item);
}

// Good: Batch processing
const BATCH_SIZE = 100;
for (let i = 0; i < items.length; i += BATCH_SIZE) {
  const batch = items.slice(i, i + BATCH_SIZE);
  await processBatch(batch);
}
```

### 4. Memory Optimization

#### Avoid Memory Leaks

```javascript
// Bad: Event listeners not removed
button.addEventListener('click', handler);
// If button is removed but listener remains → leak

// Good: Clean up
const handler = () => { /* ... */ };
button.addEventListener('click', handler);
// Later:
button.removeEventListener('click', handler);
```

```javascript
// Bad: Growing cache without limit
const cache = new Map();
function getData(key) {
  if (!cache.has(key)) {
    cache.set(key, fetchHeavyData(key));
  }
  return cache.get(key);
}

// Good: LRU cache with size limit
import LRU from 'lru-cache';
const cache = new LRU({ max: 1000, ttl: 1000 * 60 * 5 });
```

#### Efficient Data Structures

```javascript
// Bad: Array for lookups
const users = [{id: 1, name: 'Alice'}, {id: 2, name: 'Bob'}];
function findUser(id) {
  return users.find(u => u.id === id); // O(n)
}

// Good: Map for lookups
const userMap = new Map([[1, {name: 'Alice'}], [2, {name: 'Bob'}]]);
function findUser(id) {
  return userMap.get(id); // O(1)
}
```

### 5. Network Optimization

#### Reduce Payload Size

```javascript
// Bad: Send everything
const user = await db.getUser(userId);
res.json(user);

// Good: Select only needed fields
const user = await db.getUser(userId, {fields: ['id', 'name', 'email']});
res.json(user);

// Even better: Compression
import compression from 'compression';
app.use(compression());
```

#### Use CDN for Static Assets

```javascript
// Bad: Serve from your server
app.use(express.static('public'));

// Good: Use CDN
// Static assets served from https://cdn.example.com/
```

### 6. Language-Specific Optimizations

#### JavaScript/Node.js

```javascript
// Use streams for large files
const fs = require('fs');
const pipeline = require('util').promisify(require('stream').pipeline);

await pipeline(
  fs.createReadStream('large-file.txt'),
  transformStream,
  fs.createWriteStream('output.txt')
);

// Avoid blocking event loop
// Bad: CPU-intensive computation
function processData(data) {
  for (let i = 0; i < data.length; i++) {
    // Heavy computation
  }
}

// Good: Worker threads
const { Worker } = require('worker_threads');
const worker = new Worker('./processor.js', { workerData: data });
```

#### Python

```python
# Use generators for large datasets
def process_large_file(filename):
    with open(filename) as f:
        for line in f:  # Generator, not loading all into memory
            yield process_line(line)

# Use __slots__ to reduce memory
class User:
    __slots__ = ['id', 'name', 'email']  # No __dict__, less memory
    def __init__(self, id, name, email):
        self.id = id
        self.name = name
        self.email = email

# Use built-in functions instead of loops
# Bad: Creates entire list in memory first (~8MB)
#       sum([x * 2 for x in range(1000000)])

# Good: Generator expression - processes one item at a time (~0 bytes)
#       sum(x * 2 for x in range(1000000))

# Use asyncio for I/O-bound concurrency
import asyncio

async def fetch_all(urls):
    # Bad: Sequential requests
    # results = []
    # for url in urls:
    #     results.append(await fetch_url(url))

    # Good: Parallel I/O with asyncio.gather
    tasks = [fetch_url(url) for url in urls]
    results = await asyncio.gather(*tasks)
    return results

# With concurrency limit
async def fetch_all_limited(urls, limit=10):
    semaphore = asyncio.Semaphore(limit)

    async def bounded_fetch(url):
        async with semaphore:
            return await fetch_url(url)

    tasks = [bounded_fetch(url) for url in urls]
    results = await asyncio.gather(*tasks)
    return results
```

## Performance Checklist

Before optimizing, verify:

- [ ] Profiled to identify actual bottleneck
- [ ] Measured baseline metrics
- [ ] Set optimization target
- [ ] Tested after optimization
- [ ] Not prematurely optimizing
- [ ] Code remains readable
- [ ] Trade-offs are acceptable

## Common Anti-Patterns

| Anti-Pattern | Solution |
|-------------|----------|
| Premature optimization | Measure first, optimize hot paths |
| Micro-optimizations | Focus on algorithms, not syntax |
| Caching everything | Cache strategically, invalidate properly |
| Parallelizing everything | Parallelism has overhead; use wisely |
| Ignoring memory vs CPU trade-off | Choose based on constraints |

## Response Template

```
## Performance Analysis

[Bottleneck identified with evidence]

## Optimization Plan

1. [Strategy 1]: [Expected improvement]
2. [Strategy 2]: [Expected improvement]

## Implementation

[Code changes]

## Before/After Metrics

| Metric | Before | After |
|--------|--------|-------|
| [Latency] | [X ms] | [Y ms] |
| [Memory] | [X MB] | [Y MB] |
```

---
