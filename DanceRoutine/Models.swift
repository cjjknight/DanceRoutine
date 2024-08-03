import Foundation

struct DanceStep: Identifiable, Codable, Equatable {
    let id = UUID()
    let name: String
    let description: String
    let videoURL: URL?
}

struct DanceRoutine: Identifiable, Codable {
    let id = UUID()
    var name: String
    var steps: [DanceStep]
}
