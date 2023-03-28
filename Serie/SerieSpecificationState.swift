import SwiftUI

class SerieSpecificationState: ObservableObject {
    
    private let serieService: SerieService
    @Published var serie: Serie?
    @Published var isLoading = false
    @Published var error: NSError?
    
    var res:Serie?
    
    init(serieService: SerieService = SerieApiRequestor.shared) {
        self.serieService = serieService
    }

    func loadSerie(id: Int) {
        self.serie = nil
        self.isLoading = false
        self.serieService.fetchSerie(id: id) {[weak self] (result) in
            guard let self = self else { return }
            
            self.isLoading = false
            switch result {
            case .success(let serie):
                self.serie = serie
            case .failure(let error):
                self.error = error as NSError
            }
        }
    }
}
