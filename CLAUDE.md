# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A MVVM-C iOS sample app that demonstrates how to use [XCoordinator](https://github.com/QuickBirdEng/XCoordinator) v3 for navigation. There is no app logic of real-world value here — the scenes (Login → Home → News/Users → Detail/About) exist purely to exercise the coordinator types (`NavigationCoordinator`, `TabBarCoordinator`, `PageCoordinator`, `SplitCoordinator`) and the transition/animation APIs. When adding examples or fixing bugs, preserve coverage of these coordinator variants rather than collapsing them.

- Swift 5.9, iOS 16.0+, universal (iPhone + iPad). (XCoordinator 3 requires iOS 16 / Swift 5.9.)
- Dependencies are Swift Package Manager only — no Podfile / Cartfile. Resolved versions are pinned in `XCoordinator-Example.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved`: `RxSwift` 6.x, `Action` 5.x, and `XCoordinator` tracking the **`feature/3.0.0` branch** of `QuickBirdEng/XCoordinator` (a `kind = branch` requirement) because 3.0.0 is not yet tagged — see the `XCRemoteSwiftPackageReference "XCoordinator"` block in `project.pbxproj`. Re-pin to a tag once 3.0.0 is released.
- Open `XCoordinator-Example.xcodeproj` directly (there is no `.xcworkspace`).

## Build / test commands

```bash
# Build for the simulator
xcodebuild -project XCoordinator-Example.xcodeproj \
  -scheme XCoordinator-Example \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  build

# Run the full test plan (UI tests)
xcodebuild -project XCoordinator-Example.xcodeproj \
  -scheme XCoordinator-Example \
  -testPlan XCoordinator-Example \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  test

# Run a single test (Xcode test identifier: Target/Class/method)
xcodebuild ... test \
  -only-testing:XCoordinator-ExampleUITests/XCoordinator_ExampleUITests/testTabPickerLandsOnTabBar
```

The test plan at `XCoordinator-ExampleTests/XCoordinator-Example.xctestplan` now contains only the `XCoordinator-ExampleUITests` (UI) target, which drives the actual app. The `XCoordinator-ExampleTests` unit target's contents were copies of XCoordinator's own `Tests/XCoordinatorTests` suite (transition/animation mechanics of the library, not the example app); since the library now owns and maintains those, the duplicates were removed and the empty unit target dropped from the plan. Code coverage is off by default in the plan.

## Architecture

### Coordinator graph

`SceneDelegate` holds an `AppCoordinator()` typed as `any Router<AppRoute>` and calls `setRoot(for: window)`. From there everything flows through XCoordinator `Route` enums and `prepareTransition(for:)` overrides — no view controller is allocated outside a coordinator.

The top-level structure is:

- **`AppCoordinator`** (`NavigationCoordinator<AppRoute>`) — starts on `.login`. On `.home`, it presents a `UIAlertController` that lets the user pick between `HomeTabCoordinator`, `HomeSplitCoordinator`, `HomePageCoordinator`, `HomeSwiftUICoordinator`, or a Random one of those. The chosen home coordinator (an `any Router<HomeRoute>` — the coordinator instance itself) is wrapped back into `AppRoute.home(...)` and presented full-screen. This picker is the whole point of the example — it shows the same `HomeRoute` driving four different container coordinators. Keep the variants interchangeable from `HomeRoute`'s perspective when modifying them. (The `Random` action appends `HomeSwiftUICoordinator` **last**, so the UI tests that pass `--random-picker-index 0/1/2` keep landing on Tab/Split/Page.)
- **Home container coordinators** all expose `HomeRoute { case news; case userList }` and delegate to:
  - `NewsCoordinator` (`NavigationCoordinator<NewsRoute>`) — news list → detail (uses a custom `.swirl` animation).
  - `UserListCoordinator` (`NavigationCoordinator<UserListRoute>`) — user list → user detail (`UserCoordinator`), plus `.about` which is implemented via `addChild(AboutCoordinator(rootViewController: ...))` + `.none()` rather than a transition. `AppRoute.newsDetail` deep-links through `HomePageCoordinator → HomeRoute.news → NewsRoute.newsDetail` via `Transition.multiple(.dismissAll(), .popToRoot(), deepLink(...))`.

### SwiftUI interop (the `HomeSwiftUICoordinator` container)

`HomeSwiftUICoordinator` is a **SwiftUI** home container (the fourth picker variant) that demonstrates XCoordinator 3's SwiftUI bridge in **both directions** — it is the reference for how to mix SwiftUI and UIKit coordinators here:

