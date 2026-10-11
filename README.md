# github-actions
my personal github actions.  be safe in the agentic age

## Security gates

Reusable workflows that give a repo the security gates in one job. A consumer calls them from its own workflow files; it does not copy the gate steps.

### security.yml caller

Save as `.github/workflows/security.yml` in the consumer. Replace `<sha>` with the full 40-hex commit SHA of the release you want and keep the `# vX.Y.Z` comment.

```yaml
name: Security

on:
  push:
    branches: [main]
  pull_request:
  schedule:
    - cron: "17 5 * * 1"

permissions: {}

jobs:
  security:
    name: security
    permissions:
      contents: read
      security-events: write # a caller covers every called job, even with codeql: false
    uses: redscaresu/github-actions/.github/workflows/security.yml@<sha> # vX.Y.Z
```

`security-events: write` is needed even with `codeql: false`, because a caller must grant every permission of every job it calls, the skipped ones included.

### scorecard.yml caller

Save as `.github/workflows/scorecard.yml` in the consumer.

```yaml
name: Scorecard

on:
  push:
    branches: [main]
  schedule:
    - cron: "41 5 * * 1"

permissions: {}

jobs:
  security:
    name: security
    permissions:
      contents: read
      id-token: write # publish the result to the OpenSSF API
    uses: redscaresu/github-actions/.github/workflows/scorecard.yml@<sha> # vX.Y.Z
```

This is the only file that grants `id-token: write`. It never goes in a workflow that runs on `pull_request`. It publishes only on a push or scheduled run on the default branch of a public repo.

### Inputs of security.yml

| Input | Type | Default | Meaning |
| --- | --- | --- | --- |
| `zizmor` | boolean | `true` | Run the zizmor audit of GitHub Actions workflows. |
| `gitleaks` | boolean | `true` | Run the gitleaks secret scan over the full history of the checked-out commit. |
| `govulncheck` | boolean | `true` | Run govulncheck over the Go module at the repo root (skipped without a go.mod). |
| `codeql` | boolean | `true` | Run CodeQL and upload its results to code scanning (needs code scanning on the repo). |
| `codeql-languages` | string | `go` | The one CodeQL language to analyse. |
| `dependency-review` | boolean | `true` | Run dependency review on pull requests (needs the repo's dependency graph on). |
| `dependency-review-fail-on` | string | `moderate` | The lowest advisory severity (low, moderate, high, critical) that fails dependency review. |

### Check names

With the job id `security`, the checks are:

- `security / zizmor`
- `security / gitleaks`
- `security / govulncheck`
- `security / codeql`
- `security / dependency-review`
- `security / scorecard` (from the scorecard.yml caller)

A skipped gate reports success.

- zizmor runs on push and pull request.
- gitleaks, govulncheck and codeql run on push, pull request and schedule.
- dependency-review runs on pull request only.

govulncheck skips its steps without a go.mod. CodeQL still runs without a go.mod: a repo with no Go code sets `codeql: false` or another `codeql-languages`.

Requirements:

- dependency-review needs the repo's dependency graph. On a private repo without it the gate gives a notice and skips; on a public repo it fails.
- codeql needs code scanning. A private consumer without it sets `codeql: false`.

### Files to copy

These are not reusable, so copy them from `templates/`. Each copy's header becomes `template: <name> @<version>`, where `<name>` is the templates/ filename and `<version>` is the tag copied from (`unreleased` before v1.0.0). Copies drift and nothing checks them.

- `dependabot.yml` → `.github/dependabot.yml`
- `gitleaks.toml` → `.gitleaks.toml`
- `SECURITY.md` → `SECURITY.md`, filling `<owner>`, `<repo>`, `<email>` and `<credentials>`
- `pre-commit` → `scripts/pre-commit`
- `hooks.mk` → the `hooks` target pasted into the Makefile, with `hooks` added to `.PHONY`, then run `make hooks`

The hooks.mk header is not carried.

## Versioning

- Tags are `vMAJOR.MINOR.PATCH`.
- MAJOR when a consumer must change its caller (new required permission, renamed input, dropped gate).
- MINOR for a new gate or input with a safe default.
- PATCH for pin bumps and fixes.
- Consumers pin the 40-hex commit SHA with the tag in a trailing `# vX.Y.Z` comment. There is no moving `v1`.
- A tag is cut by hand with `git tag -a` after a green dogfood run on main. There is no release workflow.

## Scorecard

REFUTED: Scorecard can publish from a workflow_call job, shown for an intra-repo call.

Run: https://github.com/redscaresu/github-actions/actions/runs/38005404874

Evidence: the Scorecard API (api.securityscorecards.dev and api.scorecard.dev) returns `"repo": {"name": "github.com/redscaresu/github-actions", "commit": "c64c92db35954eb9761ee51a8646a2a30300943f"}`, score 4.1, date 2026-10-09T23:38:36Z.
