//
//  ContentView.swift
//  SwiftuiDay02ex01Practice02
//
//  Created by 원대한 on 2/11/25.
//

import SwiftUI

struct FirstlistView: View {
    let fruits = ("Apple", "Banana", "Orange", "Mango")
    
    var body: some View {
        List {
            ForEach(fruits, id: \.self) { fruit in
                Text(fruit)
                    .font(.title)
                    .foregroundColor(.green)
                    .padding()
            }
            .listStyle(InsetListStyle())
            .navigationTitle("Fruit List")
    }
}

struct FruitListView_Previews: PreviewProvider {
        static var previews: some View {
            FruitListView()
        }
    }
#Preview {
    ListViewEx()
}
