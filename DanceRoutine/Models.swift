import Foundation

struct DanceStep: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let videoURL: URL?
}

struct DanceRoutine: Identifiable {
    let id = UUID()
    var name: String
    var steps: [DanceStep]
}
