# Flink Cooks° — A Flink App Feature Demo

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Netlify](https://img.shields.io/badge/Netlify-00C7B7?style=for-the-badge&logo=netlify&logoColor=white)

A university project proposing and demonstrating a new **Flink Cooks°** feature for [Flink](https://goflink.com) — a rapid grocery delivery platform operating in Berlin, Germany.

---

## Live Demo

🌐 https://flinkcooks.netlify.app/#/home 

> Replace the link above with your actual Netlify URL

---

## About the Project

Flink delivers groceries in 10 minutes across major German cities. This project proposes a new feature called **Flink Cooks°** — a recipe hub that allows customers to:

- Browse curated 15-minute recipes
- Select and customise ingredients with quantity controls
- Toggle off pantry items they already own (reducing food waste)
- Add all required ingredients directly to their Flink cart
- Complete payment through multiple methods

This feature directly supports Flink's Supply Chain Management by increasing average basket size, reducing food waste through pantry toggling, and improving customer engagement through meal planning.

---

## Features

### Customer Features
- Firebase Authentication — secure login and registration
- **Flink Cooks° Tab** — browse recipe cards with real food images
- **Recipe Detail Page** — full ingredients list with tick/untick checkboxes and +/- quantity controls
- **Live Cart Calculation** — total price and item count updates in real time as ingredients are adjusted
- **Cart Tab** — view all selected recipes and ingredients grouped by recipe
- **Order Summary** — subtotal, delivery fee and grand total
- **Payment Screen** — Credit/Debit Card, PayPal, Google Pay, Apple Pay
- **Order Success Screen** — animated delivery confirmation with order number and estimated arrival
- **Cart Badge** — live item count badge on the cart navigation icon

### Role Based Access
| Role | Access |
|---|---|
| Customer | Home, Flink Cooks°, Cart, Payment |
| Hub Manager | Hub Inventory Dashboard |
| HQ Admin | Recipe Management Dashboard |

---

## Tech Stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform UI framework |
| Dart | Programming language |
| Firebase Auth | User authentication |
| Cloud Firestore | User data and role storage |
| GoRouter | Declarative navigation and role based routing |
| Provider | State management for authentication |
| Lottie | Delivery animation on order success screen |
| Netlify | Web deployment |

lib/
├── firebase_options.dart
├── main.dart
├── models/
│   └── user_model.dart
├── providers/
│   └── auth_provider.dart
├── router/
│   └── app_router.dart
├── theme/
│   └── app_theme.dart
├── widgets/
│   ├── flink_logo.dart
│   └── role_guard.dart
└── screens/
├── unauthorized_screen.dart
├── auth/
│   ├── login_screen.dart
│   └── register_screen.dart
├── home/
│   └── home_screen.dart
├── flinkcooks/
│   ├── flink_cooks_screen.dart
│   ├── recipes_data.dart
│   └── recipe_detail_screen.dart
├── cart/
│   ├── cart_screen.dart
│   └── cart_service.dart
├── payment/
│   ├── payment_screen.dart
│   └── order_success_screen.dart
├── hq_admin/
│   └── recipe_management_page.dart
└── hub_manager/
└── hub_inventory_page.dart

---

## App Navigation Flow
/login
├── /register
└── (on success)
├── HQ Admin     → /admin/recipes
├── Hub Manager  → /hub/inventory
└── Customer     → /home
├── Discover (coming soon)
├── Offers (coming soon)
├── Flink Cooks°
│     └── Recipe Detail
│           └── /payment
│                 └── /order-success
│                       └── /home
├── Cart
└── Profile (coming soon)

---

## Recipes Available

| Recipe | Category | Time |
|---|---|---|
| Avocado Toast | Breakfast | 15 min |
| Greek Salad | Mediterranean | 15 min |
| Margherita Pizza | Italian | 15 min |

---

## Key Technical Concepts

**CartService Singleton** — A single shared instance of the cart using the Singleton pattern with `ChangeNotifier`. Any screen that adds to or clears the cart automatically updates the badge count and tab index across the whole app.

**Role Based Routing** — GoRouter reads the user role from Firestore on login and redirects automatically. HQ Admins and Hub Managers never see the customer home screen and vice versa.

**Live Price Calculation** — Computed getters `_totalPrice` and `_totalItems` in the recipe detail screen recalculate every time `setState` is called — so the Add to Cart button always shows the correct live total.

**Responsive Layout** — The recipe grid automatically switches between 3 columns on mobile and 4 columns on web using `MediaQuery`, with different `childAspectRatio` values to prevent overflow on small screens.

**shouldResetTab Flag** — When an order is completed, `CartService.clear()` sets `shouldResetTab = true` and calls `notifyListeners()`. The HomeScreen listener detects this and resets the bottom navigation to the Discover tab before GoRouter navigates back to `/home`.

---

## SCM Relevance

This feature addresses several Supply Chain Management principles:

- **Demand Forecasting** — Recipe bundles create predictable ingredient demand patterns
- **Waste Reduction** — Pantry toggle allows customers to exclude items they already own, reducing over-ordering
- **Basket Size Optimisation** — Bundled recipe ingredients increase average order value
- **Customer Retention** — Meal planning integration increases repeat usage and customer loyalty
- **Inventory Visibility** — HQ Admin and Hub Manager dashboards provide role based visibility into stock and recipe management

---

## Getting Started

### Prerequisites
- Flutter SDK installed
- Firebase project set up
- `firebase_options.dart` configured via FlutterFire CLI

### Run locally

```bash
flutter pub get
flutter run
```

### Build for web

```bash
flutter build web --release
```

Then deploy the `build/web` folder to Netlify by drag and drop.

---

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.27.0
  firebase_auth: ^4.17.0
  cloud_firestore: ^4.15.0
  go_router: ^latest
  provider: ^latest
  lottie: ^latest
  http: ^1.2.0
  cupertino_icons: ^1.0.8
```

---

## Team
1. Ram Sri Karan Mylavarapu
2. Rajvardhan Anil Delekar
3. Stacia D'Silva Agusta

Built as part of an App Programming course at SRH University, Berlin.

---

## Disclaimer

This is a student demo project and is not affiliated with or endorsed by Flink GmbH. All Flink branding is used purely for educational demonstration purposes.
---

## Project Structure
