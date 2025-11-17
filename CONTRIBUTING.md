# Contributing to ChainCARE Protocol

Thank you for your interest in contributing to ChainCARE! This document provides guidelines and instructions for contributing to the project.

---

## 🚀 Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/yourusername/chaincare-protocol.git
   cd chaincare-protocol
   ```
3. **Add upstream remote**:
   ```bash
   git remote add upstream https://github.com/original-owner/chaincare-protocol.git
   ```

---

## 📝 Development Workflow

### 1. Create a Feature Branch

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/your-bug-fix
```

### 2. Make Your Changes

- **Contracts**: Make changes in `contracts/` directory
- **Frontend**: Make changes in `frontend/` directory
- **Tests**: Add tests in `tests/` directory
- **Documentation**: Update relevant `.md` files

### 3. Test Your Changes

```bash
# Test contracts
cd contracts
cargo test

# Test frontend
cd frontend
npm test

# Run linter
npm run lint
```

### 4. Commit Your Changes

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```bash
git commit -m "feat: add new medication reminder feature"
git commit -m "fix: resolve treasury yield calculation bug"
git commit -m "docs: update architecture documentation"
```

**Commit Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

### 5. Push and Create Pull Request

```bash
git push origin feature/your-feature-name
```

Then create a Pull Request on GitHub with:
- Clear title and description
- Reference to related issues (if any)
- Screenshots or demo videos (for UI changes)

---

## 📋 Coding Standards

### Rust (ink! Contracts)

- Follow [Rust Style Guide](https://doc.rust-lang.org/1.0.0/style/README.html)
- Use `cargo fmt` for formatting
- Use `cargo clippy` for linting
- Add documentation comments for public functions

```rust
/// Mint a new Health-SBT token for a patient.
///
/// # Arguments
/// * `to` - The patient's account ID
/// * `metadata` - JSON string containing patient health data
///
/// # Errors
/// Returns `Error::Unauthorised` if caller is not the owner
#[ink(message)]
pub fn mint(&mut self, to: AccountId, metadata: String) -> Result<(), Error> {
    // ...
}
```

### TypeScript/React (Frontend)

- Follow [React Style Guide](https://react.dev/)
- Use TypeScript for type safety
- Use functional components with hooks
- Follow ESLint rules

```typescript
// Good
const MedReminder: React.FC = () => {
  const [medication, setMedication] = useState<Medication | null>(null);
  
  const handleCheckIn = async () => {
    // ...
  };
  
  return (
    <div>
      {/* ... */}
    </div>
  );
};
```

---

## 🧪 Testing Guidelines

### Contract Tests

```rust
#[cfg(test)]
mod tests {
    use super::*;
    
    #[ink::test]
    fn test_mint_sbt() {
        // Arrange
        let accounts = default_accounts();
        let contract = HealthSbt::new(accounts.alice);
        
        // Act
        let result = contract.mint(accounts.bob, "metadata".to_string());
        
        // Assert
        assert!(result.is_ok());
    }
}
```

### Frontend Tests

```typescript
import { render, screen } from '@testing-library/react';
import { MedReminder } from './MedReminder';

describe('MedReminder', () => {
  it('renders medication reminder', () => {
    render(<MedReminder />);
    expect(screen.getByText('Take Medication')).toBeInTheDocument();
  });
});
```

---

## 📚 Documentation

### Code Documentation

- Add JSDoc/TSDoc comments for functions
- Add Rust doc comments for contract methods
- Update README.md if adding new features

### Architecture Documentation

- Update `docs/ARCHITECTURE.md` for system-level changes
- Add diagrams for complex flows
- Update API documentation

---

## 🐛 Reporting Bugs

### Before Submitting

1. Check if the bug already exists in [Issues](https://github.com/yourusername/chaincare-protocol/issues)
2. Test with the latest version from `main` branch
3. Gather information about your environment

### Bug Report Template

```markdown
**Describe the bug**
A clear and concise description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '...'
3. Scroll down to '...'
4. See error

**Expected behavior**
A clear and concise description of what you expected to happen.

**Screenshots**
If applicable, add screenshots to help explain your problem.

**Environment:**
- OS: [e.g. macOS 14.0]
- Browser: [e.g. Chrome 120]
- Node version: [e.g. 18.17.0]
- Rust version: [e.g. 1.75.0]

**Additional context**
Add any other context about the problem here.
```

---

## 💡 Feature Requests

### Feature Request Template

```markdown
**Is your feature request related to a problem?**
A clear description of the problem.

**Describe the solution you'd like**
A clear description of what you want to happen.

**Describe alternatives you've considered**
A clear description of alternative solutions or features.

**Additional context**
Add any other context or screenshots about the feature request.
```

---

## 🔒 Security Issues

**DO NOT** open a public issue for security vulnerabilities. Instead, email security@chaincare.io with:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

---

## ✅ Pull Request Checklist

Before submitting a PR, ensure:

- [ ] Code follows project style guidelines
- [ ] All tests pass (`cargo test`, `npm test`)
- [ ] Linter passes (`cargo clippy`, `npm run lint`)
- [ ] Documentation updated (if needed)
- [ ] Commit messages follow conventional commits
- [ ] PR description is clear and detailed
- [ ] No merge conflicts with `main` branch

---

## 🤝 Code Review Process

1. Maintainers will review your PR
2. Address any feedback or requested changes
3. Once approved, your PR will be merged to `main`
4. Thank you for contributing! 🎉

---

## 📞 Questions?

- Open a [Discussion](https://github.com/yourusername/chaincare-protocol/discussions)
- Join our Discord (coming soon)
- Email: hello@chaincare.io

---

<div align="center">

**Thank you for contributing to ChainCARE! 🙏**

</div>

