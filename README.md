<p align="center">
  <img src="https://quickbirdstudios.com/files/xcoordinator/logo.png">
</p>

# XCoordinator-Example

A sample iOS app showing **MVVM-C with [XCoordinator](https://github.com/quickbirdstudios/XCoordinator) v2** — built specifically to demonstrate the library's container coordinators side by side and to give you a worked example of MVVM-C scene wiring with RxSwift.

<!--
TODO: record and commit a hero GIF at docs/hero.gif showing
the picker alert → same HomeRoute.news flow rendered three times
under HomeTabCoordinator, HomeSplitCoordinator, HomePageCoordinator.
Then uncomment the line below.

<p align="center"><img src="docs/hero.gif" width="600" alt="Demo"></p>
-->

## What this example teaches

A login → home → detail flow built end-to-end with XCoordinator v2 and MVVM-C. Use it as a reference for:

- **Four coordinator container types in one app** — `NavigationCoordinator`, `TabBarCoordinator`, `SplitCoordinator`, and `PageCoordinator`. The Home screen lets you pick which one drives the same `HomeRoute`, so you can compare them side-by-side.
- **MVVM-C scene wiring** via the `BindableType` protocol — each scene is a `ViewController` + `ViewModel` protocol triplet + `ViewModelImpl`, bound with [RxSwift](https://github.com/ReactiveX/RxSwift) and [Action](https://github.com/RxSwiftCommunity/Action).
- **Custom transition animations** — a swirl push, fade modals, and shared defaults under `Animations/`.
- **Deep linking** through nested coordinators with `Transition.multiple(.dismissAll(), .popToRoot(), deepLink(...))`, simulating an incoming push notification.
- **Child coordinators without a transition** — the About screen is attached via `addChild` + `.none()` instead of being presented.
- **Custom transition extensions** — `presentFullScreen` and `dismissAll` in `Extensions/Transitions.swift`.

## The three-home-coordinator picker

When you reach the Home screen, the app asks you to pick between `HomeTabCoordinator`, `HomeSplitCoordinator`, `HomePageCoordinator`, or a random one. This picker is the point of the example: all three coordinators expose the **same** `HomeRoute { case news; case userList }`, and `AppCoordinator` wraps whichever one you pick into `AppRoute.home(StrongRouter<HomeRoute>)`.

The takeaway: routes describe *what* should happen, coordinators decide *how*. Swapping the container coordinator changes the entire navigation chrome of your app without touching a single view model or route definition. Open [`AppCoordinator.swift`](XCoordinator-Example/Coordinators/AppCoordinator.swift) to see the wrapping, then compare [`HomeTabCoordinator.swift`](XCoordinator-Example/Coordinators/HomeTabCoordinator.swift), [`HomeSplitCoordinator.swift`](XCoordinator-Example/Coordinators/HomeSplitCoordinator.swift), and [`HomePageCoordinator.swift`](XCoordinator-Example/Coordinators/HomePageCoordinator.swift) to see three different `prepareTransition(for:)` implementations handling identical routes.

## Deep-link demo

The app registers the `xcoordinator-example://` URL scheme. Trigger it from a booted simulator:

```bash
xcrun simctl openurl booted "xcoordinator-example://news/3"
xcrun simctl openurl booted "xcoordinator-example://users/Paul"
```

`SceneDelegate.scene(_:openURLContexts:)` (and the matching cold-launch path in `willConnectTo`) parses the URL via [`DeepLinkParser`](XCoordinator-Example/Common/DeepLinkParser.swift) into an `AppRoute`, then triggers it on the app's `StrongRouter<AppRoute>`. For news, `AppRoute.newsDetail` resolves to

```swift
.multiple(
    .dismissAll(),
    .popToRoot(),
    deepLink(AppRoute.home(...), HomeRoute.news, NewsRoute.newsDetail(news))
)
```

`.multiple` chains the transitions sequentially, and `deepLink(...)` walks the coordinator hierarchy by triggering successive routes, so the app lands on the article from *any* current navigation state (modal stacks included). The users path (`AppRoute.userDetail`) takes the same shape and ends in a modal present.

One gotcha worth knowing if you deep-link through a `PageCoordinator`: `deepLink` chains the next route inside each transition's completion handler, but `UIPageViewController.setViewControllers(…, animated: true)` silently skips its completion when the requested page is *already* on-screen. A deep link whose page step targets the already-visible page would stall there. This example works around it with `Transition.setReliably(_:direction:)` in [`Extensions/Transitions.swift`](XCoordinator-Example/Extensions/Transitions.swift), a drop-in replacement for `.set` that always fires the completion — see [`HomePageCoordinator`](XCoordinator-Example/Coordinators/HomePageCoordinator.swift).

## Requirements

- Xcode (current stable)
- Swift 5.9
- iOS 16+ (iPhone and iPad)
- Swift Package Manager — `XCoordinator` 2.2.1, `RxSwift` 6.10.2, `Action` 5.0.0

No CocoaPods, no Carthage; dependencies resolve automatically when you open the project.

## Run it

```bash
git clone https://github.com/quickbirdstudios/XCoordinator-Example.git
cd XCoordinator-Example
open XCoordinator-Example.xcodeproj
```

Build and run on any iOS 16+ simulator. Log in with any credentials, then pick a Home coordinator from the alert to start exploring.

## Project structure

```
XCoordinator-Example/
├── Common/         AppDelegate, SceneDelegate, asset catalog, launch screen
├── Coordinators/   AppCoordinator + four home coordinators + News/User/UserList/About
├── Scenes/<Feature>/
│       ├── <Feature>ViewController.swift  (xib-based, conforms to BindableType)
│       ├── <Feature>ViewModel.swift       (Input / Output / composite protocols)
│       └── <Feature>ViewModelImpl.swift   (RxSwift + Action implementation)
├── Animations/     Custom Animation instances (.fade, .scale, .swirl, .modal, .navigation)
├── Extensions/     Transitions.swift (presentFullScreen, dismissAll), Rx helpers
├── Services/       MockNewsService, MockUserService (no real backend)
├── Utils/          BindableType, NibIdentifiable
└── Models/         News, User
```

Every scene under `Scenes/<Feature>/` is the same triplet pattern — read [`HomeViewModel.swift`](XCoordinator-Example/Scenes/Home/HomeViewModel.swift) once to see how Input/Output/composite protocols compose into a single `ViewModelImpl`.

## Learn more

- [XCoordinator](https://github.com/quickbirdstudios/XCoordinator) — the library this example demonstrates.
- [Mobile-HackNight-XCoordinator](https://github.com/quickbirdstudios/Mobile-HackNight-XCoordinator) — a workshop using an earlier version of XCoordinator with MVC.
- [Coordinators Redux](https://khanlou.com/2015/10/coordinators-redux/) by Soroush Khanlou — background reading on the coordinator pattern.

## 👤 Author

This example app is created with ❤️ by [QuickBird Studios](https://quickbirdstudios.com).

## ❤️ Contributing

Open an issue if you need help, if you found a bug, or if you want to discuss a feature request. Open a PR if you want to make changes to the XCoordinator example app.

## 📃 License

XCoordinator-Example is released under an MIT license. See [LICENSE](LICENSE) for more information.
