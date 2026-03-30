## ELITE FIT — Gym Fitness Tracker App
## 📍 Elite Fit Pune, Katraj | Theme: RED · WHITE · BLACK


## ⚠️ IMPORTANT — EXISTING PROJECT NOTICE

The Flutter project is **already created** using VS Code Flutter extension.In flutter_application
The basic structure (`android/`, `ios/`, `lib/`, `pubspec.yaml`) already exists.

**DO NOT run `flutter create` again.**

Only do the following:
1. **Replace** `lib/` folder contents with the new screens/code
2. **Update** `pubspec.yaml` to add required dependencies
3. **Add** `assets/images/` folder and register in pubspec
4. Run `flutter pub get` after updating pubspec

---

## 📁 TARGET STRUCTURE — Inside Existing Project

```
lib/
├── main.dart                          ← update this
├── core/
│   ├── theme/
│   │   ├── app_colors.dart            ← Elite Fit RED/WHITE/BLACK palette
│   │   ├── app_text_styles.dart       ← Poppins typography
│   │   └── app_theme.dart             ← ThemeData (LIGHT theme base)
│   ├── constants/
│   │   ├── api_constants.dart
│   │   └── image_constants.dart       ← all Unsplash gym image URLs
│   ├── services/
│   │   ├── api_service.dart           ← Dio + interceptors
│   │   ├── auth_service.dart
│   │   └── storage_service.dart       ← flutter_secure_storage
│   └── widgets/
│       ├── red_button.dart            ← primary CTA button (red gradient)
│       ├── elite_input_field.dart     ← white/light input field
│       ├── hero_image_card.dart       ← image + overlay + content stack
│       ├── workout_card.dart          ← workout list card with image
│       ├── macro_ring_card.dart       ← circular progress for macros
│       └── bottom_nav_bar.dart        ← Elite Fit styled bottom nav
├── features/
│   ├── splash/
│   │   └── splash_screen.dart
│   ├── auth/
│   │   ├── welcome_screen.dart
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── onboarding/
│   │   ├── onboarding_controller.dart
│   │   ├── step_gender.dart
│   │   ├── step_age.dart
│   │   ├── step_height.dart
│   │   ├── step_weight.dart
│   │   ├── step_activity.dart
│   │   ├── step_goal_type.dart
│   │   ├── step_target_weight.dart
│   │   ├── step_weekly_rate.dart
│   │   ├── step_calories.dart
│   │   ├── step_macros.dart
│   │   └── step_water.dart
│   ├── dashboard/
│   │   ├── dashboard_screen.dart
│   │   └── widgets/
│   │       ├── calorie_ring_widget.dart
│   │       ├── macro_summary_row.dart
│   │       ├── water_tracker_widget.dart
│   │       ├── food_log_card.dart
│   │       ├── challenge_banner.dart
│   │       ├── workout_plan_card.dart
│   │       └── ai_input_bar.dart
│   ├── weight/
│   │   └── weight_screen.dart
│   ├── goals/
│   │   └── goals_screen.dart
│   └── profile/
│       └── profile_screen.dart
assets/
└── images/
    └── elite_fit_logo.png             ← placeholder, can be replaced
```

---

## 🎨 ELITE FIT DESIGN SYSTEM

### Brand Identity (from Elite Fit Pune Instagram @elitefitpune)
- **Gym Name:** ELITE FIT
- **Tagline:** "Elite Training. Elite Results."
- **Location:** Katraj, Pune
- **Brand Colors:** Bold Red + Pure White + Deep Black
- **Feel:** Energetic, bold, professional, premium gym brand

---

### 🔴 Color Palette (`app_colors.dart`)

```dart
class AppColors {

  // ─── PRIMARY BRAND COLORS (Elite Fit Red/White/Black) ──────────────────────
  static const Color red          = Color(0xFFE8191B);   // Elite Fit signature red
  static const Color redDark      = Color(0xFFC01215);   // darker red for gradients
  static const Color redLight     = Color(0xFFFF3335);   // lighter red for hover/glow
  static const Color redGlow      = Color(0x33E8191B);   // red at 20% — glow effects

  // ─── BACKGROUNDS ────────────────────────────────────────────────────────────
  static const Color scaffoldBg   = Color(0xFFF5F5F5);   // light gray white scaffold
  static const Color white        = Color(0xFFFFFFFF);   // pure white — cards
  static const Color cardBg       = Color(0xFFFFFFFF);   // white cards on light bg
  static const Color cardBgDark   = Color(0xFF1A1A1A);   // dark cards (for contrast sections)
  static const Color inputBg      = Color(0xFFF0F0F0);   // light gray inputs
  static const Color divider      = Color(0xFFE0E0E0);   // light divider

  // ─── BLACK TONES ────────────────────────────────────────────────────────────
  static const Color black        = Color(0xFF0D0D0D);   // near-black
  static const Color darkGray     = Color(0xFF1A1A1A);   // section backgrounds
  static const Color medGray      = Color(0xFF4A4A4A);   // body text
  static const Color lightGray    = Color(0xFF9A9A9A);   // captions

  // ─── TEXT ────────────────────────────────────────────────────────────────────
  static const Color textPrimary  = Color(0xFF0D0D0D);   // near black — main text
  static const Color textSecond   = Color(0xFF4A4A4A);   // dark gray — subtitles
  static const Color textMuted    = Color(0xFF9A9A9A);   // light gray — captions
  static const Color textOnRed    = Color(0xFFFFFFFF);   // white text on red bg
  static const Color textOnDark   = Color(0xFFFFFFFF);   // white text on dark bg

  // ─── MACRO COLORS ────────────────────────────────────────────────────────────
  static const Color protein      = Color(0xFF2979FF);   // blue
  static const Color carbs        = Color(0xFFE8191B);   // red (matches brand)
  static const Color fat          = Color(0xFF00C853);   // green

  // ─── STATUS ──────────────────────────────────────────────────────────────────
  static const Color success      = Color(0xFF00C853);
  static const Color warning      = Color(0xFFFFB300);
  static const Color danger       = Color(0xFFE8191B);   // same as brand red

  // ─── GRADIENTS ───────────────────────────────────────────────────────────────
  // Primary CTA gradient — red to dark red
  static const LinearGradient redGradient = LinearGradient(
    colors: [Color(0xFFE8191B), Color(0xFFC01215)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  // Dark section gradient — for hero areas
  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF0D0D0D), Color(0xFF2A2A2A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  // Image overlay — dark fade on gym photos
  static const LinearGradient imageOverlayDark = LinearGradient(
    colors: [Color(0xDD000000), Color(0x44000000)],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
  // Image overlay — red-tinted for brand cards
  static const LinearGradient imageOverlayRed = LinearGradient(
    colors: [Color(0xDDE8191B), Color(0x55C01215)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  // White card shadow
  static List<BoxShadow> cardShadow = [
    BoxShadow(color: Color(0x14000000), blurRadius: 16, offset: Offset(0, 4)),
  ];
  // Red glow shadow — for active elements
  static List<BoxShadow> redShadow = [
    BoxShadow(color: Color(0x44E8191B), blurRadius: 20, spreadRadius: 2),
  ];
}
```

