//
//  ContentView.swift
//  example
//
//  Created by 坂本　尚嗣 on 2021/12/09.
//

import SwiftUI
import MaterialColorIOS
import MaterialColorSwift

struct ContentView: View {
    
    private let image: UIImage
    private let scheme: SwiftUIScheme
    
    init() {
        self.image = UIImage(named: "sample")!
        self.scheme = MaterialColorConverter.fromImage(image, isDarkTheme: false)!.toSwiftUI()
    }
    
    
    
    var body: some View {
        ZStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            ScrollView {
                VStack {
                    ForEach(0..<scheme.allColors.count, id: \.self) {
                        scheme.allColors[$0].frame(width: 60, height: 30)
                    }
                }
            }
        }.ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


private extension SwiftUIScheme {
    var allColors: [Color] {
        [
            self.primary,
            self.onPrimary,
            self.primaryContainer,
            self.onPrimaryContainer,
            self.secondary,
            self.onSecondary,
            self.secondaryContainer,
            self.onSecondaryContainer,
            self.tertiary,
            self.onTertiary,
            self.tertiaryContainer,
            self.onTertiaryContainer,
            self.error,
            self.onError,
            self.errorContainer,
            self.onErrorContainer,
            self.background,
            self.onBackground,
            self.surface,
            self.onSurface,
            self.surfaceVariant,
            self.onSurfaceVariant,
            self.outline,
            self.shadow,
            self.inverseSurface,
            self.inverseOnSurface,
            self.inversePrimary
        ]
    }
}
