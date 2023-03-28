import SwiftUI

class SerieListingState: ObservableObject {
    
    @Published var series: [Serie]?
    @Published var isLoading: Bool = false
    @Published var error: NSError?

    private let serieService: SerieService
    
    init(serieService: SerieService = SerieApiRequestor.shared) {
        self.serieService = serieService
    }
    
    func loadSeries(with endpoint: SerieListEndpoint) {
        self.series = nil
        self.isLoading = true
        self.serieService.fetchSeries(from: endpoint) { [weak self] (result) in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let response):
                self.series = response.results
                
            case .failure(let error):
                self.error = error as NSError
            }
        }
    }
    
}

