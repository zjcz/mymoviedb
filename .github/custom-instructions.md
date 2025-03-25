### General

Rules:
-Use the Dart programming language.
-Use the Flutter framework.
-Use the latest stable version of Dart and Flutter.
-For any changes you make, summarize in the /changelog.md file.
-Use Riverpod for state management.
### UI

Rules:
-Make any UI you generate beautiful and user-friendly.

### Tests

Rules:
-Write unit tests for any code you generate.
-Write integration tests for any code you generate.
-If mocks are required, use the mockito library.
-Tests should be generated in the /test directory.
-Use the test directory structure to mirror the lib directory structure.
-Rather than mocking the provider we mock the database service the provider gets its data from, as advised in the Riverpod documentation https://riverpod.dev/docs/essentials/testing#mocking-notifiers
