# Creates the Phase 1 commits on a new branch. Run from the project root AFTER:
#   flutter pub get ; flutter gen-l10n ; flutter analyze ; flutter test
$ErrorActionPreference = 'Stop'

function Step([string[]]$paths, [string]$msg) {
  git add -- @paths
  if ($LASTEXITCODE -ne 0) { throw "git add failed: $msg" }
  git commit -m $msg
  if ($LASTEXITCODE -ne 0) { throw "git commit failed: $msg" }
}

git checkout -b phase-1-foundation
if ($LASTEXITCODE -ne 0) { throw "could not create branch" }

Step @('android','ios','macos','linux') 'chore(platform): application id tn.gobarber.app, app labels, lower Gradle memory'
Step @('pubspec.yaml','pubspec.lock','l10n.yaml','.gitignore','env','lib/l10n') 'chore(deps): flutter_localizations, dev dependencies, fr/ar l10n config and ARB files, env template'
Step @('lib/core','lib/models','lib/data') 'feat(foundation): core config/errors/TND+date formatting/theme/availability, password-free models, repository interfaces and in-memory implementations'
Step @('lib') 'refactor(ui): per-concern providers, role shells (customer/employee/owner/platformAdmin), localized RTL-ready screens'
Step @('test','README.md','scripts') 'test: replace counter test, add unit and widget tests, update README'
git log --oneline -6
