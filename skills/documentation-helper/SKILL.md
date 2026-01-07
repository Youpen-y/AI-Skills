---
name: documentation-helper
description: Help write high-quality technical documentation. Use when user asks for documentation help, wants to document code, or needs to improve existing docs.
---

# Documentation Helper

Help write clear, comprehensive, and maintainable technical documentation.

## When to Use

- User asks "help me document this code"
- User requests documentation for a function, module, or API
- User types `/docs` or similar
- User asks "how should I document this?"
- User wants to improve existing documentation

## Documentation Framework

### 1. Identify Documentation Type

Different types require different approaches:

| Type | Purpose | Audience |
|------|---------|----------|
| **API Docs** | Describe interfaces, parameters, return values | Developers |
| **Code Comments** | Explain complex logic, design decisions | Developers |
| **README** | Project overview, setup, usage | New users |
| **Architecture Docs** | System design, components, data flow | Developers |
| **Changelog** | Version history, changes | Users/Developers |
| **Contributing Guide** | How to contribute | Contributors |

### 2. Core Principles

#### CLARITY
- Use simple, direct language
- Avoid jargon unless necessary (and explain it if used)
- One concept per sentence
- Active voice over passive

#### COMPLETENESS
- Document all public APIs
- Include parameters, return values, and errors
- Provide examples for common use cases
- Mention edge cases and limitations

#### CONSISTENCY
- Use consistent terminology
- Follow established style guide
- Match code structure in docs organization

#### ACCURACY
- Keep docs in sync with code
- Update docs when changing functionality
- Test code examples before including them

### 3. Documentation Structure

#### API Documentation Template

> ## functionName
>
> Brief description of what the function does.
>
> ### Parameters
>
> | Parameter | Type | Required | Description |
> |-----------|------|----------|-------------|
> | `param1` | `string` | Yes | Description of param1 |
> | `param2` | `number` | No | Description of param2. Default: `0` |
>
> > **Note:** Type syntax shown below uses TypeScript format.
> > Adapt to your language: Python (`str`, `int`), Go (`string`, `int`),
> > Rust (`String`, `i32`), etc.
>
> ### Returns
>
> `Promise<{ id: string, status: number }>` - Description of return value.
>
> ### Throws
>
> - `ValidationError` - When param1 is invalid
> - `NetworkError` - When API call fails
>
> ### Example
>
> ```typescript
> const result = await functionName('value', 42);
> console.log(result.id);
> ```
>
> ### Notes
>
> - Additional context about behavior
> - Performance considerations
> - Dependencies or requirements

#### Code Comment Guidelines

```javascript
// DO: Explain WHY, not WHAT
// Cache the user data to avoid repeated API calls
const cachedUser = await getUser(userId);

// DON'T: Repeat what code already says
// Get the user
const user = await getUser(userId);

// DO: Document non-obvious decisions
// Using Map instead of Object for O(1) lookups by reference
const userMap = new Map();

// DO: Explain workarounds
// TODO: Remove this workaround after upgrading to v3.0
// See: https://github.com/issue/123
const value = data?.value ?? default;
```

### 4. Best Practices

#### DO
- Start with a brief summary
- Use code examples for complex concepts
- Include error conditions in API docs
- Document default values
- Add "See also" references
- Keep comments near the code they describe
- Update docs when code changes

#### DON'T
- Document private/internal implementation details
- Use redundant comments that repeat the code
- Write outdated comments
- Use "we" or "I" in documentation
- Assume knowledge without explaining

### 5. Documentation Style

#### Function Documentation

> ```typescript
> /**
>  * Validates user input against security policies.
>  *
>  * @param input - The user input string to validate
>  * @param options - Validation options
>  * @param options.maxLength - Maximum allowed length (default: 1000)
>  * @param options.allowSpecialChars - Whether to allow special characters
>  * @returns Object with validation result and any error messages
>  * @throws {ValidationError} When input format is invalid
>  *
>  * @example
>  * ```ts
>  * const result = validateInput(userText, { maxLength: 500 });
>  * if (!result.valid) {
>  *   console.log(result.errors);
>  * }
>  * ```
>  */
> function validateInput(input: string, options?: ValidationOptions): ValidationResult
> ```

#### README Structure

> # Project Name
>
> Brief description (1-2 sentences).
>
> ## Features
> - Feature 1
> - Feature 2
>
> ## Installation
>
> ```bash
> npm install package-name
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
> Detailed usage examples...
>
> ## API Reference
> Link to detailed API docs...
>
> ## Contributing
> Guidelines for contributors...
>
> ## License
> MIT

### 6. Common Documentation Tasks

| Task | Approach |
|------|----------|
| **Document a new API** | Use API template, include params/returns/errors |
| **Add code comments** | Focus on WHY, not WHAT |
| **Write a README** | Follow README structure above |
| **Update existing docs** | Review for accuracy, add missing info |
| **Create examples** | Use realistic scenarios, test before including |

### 7. Quality Checklist

Before considering documentation complete:

- [ ] All public APIs documented
- [ ] Parameters and return values specified
- [ ] Error conditions documented
- [ ] Examples provided for complex functions
- [ ] Code examples tested and working
- [ ] No outdated information
- [ ] Consistent terminology used
- [ ] Clear and concise language

---

**Need more?** See `examples.md` for real-world documentation examples.
