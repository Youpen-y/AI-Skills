---
name: test-generator
description: Generate unit tests for code. Use when user asks for tests, wants to add test coverage, or requests test examples.
---

# Test Generator

Generate unit tests following best practices and frameworks.

## When to Use

- User asks "write tests for this"
- User wants test coverage
- User requests test examples
- User types `/test` or similar

## Test Generation Framework

### 1. Identify What to Test

Ask clarifying questions:
- What function/module needs tests?
- What framework (Jest, pytest, etc.)?
- What are the expected behaviors?
- Any edge cases to cover?

### 2. Test Categories

Cover these test types:

| Category | Purpose | Example |
|----------|---------|---------|
| **Happy Path** | Normal operation | Valid input → expected output |
| **Edge Cases** | Boundary values | Empty, null, max/min values |
| **Error Cases** | Invalid input | Wrong type, missing fields |
| **Integration** | Multiple components | API calls, database |

### 3. Test Structure Template

```javascript
describe('FunctionName', () => {
  // Happy path
  it('should return expected result for valid input', () => {
    const result = functionName(validInput);
    expect(result).toEqual(expectedOutput);
  });

  // Edge cases
  it('should handle empty input', () => {
    const result = functionName(empty);
    expect(result).toEqual(defaultValue);
  });

  // Error cases
  it('should throw error for invalid input', () => {
    expect(() => functionName(invalid)).toThrow();
  });
});
```

### 4. Best Practices

- **Arrange-Act-Assert**: Clear test structure
- **Descriptive names**: Test should document behavior
- **One assertion per test**: Single responsibility
- **Mock external deps**: Isolate unit under test
- **Test behavior, not implementation**: Focus on what, not how

### 5. Common Frameworks

| Language | Framework | Import |
|----------|-----------|--------|
| JavaScript | Jest | `import { test, expect }` |
| TypeScript | Jest + types | `import { test, expect }` |
| Python | pytest | `import pytest` |
| Rust | built-in | `#[cfg(test)]` |
| Go | testing | `import "testing"` |

## Example Tests

### JavaScript (Jest)

```javascript
describe('calculateTotal', () => {
  it('calculates sum with tax', () => {
    expect(calculateTotal(100, 0.1)).toBe(110);
  });

  it('returns 0 for empty array', () => {
    expect(calculateTotal([])).toBe(0);
  });

  it('throws for negative price', () => {
    expect(() => calculateTotal(-10)).toThrow();
  });
});
```

### Python (pytest)

```python
def test_calculate_total_with_tax():
    assert calculate_total(100, 0.1) == 110

def test_calculate_total_empty():
    assert calculate_total([]) == 0

def test_calculate_total_negative_raises():
    with pytest.raises(ValueError):
        calculate_total(-10)
```

### Rust

```rust
#[cfg(test)]
mod tests {
    #[test]
    fn test_calculate_total_with_tax() {
        assert_eq!(calculate_total(100, 0.1), 110);
    }

    #[test]
    #[should_panic(expected = "negative value")]
    fn test_calculate_total_negative_panics() {
        calculate_total(-10, 0.1);
    }
}
```

## Checklist

When generating tests, ensure:

- [ ] All public functions covered
- [ ] Happy path tested
- [ ] Edge cases included
- [ ] Error handling verified
- [ ] External dependencies mocked
- [ ] Tests are independent
- [ ] Tests run fast (< 100ms each)
- [ ] Descriptive test names

## Mocking Guidelines

```javascript
// Mock API calls
jest.mock('./api', () => ({
  fetchData: jest.fn(() => Promise.resolve({ data: 'mock' }))
}));

// Mock timers
jest.useFakeTimers();

// Mock environment
process.env.NODE_ENV = 'test';
```

## Response Template

```
## Tests for [Function/Module]

### Happy Path
- [Test case 1]
- [Test case 2]

### Edge Cases
- [Edge case 1]
- [Edge case 2]

### Error Cases
- [Error case 1]

### Full Test Code
[Complete test file]
```
