# Automated Tests Directory

This directory contains all automated tests for the OpenClaw project.

## Structure

```
tests/
├── README.md                 # This file
├── unit/                     # Unit tests
│   ├── backend/              # Backend unit tests (JUnit)
│   └── frontend/             # Frontend unit tests (Jest/Vitest)
├── integration/              # Integration tests
│   ├── api/                  # API integration tests
│   └── database/             # Database integration tests
├── e2e/                      # End-to-end tests (Playwright/Cypress)
│   ├── specs/                # Test specifications
│   └── fixtures/             # Test fixtures and data
└── performance/              # Performance tests (JMeter/k6)
    ├── scripts/              # Test scripts
    └── reports/              # Test reports
```

## Running Tests

### Unit Tests
```bash
# Backend
cd ../backend
mvn test

# Frontend
cd ../frontend
npm run test
```

### Integration Tests
```bash
cd tests/integration
./run-tests.sh
```

### E2E Tests
```bash
cd tests/e2e
npm install
npm run test
```

### Performance Tests
```bash
cd tests/performance
./run-performance-tests.sh
```

## CI/CD Integration

Tests are automatically run in the CI/CD pipeline:
- Unit tests: On every commit
- Integration tests: On pull requests
- E2E tests: Before production deployments
- Performance tests: Weekly and before major releases

## Test Coverage Requirements

- **Backend**: Minimum 80% code coverage
- **Frontend**: Minimum 70% code coverage
- **Critical paths**: 100% test coverage

## Reporting

Test reports are generated in:
- `backend/target/site/jacoco/` (Backend coverage)
- `frontend/coverage/` (Frontend coverage)
- `tests/e2e/reports/` (E2E reports)
- `tests/performance/reports/` (Performance reports)
