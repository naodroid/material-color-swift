# ``MaterialColorIOS``


a support library for `MaterialColorSwift` in UIKit/SwiftUI.


## How to use


### 1. Generate Scheme from Image

```swift
let image = UIImage(named: "...")
let baseScheme = MaterialColorConverter.fromImage(image)
```

 ### 2. Convert scheme for SwiftUI (or UIKit)

```swift
let scheme: SwiftUIScheme = baseScheme.toSwiftUI()
```



