Porting [MaterialColorUtilities](https://github.com/material-foundation/material-color-utilities) to swift.

Pick theme-colors from an image.


https://user-images.githubusercontent.com/4728599/151645217-f206f694-b986-456a-b4be-5aa6f1d50efd.mp4


<br>

## How To Use

add this git-url with SwiftPM.

* MaterialColorSwift
  * only mathematics color calculation, no UIKit/SwiftUI dependencies.
  * based on int-array (argb pixels)
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




