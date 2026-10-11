# Security Policy

## Reporting a vulnerability

Please **do not** open a public GitHub issue for security vulnerabilities.
Instead, report privately via one of:

- GitHub's [private vulnerability reporting](https://github.com/redscaresu/github-actions/security/advisories/new) (preferred — keeps the entire thread off public timelines).
- Email: `ukashouri@gmail.com` with subject prefix `[security] github-actions:`.

Please include:

- A description of the issue and its impact.
- Steps to reproduce (or a proof-of-concept).
- Affected commit / version / branch.

## Handling of credentials

github-actions holds no credentials of its own: the repository has no
Actions secrets. Its workflows use only the run's `github.token`, limited by
each job's `permissions:` block, and the reusable `scorecard.yml` requests an
OIDC `id-token` only to publish its result to the OpenSSF API. If you find a
path where a token can leak into logs, output or committed files, treat it as
a security issue and report it privately as above.

A key seen on any public branch is rotated, never only removed.

## Maintainer review

GitHub's "require approvals" cannot be used with one maintainer (you cannot
approve your own PR), so the review rule is written down instead: **the owner
reads every diff touching `.github/`, `.gitleaks.toml`, `.golangci.yml` or
adding `#nosec` / `//nolint` / `//gosec:disable` / `zizmor: ignore` before
merging**, and a fork PR that touches them is not merged without that read.
