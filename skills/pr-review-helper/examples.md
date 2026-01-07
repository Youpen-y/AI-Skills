# PR Review Examples

Real-world examples of code reviews using the PR Review Helper framework.

## Example 1: Security Vulnerability

### Context
PR adds user login functionality with password authentication.

### Review

```markdown
## Summary
This PR adds user authentication with email/password login, including session management and password reset functionality.

## :white_check_mark: Strengths
- Clean separation of auth logic into dedicated service
- Proper use of bcrypt for password hashing
- Good error handling for network failures

## :bug: Issues

**Critical**
- `auth/login.ts:45` - Password comparison is vulnerable to timing attacks. Use `bcrypt.compare()` instead of direct comparison:
  ```typescript
  // Bad
  if (user.password === hashedPassword) { ... }

  // Good
  const match = await bcrypt.compare(password, user.password);
  ```

- `auth/session.ts:23` - Session token stored in localStorage without httpOnly flag. This exposes tokens to XSS. Use httpOnly cookies instead.

**High Priority**
- `auth/login.ts:67` - No rate limiting on login endpoint. This allows brute force attacks. Add rate limiting middleware.

**Medium Priority**
- `auth/types.ts` - Missing password validation rules (length, complexity). Add Zod schema for validation.

## :thinking: Questions
- Have you considered implementing MFA for additional security?
- Are there plans to add "remember me" functionality?

## :page_facing_up: Testing Status
- [x] Tests pass
- [x] New tests added
- [ ] Coverage adequate (missing error path tests)

## Overall Assessment
Good foundation for auth system, but **critical security issues must be addressed** before merging.

**Status: Request Changes**
```

---

## Example 2: Performance Improvement

### Context
PR refactors data processing pipeline for better performance.

### Review

```markdown
## Summary
This PR refactors the data processing pipeline to use streaming instead of loading all data into memory, reducing memory usage from ~2GB to ~50MB.

## :white_check_mark: Strengths
- Excellent performance improvement! 40x memory reduction is significant
- Well-documented with clear comments explaining the streaming approach
- Backward compatible API - no breaking changes

## :bug: Issues

**High Priority**
- `pipeline/stream.ts:89` - The stream is not properly closed on error. Add error handling:
  ```typescript
  stream.on('error', (err) => {
    stream.destroy();
    reject(err);
  });
  ```

**Medium Priority**
- `pipeline/config.ts` - Consider adding a `concurrency` option to control parallel processing. Current implementation processes all chunks sequentially.

## :thinking: Questions
- Have you benchmarked with different chunk sizes? 1024 bytes seems arbitrary.
- Would a worker pool provide additional benefits for CPU-intensive processing?

## :page_facing_up: Testing Status
- [x] Tests pass
- [x] New tests added
- [x] Coverage adequate

## Overall Assessment
Excellent performance improvement with clean implementation. Please address the stream cleanup issue.

**Status: Approve with Changes**
```

---

## Example 3: Clean LGTM

### Context
Small bug fix with straightforward implementation.

### Review

```markdown
## Summary
This PR fixes the null pointer exception in `getUserById` by adding proper null checking.

## :white_check_mark: Strengths
- Minimal, focused change that addresses the issue
- Good test coverage added for the edge case
- Clear commit message following conventional commits

## :bug: Issues

None! This is a clean fix.

## :thinking: Questions
None.

## :page_facing_up: Testing Status
- [x] Tests pass
- [x] New tests added
- [x] Coverage adequate

## Overall Assessment
Straightforward fix for a real bug. Well done!

**Status: LGTM** :shipit:
```

---

## Example 4: Refactoring Suggestions

### Context
PR adds new feature but has opportunities for improvement.

### Review

