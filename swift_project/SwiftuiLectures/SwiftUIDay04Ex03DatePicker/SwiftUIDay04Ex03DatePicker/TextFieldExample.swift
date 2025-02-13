import SwiftUI

struct TextFieldExample: View {
    @State private var name: String = ""

    var body: some View {
        VStack {
            Text("이름을 입력하세요:")
            TextField("이름", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Text("입력한 이름: \(name)")
        }
        .padding()
    }
}
//
//  TextFieldExample.swift
//  SwiftUIDay04Ex03DatePicker
//
//  Created by 원대한 on 2/13/25.
//

