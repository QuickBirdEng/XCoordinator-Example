# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A MVVM-C iOS sample app that demonstrates how to use [XCoordinator](https://github.com/quickbirdstudios/XCoordinator) v2 for navigation. There is no app logic of real-world value here — the scenes (Login → Home → News/Users → Detail/About) exist purely to exercise the coordinator types (`NavigationCoordinator`, `TabBarCoordinator`, `PageCoordinator`, `SplitCoordinator`) and the transition/animation APIs. When adding examples or fixing bugs, preserve coverage of these coordinator variants rather than collapsing them.

- Swift 5, iOS 13.0+, universal (iPhone + iPad).
- Dependencies are Swift Package Manager only — no Podfile / Cartfile. Resolved versions are pinned in `XCoordinator-Example.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved`: `XCoordinator` 2.0.5, `RxSwift` 5.0.1, `Action` 4.0.1.
- Open `XCoordinator-Example.xcodeproj` directly (there is no `.xcworkspace`).

## Build / test commands

```bash
# Build for the simulator
xcodebuild -project XCoordinator-Example.xcodeproj \
  -scheme XCoordinator-Example \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  build

# Run the full test plan (unit + UI tests)
xcodebuild -project XCoordinator-Example.xcodeproj \
  -scheme XCoordinator-Example \
  -testPlan XCoordinator-Example \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  test

# Run a single test (Xcode test identifier: Target/Class/method)
xcodebuild ... test \
  -only-testing:XCoordinator-ExampleTests/AnimationTests/testPageCoordinator
```

The test plan at `XCoordinator-ExampleTests/XCoordinator-Example.xctestplan` includes both `XCoordinator-ExampleTests` (unit) and `XCoordinator-ExampleUITests` (UI) targets. Code coverage is off by default in the plan.

## Architecture

### Coordinator graph

`AppDelegate` instantiates `AppCoordinator().strongRouter` and calls `setRoot(for: window)`. From there everything flows through XCoordinator `Route` enums and `prepareTransition(for:)` overrides — no view controller is allocated outside a coordinator.

The top-level structure is:

- **`AppCoordinator`** (`NavigationCoordinator<AppRoute>`) — starts on `.login`. On `.home`, it presents a `UIAlertController` that lets the user pick between `HomeTabCoordinator`, `HomeSplitCoordinator`, `HomePageCoordinator`, or a Random one of those. The chosen home coordinator's `StrongRouter<HomeRoute>` is wrapped back into `AppRoute.home(...)` and presented full-screen. This picker is the whole point of the example — it shows the same `HomeRoute` driving three different container coordinators. Keep the three variants interchangeable from `HomeRoute`'s perspective when modifying them.
- **Home container coordinators** all expose `HomeRoute { case news; case userList }` and delegate to:
  - `NewsCoordinator` (`NavigationCoordinator<NewsRoute>`) — news list → detail (uses a custom `.swirl` animation on iOS 10+, falls back to `.scale`).
  - `UserListCoordinator` (`NavigationCoordinator<UserListRoute>`) — user list → user detail (`UserCoordinator`), plus `.about` which is implemented via `addChild(AboutCoordinator(rootViewController: ...))` + `.none()` rather than a transition. `AppRoute.newsDetail` deep-links through `HomePageCoordinator → HomeRoute.news → NewsRoute.newsDetail` via `Transition.multiple(.dismissAll(), .popToRoot(), deepLink(...))`.

### MVVM-C scene wiring

Every scene under `Scenes/<Feature>/` is three files:

- `<Feature>ViewController.swift` — `.xib`-based, conforms to `BindableType` (`Utils/BindableType.swift`). Coordinators call `VC.instantiateFromNib()` then `vc.bind(to: viewModel)`, which assigns the model, loads the view, and invokes `bindViewModel()`.
- `<Feature>ViewModel.swift` — protocol triplet: `<Feature>ViewModelInput`, `<Feature>ViewModelOutput`, and `<Feature>ViewModel { var input; var output }`. A `where Self: Input & Output` extension lets a single impl class satisfy all three by returning `self`.
- `<Feature>ViewModelImpl.swift` — concrete RxSwift implementation. Triggers are `CocoaAction`s that call `router.rx.trigger(.someRoute)` (via `XCoordinatorRx` + `Action`). Routers are held as `UnownedRouter<…>` to avoid retain cycles. Follow this pattern verbatim when adding a scene.

### Models, services, common

- `Models/` — plain Swift structs (`News`, `User`).
- `Services/` — `MockNewsService`, `MockUserService`. These return hardcoded data; there is no networking. `AppCoordinator.notificationReceived()` uses `MockNewsService().mostRecentNews().articles.randomElement()` to fake an incoming push that deep-links to a news detail.
- `Common/` — `AppDelegate`, `Main.storyboard` placeholder (in `Base.lproj`), asset catalog. The app does not use the storyboard for routing — only as the launch storyboard reference.

### Animations and transitions

- `Animations/Animation+*.swift` — custom XCoordinator `Animation` instances (`.fade`, `.scale`, `.swirl`, `.modal`, `.navigation`) built from `StaticTransitionAnimation` / `TransitionAnimation`. `AnimationTests` instantiates each coordinator type and asserts that pushing/popping triggers the configured animation's `performAnimation` blocks — when you add a new custom animation, mirror the existing test pattern.
- `Extensions/Transitions.swift` — defines two app-specific transition factories: `Transition.presentFullScreen(_:animation:)` (sets `modalPresentationStyle = .fullScreen` before `.present`) and `Transition.dismissAll()` (recursively dismisses presented VCs). Prefer these over inline `modalPresentationStyle` mutation.
- `Extensions/TransitionAnimation+Defaults.swift` — shared defaults reused across the custom animations.

### Conventions worth keeping

- Routes are always enums conforming to `Route`. Adding a new screen means: add a case to the relevant `…Route`, handle it in the matching coordinator's `prepareTransition`, and add a scene triplet under `Scenes/`.
- Coordinators expose themselves to view models as `unownedRouter` (or `strongRouter` when handed across coordinator boundaries, as in `AppRoute.home`). Do not pass coordinators directly into view models.
- Child coordinators that share a navigation stack with their parent (see `AboutCoordinator` in `UserListCoordinator`) are attached with `addChild(...)` + a `.none()` transition rather than a presentation.
