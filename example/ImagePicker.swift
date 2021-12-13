//
//  ImagePicker.swift
//  example
//
//  Created by nao on 2021/12/13.
//

import Foundation
import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    let imageSelected: (UIImage?) -> Void
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        return picker
    }
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> ImagePickerCoordinator {
        return ImagePickerCoordinator(parent: self)
    }
}
// MARK: Coordinator
class ImagePickerCoordinator: NSObject {
    let parent: ImagePicker
    
    init(parent: ImagePicker) {
        self.parent = parent
        super.init()
    }
}
extension ImagePickerCoordinator: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [
                                UIImagePickerController.InfoKey : Any
                               ]
    ) {
        let image = info[.editedImage] as? UIImage
            ?? info[.originalImage] as? UIImage
        parent.imageSelected(image)
        parent.presentationMode.wrappedValue.dismiss()
    }
}


