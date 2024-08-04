import Foundation

struct DanceStep: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var description: String
    var videoURL: URL?
    
    init(id: UUID = UUID(), name: String, description: String, videoURL: URL?) {
        self.id = id
        self.name = name
        self.description = description
        self.videoURL = videoURL
    }
    
    static func == (lhs: DanceStep, rhs: DanceStep) -> Bool {
        return lhs.id == rhs.id
    }
}

struct DanceRoutine: Identifiable, Codable {
    let id = UUID()
    var name: String
    var steps: [DanceStep]
}
