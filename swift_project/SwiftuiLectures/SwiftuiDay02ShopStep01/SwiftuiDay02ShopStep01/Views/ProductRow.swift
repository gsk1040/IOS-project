//
//  ProductRow.swift
//  SwiftuiDay02ShopStep01
//
//  Created by 원대한 on 2/11/25.
//

import SwiftUI

struct ProductRow: View {
    var product: Product

    var body: some View {
        HStack {
            Image(product.imageName)
                .resizable()
                .frame(width: 100, height: 100)
                .clipped()
            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.headline)
                Text("₩\(product.price)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 3)
    }
}

#Preview {
    ProductRow(product: Product(name: "나는야 무화과", imageName: "fig", price: 3100, description: "소화가 잘되고 변비에 좋은 달달한 국내산 무화과에요. 고기와 찰떡궁합!", isFavorite: false))
}
