//
//  ContentView.swift
//  SwiftuiDay02ShopStep01
//
//  Created by 원대한 on 2/11/25.
//

import SwiftUI

struct ProductListView: View {


    @StateObject private var productLoader = ProductDataLoader()

    var body: some View {
        NavigationView {
            List(productLoader.products) { product in
                NavigationLink (destination: ProductDetailView(product: product)){
                    ProductRow(product: product)
                }
            }
        }
    }
}

#Preview {
    ProductListView()
}