---

### Typography (`app_text_styles.dart`)
Use **Google Font: "Poppins"** for all text.

```dart
// Display — calorie numbers, hero stats (bold, black or white)
static TextStyle display   = Poppins(size: 48, w800, black)
static TextStyle displayWh = Poppins(size: 48, w800, white)   // on dark bg

// H1 — screen titles
static TextStyle h1        = Poppins(size: 28, w700, black)
static TextStyle h1White   = Poppins(size: 28, w700, white)

// H2 — section headers
static TextStyle h2        = Poppins(size: 22, w700, black)
static TextStyle h2White   = Poppins(size: 22, w700, white)

// H3 — card titles
static TextStyle h3        = Poppins(size: 18, w600, black)
static TextStyle h3White   = Poppins(size: 18, w600, white)

// Body
static TextStyle body      = Poppins(size: 15, w400, darkGray #4A4A4A)
static TextStyle bodyWhite = Poppins(size: 15, w400, white)

// Caption
static TextStyle caption   = Poppins(size: 12, w400, lightGray #9A9A9A)
static TextStyle captionWh = Poppins(size: 12, w400, white)

// Label Red — active elements, badges
static TextStyle labelRed  = Poppins(size: 13, w600, red #E8191B)
static TextStyle labelWhite= Poppins(size: 13, w600, white)
```

---

### Global Theme Rules (`app_theme.dart`)

```dart
ThemeData eliteFitTheme = ThemeData(
  brightness: Brightness.light,          // LIGHT theme (white background)
  scaffoldBackgroundColor: Color(0xFFF5F5F5),
  primaryColor: Color(0xFFE8191B),       // Elite red

  // AppBar: white background, black title, red accent
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Color(0xFF0D0D0D)),
    titleTextStyle: Poppins(size: 20, w700, black),
  ),

  // Cards: white with soft shadow
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    shadowColor: Color(0x14000000),
  ),

  // Input fields: light gray fill, red focus border
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFF0F0F0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Color(0xFFE0E0E0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Color(0xFFE8191B), width: 2),
    ),
    hintStyle: TextStyle(color: Color(0xFF9A9A9A)),
  ),

  // Elevated buttons: red gradient
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFE8191B),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      minimumSize: Size(double.infinity, 56),
      textStyle: Poppins(size: 16, w600),
    ),
  ),

  // Bottom nav: white bg, red selected, gray unselected
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Color(0xFFE8191B),
    unselectedItemColor: Color(0xFF9A9A9A),
    showUnselectedLabels: false,
    elevation: 12,
  ),
);
```

---

## 🖼️ IMAGE STRATEGY — HIGH QUALITY FITNESS IMAGES

**CRITICAL RULE:** All images must be **bright, energetic, high-contrast** gym photos — matching Elite Fit's bold red/white brand. NOT dark moody. Use **CachedNetworkImage** from the `cached_network_image` package for every image with shimmer loading.

Error fallback widget:
```dart
Container(
  color: Color(0xFFF0F0F0),
  child: Icon(Icons.fitness_center, color: Color(0xFFE8191B), size: 32),
)
```

Shimmer placeholder:
```dart
Shimmer.fromColors(
  baseColor: Color(0xFFE0E0E0),
  highlightColor: Color(0xFFF5F5F5),   // light shimmer — white theme
  child: Container(color: Color(0xFFE0E0E0)),
)
```

### Image Constants (`image_constants.dart`)

```dart
class AppImages {

  // ─── SPLASH & AUTH ─────────────────────────────────────────────────────────

  // Welcome screen hero — bright modern gym interior, weights visible
  static const String welcomeBg =
    'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=1200&q=90&fit=crop';

  // Auth header — well-lit gym floor with equipment, energetic
  static const String authBg =
    'https://images.unsplash.com/photo-1540497077202-7c8a3999166f?w=1200&q=90&fit=crop';

  // ─── ONBOARDING ────────────────────────────────────────────────────────────

  // Male athlete — strong, well-lit, white background or gym setting
  static const String onboardingMale =
    'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=900&q=90&fit=crop';

  // Female athlete — confident, strong pose, gym setting
  static const String onboardingFemale =
    'https://images.unsplash.com/photo-1594381898411-846e7d193883?w=900&q=90&fit=crop';

  // Person running — bright outdoor or treadmill, energetic
  static const String activityBanner =
    'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?w=900&q=90&fit=crop';

  // Healthy food — colourful meal prep, macros visible
  static const String macroMeal =
    'https://images.unsplash.com/photo-1547592180-85f173990554?w=900&q=90&fit=crop';

  // Water / hydration — clean, bright, refreshing look
  static const String hydrationImg =
    'https://images.unsplash.com/photo-1548839140-29a749e1cf4d?w=900&q=90&fit=crop';

  // Weight measurement — scale, tape measure, bright white surface
  static const String weightGoalImg =
    'https://images.unsplash.com/photo-1502741338009-cac2772e18bc?w=900&q=90&fit=crop';

  // ─── DASHBOARD BANNERS ─────────────────────────────────────────────────────

  // Challenge banner — person working out intensely in bright gym
  static const String challengeBanner =
    'https://images.unsplash.com/photo-1549576490-b0b4831ef60a?w=1000&q=90&fit=crop';

  // Progress card — fit woman doing cardio, bright gym
  static const String progressCard =
    'https://images.unsplash.com/photo-1518310383802-640c2de311b2?w=800&q=90&fit=crop';

  // Zumba / group fitness — matches Elite Fit Zumba classes (seen on Instagram)
  static const String groupFitness =
    'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=800&q=90&fit=crop';

  // ─── WORKOUT PLAN CARDS ────────────────────────────────────────────────────

  // Lower body — squats, legs workout, bright gym
  static const String lowerBodyWorkout =
    'https://images.unsplash.com/photo-1574680096145-d05b474e2155?w=800&q=90&fit=crop';

  // Upper body — bench press, chest workout
  static const String upperBodyWorkout =
    'https://images.unsplash.com/photo-1581009137042-c552e485697a?w=800&q=90&fit=crop';

  // Full body — functional fitness, bright setting
  static const String fullBodyWorkout =
    'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=800&q=90&fit=crop';

  // Cardio — treadmill or running, well-lit
  static const String cardioWorkout =
    'https://images.unsplash.com/photo-1538805060514-97d9cc17730c?w=800&q=90&fit=crop';

  // Deadlift — matches Elite Fit's own deadlift post on Instagram
  static const String deadliftWorkout =
    'https://images.unsplash.com/photo-1526506118085-60ce8714f8c5?w=800&q=90&fit=crop';

  // ─── TRAINER / GOALS HERO ──────────────────────────────────────────────────

  // Trainer hero — athletic male trainer, confident pose, bright bg
  static const String trainerHero =
    'https://images.unsplash.com/photo-1567013127542-490d757e51fc?w=1000&q=90&fit=crop';

  // ─── WORKOUT THUMBNAILS (small 48–80px square) ─────────────────────────────

  static const String pushUpThumb =
    'https://images.unsplash.com/photo-1598971639058-bb4f853d4d76?w=400&q=85&fit=crop';
  static const String fullBodyThumb =
    'https://images.unsplash.com/photo-1544033527-b192daee1f5b?w=400&q=85&fit=crop';
  static const String hardTrainThumb =
    'https://images.unsplash.com/photo-1550259979-ed79b48d2a30?w=400&q=85&fit=crop';
  static const String zumbaThumb =
    'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=400&q=85&fit=crop';

  // ─── FOOD LOG THUMBNAILS ────────────────────────────────────────────────────

  static const String breakfastImg =
    'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?w=400&q=85&fit=crop';
  static const String lunchImg =
    'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=400&q=85&fit=crop';
  static const String proteinShakeImg =
    'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=400&q=85&fit=crop';
}
```

