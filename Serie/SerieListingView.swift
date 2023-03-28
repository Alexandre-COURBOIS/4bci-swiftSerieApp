import SwiftUI

struct SerieListingView: View {
    
    @ObservedObject private var nowPlayingState = SerieListingState()
    
    var body: some View {
        NavigationView {
            List {
                Group {
                    if nowPlayingState.series != nil {
                        SerieCarouselView(title: "Dès aujourd'hui", series: nowPlayingState.series!)
                        
                    } else {
                        LoadingView(isLoading: self.nowPlayingState.isLoading, error: self.nowPlayingState.error) {
                            self.nowPlayingState.loadSeries(with: .nowPlaying)
                        }
                    }
                    
                }
                .listRowInsets(EdgeInsets(top: 16, leading: 0, bottom:64, trailing: 0))
            }
            .navigationBarTitle("Video Prime")
        }
        .onAppear {
            self.nowPlayingState.loadSeries(with: .nowPlaying)
        }
        
    }
}
