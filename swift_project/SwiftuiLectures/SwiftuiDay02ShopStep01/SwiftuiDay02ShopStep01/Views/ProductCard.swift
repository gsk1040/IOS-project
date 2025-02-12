//
//  ProductCard.swift
//  SwiftuiDay02ShopStep01
//
//  Created by 원대한 on 2/11/25.
//
import SwiftUI

struct ProductCard: View {
    var product: Product

    var body: some View {
        VStack(alignment: .leading) {
            Image(product.imageName)
                .resizable()
                .frame(height: 250)
                .clipped()
            Text(product.name)
                .font(.headline)
            Text("₩\(product.price)")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

#Preview {
    ProductCard(product: Product(name: "나는야 무화과", imageName: "fig", price: 3100, description: "소화가 잘되고 변비에 좋은 달달한 국내산 무화과에요. 고기와 찰떡궁합!", isFavorite: false))
}
