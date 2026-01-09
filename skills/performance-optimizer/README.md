# Performance Optimizer Skill

> Identify and resolve performance bottlenecks through systematic analysis and optimization techniques.

## Overview

This skill helps you optimize code performance by:
- **Profiling** - Identify actual bottlenecks with measurement
- **Optimizing** - Apply proven strategies for common issues
- **Benchmarking** - Measure improvements objectively
- **Best practices** - Language-specific performance patterns

Performance issues fall into these categories:
- **CPU** - Slow algorithms, inefficient computations
- **Memory** - Leaks, high consumption, GC pressure
- **I/O** - Slow disk, database, network operations
- **Database** - N+1 queries, missing indexes
- **Network** - Too many requests, large payloads

## Quick Start

When using Claude Code, ask for performance help:

```
This function is slow, can you optimize it?
```

```
Profile this code and find bottlenecks
```

```
Optimize the database queries in this module
```

```
My memory usage keeps growing, help me find the leak
```

## Supported Languages

| Language | Profiling Tools | Common Issues |
|----------|----------------|---------------|
| JavaScript/Node.js | Chrome DevTools, Node.js profiler | Event loop blocking, memory leaks |
| Python | cProfile, memory_profiler, py-spy | GIL, inefficient data structures |

## Optimization Workflow

```
1. Measure → 2. Identify → 3. Optimize → 4. Verify
   ↑_________5. Repeat if needed____________↑
```

**Golden Rule:** Never optimize without measuring first.

## Common Optimizations

### Algorithm: O(n²) → O(n)

**Before:** Nested loops for duplicate detection
```javascript
function findDuplicates(arr) {
  const dupes = [];
  for (let i = 0; i < arr.length; i++) {
    for (let j = i + 1; j < arr.length; j++) {
      if (arr[i] === arr[j]) dupes.push(arr[i]);
    }
  }
  return dupes;
}
// Time: O(n²), Space: O(n)
```

**After:** Using Set for O(1) lookups
```javascript
function findDuplicates(arr) {
  const seen = new Set();
  const dupes = new Set();
  for (const item of arr) {
    if (seen.has(item)) dupes.add(item);
    else seen.add(item);
  }
  return Array.from(dupes);
}
// Time: O(n), Space: O(n)
```

**Result:** ~100x faster for 10,000 items

### Database: N+1 Query Problem

**Before:** Query + N queries
```javascript
// 1 query for users, then N queries for posts
const users = await db.query('SELECT * FROM users');
for (const user of users) {
  user.posts = await db.query(
    'SELECT * FROM posts WHERE user_id = ?',
    [user.id]
  );
}
// Total queries: 1 + N
```

**After:** Single JOIN query
```javascript
const users = await db.query(`
  SELECT u.*, p.*
  FROM users u
  LEFT JOIN posts p ON u.id = p.user_id
`);
// Then group by user in code
// Total queries: 1
```

**Result:** ~100x faster for 100 users

### Async: Sequential → Parallel

**Before:** Sequential async operations
```javascript
for (const url of urls) {
  await fetch(url);  // Wait for each
}
// Time: sum of all requests
```

**After:** Parallel requests
```javascript
await Promise.all(urls.map(url => fetch(url)));
// Time: max of all requests
```

**Result:** 10 requests, 100ms each → 100ms instead of 1000ms

### Memory: Caching Expensive Operations

**Before:** Recalculate every time
```python
def fibonacci(n):
    if n < 2:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)
# fibonacci(40) = ~3 seconds
```

**After:** Memoization
```python
from functools import lru_cache

@lru_cache(maxsize=128)
def fibonacci(n):
    if n < 2:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)
# fibonacci(40) = ~0.0001 seconds
```

**Result:** ~30,000x faster

## Performance Metrics

### Key Metrics to Track

| Metric | Description | Tool |
|--------|-------------|------|
| **Latency** | Time to complete operation | Stopwatch, profiler |
| **Throughput** | Operations per second | Load tester |
| **Memory** | RAM consumption | Memory profiler |
| **CPU** | Processor usage | Profiler, top |
| **I/O** | Disk/network operations | iostat, strace |

### Setting Targets

Before optimizing, set measurable targets:
- "Reduce API response time from 500ms to < 200ms"
- "Handle 10,000 concurrent users with < 2GB memory"
- "Process 1M records in under 5 minutes"

## Profiling Tools by Language

### JavaScript/Node.js

```bash
# CPU profiling
node --prof app.js
node --prof-process isolate-0x*.log > profile.txt

# Heap profiling
node --heap-prof app.js

# Flame graphs
0x -- pack profiler
0x -f profile-flamegraph.svg profile.txt
```

### Python

```bash
# CPU profiling
python -m cProfile -o profile.stats app.py
python -m pstats profile.stats

# Memory profiling
pip install memory_profiler
python -m memory_profiler app.py

# Live profiling
pip install py-spy
py-spy top --pid <PID>
```

## What Gets Optimized

Generated optimizations typically address:
- Algorithm complexity (O(n²) → O(n), O(n log n))
- Database query patterns (N+1, missing indexes)
- Async/concurrency patterns (sequential → parallel)
- Memory usage (leaks, unnecessary allocations)
- Caching strategies (memoization, LRU caches)
- I/O patterns (batching, streaming)

## Further Documentation

See [SKILL.md](./SKILL.md) for:
- Complete optimization framework
- Language-specific patterns
- Memory optimization techniques
- Network optimization strategies

## License

MIT
