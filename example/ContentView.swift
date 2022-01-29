//
//  ContentView.swift
//  example
//
//  Created by 坂本　尚嗣 on 2021/12/09.
//

import SwiftUI
import MaterialColorIOS
import MaterialColorSwift
import Combine

struct ContentView: View {
    
    @State private var image: UIImage
    @State private var scheme: SwiftUIScheme
    @State private var isDarkMode: Bool = false
    @State private var imageIndex = 0
    
    init() {
        let image = UIImage(named: "sample00")!
        self.image = image
        self.scheme = MaterialColorConverter.generateScheme(
            from: image,
            isDarkTheme: false
        )!.toSwiftUI()
    }
    var body: some View {
        _ContentView(
            image: self.image,
            scheme: self.scheme,
            isDarkMode: $isDarkMode,
            onImageChangeClicked: {
                nextImage()
            }
        )
            .onChange(of: isDarkMode, perform: { newValue in
                scheme = MaterialColorConverter.generateScheme(
                    from: image,
                    isDarkTheme: newValue
                )!.toSwiftUI()

            })
    }
    private func nextImage() {
        imageIndex = (imageIndex + 1) % 3
        image = UIImage(named: "sample0\(imageIndex)")!
        scheme = MaterialColorConverter.generateScheme(
            from: image,
            isDarkTheme: isDarkMode
        )!.toSwiftUI()
    }
}
///
private struct _ContentView: View {
    let image: UIImage
    let scheme: SwiftUIScheme
    @Binding var isDarkMode: Bool
    let onImageChangeClicked: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .bottomTrailing) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 120)
                        .clipped()
                        .ignoresSafeArea()
                    
                    HStack {
                        VStack(alignment: .center, spacing: 0) {
                            Text("Dark Theme")
                                .font(.caption)
                            Toggle(isOn: $isDarkMode) {
                                
                            }
                            .labelsHidden()
                            .toggleStyle(SwitchToggleStyle(tint: scheme.secondary))
                        }
                        .padding(.all, 4)
                        .foregroundColor(scheme.onTertiary)
                        .background(scheme.tertiary)
                        .cornerRadius(4)
                        
                        Button {
                            onImageChangeClicked()
                        } label: {
                            Image(systemName: "photo")
                                .foregroundColor(scheme.onPrimary)
                                .frame(width: 44, height: 44)
                                .background(scheme.primary)
                                .clipShape(Circle())
                                .shadow(color: scheme.shadow, radius: 2, x: 2, y: 2)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 12))
                        }
                    }
                }
                
                VStack {
                    Text("Primary")
                    HStack {
                        Text("Primary Container")
                    }
                    .padding(.all, 8)
                    .foregroundColor(scheme.onPrimaryContainer)
                    .background(scheme.primaryContainer)
                    .cornerRadius(8)
                    Text("Inverse Primary")
                        .foregroundColor(scheme.inversePrimary)
                }
                .frame(maxWidth: .infinity)
                .padding(.all, 8)
                .foregroundColor(scheme.onPrimary)
                .background(scheme.primary)
                .cornerRadius(16)
                .padding(.all, 8)
                
                
                VStack {
                    Text("Secondary")
                    HStack {
                        Text("Secongary Container")
                    }
                    .padding(.all, 8)
                    .foregroundColor(scheme.onSecondaryContainer)
                    .background(scheme.secondaryContainer)
                    .cornerRadius(8)
                }
                .frame(maxWidth: .infinity)
                .padding(.all, 8)
                .foregroundColor(scheme.onSecondary)
                .background(scheme.secondary)
                .cornerRadius(16)
                .padding(.all, 8)
                
                
                VStack {
                    Text("Tertiary")
                    HStack {
                        Text("Tertiary Container")
                    }
                    .padding(.all, 8)
                    .foregroundColor(scheme.onTertiaryContainer)
                    .background(scheme.tertiaryContainer)
                    .cornerRadius(8)
                }
                .frame(maxWidth: .infinity)
                .padding(.all, 8)
                .foregroundColor(scheme.onTertiary)
                .background(scheme.tertiary)
                .cornerRadius(16)
                .padding(.all, 8)
                
                VStack {
                    Text("Error")
                    HStack {
                        Text("Error Container")
                    }
                    .padding(.all, 8)
                    .foregroundColor(scheme.onErrorContainer)
                    .background(scheme.errorContainer)
                    .cornerRadius(8)
                }
                .frame(maxWidth: .infinity)
                .padding(.all, 8)
                .foregroundColor(scheme.onError)
                .background(scheme.error)
                .cornerRadius(16)
                .padding(.all, 8)
                
                
                VStack {
                    Text("Background With Outline")
                }
                .frame(maxWidth: .infinity)
                .padding(.all, 8)
                .foregroundColor(scheme.onBackground)
                .background(scheme.background)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(scheme.outline, lineWidth: 4)
                )
                .padding(.all, 8)
                
                
                VStack {
                    Text("Surface With Shadow")
                }
                .frame(maxWidth: .infinity)
                .padding(.all, 8)
                .foregroundColor(scheme.onSurface)
                .background(scheme.surface)
                .cornerRadius(8)
                .shadow(color: scheme.shadow, radius: 2, x: 2, y: 2)
                .padding(.all, 8)
                
                
                VStack {
                    Text("Surface With Shadow")
                }
                .frame(maxWidth: .infinity)
                .padding(.all, 8)
                .foregroundColor(scheme.onSurface)
                .background(scheme.surface)
                .cornerRadius(8)
                .shadow(color: scheme.shadow, radius: 2, x: 2, y: 2)
                .padding(.all, 8)
                
                VStack {
                    Text("Surface Variant")
                    HStack {
                        Text("Inverse Surface")
                    }
                    .padding(.all, 8)
                    .foregroundColor(scheme.inverseOnSurface)
                    .background(scheme.inverseSurface)
                    .cornerRadius(8)
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.all, 8)
                .foregroundColor(scheme.onSurfaceVariant)
                .background(scheme.surfaceVariant)
                .cornerRadius(8)
                .padding(.all, 8)
            }
        }
        .background(scheme.surfaceVariant)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    @State static var isDarkMode: Bool = false
    static var previews: some View {
        _ContentView(
            image: UIImage(named: "sample")!,
            scheme: Scheme.light(color: 0xFF88F0C8).toSwiftUI(),
            isDarkMode: $isDarkMode,
            onImageChangeClicked: {
            }
        )
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
