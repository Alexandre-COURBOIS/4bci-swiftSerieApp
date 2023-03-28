
import SwiftUI

struct SerieSearchView: View {
    
    @ObservedObject var serieSearchState = SearchbarState()
    
    var body: some View {
        NavigationView {
            List {
                SearchBarView(placeholder: "Rechercher une série", text: self.$serieSearchState.query)
                    .listRowInsets(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                
                LoadingView(isLoading: self.serieSearchState.isLoading, error: self.serieSearchState.error) {
                    self.serieSearchState.search(query: self.serieSearchState.query)
                }
                
                if self.serieSearchState.series != nil {
                    ForEach(self.serieSearchState.series!) { serie in
                        NavigationLink(destination: SerieSpecificationView(serieId: serie.id)) {
                            VStack(alignment: .leading) {
                                Text(serie.name)
                                Text(serie.yearText)
                            }
                        }
                    }
                }
                
            }
            .onAppear {
                self.serieSearchState.startObserve()
            }
            .navigationBarTitle("Rechercher")
        }
    }
}
