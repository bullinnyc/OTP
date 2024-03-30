# OTP

One-time password (OTP) for SwiftUI.

## Gifs
![](./demo.gif)

## Usage

```swift
struct MyView: View {
    @StateObject private var viewModel = SomeViewModel()
    
    var body: some View {
        OTPView(text: viewModel.code, error: viewModel.codeError) { code in
            viewModel.verification(with: code)
        }
    }
}
```

## Requirements
- [SwiftUI](https://developer.apple.com/xcode/swiftui/)

## License
- OTP is distributed under the MIT License.
