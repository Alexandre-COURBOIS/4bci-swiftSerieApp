import Foundation

struct SerieResponse: Decodable {
    
    let results: [Serie]
}


struct Serie: Decodable, Identifiable, Hashable {
    static func == (lhs: Serie, rhs: Serie) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: Int
    let name: String
    let backdropPath: String?
    let posterPath: String?
    let overview: String
    let voteAverage: Double
    let voteCount: Int
    let runtime: Int?
    let releaseDate: String?
    let firstAirDate: String
    
    let genres: [SerieGenre]?
    let credits: SerieCredit?
    let videos: SerieVideoResponse?
    
    static private let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    static private let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute]
        return formatter
    }()
    
    var backdropURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath ?? "")")!
    }
    
    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")!
    }
    
    var genreText: String {
        genres?.first?.name ?? ""
    }
    
    var ratingText: String {
        let rating = Int(voteAverage)
        let ratingText = (0..<rating).reduce("") { (acc, _) -> String in
            return acc + "★"
        }
        return ratingText
    }
    
    var scoreText: String {
        guard ratingText.count > 0 else {
            return ""
        }
        return "\(ratingText.count)/10"
    }
    
    var yearText: String {
        guard let releaseDate = self.releaseDate, let date = Utils.dateFormatter.date(from: releaseDate) else {
            return ""
        }
        return Serie.yearFormatter.string(from: date)
    }
    
    var firstAirDateText: String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: firstAirDate) {
            
            let newDateFormatter = DateFormatter()
            
            newDateFormatter.dateFormat = "dd MMMM yyyy"
            
            let newDateString = newDateFormatter.string(from: date)
            return newDateString
        } else {
            return ""
        }
    }
    
    var durationText: String {
        guard let runtime = self.runtime, runtime > 0 else {
            return ""
        }
        return Serie.durationFormatter.string(from: TimeInterval(runtime) * 60) ?? ""
    }
    
    var cast: [SerieCast]? {
        credits?.cast
    }
    
    var crew: [SerieCrew]? {
        credits?.crew
    }
    
    var directors: [SerieCrew]? {
        crew?.filter { $0.job.lowercased() == "director" }
    }
    
    var producers: [SerieCrew]? {
        crew?.filter { $0.job.lowercased() == "producer" }
    }
    
    var screenWriters: [SerieCrew]? {
        crew?.filter { $0.job.lowercased() == "story" }
    }
    
    var youtubeTrailers: [SerieVideo]? {
        videos?.results.filter { $0.youtubeURL != nil }
    }
    
}

struct SerieGenre: Decodable {
    
    let name: String
}

struct SerieCredit: Decodable {
    
    let cast: [SerieCast]
    let crew: [SerieCrew]
}

struct SerieCast: Decodable, Identifiable {
    let id: Int
    let character: String
    let name: String
}

struct SerieCrew: Decodable, Identifiable {
    let id: Int
    let job: String
    let name: String
}

struct SerieVideoResponse: Decodable {
    
    let results: [SerieVideo]
}

struct SerieVideo: Decodable, Identifiable {
    
    let id: String
    let key: String
    let name: String
    let site: String
    
    var youtubeURL: URL? {
        guard site == "YouTube" else {
            return nil
        }
        return URL(string: "https://youtube.com/watch?v=\(key)")
    }
}
