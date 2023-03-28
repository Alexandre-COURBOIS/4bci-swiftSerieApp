import Foundation

protocol SerieService {
    
    func fetchSeries(from endpoint: SerieListEndpoint, completion: @escaping (Result<SerieResponse, SerieError>) -> ())
    func fetchSerie(id: Int, completion: @escaping (Result<Serie, SerieError>) -> ())
    func searchSerie(query: String, completion: @escaping (Result<SerieResponse, SerieError>) -> ())
}

enum SerieListEndpoint: String, CaseIterable, Identifiable {
    
    var id: String { rawValue }
    
    case nowPlaying = "airing_today"
    case topRated = "top_rated"
    
    var description: String {
        switch self {
            case .nowPlaying: return "Now Playing"
            case .topRated: return "Top Rated"
        }
    }
}

enum SerieError: Error, CustomNSError {
    
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    var localizedDescription: String {
        switch self {
        case .apiError: return "Failed to fetch data"
        case .invalidEndpoint: return "Invalid endpoint"
        case .invalidResponse: return "Invalid response"
        case .noData: return "No data"
        case .serializationError: return "Failed to decode data"
        }
    }
    
    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
    
}

