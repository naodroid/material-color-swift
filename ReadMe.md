Porting [MaterialColorUtilities](https://github.com/material-foundation/material-color-utilities) to swift.



## How To Use

add this git-url with SwiftPM.

* MaterialColorSwift
  * only mathematics color calculation, no UIKit/SwiftUI dependencies.
  * based on int array (32bit argb pixels)
* MaterailColorIOS
  * a support library for iOS
  * generate material-colors from UIImage
  * convert int based scheme to UIColors/SwiftUI-Colors


## Basic usage

Create `Scheme` from `UIImage`, and convert it into `SwiftUIScheme`

```swift
import MaterialColorSwift

// create scheme
let image = Image(named: "sample")!
let baseScheme: Scheme = MaterialColorConverter.from(image: image, isDarkMode: true)
let scheme: SwiftUISheme = baseScheme.toSwiftUI()

// use
VStack {
  Text("Sample Text")   
}
.foregroundColor(scheme.onPrimary)
.background(scheme.primary)
```



