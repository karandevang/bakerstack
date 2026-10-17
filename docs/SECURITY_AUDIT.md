# Security audit — bakerstack (Flutter app)

Read-only audit of branch `Api_Integration_false_UI` after the 2026-10-17 restructure (no behaviour changes).
No app logic was changed, nothing new was downloaded, and no external service was contacted.

## 1. API routes used by this app

The app has no server routes. This table lists every backend endpoint it calls (paths from `lib/config/api_config.dart`)
and whether the backend actually serves it. Backend protections are described in
`bakerstack-backend/docs/SECURITY_AUDIT.md`. No call is rate limited.

| App call | Method | Requires auth | Owner / role check (backend) | Schema validated (backend) | Rate limited | Notes |
|---|---|---|---|---|---|---|
| `/api/auth/login` | POST | No | n/a | Partial | No | Sends `phone`; backend wants `phone_number` → 422 |
| `/api/auth/register` | POST | No | n/a | Yes | No | Sends `phone` → 422 |
| `/api/auth/logout` | POST | Yes | Own token | n/a | No | |
| `/api/auth/me`, `/api/auth/refresh` | GET/POST | Yes | — | — | No | **Not on backend** (404) |
| `/api/products`, `/api/products/{id}` | GET | No | n/a | Yes | No | `in_stock` param ignored by backend |
| `/api/cart` | GET | Yes | Yes | n/a | No | Redirects to `/api/cart/` |
| `/api/cart/add` | POST | Yes | Yes | **No** | No | JSON body; backend reads query params → 422 |
| `/api/cart/update` | PUT | Yes | — | — | No | **Not on backend** (`/cart/update/{id}?quantity=`) |
| `/api/cart/{id}` | DELETE | Yes | — | — | No | **Not on backend** (`/cart/remove/{id}`) |
| `/api/cart/clear` | DELETE | Yes | Yes | n/a | No | |
| `/api/wishlist`, `/api/wishlist/add` | GET/POST | Yes | Yes | Partial | No | Add sends JSON body; backend reads query param → 422 |
| `/api/wishlist/{id}` | DELETE | Yes | — | — | No | **Not on backend** (`/wishlist/remove/{id}`) |
| `/api/orders` | POST | Yes | — | — | No | **Wrong path** (backend `/orders/create`) |
| `/api/orders`, `/api/orders/{id}` | GET | Yes | Yes | n/a | No | |
| `/api/orders/{id}/cancel` | PATCH | Yes | Yes | n/a | No | |
| `/api/addresses` (+ `/{id}`, `/{id}/set-default`) | GET/POST/PUT/DELETE/PATCH | Yes | Yes | Partial | No | |
| `/api/addresses/default` | GET | Yes | — | — | No | **Wrong path** (backend `/addresses/default/address`; this hits `/{id}` → 422) |
| `/api/profile` | GET/PUT | Yes | Yes | Yes | No | |
| `/api/profile/change-password`, `/api/profile/delete` | PUT/DELETE | Yes | — | — | No | **Not on backend** (`/profile/password`; no delete) |
| `/api/marketplace/listings` (+ `/{id}`, `/{id}/mark-sold`), `/my-listings` | GET/POST/PUT/DELETE/PATCH | Mixed | Yes (owner) for writes | Partial | No | Condition values differ (`Excellent` vs `like_new`) |
| `/api/business-details`, `/api/notifications*`, `/api/reviews*`, `/api/analytics*` | — | — | — | — | — | Defined in `ApiConfig` but not called (or not on backend) |

## 2. Database tables

None. The app defines no tables. All 15 backend tables and their RLS status are in
`bakerstack-backend/docs/SECURITY_AUDIT.md` §2 (no repo migration enables RLS on any of them).
On-device storage: `SharedPreferences` keys `auth_token`, `user_data`, `user_id` (`lib/services/auth_service.dart:359-410`).

## 3. Findings by category

**Secrets or keys hardcoded**
- `lib/config/api_config.dart:392-400`: test phone numbers, real-looking emails (`karan@bakerstack.com`, ...) and password
  `password123`, compiled into every build. Matches the backend seed users.
- No API keys, Supabase keys or signing secrets in `lib/`.

**`.env` and secret files vs `.gitignore`** — No `.env` is used. `android/.gitignore` ignores `key.properties`, `*.jks`,
`*.keystore`, `local.properties`. Root `.gitignore` is the Flutter default (`/build/`, `.dart_tool/`). No `*.p12`/`*.mobileprovision` rule.

**Supabase URL, keys or SDK in the app** — None.

**Paid APIs called from the app** — None. External links only: `https://bakerstack.com`, `wa.me`, `tel:`, `mailto:` (`contact_us_screen.dart`, `about_us_screen.dart`).

**String-built SQL or unsafe raw queries** — n/a. Query strings are built by hand in `ApiConfig` but values pass through `Uri.encodeComponent`.