```markdown
## Summary
This PR adds a new dashboard widget system that allows users to customize their homepage layout.

## :white_check_mark: Strengths
- Solid implementation of the core widget functionality
- Good TypeScript typing throughout
- Nice use of React Context for state management

## :bug: Issues

**High Priority**
- `widgets/WidgetRegistry.ts:45-67` - This class has too many responsibilities. Consider extracting:
  - Widget validation to `WidgetValidator`
  - Widget persistence to `WidgetStorage`

**Medium Priority**
- `components/Dashboard.tsx:123` - The `useEffect` dependency array is missing `widgetConfig`. This could cause stale closures.

- `utils/helpers.ts` - The function `calculateWidgetPosition` is 80+ lines. Consider breaking into smaller functions for readability.

**Nice to Have**
- Consider adding unit tests for the WidgetRegistry class
- Add JSDoc comments for public API methods

## :thinking: Questions
- What's the strategy for handling widget updates after initial load? Real-time updates or manual refresh?
- Have you considered using a grid layout library like react-grid-layout instead of custom positioning?

## :page_facing_up: Testing Status
- [x] Tests pass
- [x] New tests added
- [ ] Coverage adequate (missing WidgetRegistry tests)

## Overall Assessment
Good feature implementation with room for improved code organization. Not blocking, but would be valuable improvements.

**Status: Approve with Comments**
```

---

## Example 5: API Design Feedback

### Context
PR introduces new REST API endpoints.

### Review

```markdown
## Summary
This PR adds REST API endpoints for user management, including CRUD operations and bulk actions.

## :white_check_mark: Strengths
- Consistent API design following REST conventions
- Good use of HTTP status codes
- Proper pagination implementation

## :bug: Issues

**Critical**
- `api/users.ts:45` - DELETE endpoint returns 200 OK. Should return 204 No Content for successful deletion with no response body.

**High Priority**
- `api/users.ts:89` - No authentication on bulk delete endpoint. This is a data loss risk.

**Medium Priority**
- `api/types.ts` - The API response format is inconsistent. Some endpoints use `{ data, error }` wrapper, others don't. Consider standardizing.

- Missing rate limiting on user creation endpoint.

**Nice to Have**
- Consider adding OpenAPI/Swagger documentation
- Add HATEOAS links for better API discoverability

## :thinking: Questions
- Why use POST for bulk operations instead of PATCH?
- Are there plans to add webhook support for user events?

## :page_facing_up: Testing Status
- [x] Tests pass
- [x] New tests added
- [x] Coverage adequate

## Overall Assessment
Solid API design with a few issues to address before merge.

**Status: Request Changes**
```

---

## Example 6: Code Review with Learning Resources

### Context
Junior developer submits first PR to the project.

### Review

```markdown
## Summary
This PR adds the ability to filter products by category in the product listing page.

## :white_check_mark: Strengths
- Great first PR! The implementation is clean and follows the project conventions
- Well-written commit message
- Tests included for the new functionality

## :bug: Issues

**Medium Priority**
- `products/filter.ts:23` - Consider using `Set` instead of `Array.includes()` for better performance when filtering multiple categories:
  ```typescript
  // Current - O(n*m)
  const filtered = products.filter(p => selectedCategories.includes(p.category));

  // Better - O(n+m) with Set
  const categorySet = new Set(selectedCategories);
  const filtered = products.filter(p => categorySet.has(p.category));
  ```

**Nice to Have**
- `components/ProductList.tsx:67` - The filter state could be moved to URL params for shareable links. Check out our `useSearchParams` hook for an example.

## :thinking: Questions
- How did you test this? Manual testing or automated?
- Any edge cases you considered that aren't covered in tests?

## :page_facing_up: Testing Status
- [x] Tests pass
- [x] New tests added
- [x] Coverage adequate

## Overall Assessment
Excellent work for a first PR! The code is clean and well-tested. The performance suggestion is minor - the code works fine as-is.

**Status: LGTM** :shipit:

---

**Welcome to the project!** Feel free to reach out if you have questions about the codebase or development workflow.
```

---

## Key Takeaways

1. **Always start with positive feedback** - Recognition goes a long way
2. **Be specific with file:line references** - Makes issues easy to find
3. **Explain the "why"** - Help the author understand, not just fix
4. **Prioritize issues** - Not everything needs to block the PR
5. **Be kind** - Code review is about collaboration, not criticism
