# Flutter Project Instructions

## Project

This is a Flutter application.

Use the existing project structure and conventions when implementing features.

Do not introduce a new architecture unless explicitly requested.

## Flutter Version

Use the Flutter SDK version configured by the project.

Current CI version:

Flutter 3.47.6

## Code Quality

Before creating a pull request:

1. Run `flutter pub get`
2. Run `flutter analyze`
3. Run `flutter test`

Do not create a PR if tests are failing.

## Implementation Rules

- Prefer existing reusable widgets and utilities.
- Follow the existing naming conventions.
- Keep widgets focused and maintainable.
- Avoid unnecessary dependencies.
- Do not modify unrelated files.
- Do not remove existing tests unless required by the ticket.

## Testing

Every new feature should include appropriate tests.

For business logic:
- Add unit tests.

For widgets:
- Add widget tests where appropriate.

Tests should cover:
- Success scenarios
- Failure scenarios
- Validation
- Edge cases

## Git

Create a feature branch using:

`feature/<JIRA-TICKET>-<short-description>`

Example:

`feature/SCRUM-1-login-screen`

Commit messages should follow:

`feat(SCRUM-1): implement login screen`

## Pull Requests

Every PR should contain:

### Summary
What was implemented.

### Changes
Important files and implementation details.

### Tests
Commands executed and their results.

### Jira
The related Jira ticket.

## Important Safety Rules

Do not:

- Modify production secrets.
- Commit credentials or API keys.
- Modify GitHub Actions permissions without explicit approval.
- Modify unrelated functionality.
- Merge your own pull request.
- Push directly to `main`.

Always keep changes limited to the Jira ticket.
