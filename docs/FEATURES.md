# Features — bakerstack (Flutter app)

Read the index, then open only the entries you need. One entry per feature, each under 8 lines.
When this file passes about 300 lines, move stable entries to `docs/FEATURES_ARCHIVE.md` and keep their index rows.

| Feature | Status | Main files | Updated |
|---|---|---|---|
| [App shell & navigation](#app-shell) | Done | `lib/main.dart`, `screens/main_screen.dart`, `splash_screen.dart` | 2026-10-17 |
| [API services layer](#api-services) | In progress | `config/api_config.dart`, `services/api_service.dart`, `services/*_service.dart` | 2026-10-17 |
| [Auth & session](#auth-and-session) | In progress | `services/auth_service.dart`, `screens/login_screen.dart`, `register_screen.dart` | 2026-10-17 |
| [Products & home](#products-and-home) | Done | `screens/home_screen.dart`, `product_detail_screen.dart`, `services/product_service.dart` | 2026-10-17 |
| [Cart & wishlist](#cart-and-wishlist) | In progress | `services/cart_service.dart`, `wishlist_service.dart`, `screens/cart_screen.dart`, `wishlist_screen.dart` | 2026-10-17 |
| [Checkout, payment & orders](#checkout-payment-and-orders) | In progress | `screens/checkout_screen.dart`, `payment_screen.dart`, `order_*`, `services/order_service.dart` | 2026-10-17 |
| [Profile & addresses](#profile-and-addresses) | In progress | `screens/profile_screen.dart`, `edit_profile_screen.dart`, `delivery_addresses_screen.dart` | 2026-10-17 |
| [Business details](#business-details) | In progress | `screens/buisness_details_screen.dart` | 2026-10-17 |
| [Marketplace](#marketplace) | In progress | `screens/marketplace_*`, `create_listing_screen.dart`, `edit_listing_screen.dart`, `my_listing_screen.dart` | 2026-10-17 |
| [Notifications](#notifications) | In progress | `screens/notifications_screen.dart`, `services/notification_service.dart` | 2026-10-17 |
| [Static pages](#static-pages) | Done | `screens/about_us_screen.dart`, `contact_us_screen.dart`, `terms_privacy_screen.dart` | 2026-10-17 |
| Email verification | Planned | — | 2026-10-17 |
| Password reset / OTP | Planned | — | 2026-10-17 |
| Cloud image uploads | Planned | `image_picker` is a dependency; no upload flow | 2026-10-17 |
| Payment gateway | Planned | `payment_screen.dart` is UI only | 2026-10-17 |
| Order tracking | Planned | — | 2026-10-17 |
| Admin panel | Planned | — | 2026-10-17 |
| Rate limiting | Planned | backend | 2026-10-17 |
| Caching | Planned | `api_config.dart` has unused cache settings | 2026-10-17 |
| Secure token storage | Planned | replace `SharedPreferences` in `auth_service.dart` | 2026-10-17 |
| Real app id, name, release signing | Planned | `android/app/build.gradle.kts`, `ios/Runner` | 2026-10-17 |

---

### App shell
- **What:** Splash → login/register → main screen with tabs; named routes and a 404 page.
- **Where:** `lib/main.dart`, `lib/screens/main_screen.dart`, `splash_screen.dart`.
- **How:** Plain `MaterialApp` with `routes` + `onGenerateRoute` for detail screens. No `Provider` in the tree; services are singletons (`factory X() => _instance`).
- **Rules:** New screens get a named route in `main.dart`.
- **Tests:** `test/widget_test.dart` (5 tests, all failing: splash timers never settle, theme color changed). **Open:** fix tests.
- **Updated:** 2026-10-17

### API services
- **What:** One HTTP helper plus a service per feature; all paths in `ApiConfig`.
- **Where:** `lib/config/api_config.dart`, `lib/services/api_service.dart`, `lib/services/*_service.dart`.
- **How:** `ApiService.get/post/put/patch/delete(path, body, auth:)` returns `{success, data}`; base URL `http://10.0.2.2:8000`.
- **Rules:** Match the backend's real routes (`bakerstack-backend/docs/PROJECT_MAP.md`); no secrets in `ApiConfig`.
- **Tests:** None.
- **Open:** Paths that don't exist on the backend: `/auth/me`, `/auth/refresh`, `/profile/change-password`, `/profile/delete`, `POST /orders` (is `/orders/create`), `/addresses/default` (is `/addresses/default/address`), `DELETE /cart/{id}` (is `/cart/remove/{id}`), `PUT /cart/update` with body (is `/cart/update/{id}?quantity=`), `DELETE /wishlist/{id}` (is `/wishlist/remove/{id}`). Cart/wishlist add send JSON bodies; the backend expects query params.
- **Updated:** 2026-10-17

### Auth and session
- **What:** Login, register, logout, profile update, change password, delete account; session restore on start.
- **Where:** `lib/services/auth_service.dart`, `screens/login_screen.dart`, `register_screen.dart`, `splash_screen.dart`.
- **How:** Token + user JSON saved in `SharedPreferences`; `validateSession()` on start.
- **Rules:** Never log tokens or passwords; move the token to secure storage.
- **Tests:** None. **Open:** Login sends `phone`, the backend expects `phone_number` (`auth_service.dart:36`) → 422. `getCurrentUser`/`refreshToken`/`changePassword`/`deleteAccount` call missing endpoints.
- **Updated:** 2026-10-17

### Products and home
- **What:** Home feed with categories and products; product detail; add to cart/wishlist.
- **Where:** `screens/home_screen.dart`, `product_detail_screen.dart`, `services/product_service.dart`, `widgets/product_card.dart`.
- **How:** `GET /api/products` (+ filters), `GET /api/products/{id}`.
- **Tests:** None. **Open:** `lib/data/sample_products.dart` still present; `in_stock` filter isn't a backend param (`is_available`).
- **Updated:** 2026-10-17

### Cart and wishlist
- **What:** Cart list, add, update quantity, remove, clear; wishlist list/add/remove.
- **Where:** `services/cart_service.dart`, `wishlist_service.dart`, `screens/cart_screen.dart`, `wishlist_screen.dart`.
- **How:** Through `ApiService` with `auth: true`.
- **Tests:** None. **Open:** add/update/remove don't match backend routes (see API services).
- **Updated:** 2026-10-17

### Checkout, payment and orders
- **What:** Choose address, place order, payment screen, order history and detail, cancel.
- **Where:** `screens/checkout_screen.dart`, `payment_screen.dart`, `order_history_screen.dart`, `order_detail_screen.dart`, `services/order_service.dart`.
- **How:** `OrderService` posts to `ApiConfig.orders`; cancel uses `PATCH /orders/{id}/cancel` (matches backend).
- **Rules:** Never mark an order paid on the client; payment confirmation comes from the backend.
- **Tests:** None. **Open:** Create posts to `/api/orders` (backend: `/orders/create`); payment screen is UI only.
- **Updated:** 2026-10-17

### Profile and addresses
- **What:** View/edit profile; list, add, edit, delete, set default address.
- **Where:** `screens/profile_screen.dart`, `edit_profile_screen.dart`, `delivery_addresses_screen.dart`, `services/address_service.dart`.
- **How:** `/api/profile`, `/api/addresses/*`.
- **Tests:** None. **Open:** Default-address path mismatch; addresses have no lat/lng, which backend order placement needs.
- **Updated:** 2026-10-17

### Business details
- **What:** Form for business name, GSTIN, PAN, etc.
- **Where:** `screens/buisness_details_screen.dart` (file name misspelled).
- **How:** Calls `Provider.of<ApiService>(context)` (lines 48, 490) but no provider is registered, so it throws at runtime; the result is unused anyway. Data is not saved to the backend.
- **Tests:** None. **Open:** Wire to `/api/business-details/`; rename file in a separate change.
- **Updated:** 2026-10-17

### Marketplace
- **What:** Feed, listing detail, create, edit, my listings, mark sold.
- **Where:** `screens/marketplace_feed_screen.dart`, `marketplace_detail_screen.dart`, `create_listing_screen.dart`, `edit_listing_screen.dart`, `my_listing_screen.dart`, `services/marketplace_service.dart`.
- **How:** `/api/marketplace/listings*` (paths match the backend); feed/create/edit also use local data.
- **Tests:** None. **Open:** App conditions are `Excellent/Good/Fair/Poor`; backend accepts `like_new|good|fair|poor`. Edit screen not wired to the API. No image upload.
- **Updated:** 2026-10-17

### Notifications
- **What:** Notification list and unread badge.
- **Where:** `screens/notifications_screen.dart`, `services/notification_service.dart`.
- **How:** Local list; `NotificationService` only holds a count. Backend has no notifications API.
- **Updated:** 2026-10-17

### Static pages
- **What:** About us, contact us (phone, email, WhatsApp, website links), terms & privacy.
- **Where:** `screens/about_us_screen.dart`, `contact_us_screen.dart`, `terms_privacy_screen.dart`.
- **How:** `url_launcher` for `https://bakerstack.com`, `wa.me`, `tel:`, `mailto:`.
- **Open:** Contact form isn't sent anywhere; `Provider.of<ApiService>` at `contact_us_screen.dart:484` (and `payment_screen.dart:366`) throws because no provider is registered.
- **Updated:** 2026-10-17

---

<!--
TEMPLATE — copy below this line for a new feature, and add a row to the index table.

### Feature name
- **What:** One sentence on what it does for the user.
- **Where:** Main files.
- **How:** Key mechanism in one or two lines.
- **Rules:** Patterns or constraints the next agent must follow.
- **Tests:** Test file(s) and what they check, or "None".
- **Open:** Known gaps or follow-ups.
- **Updated:** YYYY-MM-DD
-->
