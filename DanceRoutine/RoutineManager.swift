import Foundation

class RoutineManager: ObservableObject {
    @Published var routines: [DanceRoutine] = []
    
    private let routinesKey = "savedRoutines"
    
    init() {
        loadRoutines()
    }
    
    func saveRoutine(_ routine: DanceRoutine) {
        routines.append(routine)
        saveRoutines()
    }
    
    func deleteRoutine(at offsets: IndexSet) {
        routines.remove(atOffsets: offsets)
        saveRoutines()
    }
    
    func saveRoutines() {
        if let encoded = try? JSONEncoder().encode(routines) {
            UserDefaults.standard.set(encoded, forKey: routinesKey)
        }
    }
    
    func loadRoutines() {
        if let savedData = UserDefaults.standard.data(forKey: routinesKey),
           let decoded = try? JSONDecoder().decode([DanceRoutine].self, from: savedData) {
            routines = decoded
        }
    }
}