- **UIKit → SwiftUI (forward):** it subclasses `ViewCoordinator<HomeRoute>` and calls `super.init(body: { HomeSwiftUIView(state:) })`, which hosts the SwiftUI view in a `RoutingController` and auto-registers the coordinator, so `@Routing<HomeRoute>` inside the view resolves to it.
- **SwiftUI → UIKit (backward):** `HomeSwiftUIView` is a `TabView` whose tabs embed the existing UIKit `UserListCoordinator` and `NewsCoordinator` via `WrappedRouter { … }`.
- **Route-driven SwiftUI state:** tab selection is a `Binding` whose setter calls `await router.trigger(.news/.userList)`; `HomeSwiftUICoordinator.prepareTransition` handles those with `Transition.withAnimation { state.selection = … }` (a no-UIKit-transition route that animates SwiftUI state).
- The `@Routing`/`Transition.withAnimation` etc. live in `Sources/XCoordinator/SwiftUI/` of the library. Deferred (not yet shown here): `redirect(to:map:)`, the `.triggerOnAppear`/`.trigger(when:)` modifiers.

### MVVM-C scene wiring

Every scene under `Scenes/<Feature>/` is three files:

- `<Feature>ViewController.swift` — `.xib`-based, conforms to `BindableType` (`Utils/BindableType.swift`). Coordinators call `VC.instantiateFromNib()` then `vc.bind(to: viewModel)`, which assigns the model, loads the view, and invokes `bindViewModel()`.
- `<Feature>ViewModel.swift` — protocol triplet: `<Feature>ViewModelInput`, `<Feature>ViewModelOutput`, and `<Feature>ViewModel { var input; var output }`. A `where Self: Input & Output` extension lets a single impl class satisfy all three by returning `self`.
- `<Feature>ViewModelImpl.swift` — concrete RxSwift implementation, annotated `@MainActor` (XCoordinator 3's API is `@MainActor`, so the router-triggering closures must be too). Triggers are `CocoaAction`s that call `router.rx.trigger(.someRoute)` (via `XCoordinatorRx` + `Action`; `import XCoordinatorRx` is required for `.rx`). Routers are held as `unowned let router: any Router<…>` to avoid retain cycles. Follow this pattern verbatim when adding a scene.

### Models, services, common

- `Models/` — plain Swift structs (`News`, `User`).
- `Services/` — `MockNewsService`, `MockUserService`. These return hardcoded data; there is no networking. `AppCoordinator.notificationReceived()` uses `MockNewsService().mostRecentNews().articles.randomElement()` to fake an incoming push that deep-links to a news detail.
- `Common/` — `AppDelegate`, `Main.storyboard` placeholder (in `Base.lproj`), asset catalog. The app does not use the storyboard for routing — only as the launch storyboard reference.

### Animations and transitions

- `Animations/Animation+*.swift` — custom XCoordinator `Animation` instances (`.fade`, `.scale`, `.swirl`, `.modal`, `.navigation`) built from `StaticTransitionAnimation` / `TransitionAnimation`. The library's own `Tests/XCoordinatorTests` (e.g. `AnimationTests`) covers that pushing/popping triggers a configured animation's blocks; this example no longer duplicates that. The example's `XCoordinator-ExampleUITests` instead verify the real app flows end-to-end (login → picker → each home container, deep links).
  - **`UIHostingController` gotcha:** a custom animator must give the incoming view a real frame. All five animations set `toView.frame = transitionContext.finalFrame(for:)` (+ `autoresizingMask`) before animating — without it, UIKit does not pre-size the presented view for a custom animator and a `UIHostingController`'s SwiftUI view lays out to zero and renders **blank/black** (this is exactly what happened to `HomeSwiftUICoordinator` under `.fade`). Keep this pattern in any new custom animator.
- `Extensions/Transitions.swift` — defines two app-specific transition factories: `Transition.presentFullScreen(_:animation:)` (sets `modalPresentationStyle = .fullScreen` before `.present`) and `Transition.dismissAll()` (recursively dismisses presented VCs). Prefer these over inline `modalPresentationStyle` mutation.
- `Extensions/TransitionAnimation+Defaults.swift` — shared defaults reused across the custom animations.

### Conventions worth keeping

- Routes are always enums conforming to `Route`. Adding a new screen means: add a case to the relevant `…Route`, handle it in the matching coordinator's `prepareTransition`, and add a scene triplet under `Scenes/`.
- `prepareTransition(for:)` overrides use XCoordinator 3's `@TransitionBuilder` (inherited from `BaseCoordinator`): each `switch` case is a single trailing `Transition` expression with no `return`. The builder transforms reliably only when each case is **one** expression — a case body with `void` statements, local `let`s, `if/else`, or several listed transitions falls back to "missing return". So view-controller construction (instantiate + `bind(to:)`), `addChild`, control flow, and transition chains (`.multiple(...)`) live in `private func` helpers that each return a `Transition`, keeping every case a single expression. Keep this shape when adding scenes.
- Coordinators pass themselves to view models as `self` (a coordinator is an `any Router<…>`); the view model stores it `unowned`. When a router is handed across coordinator boundaries (as in `AppRoute.home`) the coordinator instance is held strongly as `any Router<…>`. Do not pass coordinators into view models by concrete type.
- Child coordinators that share a navigation stack with their parent (see `AboutCoordinator` in `UserListCoordinator`) are attached with `addChild(...)` + a `.none()` transition rather than a presentation.