---

## 📦 PUBSPEC.YAML — Update Existing File

Add these dependencies to the existing `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # HTTP
  dio: ^5.4.0

  # State management
  provider: ^6.1.1

  # Secure storage (tokens)
  flutter_secure_storage: ^9.0.0
  shared_preferences: ^2.2.2

  # Fonts
  google_fonts: ^6.1.0

  # Charts
  fl_chart: ^0.67.0

  # Circular progress
  percent_indicator: ^4.2.3

  # Audio recording
  record: ^5.1.0

  # Permissions
  permission_handler: ^11.3.0

  # Animations
  lottie: ^3.0.0

  # SVG
  flutter_svg: ^2.0.9

  # Shimmer loading
  shimmer: ^3.0.0

  # Page indicator
  smooth_page_indicator: ^1.1.0

  # Cached images (REQUIRED for all network images)
  cached_network_image: ^3.3.1

flutter:
  uses-material-design: true
  assets:
    - assets/images/
```

Run: `flutter pub get`

---

## 🔐 AUTH FLOW

```
main.dart → SplashScreen (2s)
     ↓
flutter_secure_storage → check 'access_token'
     ↓ No token              ↓ Token found
  WelcomeScreen          GET /auth/me
                              ↓ fail → WelcomeScreen
                         GET /profile/me
                         ↓ 404          ↓ 200
                    OnboardingScreen  DashboardScreen

401 anywhere → POST /auth/refresh → retry
Refresh fail → clear storage → WelcomeScreen
```

API Base: `http://localhost:8000`
Auth header: `Authorization: Bearer {access_token}`

---

## 🔴 ELITE FIT UI — DESIGN PATTERN

### The Elite Fit Visual Language (study these rules carefully):

1. **White cards on light gray background** — clean, professional gym feel
2. **Red (`#E8191B`) is the ONLY accent color** — buttons, progress bars, active states, borders, badges
3. **Bold black text** on white cards — high contrast, sporty
4. **Dark sections break the white** — hero banners and image cards use dark overlays
5. **Red gradient on image overlays** — brand-consistent (like their Instagram posts — red + image combo)
6. **No orange anywhere** — this is NOT MacroMind; replace every orange reference with red
7. **"ELITE FIT" branding** appears on splash, welcome, header — bold, all-caps style

---

## 🎬 SCREEN 1: SplashScreen

**Full-screen. White background. Bold brand reveal.**

```dart
// Background: pure white with subtle red radial glow center
Container(
  decoration: BoxDecoration(
    gradient: RadialGradient(
      center: Alignment.center,
      radius: 0.7,
      colors: [Color(0x18E8191B), Color(0xFFFFFFFF)],
    ),
  ),
)
```

Center column (staggered animations — each fades + slides up):
1. **Elite Fit Logo** — use a bold `"EF"` monogram in white on red circle `90px`, OR show `"ELITE FIT"` in two lines — `"ELITE"` big red bold + `"FIT"` black bold. Pulse `ScaleTransition` 0.0→1.0, 800ms `elasticOut`
2. **Divider line** — thin red `2px` horizontal `80px wide`, fades in at 400ms delay
3. **Tagline:** `"Elite Training. Elite Results."` — caption dark gray, fades in at 600ms
4. **Location tag:** `"📍 Katraj, Pune"` — tiny caption, fades in at 800ms
5. **Red progress line** at very bottom — thin 3px, animates left to right over 2s

After 2.5s → auth check → WelcomeScreen or Dashboard.

---

## 🌟 SCREEN 2: WelcomeScreen

**Split layout — image hero top, white action panel bottom**

