# Documentation Reference

Comprehensive reference guide for writing technical documentation.

## Table of Contents

1. [Documentation Standards](#documentation-standards)
2. [Writing Guidelines](#writing-guidelines)
3. [Format Specifications](#format-specifications)
4. [Language-Specific Docs](#language-specific-documentation)
5. [Tools and Automation](#tools-and-automation)

---

## Documentation Standards

### JSDoc (JavaScript/TypeScript)

> ```typescript
> /**
>  * Brief one-line description.
>  *
>  * Extended description with more details about the function's
>  * purpose, behavior, and any important notes.
>  *
>  * @param param1 - Description of first parameter
>  * @param param2 - Description of second parameter
>  * @returns Description of return value
>  * @throws {ErrorType} Description of when this error is thrown
>  *
>  * @example
>  * ```ts
>  * const result = functionName('arg1', 'arg2');
>  * ```
>  */
> function functionName(param1: string, param2: number): boolean
> ```

### Python Docstrings (PEP 257)

```python
def calculate_discount(price: float, discount_percent: float) -> float:
    """
    Calculate the discounted price.

    Args:
        price: The original price.
        discount_percent: Discount percentage (0-100).

    Returns:
        The discounted price.

    Raises:
        ValueError: If discount_percent is not between 0 and 100.

    Examples:
        >>> calculate_discount(100.0, 20)
        80.0
    """
    if not 0 <= discount_percent <= 100:
        raise ValueError("Discount must be between 0 and 100")
    return price * (1 - discount_percent / 100)
```

### Rust Doc Comments

```rust
/// Processes the input data and returns a transformed result.
///
/// This function applies a series of transformations to the input
/// data, including validation, normalization, and formatting.
///
/// # Arguments
///
/// * `input` - The raw input string to process
/// * `options` - Configuration options for processing
///
/// # Returns
///
/// A `Result` containing the processed data or an error.
///
/// # Errors
///
/// This function will return an error if:
/// - The input contains invalid characters
/// - The options configuration is invalid
///
/// # Examples
///
/// ```
/// let result = process_data("hello", Options::default());
/// assert_eq!(result.unwrap(), "HELLO");
/// ```
pub fn process_data(input: &str, options: Options) -> Result<String>
```

### Go Doc Comments

```go
// Authenticate verifies user credentials and returns a session token.
//
// The password is compared using bcrypt with a cost factor of 10.
// Failed attempts are logged for security monitoring.
//
// Parameters:
//   - email: User's email address
//   - password: User's plaintext password
//
// Returns:
//   - string: JWT session token valid for 24 hours
//   - error: Authentication error if credentials are invalid
//
// Example:
//   token, err := Authenticate("user@example.com", "password")
//   if err != nil {
//       log.Fatal(err)
//   }
func Authenticate(email string, password string) (string, error)
```

---

## Writing Guidelines

### Style Rules

| Rule | Correct | Incorrect |
|------|---------|-----------|
| Use active voice | "The function validates input" | "The input is validated by the function" |
| Be concise | "Returns user data" | "This function is responsible for returning user data to the caller" |
| Use present tense | "Calculates the total" | "Will calculate the total" |
| Avoid redundancy | "Validate email format" | "This function validates the email format" |

### Terminology Consistency

Define and use consistent terminology:

| Concept | Preferred Term | Avoid |
|---------|---------------|-------|
| End users of API | "Users" or "Developers" | "Clients", "Consumers" |
| Application interface | "API" | "Interface", "Endpoint layer" |
| Request failures | "Errors" | "Exceptions", "Failures" |
| Function parameters | "Parameters" | "Arguments", "Args" |

### Clarity Guidelines

1. **One concept per sentence**
   ```markdown
   Good: The function validates input and returns a boolean.
   Bad: The function validates the user input which is provided as a parameter and then it returns either true or false depending on whether the validation was successful.
   ```

2. **Define unfamiliar terms**
   ```markdown
   Good: Uses a **nonce** (number used once) to prevent replay attacks.
   Bad: Uses a nonce for replay protection.
   ```

3. **Provide context first**
   ```markdown
   Good: This function formats dates for display in the UI, not for storage.
   Bad: Formats dates. (ambiguous purpose)
   ```

---

## Format Specifications

### README Template

> # [Project Name]
>
> [One sentence description of what the project does and who it's for.]
>
> [Optional: 2-3 sentence paragraph with more detail]
>
> ## Features
>
> - [Feature 1 - what it does]
> - [Feature 2 - what it does]
> - [Feature 3 - what it does]
>
> ## Installation
>
> ```bash
> # npm
> npm install package-name
>
> # yarn
> yarn add package-name
>
> # pnpm
> pnpm add package-name
> ```
>
> ## Quick Start
>
> ```typescript
> import { Package } from 'package-name';
>
> const instance = new Package();
> instance.doSomething();
> ```
>
> ## Usage
>
> [Detailed usage examples and explanations]
>
> ### Basic Usage
>
> [Example 1]
>
> ### Advanced Usage
>
> [Example 2]
>
> ## API Reference
>
> [Link to full API docs or summary of main APIs]
>
> ## Configuration
>
> [Configuration options and environment variables]
>
> ## Contributing
>
> [Link to or include contributing guidelines]
>
> ## License
>
> [License name]
>
> ## Links
>
> - Documentation: [URL]
> - Changelog: [URL]
> - Issues: [URL]

### Changelog Format (Keep a Changelog)

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- New feature description

### Changed
- Changed behavior description

### Deprecated
- Deprecated feature description

### Removed
- Removed feature description

### Fixed
- Bug fix description

### Security
- Security fix description

## [1.2.0] - 2024-01-15

### Added
- New feature that was added in this version
```

---

## Language-Specific Documentation

### TypeScript Best Practices

1. **Use JSDoc with type information**
   > ```typescript
   >  /**
   >   * Creates a new user account.
   >   *
   >   * @template T - Type of user data extension
   >   * @param data - User registration data
   >   * @param data.email - User email address
   >   * @param data.password - User password (min 8 chars)
   >   * @returns Promise resolving to created user object
   >   *
   >   * @example
   >   * ```ts
   >   * const user = await createUser<User & { role: string }>({
   >   *   email: 'user@example.com',
   >   *   password: 'securepass',
   >   *   role: 'admin'
   >   * });
   >   * ```
   >   */
   >   async function createUser<T extends User>(data: {
   >     email: string;
   >     password: string;
   >   }): Promise<T>
   > ```

2. **Document generic constraints**
   ```typescript
   /**
    * Merges two objects of the same type.
    *
    * @template T - Object type with known keys
    * @param target - Base object
    * @param source - Object to merge into target
    * @returns Merged object with type T
    */
   function merge<T extends object>(target: T, source: Partial<T>): T
   ```

### Python Best Practices

1. **Use Google style docstrings**
   ```python
   def fetch_users(limit: int = 100) -> list[User]:
       """Fetch users from the database.

       Args:
           limit: Maximum number of users to return.

       Returns:
           List of User objects.

       Raises:
           DatabaseError: If connection fails.
       """
       pass
   ```

2. **Document class attributes**
   ```python
   class UserService:
       """Manages user operations and data.

       Attributes:
           db: Database connection instance
           cache: Redis cache client
           max_retries: Number of retry attempts for failed operations
       """
   ```

---

## Tools and Automation

### Documentation Generators

| Tool | Language | Features |
|------|----------|----------|
| **TypeDoc** | TypeScript | JSDoc to HTML, type information |
| **Sphinx** | Python | ReST, multiple output formats |
| **rustdoc** | Rust | Built-in, supports tests in docs |
| **godoc** | Go | Auto-generated from comments |
| **JSDoc** | JavaScript | Type annotations, templates |

### Automated Tools

1. **API Documentation**
   - **OpenAPI/Swagger**: REST API specification
   - **GraphQL Docs**: Auto-generated from schema
   - **Postman Collections**: Documented API requests

2. **Markdown Linting**
   ```bash
   npm install -g markdownlint-cli
   markdownlint **/*.md
   ```

3. **Spell Checking**
   ```bash
   npm install -g cspell
   cspell "**/*.md"
   ```

4. **Link Checking**
   ```bash
   npm install -g markdown-link-check
   markdown-link-check README.md
   ```

### Documentation Testing

```javascript
// Test code examples in documentation
import { execFileSync } from 'child_process';

const testCodeExample = (code, expectedOutput) => {
  const result = execFileSync('node', ['-e', code], { encoding: 'utf8' });
  if (result !== expectedOutput) {
    throw new Error(`Example output mismatch: ${result}`);
  }
};

// Run in CI to ensure examples stay current
testCodeExample('console.log(2 + 2)', '4\n');
```

---

## Quick Reference

### Common JSDoc Tags

| Tag | Purpose |
|-----|---------|
| `@param` | Document a parameter |
| `@returns` | Document return value |
| `@throws` | Document thrown errors |
| `@example` | Provide usage example |
| `@see` | Reference another resource |
| `@deprecated` | Mark as deprecated |
| `@since` | Version when added |
| `@template` | TypeScript generic type |
| `@overload` | Function overloads |

### Documentation Anti-Patterns

| Anti-Pattern | Better Approach |
|--------------|-----------------|
| "This function..." | Start with verb: "Calculates..." |
| Restating code | Explain WHY, not WHAT |
| Outdated examples | Test and update examples |
| Missing error docs | Document all throws |
| Wall of text | Use headers and lists |
| Assumed knowledge | Define terms and context |

### Quality Checklist

Before publishing documentation:

**Content**
- [ ] All public APIs documented
- [ ] Parameters and returns specified
- [ ] Error conditions listed
- [ ] Examples provided
- [ ] Code examples tested

**Style**
- [ ] Consistent terminology
- [ ] Active voice used
- [ ] No redundant comments
- [ ] Clear and concise

**Maintenance**
- [ ] Version number included
- [ ] Changelog up to date
- [ ] Deprecated items marked
- [ ] Links verified
