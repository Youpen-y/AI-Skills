# Test Generator Skill

> Automated unit test generation following best practices and testing frameworks.

## Overview

This skill helps users generate comprehensive unit tests that follow testing best practices. It covers happy paths, edge cases, error handling, and provides framework-specific implementations for multiple programming languages.

## Quick Start

When using Claude Code, simply ask for tests:

```
Write tests for this function
```

```
Add test coverage for the auth module
```

```
Generate unit tests for the API handler
```

Claude will use this skill to generate comprehensive tests.

## Features

### Structured Framework

- Happy path coverage
- Edge case identification
- Error handling verification
- External dependency mocking
- Framework-specific implementations

### Comprehensive Coverage

| Category | Purpose | Example |
|----------|---------|---------|
| **Happy Path** | Normal operation | Valid input → expected output |
| **Edge Cases** | Boundary values | Empty, null, max/min values |
| **Error Cases** | Invalid input | Wrong type, missing fields |
| **Integration** | Multiple components | API calls, database |

### Supported Languages

| Language | Framework | Status |
|----------|-----------|--------|
| JavaScript | Jest | ✅ |
| TypeScript | Jest + types | ✅ |
| Python | pytest | ✅ |
| Rust | built-in | ✅ |
| Go | testing | ✅ |

## Structure

```
test-generator/
├── SKILL.md    # Main skill documentation
└── README.md   # This file
```

## Usage Examples

### JavaScript (Jest)

**Request:**
```
Write tests for calculateTotal function
```

**Generated Tests:**
```javascript
describe('calculateTotal', () => {
  // Happy path
  it('calculates sum with tax', () => {
    expect(calculateTotal(100, 0.1)).toBe(110);
  });

  // Edge cases
  it('returns 0 for empty array', () => {
    expect(calculateTotal([])).toBe(0);
  });

  // Error cases
  it('throws for negative price', () => {
    expect(() => calculateTotal(-10)).toThrow();
  });
});
```

### Python (pytest)

**Request:**
```
Add test coverage for the user service
```

**Generated Tests:**
```python
def test_create_user_valid():
    user = create_user("alice@example.com")
    assert user.email == "alice@example.com"
    assert user.id is not None

def test_create_user_duplicate_email():
    with pytest.raises(DuplicateError):
        create_user("existing@example.com")

def test_create_user_invalid_email():
    with pytest.raises(ValidationError):
        create_user("not-an-email")
```

### Rust

**Request:**
```
Generate tests for the parser module
```

**Generated Tests:**
```rust
#[cfg(test)]
mod tests {
    #[test]
    fn test_parse_valid_input() {
        let result = parse("valid input");
        assert_eq!(result, Expected::Value);
    }

    #[test]
    #[should_panic(expected = "invalid format")]
    fn test_parse_invalid_panics() {
        parse("invalid");
    }
}
```

## Test Generation Template

### 1. Clarification Questions

Before generating tests, the skill will ask:
- What function/module needs tests?
- What testing framework (Jest, pytest, etc.)?
- What are the expected behaviors?
- Any specific edge cases to cover?

### 2. Test Structure

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

## Best Practices

### Test Writing Principles

| Principle | Description |
|-----------|-------------|
| **Arrange-Act-Assert** | Clear test structure |
| **Descriptive names** | Tests should document behavior |
| **One assertion per test** | Single responsibility |
| **Mock external deps** | Isolate unit under test |
| **Test behavior** | Focus on what, not how |

### Mocking Guidelines

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

### Test Checklist

When generating tests, ensure:

- [ ] All public functions covered
- [ ] Happy path tested
- [ ] Edge cases included
- [ ] Error handling verified
- [ ] External dependencies mocked
- [ ] Tests are independent
- [ ] Tests run fast (< 100ms each)
- [ ] Descriptive test names

## Response Format

The skill provides structured responses:

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

## Language-Specific Concepts

| Language | Key Concepts |
|----------|--------------|
| JavaScript | Async tests, mocking, timers |
| Python | Fixtures, parametrize, raises |
| Rust | Attribute tests, should_panic |
| Go | Table-driven tests, subtests |

## License

MIT