**TOP 60% — Full bleed gym image:**
```dart
Stack(children: [
  CachedNetworkImage(
    imageUrl: AppImages.welcomeBg,
    // Bright modern gym with weights and equipment — energetic feel
    height: screenHeight * 0.60,
    fit: BoxFit.cover,
    filterQuality: FilterQuality.high,
  ),
  // Dark overlay — stronger at bottom, lighter at top
  Container(
    height: screenHeight * 0.60,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x44000000), Color(0xFF000000)],
        stops: [0.3, 1.0],
      ),
    ),
  ),
  // ELITE FIT branding top-left
  Positioned(top: 56, left: 24,
    child: Row(children: [
      Container(
        width: 40, height: 40,
        decoration: BoxDecoration(color: red, borderRadius: 8),
        child: Center(child: Text("EF", style: h3_white_bold)),
      ),
      SizedBox(width: 10),
      Text("ELITE FIT", style: Poppins(size: 18, w800, white, letterSpacing: 2)),
    ]),
  ),
  // Hero text bottom-left (over image, before fade)
  Positioned(bottom: 40, left: 24, right: 24,
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("YOUR BEST", style: Poppins(size: 38, w900, white, height: 1.1)),
      Text("SELF STARTS", style: Poppins(size: 38, w900, white, height: 1.1)),
      Row(children: [
        Text("HERE ", style: Poppins(size: 38, w900, white, height: 1.1)),
        Container(height: 6, width: 50, color: red, margin: EdgeInsets.only(bottom: 4)),
        // Red underline accent — Elite Fit style
      ]),
    ]),
  ),
])
```

**BOTTOM 40% — White action panel (rounded top 32px):**
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
  ),
  padding: EdgeInsets.fromLTRB(24, 28, 24, 40),
  child: Column(children: [
    // Drag handle — red pill
    Container(width: 40, height: 4, decoration: BoxDecoration(
      color: Color(0xFFE8191B), borderRadius: BorderRadius.circular(2))),
    SizedBox(height: 20),
    Text("Best & Biggest Fitness Club 🏆", style: h2_black_bold, textAlign: TextAlign.center),
    SizedBox(height: 6),
    Text("Certified Male & Female Coaches", style: caption_gray, textAlign: TextAlign.center),
    SizedBox(height: 28),
    // Red "Get Started" button
    _RedGradientButton("Get Started →", onTap: goToRegister),
    SizedBox(height: 12),
    // Outline "Login" button
    OutlinedButton(
      onPressed: goToLogin,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Color(0xFFE8191B), width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        minimumSize: Size(double.infinity, 56),
      ),
      child: Text("I Already Have an Account", style: labelRed),
    ),
    SizedBox(height: 20),
    Text("📞 9028 100 303 · Katraj, Pune", style: caption_gray, textAlign: TextAlign.center),
  ]),
)
```

---

## 📝 SCREEN 3 & 4: RegisterScreen & LoginScreen

**Both use same layout — white background, image header, form below**

**TOP HEADER — image with dark+red overlay (240px):**
```dart
Stack(children: [
  CachedNetworkImage(
    imageUrl: AppImages.authBg,
    // Well-lit gym interior — bright, modern
    height: 240, fit: BoxFit.cover),
  // Dark overlay
  Container(height: 240, color: Color(0xCC000000)),
  // Red left accent bar
  Positioned(left: 0, top: 0, bottom: 0,
    child: Container(width: 4, color: Color(0xFFE8191B))),
  // Content
  Positioned(bottom: 24, left: 24,
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Back button
      GestureDetector(
        onTap: Navigator.pop,
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(color: red, borderRadius: 8),
          child: Icon(Icons.arrow_back_ios_new, color: white, size: 18),
        ),
      ),
      SizedBox(height: 14),
      Text("Create Account", style: h1_white_bold),   // or "Welcome Back 👋"
      Text("Start your Elite journey today", style: caption_white70),
    ]),
  ),
])
```

**FORM SECTION — white background:**
- `SingleChildScrollView`, `24px` horizontal padding
- White `#FFFFFF` background

**Input style:**
- Height: `56px`
- `#F0F0F0` fill
- `borderRadius: 14px`
- Default border: `1px solid #E0E0E0`
- Focus border: `2px solid #E8191B`
- Black text `15px`, hint `#9A9A9A`
- Prefix icon: red `20px`
- Label above in dark gray bold caption

**Register fields:** Full Name · Email · Password · Confirm Password
**Login fields:** Email · Password

**Buttons:**
```dart
// Primary — red gradient
Container(
  decoration: BoxDecoration(
    gradient: AppColors.redGradient,
    borderRadius: BorderRadius.circular(14),
    boxShadow: AppColors.redShadow,
  ),
  height: 56, width: double.infinity,
  child: Center(child: Text("Create Account", style: label_white_semibold)),
)

// Google — white with border
OutlinedButton.icon(
  icon: SvgPicture.asset('assets/google.svg', width: 20),
  label: Text("Continue with Google"),
  style: OutlinedButton.styleFrom(
    backgroundColor: Colors.white,
    side: BorderSide(color: Color(0xFFE0E0E0)),
    minimumSize: Size(double.infinity, 56),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
  ),
)
```

---

## 🪜 SCREEN 5: OnboardingScreen — 11 Steps

### PROGRESS BAR (every step — top of screen):
```dart
// White AppBar area
Container(
  color: Colors.white,
  padding: EdgeInsets.fromLTRB(16, statusBarHeight + 12, 16, 12),
  child: Column(children: [
    Row(children: [
      // Red back button
      GestureDetector(
        child: Container(
          width: 36, height: 36,
          decoration: BoxDecoration(color: Color(0xFFE8191B), borderRadius: 8),
          child: Icon(Icons.arrow_back_ios_new, color: white, size: 16),
        ),
      ),
      SizedBox(width: 12),
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: currentStep / 11,
            backgroundColor: Color(0xFFE0E0E0),
            valueColor: AlwaysStoppedAnimation(Color(0xFFE8191B)),
            minHeight: 6,
          ),
        ),
      ),
      SizedBox(width: 12),
      Text("$currentStep / 11", style: caption_gray),
    ]),
  ]),
)
```

### BOTTOM CTA (every step — pinned):
```dart
Container(
  color: Colors.white,
  padding: EdgeInsets.fromLTRB(24, 12, 24, bottomPadding + 12),
  child: Container(
    height: 56,
    decoration: BoxDecoration(
      gradient: AppColors.redGradient,
      borderRadius: BorderRadius.circular(14),
      boxShadow: AppColors.redShadow,
    ),
    child: Center(child: Text("Continue →", style: h3_white_semibold)),
  ),
)
```

---

### STEP 1 — Gender

**Top image banner — crossfades based on selection:**
```dart
AnimatedSwitcher(
  duration: Duration(milliseconds: 400),
  child: heroImageCard(
    key: ValueKey(selectedGender),
    imageUrl: selectedGender == 'male'
        ? AppImages.onboardingMale    // male athlete
        : selectedGender == 'female'
            ? AppImages.onboardingFemale  // female athlete
            : AppImages.activityBanner,   // other
    height: 240,
    overlay: AppColors.imageOverlayDark,
    content: Align(alignment: Alignment.bottomLeft, child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("What's your", style: h2_white),
        Text("gender?", style: display_white),
      ],
    )),
  ),
)
```

