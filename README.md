# todo-client-ios

This is a ToDo iOS Client built with Swift and SwiftUI, offering a seamless and intuitive user experience.

## Tech Stack
![Swift](https://img.shields.io/badge/swift-F54A2A?style=for-the-badge&logo=swift&logoColor=white)
![SwiftUI](https://img.shields.io/badge/SwiftUI-F54A2A?style=for-the-badge&logo=swift&logoColor=white)
![XCTest](https://img.shields.io/badge/XCTest-F54A2A?style=for-the-badge&logo=swift&logoColor=white)
![SwiftLint](https://img.shields.io/badge/SwiftLint-F54A2A?style=for-the-badge&logo=swift&logoColor=white)
![SwiftFormat](https://img.shields.io/badge/SwiftFormat-F54A2A?style=for-the-badge&logo=swift&logoColor=white)
![Xcode](https://img.shields.io/badge/Xcode-007ACC?style=for-the-badge&logo=Xcode&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)

### Programming Languages
- [Swift](https://swift.org/) v5.7+ - Primary development language

### Frontend
- [SwiftUI](https://developer.apple.com/xcode/swiftui/) - Modern UI framework for iOS
- [Combine](https://developer.apple.com/documentation/combine) - Reactive programming framework

### Development Environment
- [Xcode](https://developer.apple.com/xcode/) v14.0+ - Integrated development environment
- [Swift Package Manager](https://swift.org/package-manager/) - Dependency management tool
- [Mint](https://github.com/yonaskolb/Mint) - Package manager for Swift command line tools

### Testing & Quality Assurance
- [XCTest](https://developer.apple.com/documentation/xctest) - Testing framework
- [SwiftLint](https://github.com/realm/SwiftLint) v0.59.1 - Code style enforcement tool
- [SwiftFormat](https://github.com/nicklockwood/SwiftFormat) v0.52.11 - Code formatter

### CI/CD
- GitHub Actions - Continuous Integration and Deployment

## Setup
### Initial Setup
1. Clone this repository:
    ```
    $ git clone https://github.com/kenwoo9y/todo-client-ios.git
    $ cd todo-client-ios
    ```

2. Install Mint and development tools:
    ```
    $ brew install mint
    $ mint bootstrap
    ```

3. Open the project in Xcode

## Development
### Running Tests
- Run tests: Open the project in Xcode

### Code Quality Checks
- Lint check:
    ```
    $ make lint-check
    ```
- Apply lint fixes:
    ```
    $ make lint-fix
    ```
- Check code formatting:
    ```
    $ make format-check
    ```
- Apply code formatting:
    ```
    $ make format-fix
    ```

## Requirements
- iOS 15.0+
- Xcode 14.0+
- Swift 5.7+
- Homebrew (for installing Mint)
