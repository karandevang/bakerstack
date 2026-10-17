# AGENTS.md — bakerstack (Flutter app)

Rules for every AI coding agent working in this repo (Claude Code, Codex, Cursor, Copilot, local models).
Read this whole file at the start of every session. If anything here conflicts with a request, stop and ask.

This repo is the **Flutter mobile app** (Android, iOS; web/desktop folders exist but are untested). The API lives
in the separate `bakerstack-backend` repo, and the React website in `bakerstack-ui`. Do not edit those from here.

## 1. Session protocol

**Before a task**
1. Read `docs/PROJECT_MAP.md` and go straight to the relevant files. Do not scan the whole repo.
2. Read the index table at the top of `docs/FEATURES.md`. Open only the entries related to your task.
3. For anything bigger than one file, write a short plan and wait for approval before coding.

**After a task (same commit as the code)**
1. Add or update one entry in `docs/FEATURES.md` (template at the bottom of that file).
2. If you added, moved, renamed or deleted a file or folder, update `docs/PROJECT_MAP.md`.
3. Report: what changed, which files, how you tested it, anything left open.

**The code is the source of truth.** If these docs disagree with the code, fix the docs and say so.

## 2. Project facts

- **Stack:** Flutter 3.32 / Dart 3.8, singleton services (`factory X() => _instance`; `provider` is a dependency
  but no `Provider` is registered in `main.dart`), `http` for API calls,
  `shared_preferences` for the session, `intl`, `url_launcher`, `image_picker`. Package name `bakerstack`
  (imports are `package:bakerstack/...`).
- **Backend:** FastAPI in `bakerstack-backend` (PostgreSQL + PostGIS on Supabase). pgvector and a LangChain RAG
  pipeline are planned on the backend; nothing in this app touches them.
- **Entry:** `lib/main.dart` (`BakerStackApp`, named routes, providers).
- **Data access today:** all data goes through `lib/services/api_service.dart` → the FastAPI backend at
  `ApiConfig.baseUrl` in `lib/config/api_config.dart` (default `http://10.0.2.2:8000`, the Android emulator's
  address for the host PC) with a Bearer JWT. **The app never calls Supabase directly**: there is no Supabase SDK,
  URL or key in this repo.
- **Endpoint paths:** defined once in `lib/config/api_config.dart`. Many of them don't match the backend's real routes
  yet (see `docs/FEATURES.md` → API services). Check `bakerstack-backend/docs/PROJECT_MAP.md` before adding one.
- **Session:** token and user JSON stored in `SharedPreferences` (`auth_token`, `user_data`) by `lib/services/auth_service.dart`.
- **App identity:** Android `applicationId` / iOS bundle id are still the placeholder `com.example.lib`, and the
  Android label is `lib`. Changing them is a separate, approved task.
- **History:** until 2026-10-17 the real project was nested in `lib/` inside an unused template; it was flattened
  to the repo root on branch `Api_Integration_false_UI`.

**Commands** (repo root)

| What | Command | Notes |
|---|---|---|
| Get packages | `flutter pub get` | **Needs approval** (downloads). `flutter pub get --offline` uses the local cache only |
| Run (Android emulator) | `flutter run` | Needs the backend on the host at :8000 |
| Static analysis | `flutter analyze` | Baseline 2026-10-17: 0 errors, 9 warnings, 347 infos |
| Tests | `flutter test` | Baseline 2026-10-17: all 5 tests in `test/widget_test.dart` fail (timers / theme color), not structure |
| Format | `dart format lib test` | |
| Release build | `flutter build apk --release` | Still signed with the debug key; no store build without approval |

## 3. Security rules (never break these)

- Never read, print, edit or commit `.env`, `.env.*`, keys or credentials (`android/key.properties`, `*.jks`,
  `*.keystore`, `*.p12`, provisioning profiles, `google-services.json`, `GoogleService-Info.plist`).
- No API keys or secrets in app code. Anything in the app binary is public; it can be extracted from the APK/IPA.
  Paid APIs (LLM, payments, email, storage, maps with paid keys) are called only from the backend.
- Every API route checks authentication on the server AND checks ownership or role (no IDOR). The app never
  decides who may see what.