**3 selector cards (white, red accent when selected):**
```
┌──────────────────────────────────────────────────────────┐
│ ████  👨  Male                                      ✓   │  ← selected: 4px red left bar
└──────────────────────────────────────────────────────────┘
┌──────────────────────────────────────────────────────────┐
│       👩  Female                                         │
└──────────────────────────────────────────────────────────┘
┌──────────────────────────────────────────────────────────┐
│       🧑  Other                                          │
└──────────────────────────────────────────────────────────┘
```
- Card: white `#FFFFFF`, `borderRadius: 16px`, `boxShadow: cardShadow`
- Selected: `border: 2px solid #E8191B`, left bar `4px red`, bg `rgba(232,25,27,0.04)`
- Unselected: `border: 1px solid #E0E0E0`
- Check icon: red circle `Icons.check` white

---

### STEP 2 — Age

**Top banner (100px):** White area, no image. Title `"How old are you?"` H1 black, subtitle caption gray.

**Center drum picker:**
```dart
ListWheelScrollView.useDelegate(
  itemExtent: 72,
  perspective: 0.005,
  physics: FixedExtentScrollPhysics(),
  overAndUnderCenterOpacity: 0.25,
  // Highlight border: red lines above/below center
)
```
- Selected: `72px` ultra-bold `#0D0D0D`
- Others: gray, fading
- Two thin `2px` red horizontal lines flanking the center slot
- Range: 13–100

---

### STEP 3 — Height

**Top white header (100px):** Title `"Your height?"` H1, subtitle `"In centimeters"`

**Hero display (center):**
```
      ┌──────────────────────────────┐
      │           170                │   ← 96px ultra-bold black
      │         ── cm ──             │   ← 18px gray + red underline
      └──────────────────────────────┘
```
White card with `boxShadow: cardShadow`, faint `1px solid #E0E0E0` border, subtle `boxShadow: redShadow` glow when adjusting.

**Horizontal ruler slider:**
- Track: white pill `#F0F0F0`
- Tick marks: `#D0D0D0` every 10cm, `#E5E5E5` every 5cm
- Current tick: tall `24px` red
- Thumb: red filled circle `24px`, white center dot `8px`
- `HapticFeedback.selectionClick()` per cm

---

### STEP 4 — Weight

Same pattern as Height. Unit: `"kg"`.

**`+` / `−` buttons:**
```dart
Container(
  width: 64, height: 64,
  decoration: BoxDecoration(
    gradient: AppColors.redGradient,
    shape: BoxShape.circle,
    boxShadow: AppColors.redShadow,
  ),
  child: Icon(Icons.add, color: white, size: 28),
)
```
Step: 0.5 kg. Long-press for fast increment.

---

### STEP 5 — Activity Level

**TOP: full image banner `220px`:**
```dart
heroImageCard(
  imageUrl: AppImages.activityBanner,
  // Person running — bright, energetic outdoor/treadmill
  height: 220,
  overlay: AppColors.imageOverlayRed,   // red-tinted overlay = Elite Fit brand
  content: column_bottom_left([
    Text("How active are you?", style: h1_white),
    Text("Shapes your daily calorie targets", style: caption_white),
  ]),
)
```

**5 white selector cards (`90px` each, `10px` gap):**
- Same white card style as gender step
- Left icon `32px` emoji, title bold black, subtitle caption gray right
- Selected: `2px red border`, red left bar `4px`, `rgba(232,25,27,0.04)` tint
- Red checkmark circle `24px` top-right when selected

**Loading overlay (while calling API):**
```dart
// Semi-transparent white overlay with red spinner
Container(color: Color(0xBBFFFFFF),
  child: Center(child: Column(children: [
    CircularProgressIndicator(color: Color(0xFFE8191B)),
    SizedBox(height: 12),
    Text("Setting up your profile...", style: caption_gray),
  ])),
)
```

---

### STEP 6 — Goal Type

**TOP: bright gym image banner `220px` with red overlay:**
```dart
heroImageCard(
  imageUrl: AppImages.fullBodyWorkout,
  height: 220,
  overlay: AppColors.imageOverlayRed,
  content: column_bottom_left([
    Text("What's your goal?", style: h1_white),
    Text("We'll customise everything for you", style: caption_white),
  ]),
)
```

**3 white goal cards (`130px` each):**

```
┌─────────────────────────────────────────────────────────────────┐
│  🔻  Lose Weight                           [small: weight img]  │
│      Burn fat, slim down to your ideal weight                   │
└─────────────────────────────────────────────────────────────────┘
```
Right side: `60px` circular `CachedNetworkImage` thumbnail of related activity.
Selected: `2px solid red`, red checkmark badge top-right `24px`, subtle red tint bg.

---

### STEP 7 — Target Weight

**Top white banner (80px):** Title black, current weight gray info badge.

**Center drum picker or large number display** (same as Step 4, but for target weight).

**Difference indicator card (white, slides in):**
```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Color(0xFFE8191B).withOpacity(0.4)),
    boxShadow: AppColors.cardShadow,
  ),
  child: Row(children: [
    Icon(Icons.trending_down, color: Color(0xFFE8191B)),
    SizedBox(width: 8),
    Text("10 kg to lose · ~20 weeks at 0.5 kg/week",
      style: body_dark),
  ]),
)
```

---

### STEP 8 — Weekly Rate

**2×2 chip grid:**
```
┌─────────────────────┐  ┌──────────────────────────────┐
│   0.25 kg / week    │  │  ⭐ 0.5 kg / week  Recommend │
└─────────────────────┘  └──────────────────────────────┘
┌─────────────────────┐  ┌──────────────────────────────┐
│   0.75 kg / week    │  │   1.0 kg / week              │
└─────────────────────┘  └──────────────────────────────┘
```
Unselected: white card, `1px solid #E0E0E0`, dark text.
Selected: red gradient bg, white text, `boxShadow: redShadow`.

"Recommended" badge: `#E8191B` small pill with white text on the 0.5 chip.

**Animated info card (white, slides up):**
```
┌───────────────────────────────────────────────────────┐
│  📅  Estimated goal date:  June 15, 2025             │
│  🔴  Daily calorie adjustment:  -550 kcal/day        │
│  ⏱️  Time to goal:  20 weeks                         │
└───────────────────────────────────────────────────────┘
```
White card, `1px solid rgba(232,25,27,0.3)` border.

