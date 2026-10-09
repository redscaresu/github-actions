# github-actions
my personal github actions.  be safe in the agentic age

## Scorecard

REFUTED: Scorecard can publish from a workflow_call job, shown for an intra-repo call.

Run: https://github.com/redscaresu/github-actions/actions/runs/38005404874

Evidence: the Scorecard API (api.securityscorecards.dev and api.scorecard.dev) returns `"repo": {"name": "github.com/redscaresu/github-actions", "commit": "c64c92db35954eb9761ee51a8646a2a30300943f"}`, score 4.1, date 2026-10-09T23:38:36Z.

The cross-repo case is proven later by public-only-gates' API check on itsm.
