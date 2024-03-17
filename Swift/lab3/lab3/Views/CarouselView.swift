//
//  CarouselView.swift
//  lab3
//
//  Created by dumonten on 16/3/24.
//

import SwiftUI

struct Base64ImageView: View {
    let base64String: String?
    
    init(from urlString: String) {
        let components = urlString.split(separator: ",")
        self.base64String = components.count > 1 ? String(components.last!) : nil
    }
    
    var body: some View {
        if let base64String = base64String,
           let imageData = Data(base64Encoded: base64String),
           let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
        } else {
            EmptyView()
        }
    }
}

struct WebImage: View {
    let urlString: String
    @State private var image: UIImage? = nil
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = uiImage
                }
            }
        }
        task.resume()
    }
}

struct CarouselView: View {
    let images: [String]
    @Binding var currentIndex: Int

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            imageScrollViewContent
        }
        .onChange(of: currentIndex) { newValue in
            withAnimation {
                currentIndex = newValue
            }
        }
    }

    private var imageScrollViewContent: some View {
        HStack(spacing: 0) {
            ForEach(0..<images.count) { index in
                if let url = URL(string: images[index]), url.scheme == "data" {
                    Base64ImageView(from: images[index])
                        .padding()
                } else {
                    WebImage(urlString: images[index])
                        .padding()
                }
            	}
        }
    }
}