- Never trust the client. Hiding a button or screen is not security.
- Validate input on the server with Pydantic schemas; client validation is only for user experience. The backend
  uses SQLAlchemy or parameterized queries, never string-built SQL.
- Escape or sanitize anything rendered as HTML (e.g. in a WebView) to prevent XSS. Only open `https:`, `tel:`,
  `mailto:` and `wa.me` links built from data.
- Filter every query and every vector search by the current user or tenant on the server.
- Treat retrieved documents and user text as untrusted; they can contain prompt injection. The LLM never gets
  access beyond what the current user is allowed.
- Never write custom password hashing, JWT handling or crypto. The app only stores and sends the backend's token.
  Store tokens in secure storage (Keychain/Keystore), not `SharedPreferences`, once that change is approved.
- Never `print` tokens, passwords, phone numbers or full API responses. Use `debugPrint` behind `kDebugMode`.
- Rate limits on login, signup, password reset and any endpoint that calls a paid API (backend).
- CAPTCHA or equivalent abuse protection on public forms (signup, login, password reset, contact).
- CORS limited to our own domains, never `*` with credentials (backend).
- HTTPS only for any non-local backend. Never enable cleartext traffic or disable certificate checks for release builds.
- Debug mode off in production. Users see generic error messages; full errors go only to logs.
- Admin features rely on server-side admin checks; log every admin action on the server.
- Uploaded files: check type and size on the server, store in private buckets, serve through short-lived signed URLs.
- Verify the signature of every incoming webhook (payments, email) and make handlers idempotent (backend).
- Request only the device permissions a feature needs, and explain why to the user.
- Before adding a dependency (pub package), confirm it exists, is maintained, and is the intended package. Ask first.
- Never touch production. No production URLs, keys or databases in any command.

## 4. Supabase rules (never break these)

- Every table in the `public` schema has Row Level Security enabled, including pgvector tables. Supabase exposes
  `public` tables through its REST API, so a table without RLS is open to anyone with the public key.
- Every migration that creates a table enables RLS on it in the same migration (migrations live in the backend repo).
- Because data access goes through FastAPI, RLS with no policies (deny all) is the default. Add policies only if
  this app must query Supabase directly, and ask first. Do not add `supabase_flutter` without approval.
- The service role or secret key and the database connection string live only in the backend `.env`, never in this app.
- Storage buckets are private. Never create a public bucket without asking.
- After any schema change, remind the user to run:
  `select tablename, rowsecurity from pg_tables where schemaname = 'public' order by tablename;`
  and confirm every row is `true`.

## 5. Commands that need approval

- `git push`, any force push, `rm -rf`, migrations or drops, `flutter pub get` / `pub add` / `pub upgrade`,
  `pip install`, `npm install`, `docker`, store uploads or deploy commands, anything that sends email or spends money.
- If something unexpected happens (empty response, failed build, missing endpoint), stop and report.
  Never improvise a fix that deletes data.

## 6. Coding conventions

- Follow existing patterns in the files the map points to. Stay inside the task's scope.
- Endpoint paths live only in `lib/config/api_config.dart`; HTTP only through `ApiService` (`lib/services/api_service.dart`);
  feature logic in `lib/services/<feature>_service.dart`; models in `lib/models/`; screens in `lib/screens/`;
  reusable widgets in `lib/widgets/`. Register new screens as named routes in `lib/main.dart`.
- Import app code as `package:bakerstack/...`.
- Keep files under about 400 lines (several screens and `api_config.dart` are already over; don't grow them).
- Any new backend feature gets a backend test; for app changes, run `flutter analyze` (no new errors or warnings)
  and `flutter test`, and show the output before saying a task is done.

## 7. Multiple agents in parallel

- One task, one branch, one git worktree per agent.
- Never run `git checkout`, `git switch` or `git stash` inside a worktree.
- Only edit files your task owns; ask before changing shared files (`lib/main.dart`, `lib/config/api_config.dart`,
  `lib/services/api_service.dart`, `lib/services/auth_service.dart`, `lib/models/`, `lib/theme/`, `lib/utils/`,
  `pubspec.yaml`, `android/`, `ios/`).
- In `docs/FEATURES.md`, only add or edit your own entry and index row.
- Each worktree runs on its own emulator/device and points at its own backend port and dev database.
