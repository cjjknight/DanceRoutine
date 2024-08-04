import Foundation

class RoutineManager: ObservableObject {
    @Published var routines: [DanceRoutine] = []
    @Published var availableSteps: [DanceStep] = [
        DanceStep(name: "Basic Step", description: "The basic step of Quickstep", videoURL: nil),
        DanceStep(name: "Quarter Turn", description: "A quarter turn to the right", videoURL: nil),
        DanceStep(name: "Progressive Chasse", description: "A series of steps that progress down the floor", videoURL: nil),
        DanceStep(name: "Lock Step", description: "A step where one foot crosses behind the other", videoURL: nil),
        DanceStep(name: "Natural Turn", description: "A turn to the right", videoURL: nil),
        DanceStep(name: "Reverse Turn", description: "A turn to the left", videoURL: nil),
        DanceStep(name: "Tipple Chasse", description: "A quick chasse with a turning motion", videoURL: nil),
        DanceStep(name: "V6", description: "A step pattern that resembles the shape of a V and 6 quick steps", videoURL: nil),
        DanceStep(name: "Fishtail", description: "A step resembling the movement of a fish tail", videoURL: nil),
        DanceStep(name: "Hover Corte", description: "A step with a hovering motion", videoURL: nil),
        DanceStep(name: "Running Right Turn", description: "A series of quick steps in a right turn", videoURL: nil),
        DanceStep(name: "Zig Zag", description: "A series of quick steps in a zigzag pattern", videoURL: nil),
        DanceStep(name: "Pendulum Points", description: "Steps that swing like a pendulum", videoURL: nil),
        DanceStep(name: "Quick Open Reverse", description: "An open reverse turn", videoURL: nil),
        DanceStep(name: "Quick Natural Spin Turn", description: "A quick spin turn to the right", videoURL: nil),
        DanceStep(name: "Six Quick Run", description: "Six quick steps in a running motion", videoURL: nil),
        DanceStep(name: "Double Reverse Spin", description: "A double spin turn to the left", videoURL: nil),
        DanceStep(name: "Scatter Chasse", description: "A chasse step with a scattering motion", videoURL: nil),
        DanceStep(name: "Tipsy to Right", description: "A tipsy step to the right", videoURL: nil),
        DanceStep(name: "Tipsy to Left", description: "A tipsy step to the left", videoURL: nil),
        DanceStep(name: "Four Quick Run", description: "Four quick steps in a running motion", videoURL: nil),
        DanceStep(name: "Pepperpot", description: "A quick step with a pepperpot motion", videoURL: nil),
        DanceStep(name: "Running Finish", description: "A finishing step with a running motion", videoURL: nil),
        DanceStep(name: "Outside Change", description: "A change step taken outside partner", videoURL: nil)
    ]
    
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