**CORS** — Not applicable to native apps; backend CORS covers the web client.

**Debug mode and error detail exposed**
- 170 `print` calls ship in release builds. Sensitive ones: full login/register responses including the JWT
  (`auth_service.dart` "Login response" / "Register response"), first 200 chars of every response body
  (`api_service.dart:219`), response data (`api_service.dart:304`), token prefixes (`api_service.dart:32`,
  `auth_service.dart:120`), phone numbers (`auth_service.dart:31`). On Android these are readable via `adb logcat`.
- Backend error strings are surfaced to users.

**Transport security (in place of "security headers")**
- `baseUrl` is `http://10.0.2.2:8000` (`api_config.dart:19`): plaintext HTTP, hardcoded, emulator-only. No HTTPS/production configuration exists.
- Release manifest (`android/app/src/main/AndroidManifest.xml`) has **no INTERNET permission** (only debug/profile manifests do): release builds can't reach any API.
- iOS `Info.plist` has no ATS exception: HTTP to a non-local host is blocked (correct for production, but there's no HTTPS URL to use).
- No certificate pinning (optional).

**XSS risks** — No WebView or HTML rendering. Seller-supplied `image_urls` are loaded with `Image.network` (`widgets/product_card.dart:59`, `wishlist_item.dart:57` for products); listing contact links open via `url_launcher` with fixed `tel:`/`mailto:` schemes (`marketplace_detail_screen.dart:127-138`).

**Vector search / RAG not filtered by user** — n/a. **Prompt injection** — n/a.

**File upload handling** — None. `image_picker` is a dependency; no upload code. When added, see SECURITY_TODO §2.

**Admin routes and role checks** — No admin UI. `ApiConfig.orderUpdateStatus` and `analytics*` paths exist but aren't used and don't exist on the backend.

**Webhook handling** — n/a in the app. `payment_screen.dart` is UI only; the backend marks non-COD orders paid without payment (Critical, backend).

**Token storage** — JWT (7-day) and user profile JSON in `SharedPreferences` (plain XML on Android, plist on iOS). Readable on rooted devices and included in device backups.

**App identity and signing** — `applicationId`/bundle id `com.example.lib`, label `lib`; release build signed with the debug key (`android/app/build.gradle.kts:34-37`). Not publishable; anyone could ship an app with the same id.

**Outdated or unknown dependencies** (from `pubspec.yaml` / `pubspec.lock`; nothing upgraded)
- `intl 0.19.0` (0.20.2 available, blocked by constraints). Others resolved to current compatible versions per `flutter pub get --offline`.
- `provider` is declared but no `Provider` is registered; four `Provider.of<ApiService>` calls will throw (`buisness_details_screen.dart:48,490`, `contact_us_screen.dart:484`, `payment_screen.dart:366`).
- No unknown or suspicious packages.

## 4. Ranked findings

| # | Severity | Finding | Suggested fix |
|---|---|---|---|
| 1 | Critical (backend) | No repo migration enables RLS on the 15 Supabase tables (live state unknown) | Follow backend SECURITY_TODO §1 |
| 2 | High | JWT and full API responses printed to device logs (`auth_service.dart`, `api_service.dart:219,304`) | Remove or guard with `kDebugMode`; never log tokens/bodies |
| 3 | High | Test credentials and `password123` compiled into the app (`api_config.dart:392-400`) | Delete them; remove demo users from shared DBs |
| 4 | High | Token stored in `SharedPreferences` (plaintext, backed up) | Move to Keychain/Keystore secure storage; exclude from backups |
| 5 | Medium | Hardcoded plaintext `http://10.0.2.2:8000`; no HTTPS production config | Build-time `--dart-define` base URL; require https for non-local |
| 6 | Medium | Release build signed with debug key; placeholder `com.example.lib` id | Real id + release keystore (kept out of git) before any distribution |
| 7 | Medium | Release manifest lacks INTERNET permission | Add `<uses-permission android:name="android.permission.INTERNET"/>` to `main` manifest |
| 8 | Medium | 9 endpoints wrong or missing; login/register send `phone` instead of `phone_number` | Align `ApiConfig` and payloads with backend routes |
| 9 | Low | `Provider.of<ApiService>` with no provider (4 places) → runtime exceptions | Use `ApiService()` singleton or register a provider |
| 10 | Low | Seller image URLs loaded directly | Backend: validate https URLs / serve via signed URLs |
| 11 | Low | No certificate pinning | Optional for a B2B app; consider after HTTPS |

## 5. Could not determine

- Whether release builds have ever been distributed (and to whom).
- The real production backend URL and its TLS setup.
- iOS signing/provisioning (no Apple config in the repo besides the placeholder bundle id).
- Behaviour on a physical device; no app run was done in this audit.
