import SwiftUI
import SafariServices

import SwiftUI

struct SerieSpecificationView: View {
    let serieId: Int
    @ObservedObject private var serieSpecificationState = SerieSpecificationState()
    
    var body: some View {
        ZStack {
            LoadingView(isLoading: self.serieSpecificationState.isLoading, error: self.serieSpecificationState.error) {
                self.serieSpecificationState.loadSerie(id: self.serieId)
            }
            
            if serieSpecificationState.serie != nil {
                SerieSpecificationListView(serie: self.serieSpecificationState.serie!)
                
            }
        }
        .navigationBarTitle(serieSpecificationState.serie?.name ?? "")
        .navigationBarItems(leading: Spacer(), trailing: HStack {
                Spacer()
            }
        )
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            self.serieSpecificationState.loadSerie(id: self.serieId)
        }
    }
}

struct SerieSpecificationListView: View {
    
    let serie: Serie
    @State private var selectedTrailer: SerieVideo?
    let imageLoader = ImageLoader()
    
    var body: some View {
        List {
            SerieSpecificationImage(imageLoader: imageLoader, imageURL: self.serie.backdropURL)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            
            HStack {
                Text(serie.genreText)
                Text("·")
                Text(serie.firstAirDateText)
                Text(serie.durationText)
            }
            
            Text(serie.overview)
            HStack {
                if !serie.ratingText.isEmpty {
                    Text(serie.ratingText).foregroundColor(.yellow)
                }
                Text(serie.scoreText)
            }
            
            Divider()
            
            HStack(alignment: .top, spacing: 4) {
                if serie.cast != nil && serie.cast!.count > 0 {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Starring").font(.headline)
                        ForEach(self.serie.cast!.prefix(9)) { cast in
                            Text(cast.name)
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    
                }
                
                if serie.crew != nil && serie.crew!.count > 0 {
                    VStack(alignment: .leading, spacing: 4) {
                        if serie.directors != nil && serie.directors!.count > 0 {
                            Text("Director(s)").font(.headline)
                            ForEach(self.serie.directors!.prefix(2)) { crew in
                                Text(crew.name)
                            }
                        }
                        
                        if serie.producers != nil && serie.producers!.count > 0 {
                            Text("Producer(s)").font(.headline)
                                .padding(.top)
                            ForEach(self.serie.producers!.prefix(2)) { crew in
                                Text(crew.name)
                            }
                        }
                        
                        if serie.screenWriters != nil && serie.screenWriters!.count > 0 {
                            Text("Screenwriter(s)").font(.headline)
                                .padding(.top)
                            ForEach(self.serie.screenWriters!.prefix(2)) { crew in
                                Text(crew.name)
                            }
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                }
            }
            
            Divider()
            
            if serie.youtubeTrailers != nil && serie.youtubeTrailers!.count > 0 {
                Text("Trailers").font(.headline)
                
                ForEach(serie.youtubeTrailers!) { trailer in
                    Button(action: {
                        self.selectedTrailer = trailer
                    }) {
                        HStack {
                            Text(trailer.name)
                            Spacer()
                            Image(systemName: "play.circle.fill")
                                .foregroundColor(Color(UIColor.systemBlue))
                        }
                    }
                }
            }
        }
        .sheet(item: self.$selectedTrailer) { trailer in
            SafariView(url: trailer.youtubeURL!)
        }
    }
}

struct SerieSpecificationImage: View {
    
    @ObservedObject var imageLoader: ImageLoader
    let imageURL: URL
    
    var body: some View {
        ZStack {
            Rectangle().fill(Color.gray.opacity(0.3))
            if self.imageLoader.image != nil {
                Image(uiImage: self.imageLoader.image!)
                    .resizable()
            }
        }
        .aspectRatio(16/9, contentMode: .fit)
        .onAppear {
            self.imageLoader.loadImage(with: self.imageURL)
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    
    let url: URL

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let safariVC = SFSafariViewController(url: self.url)
        return safariVC
    }
}
