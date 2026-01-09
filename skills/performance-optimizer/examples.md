# Performance Optimizer - Real-World Examples

Real-world examples of identifying and fixing performance bottlenecks.

## Table of Contents

- [API Response Optimization](#api-response-optimization)
- [Database Query Optimization](#database-query-optimization)
- [Memory Leak Fix](#memory-leak-fix)
- [Async Concurrency](#async-concurrency)
- [Algorithm Optimization](#algorithm-optimization)
- [Caching Strategy](#caching-strategy)
- [Stream Processing](#stream-processing)

---

## API Response Optimization

### Problem: API endpoint takes 5 seconds

**Before:**
```javascript
app.get('/api/users/:id/dashboard', async (req, res) => {
  const user = await db.findUser(req.params.id);        // 500ms
  const posts = await db.getUserPosts(req.params.id);   // 1000ms
  const comments = await db.getUserComments(req.params.id); // 1000ms
  const stats = await db.getUserStats(req.params.id);   // 1500ms
  const recommendations = await db.getRecommendations(req.params.id); // 1000ms

  res.json({ user, posts, comments, stats, recommendations });
});
// Total: ~5000ms (sequential)
```

**Analysis:** All queries run sequentially when they could run in parallel.

**After:**
```javascript
app.get('/api/users/:id/dashboard', async (req, res) => {
  const [user, posts, comments, stats, recommendations] = await Promise.all([
    db.findUser(req.params.id),
    db.getUserPosts(req.params.id),
    db.getUserComments(req.params.id),
    db.getUserStats(req.params.id),
    db.getRecommendations(req.params.id)
  ]);

  res.json({ user, posts, comments, stats, recommendations });
});
// Total: ~1500ms (parallel)
```

**Result:** 5s → 1.5s (3.3x faster)

---

## Database Query Optimization

### Problem: User list page loads slowly (10+ seconds)

**Before:**
```javascript
// N+1 query problem
app.get('/api/users', async (req, res) => {
  const users = await db.query('SELECT * FROM users LIMIT 100');

  // N queries to get posts for each user
  for (const user of users) {
    user.posts = await db.query(
      'SELECT * FROM posts WHERE user_id = ?',
      [user.id]
    );
  }

  res.json(users);
});
// Total queries: 1 + 100 = 101
// Time: ~10,000ms
```

**Analysis:** Making a separate database query for each user's posts.

**After:**
```javascript
app.get('/api/users', async (req, res) => {
  // Single query with JOIN
  const users = await db.query(`
    SELECT
      u.*,
      COUNT(p.id) as post_count,
      GROUP_CONCAT(p.title SEPARATOR '|') as post_titles
    FROM users u
    LEFT JOIN posts p ON u.id = p.user_id
    GROUP BY u.id
    LIMIT 100
  `);

  res.json(users);
});
// Total queries: 1
// Time: ~150ms
```

**Note:** `GROUP_CONCAT` is MySQL/MariaDB specific. For PostgreSQL use `string_agg()`, for SQL Server use `STRING_AGG()`.

**Result:** 10s → 0.15s (67x faster)

---

## Memory Leak Fix

### Problem: Memory usage grows continuously, eventually crashes

**Before:**
```javascript
class EventBus {
  constructor() {
    this.listeners = new Map();
  }

  on(event, callback) {
    if (!this.listeners.has(event)) {
      this.listeners.set(event, []);
    }
    this.listeners.get(event).push(callback);
  }

  emit(event, data) {
    const callbacks = this.listeners.get(event) || [];
    callbacks.forEach(cb => cb(data));
  }
}

// Usage
const bus = new EventBus();

// Event listeners never removed!
function setupWidget(widget) {
  bus.on('update', (data) => {
    widget.update(data);
  });
}

// Each widget adds a listener, old widgets never cleaned up
// When widget is removed from DOM, listener remains
// Memory leak: listeners array keeps growing
```

**Analysis:** Event listeners accumulate but are never removed.

**After:**
```javascript
class EventBus {
  constructor() {
    this.listeners = new Map();
  }

  on(event, callback) {
    if (!this.listeners.has(event)) {
      this.listeners.set(event, new Set()); // Use Set
    }
    this.listeners.get(event).add(callback);

    // Return unsubscribe function
    return () => this.off(event, callback);
  }

  off(event, callback) {
    const callbacks = this.listeners.get(event);
    if (callbacks) {
      callbacks.delete(callback);
    }
  }

  emit(event, data) {
    const callbacks = this.listeners.get(event);
    if (callbacks) {
      callbacks.forEach(cb => cb(data));
    }
  }
}

// Usage with cleanup
class Widget {
  constructor(bus) {
    this.unsubscribe = null;
  }

  attach(bus) {
    // Store unsubscribe function
    this.unsubscribe = bus.on('update', (data) => {
      this.update(data);
    });
  }

  detach() {
    // Clean up listener when widget is removed
    if (this.unsubscribe) {
      this.unsubscribe();
      this.unsubscribe = null;
    }
  }
}
```

**Result:** Memory usage stays constant, no leaks

---

## Async Concurrency

### Problem: Batch processing takes hours

**Before:**
```javascript
async function processBatch(items) {
  const results = [];

  for (const item of items) {
    // Process sequentially
    const result = await externalAPI.process(item);
    results.push(result);
  }

  return results;
}

// Processing 10,000 items at 100ms each
// Time: 10,000 * 100ms = 1,000 seconds (~17 minutes)
```

**After:**
```javascript
import pLimit from 'p-limit';

async function processBatch(items, concurrency = 10) {
  const limit = pLimit(concurrency);
  const results = [];

  // Process with concurrency limit
  const tasks = items.map(item =>
    limit(() => externalAPI.process(item))
  );

  const processed = await Promise.all(tasks);
  results.push(...processed);

  return results;
}

// Processing 10,000 items at 100ms each with 10 concurrent
// Time: (10,000 / 10) * 100ms = 100 seconds (~1.7 minutes)
```

**Result:** 17 minutes → 1.7 minutes (10x faster)

---

## Algorithm Optimization

### Problem: Finding common users between two lists is slow

**Before:**
```python
def find_common_users(list_a, list_b):
    """Find users present in both lists"""
    common = []
    for user_a in list_a:
        for user_b in list_b:
            if user_a.id == user_b.id:
                common.append(user_a)
                break
    return common

# Time complexity: O(n * m)
# With 10,000 users each: 100,000,000 comparisons
# Time: ~5 seconds
```

**After:**
```python
def find_common_users(list_a, list_b):
    """Find users present in both lists"""
    # Create a set of IDs from list_b for O(1) lookup
    set_b_ids = {user.id for user in list_b}

    # Find common users
    common = [user for user in list_a if user.id in set_b_ids]
    return common

# Time complexity: O(n + m)
# With 10,000 users each: 20,000 operations
# Time: ~0.005 seconds
```

**Result:** 5s → 0.005s (1000x faster)

---

## Caching Strategy

### Problem: Expensive calculation repeats for same inputs

**Before:**
```javascript
// Calculate product recommendations based on purchase history
async function getRecommendations(userId) {
  const purchases = await db.getPurchases(userId);
  const similarProducts = await findSimilarProducts(purchases);
  const recommendations = await rankByPopularity(similarProducts);
  return recommendations;
}

// Called frequently for same users
// Each call: 5 database queries + 500ms processing
```

**After:**
```javascript
import LRU from 'lru-cache';

const cache = new LRU({
  max: 1000,              // Max 1000 entries
  ttl: 1000 * 60 * 15,    // Expire after 15 minutes
});

async function getRecommendations(userId) {
  // Check cache first
  const cached = cache.get(userId);
  if (cached) {
    return cached;
  }

  // Cache miss - calculate
  const purchases = await db.getPurchases(userId);
  const similarProducts = await findSimilarProducts(purchases);
  const recommendations = await rankByPopularity(similarProducts);

  // Store in cache
  cache.set(userId, recommendations);

  return recommendations;
}

// First call: 500ms (cache miss)
// Subsequent calls: <1ms (cache hit)
// 95% cache hit rate = effective time: ~25ms
```

**Result:** 500ms → 25ms average (20x faster)

---

## Stream Processing

### Problem: Large file processing uses too much memory

**Before:**
```javascript
const fs = require('fs');

function processLargeFile(inputPath, outputPath) {
  // Read entire file into memory
  const data = fs.readFileSync(inputPath, 'utf8');
  const lines = data.split('\n');

  const results = [];
  for (const line of lines) {
    const processed = transformLine(line);
    results.push(processed);
  }

  fs.writeFileSync(outputPath, results.join('\n'));
}

// Processing 1GB file:
// Memory usage: ~2GB (original + processed)
// Node.js crashes with "JavaScript heap out of memory"
```

**After:**
```javascript
const { pipeline } = require('stream/promises');
const { Transform } = require('stream');
const fs = require('fs');
const readline = require('readline');

async function processLargeFile(inputPath, outputPath) {
  // For line-by-line processing, use readline with pipeline
  const readStream = fs.createReadStream(inputPath);
  const writeStream = fs.createWriteStream(outputPath);

  const rl = readline.createInterface({
    input: readStream,
    crlfDelay: Infinity
  });

  // Process each line and write to output
  for await (const line of rl) {
    const processed = transformLine(line);
    writeStream.write(processed + '\n');
  }

  writeStream.end();
}

// Alternative: For binary/chunk-based processing (not line-oriented)
async function processBinaryFile(inputPath, outputPath) {
  const { pipeline } = require('stream/promises');

  const transformStream = new Transform({
    transform(chunk, encoding, callback) {
      // Process raw chunks (not line-by-line)
      // Note: chunks may split line boundaries
      const processed = processChunk(chunk);
      callback(null, processed);
    }
  });

  await pipeline(
    fs.createReadStream(inputPath),
    transformStream,
    fs.createWriteStream(outputPath)
  );
}

// Processing 1GB file:
// Memory usage: ~10MB (only current line/chunk in memory)
// Runs successfully

// Note: Use readline for line-by-line text processing.
// Use Transform directly only for binary data or chunked operations.
```

**Result:** Memory usage: 2GB → 10MB (200x reduction)

---

## Python Generator Optimization

### Problem: Loading entire dataset into memory

**Before:**
```python
import csv

def process_csv_file(filepath):
    """Process a large CSV file"""
    with open(filepath) as f:
        reader = csv.DictReader(f)
        rows = list(reader)  # Load ALL rows into memory

    results = []
    for row in rows:
        processed = transform_row(row)
        results.append(processed)

    return results

# Processing 10M row CSV:
# Memory usage: ~4GB
# May cause MemoryError
```

**After:**
```python
import csv

# Option 1: Process and yield results
def process_csv_file(filepath):
    """Process a large CSV file using generators"""
    with open(filepath) as f:
        reader = csv.DictReader(f)

        # Process one row at a time
        for row in reader:
            processed = transform_row(row)
            yield processed

# Option 2: Stream to output file
def process_csv_stream(input_path, output_path):
    """Process CSV and stream results to output file"""
    with open(input_path) as f:
        reader = csv.DictReader(f)

        with open(output_path, 'w') as out:
            writer = csv.DictWriter(out, fieldnames=['id', 'value'])
            writer.writeheader()

            for row in reader:
                processed = transform_row(row)
                writer.writerow(processed)

# Processing 10M row CSV:
# Memory usage: ~1MB (one row at a time)
# Runs successfully
```

**Result:** Memory usage: 4GB → 1MB (4000x reduction)
