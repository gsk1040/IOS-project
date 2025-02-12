//
//  BindToggleEx.swift
//  SwiftuiDay03Ex03
//
//  Created by 원대한 on 2/12/25.
//

import SwiftUI

struct ParentView2: View {
    @State var isOn = false
    var body: some View {
        ToggleView2(isOn: $isOn)
    }
}


struct ToggleView2: View {
    @Binding var isOn: Bool
    
    var body: some View {
        VStack {
            Text("isOn: \(isOn)")
            Toggle("isOn", isOn: $isOn)
        }
        .padding()
    }
}

struct BindToggleEx: View {
    var body: some View {
        ParentView2()
    }
}

#Preview {
    BindToggleEx()
}