---

### STEP 9 — Daily Calories

**White background. Hero calorie number:**
```
┌──────────────────────────────────────────────────┐
│         [⭐ AI Recommended]                      │  ← red pill badge
│                                                  │
│               2,150                              │  ← 72px bold black
│             kcal / day                           │  ← caption red
│                                                  │
└──────────────────────────────────────────────────┘
```
White card with `boxShadow: redShadow` glow. Big number in near-black.
Badge: red pill `"⭐ AI Recommended"` white text.

**Slider:**
- Active: `#E8191B` red track
- Inactive: `#E0E0E0`
- Thumb: red circle with white dot

**Warning (below 1200):** yellow card `⚠️ Very low calories can be harmful`.

---

### STEP 10 — Macros

**3 white macro cards stacked:**
```
PROTEIN
┌─────────────────────────────────────────────────────────────┐
│  ● Protein                                     [−][150g][+] │
│    ████████████████░░░░  Protein · 30% of calories         │
└─────────────────────────────────────────────────────────────┘
```
- Blue dot for Protein, Red dot for Carbs, Green dot for Fat
- `LinearProgressIndicator` in each macro color, `6px` height
- `[−]` `[+]` buttons: small red circles `32px`
- White cards, `cardShadow`, `borderRadius: 16px`

**Totals bar (white card at bottom):**
```
Total: 2,140 kcal  |  ✅ Balanced  |  10 kcal remaining
```
Green checkmark when balanced. Red `⚠️` if over by >50 kcal.

---

### STEP 11 — Water Goal

**Top: bright hydration image:**
```dart
heroImageCard(
  imageUrl: AppImages.hydrationImg,
  height: 180,
  overlay: AppColors.imageOverlayDark,
  content: column_bottom_left([
    Text("Stay Hydrated 💧", style: h1_white),
    Text("How many glasses per day?", style: caption_white),
  ]),
)
```

**Center count display (white card):**
```
     💧  8
  glasses
= 2.0 liters
```
Count `72px` bold black. Unit caption gray. Card: white, `boxShadow: redShadow`.

**Glass icon row:** `Icons.water_drop` `26px` — filled = `#2979FF` blue, empty = `#E0E0E0`.

**Slider:** red active track, `1–20`.

**On complete:** Red circle checkmark success animation → Dashboard.

---

## 🏠 SCREEN 6: DashboardScreen

**Full light theme. White cards on `#F5F5F5` scaffold.**

APIs: same as before (see API table at bottom).

---

### HEADER

```
┌──────────────────────────────────────────────────────────────────┐
│  ┌────┐  HI JAMES 👋                              🔔  ⋮          │  ← white bg
│  │ EF │  ✦ Elite Fit Member                                      │
│  └────┘                                                          │
└──────────────────────────────────────────────────────────────────┘
```
- Avatar: `48px` circle — red bg `#E8191B`, white initials bold
- OR user photo via `CachedNetworkImage`
- Name: `"HI [NAME] 👋"` H1 black bold
- Subtitle: `"✦ Elite Fit Member"` — red `✦` star + caption gray
- Notification bell: `Icons.notifications_outlined` dark
- White AppBar, no elevation

---

### DATE STRIP

```
May 2024                                    [←]  [→]
─────────────────────────────────────────────────────────
  M    T    W    T    F    S    S
  15   16  [18]  19   20   21   22
```
- `ListView` horizontal
- Today: red filled circle `44px`, white text bold
- Others: white/light gray, dark text
- `#F5F5F5` container bg

---

### TODAY'S CHALLENGE BANNER ⭐

```dart
heroImageCard(
  imageUrl: AppImages.challengeBanner,
  // Energetic gym workout photo — bright, intense
  height: 115,
  borderRadius: 20,
  overlay: AppColors.imageOverlayRed,  // red brand overlay on left
  content: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        color: Colors.white.withOpacity(0.2),
        child: Text("TODAY'S CHALLENGE", style: Poppins(size: 10, w700, white)),
      ),
      SizedBox(height: 4),
      Text("Do your plan before 9:00 PM", style: body_white_bold),
    ]),
    // Right: gym photo naturally shows through lighter overlay
  ]),
)
```

---

### FILTER CHIPS

```
[ All ]   Running   Cycling   Zumba
```
Selected: red gradient bg, white text, `borderRadius: 24px`
Unselected: white, `1px solid #E0E0E0`, gray text

---

### STEPS & GOALS ROW

Two white shadow cards side-by-side (`48%` width):

**Steps:** `👟 1,840 steps` — large bold black number
**Goals:** `🎯 My Goals` + subtitle + small red `"Start →"` button

```dart
// "Start" button — red gradient, small
Container(
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  decoration: BoxDecoration(gradient: AppColors.redGradient, borderRadius: 20),
  child: Text("Start →", style: label_white),
)
```

---

### CALORIE RING ⭐

```dart
CircularPercentIndicator(
  radius: 120.0,
  lineWidth: 16.0,
  animation: true,
  animationDuration: 1500,
  startAngle: 180.0,          // semicircle arc (speedometer style)
  circularStrokeCap: CircularStrokeCap.round,
  progressColor: Color(0xFFE8191B),      // ELITE FIT RED
  backgroundColor: Color(0xFFE0E0E0),   // light gray track (white theme)
  center: Column(children: [
    Text("258", style: display_72_bold_black),
    Text("Kcal", style: caption_red),
    Text("Burned", style: caption_gray),
  ]),
)
```
**White card** wrapping the ring with `cardShadow`.

Below ring — 3 stat chips:
```
Target: 430  |  222 Kcal  |  Rest: 90
```
Each: caption gray + bold black value. Red vertical dividers `1px`.

---

### MACRO CARDS ROW

3 white shadow cards:
```
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│  ● Protein   │  │  ● Carbs     │  │  ● Fat        │
│  ░░██████░   │  │  ░░░░████░░  │  │  ████████░    │
│  45 / 150g   │  │  80 / 200g   │  │  20 / 65g    │
└──────────────┘  └──────────────┘  └──────────────┘
```
- Blue / Red / Green `LinearProgressIndicator` `6px`
- Black bold values, gray label

---

### YOUR PLAN SECTION ⭐ KEY VISUAL

**Title:** `"Your Plan"` H2 black + filter chips `[All workouts]` `Lower body` `Upper body` `Zumba`

