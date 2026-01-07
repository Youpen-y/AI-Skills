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

## Supported Languages

| Language | Framework |
|----------|-----------|
| JavaScript | Jest |
| TypeScript | Jest + types |
| Python | pytest |
| Rust | built-in |
| Go | testing |

## Usage Examples

### JavaScript (Jest)

**Request:**
```
Write tests for sumPrices function
```

**Generated Tests:**
```javascript
describe('sumPrices', () => {
  it('calculates sum of prices with tax', () => {
    expect(sumPrices([100, 200, 50], 0.1)).toBe(385);
  });

  it('returns 0 for empty array', () => {
    expect(sumPrices([], 0.1)).toBe(0);
  });

  it('throws for negative price', () => {
    expect(() => sumPrices([-10], 0.1)).toThrow();
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

### Go

**Request:**
```
Add test coverage for the price calculator
```

**Generated Tests:**
```go
func TestSumPrices(t *testing.T) {
    tests := []struct {
        name    string
        prices  []int
        taxRate float64
        want    int
    }{
        {"calculates sum with tax", []int{100, 200, 50}, 0.1, 385},
        {"empty array returns zero", []int{}, 0.1, 0},
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got := SumPrices(tt.prices, tt.taxRate)
            if got != tt.want {
                t.Errorf("SumPrices(%v, %v) = %v, want %v", tt.prices, tt.taxRate, got, tt.want)
            }
        })
    }
}
```

### Rust

**Request:**
```
Generate tests for the price calculator
```

**Generated Tests:**
```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_sum_prices_with_tax() {
        assert_eq!(sum_prices(&[100, 200, 50], 0.1), 385);
    }

    #[test]
    fn test_sum_prices_empty() {
        assert_eq!(sum_prices(&[], 0.1), 0);
    }

    #[test]
    #[should_panic(expected = "negative value")]
    fn test_sum_prices_negative_panics() {
        sum_prices(&[-10], 0.1);
    }
}
```

## What Gets Tested

Generated tests typically cover:
- **Happy Path** - Normal operation with valid inputs
- **Edge Cases** - Empty/null values, boundaries
- **Error Cases** - Invalid inputs, exceptions

## Further Documentation

See [SKILL.md](./SKILL.md) for:
- Detailed test generation framework
- Best practices and guidelines
- Mocking strategies
- Complete code examples

## License

MIT
