# Secure Coding Practices

### Dependency scanning and secret detection: 

We use GitGuardian to automatically detect secrets and credentials in the codebase 
before they reach production.

### Access control enforcement: 

Specify implements role-based access control (RBAC) to protect sensitive operations and 
data.

### Regular reviews and manual code audits: 

Security-sensitive parts of the system are reviewed by senior developers, although 
we do not yet have automated static analysis or a formal secure code review policy. 