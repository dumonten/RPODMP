//
//  ImagesHolder.swift
//  lab3
//
//  Created by dumonten on 16/3/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImagesHolder: View {
    let images: [String]
    @State private var currentIndex = 0

    var body: some View {
        VStack {
            // Carousel
            CarouselView(images: images, currentIndex: $currentIndex)
                .frame(height: 200)
        }
    }
}
