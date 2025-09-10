# JsonPlaceHolder 📱

A modern iOS application built with Swift that demonstrates clean architecture, reactive programming, and best practices for iOS development. The app fetches and displays user profiles, albums, and photos from the JSONPlaceholder API with a beautiful, intuitive interface.

## ✨ Features

- **User Profile Management**: View detailed user profiles with contact information and address
- **Album Gallery**: Browse through user albums with photo collections
- **Image Viewer**: Full-screen image viewing with pinch-to-zoom functionality
- **Search & Filter**: Search through photos within albums
- **Error Handling**: Comprehensive error handling with user-friendly alerts
- **Loading States**: Smooth loading indicators and transitions
- **Responsive Design**: Optimized for all iOS devices and orientations

## 🏗️ Architecture

This project follows **MVVM (Model-View-ViewModel)** architecture with reactive programming principles.

## 🛠️ Tech Stack

- **Language**: Swift 5
- **Architecture**: MVVM
- **Reactive Programming**: RxSwift, RxCocoa, RxMoya
- **Networking**: Moya, Alamofire
- **Image Loading**: Kingfisher
- **UI Layout**: SnapKit (Programmatic Auto Layout)
- **Testing**: XCTest

## 📦 Dependencies

| Framework | Version | Purpose |
|-----------|---------|---------|
| [RxSwift](https://github.com/ReactiveX/RxSwift) | 6.9.0 | Reactive Programming |
| [RxCocoa](https://github.com/ReactiveX/RxSwift) | 6.9.0 | RxSwift for Cocoa |
| [Moya](https://github.com/Moya/Moya) | 15.0.3 | Network Abstraction |
| [RxMoya](https://github.com/Moya/Moya) | 15.0.3 | Moya + RxSwift |
| [Alamofire](https://github.com/Alamofire/Alamofire) | 5.10.2 | HTTP Networking |
| [Kingfisher](https://github.com/onevcat/Kingfisher) | 8.5.0 | Image Loading & Caching |
| [SnapKit](https://github.com/SnapKit/SnapKit) | 5.7.1 | Auto Layout DSL |
| [ReactiveSwift](https://github.com/ReactiveCocoa/ReactiveSwift) | 6.7.0 | Reactive Programming |

## 🚀 Getting Started

### Prerequisites

- Xcode 14.0 or later
- iOS 13.0 or later
- Swift 5.0 or later

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/HadeerElnagdy/JsonPlaceHolder.git
   cd JsonPlaceHolder
   ```

2. **Open the project**
   ```bash
   open JsonPlaceHolder.xcodeproj
   ```

3. **Build and run**
   - Select your target device or simulator
   - Press `Cmd + R` to build and run the project

### Dependencies

The project uses Swift Package Manager for dependency management. Dependencies will be automatically resolved when you open the project in Xcode.

## 🧪 Testing

The project includes comprehensive unit tests covering:

- **ViewModels**: Profile ViewModel
- **Use Cases**: Profile Use Case business logic
- **Mock Objects**: Mock repositories and use cases


## 🧩 Code Quality

- **Clean Architecture**: Separation of concerns with MVVM
- **Protocol-Oriented**: Extensive use of protocols for testability
- **Constants Management**: Centralized constants in `Constants.swift`
- **Error Handling**: Structured error management
- **Unit Testing**: Comprehensive test coverage
- **Code Documentation**: Well-documented code with clear naming

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


## 🙏 Acknowledgments

- [JSONPlaceholder](https://jsonplaceholder.typicode.com/) for the free API
- [Picsum](https://picsum.photos/) for placeholder images

---

⭐ **Star this repository if you found it helpful!**
