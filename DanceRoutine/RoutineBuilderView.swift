import SwiftUI
import UniformTypeIdentifiers

struct RoutineBuilderView: View {
    @State private var steps: [DanceStep] = [
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
    
    @State private var routineSteps: [DanceStep]
    @State private var routineName: String
    @State private var isEditing: Bool
    @State private var routineId: UUID?
    
    @EnvironmentObject var routineManager: RoutineManager
    @Environment(\.presentationMode) var presentationMode
    
    init(routine: DanceRoutine? = nil) {
        if let routine = routine {
            _routineName = State(initialValue: routine.name)
            _routineSteps = State(initialValue: routine.steps)
            _isEditing = State(initialValue: true)
            _routineId = State(initialValue: routine.id)
        } else {
            _routineName = State(initialValue: "")
            _routineSteps = State(initialValue: [
                DanceStep(name: "Basic Step", description: "The basic step of Quickstep", videoURL: nil)
            ])
            _isEditing = State(initialValue: false)
            _routineId = State(initialValue: nil)
        }
    }
    
    var body: some View {
        VStack {
            Text(isEditing ? "Edit Dance Routine" : "Build Your Dance Routine")
                .font(.largeTitle)
                .padding()
            
            TextField("Routine Name", text: $routineName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            HStack {
                VStack {
                    Text("Available Steps")
                        .font(.headline)
                    
                    List {
                        ForEach(steps) { step in
                            Text(step.name)
                                .onDrag {
                                    NSItemProvider(object: step.name as NSString)
                                }
                                .onTapGesture(count: 2) {
                                    addStepToRoutine(step: step)
                                }
                        }
                    }
                }
                .frame(maxWidth: 200)
                
                VStack {
                    Text("Routine Steps")
                        .font(.headline)
                    
                    VStack {
                        List {
                            ForEach(routineSteps) { step in
                                Text(step.name)
                                    .onDrag {
                                        NSItemProvider(object: step.name as NSString)
                                    }
                            }
                            .onMove(perform: moveSteps)
                            .onDelete(perform: deleteStep)
                            .onInsert(of: [UTType.plainText], perform: insertSteps)
                        }
                        .frame(maxWidth: 200)
                    }
                    .onDrop(of: [UTType.plainText], isTargeted: nil, perform: handleDrop(providers:))
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            
            Button(isEditing ? "Save Changes" : "Save Routine") {
                if isEditing {
                    if let index = routineManager.routines.firstIndex(where: { $0.id == routineId }) {
                        routineManager.routines[index].name = routineName
                        routineManager.routines[index].steps = routineSteps
                    }
                } else {
                    let newRoutine = DanceRoutine(name: routineName, steps: routineSteps)
                    routineManager.saveRoutine(newRoutine)
                }
                routineManager.saveRoutines()
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
    }
    
    private func moveSteps(from source: IndexSet, to destination: Int) {
        routineSteps.move(fromOffsets: source, toOffset: destination)
    }
    
    private func insertSteps(at index: Int, itemProviders: [NSItemProvider]) {
        for item in itemProviders {
            item.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { (data, error) in
                if let data = data as? Data, let stepName = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        if let step = steps.first(where: { $0.name == stepName }) {
                            routineSteps.insert(step, at: index)
                        }
                    }
                }
            }
        }
    }
    
    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        for provider in providers {
            provider.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { (data, error) in
                if let data = data as? Data, let stepName = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        if let step = steps.first(where: { $0.name == stepName }) {
                            routineSteps.append(step)
                        } else if let step = routineSteps.first(where: { $0.name == stepName }) {
                            routineSteps.removeAll { $0 == step }
                            steps.append(step)
                        }
                    }
                }
            }
        }
        return true
    }
    
    private func addStepToRoutine(step: DanceStep) {
        routineSteps.append(step)
    }
    
    private func deleteStep(at offsets: IndexSet) {
        routineSteps.remove(atOffsets: offsets)
    }
}

struct RoutineBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        RoutineBuilderView().environmentObject(RoutineManager())
    }
}