**Progress Card — full width, image hero:**
```dart
heroImageCard(
  imageUrl: AppImages.progressCard,
  // Fit female doing cardio in bright gym
  height: 165,
  borderRadius: 20,
  overlay: LinearGradient(  // dark on right, lighter on left
    colors: [Color(0x33000000), Color(0xBB000000)],
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
  ),
  content: Stack(children: [
    // "Progress" badge — RED pill top-left
    Positioned(top: 0, left: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: Color(0xFFE8191B),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text("Progress", style: label_white),
      ),
    ),
    // Bottom content
    Positioned(bottom: 0, left: 0, child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Lower Body", style: h2_white),
        Text("Cardio 10 mins", style: caption_white70),
        SizedBox(height: 8),
        // "Start" white pill button — like reference image
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text("Start", style: Poppins(size: 13, w600, red)),
            SizedBox(width: 4),
            Icon(Icons.play_circle_filled, color: red, size: 18),
          ]),
        ),
      ],
    )),
  ]),
)
```

**Workout Cards (scrollable list — each `130px` tall):**

Each card uses `heroImageCard` with:
- Image: bright gym workout photo
- Top-right: duration badge — white circle `52px`, gray bg `rgba(255,255,255,0.9)`, dark text
- Bottom-left: workout name (H3 white) + muscle groups (caption white70)
- Bottom-right: red `"Start →"` pill button

```dart
// Workout list
[
  WorkoutItem(img: AppImages.lowerBodyWorkout, name: "Lower body workout",
    muscles: "Glutes / Squads / Hamstrings", duration: "30 mins"),
  WorkoutItem(img: AppImages.cardioWorkout,    name: "Cardio Session",
    muscles: "Full Body Fat Burn",            duration: "20 mins"),
  WorkoutItem(img: AppImages.upperBodyWorkout, name: "Upper Body Strength",
    muscles: "Chest / Back / Shoulders",      duration: "45 mins"),
  WorkoutItem(img: AppImages.groupFitness,    name: "Zumba / Dance",
    muscles: "Full Body · Fun",               duration: "60 mins"),
]
```

---

### WATER TRACKER

```
┌──────────────────────────────────────────────────────────────────┐
│  💧 Water Intake                                5 / 8    [+]    │  ← white card
│                                                                  │
│  💧 💧 💧 💧 💧 ○ ○ ○                                          │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```
White card, `cardShadow`. `[+]` button: red gradient circle `36px`.
Filled glasses: `#2979FF` blue. Empty: `#E0E0E0`.

---

### TODAY'S FOOD/WORKOUT LOGS

**Title:** `"Today's Logs"` + `"View All →"` in red.

**Each log card (white, `80px`):**
```
┌──────────────────────────────────────────────────────────────────┐
│ ████  [48px img]  Scrambled Eggs    +320 kcal     08:30 AM      │  ← red left bar
│                   P:22g · C:3g · F:18g                          │
└──────────────────────────────────────────────────────────────────┘
```
- Left bar `4px`: red for food, blue for workout
- Thumbnail: `48px` rounded `CachedNetworkImage`
- Calorie: red/positive for food, green/negative for workout burned
- Macro pills: `#F0F0F0` bg, dark text, `borderRadius: 20px`

---

### AI INPUT BAR (pinned above bottom nav)

```
┌──────────────────────────────────────────────────────────────────┐
│  [🎤 red]  Log food or workout...                        [→ red] │
└──────────────────────────────────────────────────────────────────┘
```
- White bg, `borderRadius: 32px`, `boxShadow: cardShadow`
- Border: `1.5px solid #E0E0E0`
- Mic: `Icons.mic_rounded` in red
- Send: red gradient circle `40px`, white arrow
- **While recording:** border → `2px solid red`, bg → `rgba(232,25,27,0.05)`, mic pulses `ScaleTransition`

---

## ⚖️ SCREEN 7: WeightScreen

**TOP HERO — image with stats overlay:**
```dart
heroImageCard(
  imageUrl: AppImages.deadliftWorkout,
  // Bright deadlift photo — matches Elite Fit's own Instagram post
  height: 220,
  overlay: AppColors.imageOverlayDark,
  content: column_bottom([
    Text("Weight Journey", style: h1_white),
    // Stat chips row: Current | Target | Change
    Row(children: [
      _WhiteStatChip("Current", "78.5 kg"),
      _WhiteStatChip("Target", "72 kg"),
      _WhiteStatChip("Lost", "↓ -0.5 kg", textColor: green),
    ]),
  ]),
)
```

**White card weight chart (fl_chart):**
- Line: `#E8191B` red, `strokeWidth: 2.5`
- Dots: red `6px` circles
- Grid: `#F0F0F0` light
- Bg: white card

**FAB:** `FloatingActionButton.extended` — red gradient, `"+ Log Weight"`, white text.

**Log Weight BottomSheet:** white bg, rounded top `28px`, red drag handle pill, big number + `−` / `+` controls, red `"Save Entry"` button.

---

## 🎯 SCREEN 8: GoalsScreen

**TOP HERO — trainer image with Elite Fit branding:**
```dart
heroImageCard(
  imageUrl: AppImages.trainerHero,
  // Confident male athlete, bright studio setting
  height: 240,
  overlay: AppColors.imageOverlayDark,
  content: Stack(children: [
    // Top: coach info row
    Positioned(top: 0, left: 0, right: 0,
      child: Row(children: [
        CircleAvatar(radius: 22, backgroundImage: NetworkImage(AppImages.trainerHero)),
        SizedBox(width: 8),
        Column(children: [
          Text("Your Coach", style: caption_white),
          Text("Elite Fit AI", style: label_white_bold),
        ]),
        Spacer(),
        // Red arrow circle
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: red, shape: BoxShape.circle),
          child: Icon(Icons.arrow_outward, color: white),
        ),
      ]),
    ),
    // Bottom: main text
    Positioned(bottom: 0, left: 0, child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Make Your Body", style: h1_white),
        Text("Stronger 💪", style: h1_white),
      ],
    )),
  ]),
)
```

**Goal Summary Card (white):**
```
┌──────────────────────────────────────────────────────────┐
│  [🔻 LOSE WEIGHT]            Target: June 15, 2025      │
│                                                          │
│  78.5 kg ──────────────────────────────────→  72.0 kg  │
│                                                          │
│  ████████████████░░░░░░  65% to goal                    │
└──────────────────────────────────────────────────────────┘
```
Progress bar: red fill on `#E0E0E0`.

