import SwiftUI
struct SerieCarouselCard: View {
    
    let serie: Serie
    @ObservedObject var imageLoader = ImageLoader()
    
    var body: some View {
        ZStack {
            if self.imageLoader.image != nil {
                Image(uiImage: self.imageLoader.image!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(8)
                    .shadow(radius: 4)
                
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .cornerRadius(8)
                    .shadow(radius: 4)
                
                Text(serie.name)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(width: 300, height: 450)
        .onAppear {
            self.imageLoader.loadImage(with: self.serie.posterURL)
        }
    }
}
struct SerieCarouselView: View {
    
    let title: String
    let series: [Serie]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(self.series) { serie in
                        NavigationLink(destination: SerieSpecificationView(serieId: serie.id)) {
                            SerieCarouselCard(serie: serie)
                        }.buttonStyle(PlainButtonStyle())
                            .padding(.leading, serie.id == self.series.first!.id ? 16 : 0)
                            .padding(.trailing, serie.id == self.series.last!.id ? 16 : 0)
                    }
                }
            }
        }
        
    }
}
