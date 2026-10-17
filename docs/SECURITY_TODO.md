# Security TODO — bakerstack (Flutter app)

Checklist for the project owner. Agents: do not run these against any database yourself; remind the user.
Findings and evidence are in `docs/SECURITY_AUDIT.md`. Database work is tracked in
`bakerstack-backend/docs/SECURITY_TODO.md`.

## 1. Supabase lockdown

The app does not talk to Supabase, but it ships against the same project, so check:

- [ ] **RLS check** (Supabase SQL editor); every row must be `true`:
  ```sql
  select tablename, rowsecurity from pg_tables where schemaname = 'public' order by tablename;
  ```
- [ ] **Enable RLS** on every backend table: `users`, `business_details`, `user_credit`, `credit_transactions`,
      `products`, `addresses`, `store_rooms`, `stock_inventory`, `stock_movements`, `orders`, `order_items`,
      `cart_items`, `wishlist_items`, `marketplace_listings`, `revoked_tokens` (SQL in the backend's SECURITY_TODO).
- [ ] **REST API test** with the anon key; must return `[]` or an error, never rows:
  ```bash
  curl "https://<project-ref>.supabase.co/rest/v1/users?select=id,email&limit=1" -H "apikey: <anon-key>" -H "Authorization: Bearer <anon-key>"
  ```
- [ ] **Security Advisor** (Supabase Dashboard → Advisors) shows no errors.
- [ ] **Secrets only in the backend `.env`.** Nothing secret in `lib/config/api_config.dart` or anywhere in `lib/`:
      the APK/IPA can be unpacked by anyone.
- [ ] **Search this repo for Supabase keys:** `supabase`, `anon`, `service_role`, `eyJ`. Audit result on 2026-10-17: none.
- [ ] **Rotate any key ever committed.** Check git history (`git log -p -S "<fragment>"`), including the old nested `lib/` layout.
- [ ] **Remove test credentials** from `lib/config/api_config.dart:392-400` (demo phones, emails, `password123`) and make
      sure those demo users don't exist in any shared or production database.

## 2. Planned features and the security work each needs

| Feature | Required security work |
|---|---|
| Payment gateway | Provider's official Flutter SDK with a publishable key only; order marked paid only by the backend after a verified webhook (signature + idempotency); never trust the app's "success" callback. |
| Admin panel | Server-side `get_current_admin` on every admin action plus an audit log; hiding admin screens is not protection. |
| Cloud image uploads (`image_picker`) | Upload via backend-issued signed URLs to a private bucket; server checks type (magic bytes) and size; strip EXIF location; show images through short-lived signed URLs. |
| Email verification & password reset / OTP | Abuse protection (CAPTCHA or device attestation); backend rate limits; single-use, expiring codes; same message whether or not the account exists. |
| Secure token storage | Move `auth_token` from `SharedPreferences` to Keychain/Keystore (e.g. `flutter_secure_storage`, ask before adding); clear on logout. |
| Production release | HTTPS-only backend URL (build-time config, not hardcoded); real `applicationId`/bundle id; release signing key kept out of git; strip debug `print`s; `--obfuscate --split-debug-info`. |

## 3. Before every merge

- [ ] Run `/security-review` in Claude Code on the branch.
- [ ] If the backend schema changed, re-run the RLS check and confirm every row is `true`.
- [ ] `flutter analyze` has no new errors or warnings; no new `print` of tokens, passwords or full responses.
