//
//  imagePicker.swift
//  SwiftPractice
//
//  Created by 원대한 on 3/27/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        VStack {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
            } else {
                Text("선택된 이미지가 없다!")
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
            }
            Text("Hello, world!")
            Button("이미지 선택") {
                self.showImagePicker.toggle()
                print(self.showImagePicker)
            }
            .padding()
        }
        .sheet(isPresented: $showImagePicker) {
            // UIImagePicker를 사용 할 객체 호출
            ImagePicker(selectedImage: self.$selectedImage)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