**Workout list (3 rows with thumbnails — exact Elite Fit style):**
```
┌──────────────────────────────────────────────────────────┐
│  [48px]  Push Up Training              [▶️ red circle]   │
│          Increase your strength...                       │
└──────────────────────────────────────────────────────────┘
┌──────────────────────────────────────────────────────────┐
│  [48px]  Full Body Workout             [▶️ red circle]   │
│          Exercise and target your body        ← red text │
└──────────────────────────────────────────────────────────┘
┌──────────────────────────────────────────────────────────┐
│  [48px]  Hard Training                 [▶️ red circle]   │
│          Maximize with intense sets                      │
└──────────────────────────────────────────────────────────┘
```
Play button: red gradient circle `40px`, white `Icons.play_arrow`.

**BOTTOM: full-width red "Start Course" button:**
```dart
Container(
  width: double.infinity, height: 56,
  decoration: BoxDecoration(
    gradient: AppColors.redGradient,
    borderRadius: BorderRadius.circular(16),
    boxShadow: AppColors.redShadow,
  ),
  child: Center(child: Text("Start Course", style: h3_white_semibold)),
)
```

---

## 👤 SCREEN 9: ProfileScreen

**TOP HERO — image with profile overlay (260px):**
```dart
heroImageCard(
  imageUrl: AppImages.authBg,
  // Bright gym interior
  height: 260,
  overlay: AppColors.imageOverlayDark,
  content: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
    // Avatar: red ring border + white glow
    Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Color(0xFFE8191B), width: 3),
        boxShadow: [BoxShadow(color: Color(0x55E8191B), blurRadius: 20, spreadRadius: 4)],
      ),
      child: CircleAvatar(radius: 40, backgroundColor: red,
        child: Text("JD", style: h2_white)),
    ),
    SizedBox(height: 10),
    Text("James Doe", style: h2_white),
    Text("james@email.com", style: caption_white70),
    SizedBox(height: 8),
    // "Elite Fit Member" badge
    Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xFFE8191B),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.star, color: white, size: 14),
        SizedBox(width: 4),
        Text("Elite Fit Member", style: label_white),
      ]),
    ),
  ]),
)
```

**Stats Row (3 white cards):**
- Age | Height | Weight — white cards, black bold values, gray labels

**Settings list (white card, iOS-style):**
- Left icon: red circle `36px` + white icon
- Row items: Edit Profile · My Goals · Weight History · Notifications · About Elite Fit

**Logout:** white card, `1.5px solid #E8191B`, red text `"Log Out"`.

---

## 🧭 BOTTOM NAVIGATION BAR

```
┌────────────────────────────────────────────────────────────────────┐
│  [🏠]          [📊]          [🎯]          [👤]                   │
│  Home        Progress       Goals         Profile                  │
│   •                                                                │  ← red dot
└────────────────────────────────────────────────────────────────────┘
```
- Background: **white** `#FFFFFF`, `elevation: 12`
- Top shadow: `boxShadow: [BoxShadow(color: 0x0D000000, blurRadius: 16)]`
- Active: red `#E8191B` icon + red label `12px` + red dot `6px`
- Inactive: `#9A9A9A`
- Icons: `home_rounded`, `bar_chart_rounded`, `track_changes_rounded`, `person_rounded`

---

## ✨ UI POLISH — WHITE THEME SPECIFIC

### White Theme Shimmer
```dart
Shimmer.fromColors(
  baseColor: Color(0xFFE8E8E8),      // light gray
  highlightColor: Color(0xFFF5F5F5), // near white highlight
  child: Container(
    color: Color(0xFFE8E8E8),
    borderRadius: BorderRadius.circular(16),
  ),
)
```

### Micro-interactions
- Card tap: `InkWell` splashColor `rgba(232,25,27,0.08)`, borderRadius 16px
- Button press: scale `0.96 → 1.0`, 50ms
- Input focus: red animated border, 150ms
- Success API: brief green border flash on card

### Error Snackbar
```
White card | 4px red left border | dark text | borderRadius 12px | shadow
```

### Hero Image Card Pattern (reusable widget)
```dart
Widget heroImageCard({
  required String imageUrl,
  required Widget content,
  double height = 160,
  double borderRadius = 20,
  Gradient? overlay,
}) => ClipRRect(
  borderRadius: BorderRadius.circular(borderRadius),
  child: SizedBox(
    height: height,
    child: Stack(fit: StackFit.expand, children: [
      CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
        placeholder: (c, u) => Shimmer.fromColors(
          baseColor: Color(0xFFE0E0E0),
          highlightColor: Color(0xFFF5F5F5),
          child: Container(color: Color(0xFFE0E0E0)),
        ),
        errorWidget: (c, u, e) => Container(
          color: Color(0xFFF0F0F0),
          child: Icon(Icons.fitness_center, color: Color(0xFFE8191B), size: 32),
        ),
      ),
      if (overlay != null)
        Container(decoration: BoxDecoration(gradient: overlay)),
      Padding(padding: EdgeInsets.all(16), child: content),
    ]),
  ),
);
```

---

## 🔗 BACKEND API TABLE

**Base URL:** `http://localhost:8000`
**Auth header:** `Authorization: Bearer {access_token}`

| Method | Endpoint | Screen |
|--------|----------|--------|
| POST | `/auth/register` | Register |
| POST | `/auth/login` | Login |
| GET | `/auth/google/login` | Login, Register |
| GET | `/auth/me` | Dashboard, Profile |
| POST | `/auth/refresh` | Dio interceptor |
| POST | `/auth/logout` | Profile |
| POST | `/profile/setup` | Onboarding Step 5, Profile edit |
| GET | `/profile/me` | Login check, Profile |
| POST | `/goals/set` | Onboarding Step 11, Goals |
| GET | `/goals/me` | Dashboard, Goals |
| POST | `/weight/log` | Weight |
| GET | `/weight/history` | Weight chart |
| POST | `/water/goal` | Onboarding Step 11 |
| POST | `/water/add-glass` | Dashboard |
| GET | `/water/today` | Dashboard |
| POST | `/llm/log` | Dashboard AI bar |
| GET | `/food-or-workout/today` | Dashboard nutrition |
| GET | `/food-or-workout/logs/today` | Dashboard logs |
| POST | `/api/speech-to-text/` | Dashboard mic button |

---

