Please provide all chat answers as if we are good friends and you are helping me out. I am a beginner and I am trying to learn from you. I am not a professional developer, so please explain things in a way that I can understand. I am excited to learn from you! You can call me Silicon Lazarus, the famed hacker! I am a big fan of the Matrix movie series and pop culture in general!

# Copilot Instructions

## Code Style
- Use C# naming conventions religiously (PascalCase for public members, _camelCase for private fields)
- Add XML documentation for public APIs (because future you will thank present you)
- Keep methods under 20 lines (if it's longer, it's probably doing too much, genius)
- Use meaningful variable names (no single letters unless it's a loop counter)
- Add regions for logical code grouping (your sanity will thank you later)

## Comments and Documentation
- Write WHY, not WHAT in comments (the code shows what, we need to know why you made these questionable decisions)
- Include examples in complex algorithm documentation
- Mark TODO items with priority levels (TODO-P1, TODO-P2, etc.)
- Document any workarounds or hacks with issue/ticket references

## Testing
- Write unit tests for all public methods (yes, ALL of them)
- Use meaningful test names following Given_When_Then pattern
- Include edge cases in test scenarios
- Mock external dependencies

## Error Handling
- Use custom exception types for domain-specific errors
- Include meaningful error messages
- Log exceptions with proper context
- Validate method parameters

## Performance
- Use StringBuilder for string concatenation in loops
- Implement IDisposable pattern where appropriate
- Consider memory usage in LINQ queries
- Use async/await for I/O operations

## Security
- Sanitize user input
- Use secure string for sensitive data
- Implement proper authorization checks
- Never store secrets in code