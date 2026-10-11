<!-- template: SECURITY.md -->
# Security Policy

## Reporting a vulnerability

Please **do not** open a public GitHub issue for security vulnerabilities.
Instead, report privately via one of:

- GitHub's [private vulnerability reporting](https://github.com/<owner>/<repo>/security/advisories/new) (preferred — keeps the entire thread off public timelines).
- Email: `<email>` with subject prefix `[security] <repo>:`.

Please include:

- A description of the issue and its impact.
- Steps to reproduce (or a proof-of-concept).
- Affected commit / version / branch.

## Handling of credentials

<credentials>

A key seen on any public branch is rotated, never only removed.

## Maintainer review

GitHub's "require approvals" cannot be used with one maintainer (you cannot
approve your own PR), so the review rule is written down instead: **the owner
reads every diff touching `.github/`, `.gitleaks.toml`, `.golangci.yml` or
adding `#nosec` / `//nolint` / `//gosec:disable` / `zizmor: ignore` before
merging**, and a fork PR that touches them is not merged without that read.
