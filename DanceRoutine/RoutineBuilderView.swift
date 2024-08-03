import SwiftUI
import UniformTypeIdentifiers

struct RoutineBuilderView: View {
    @State private var steps: [DanceStep] = [
        DanceStep(name: "Basic Step", description: "The basic step of Quickstep", videoURL: nil),
        DanceStep(name: "Quarter Turn", description: "A quarter turn to the right", videoURL: nil)
        // Add more steps as needed
    ]
    
    @State private var routineSteps: [DanceStep] = []
    @State private var routineName: String = ""
    
    @EnvironmentObject var routineManager: RoutineManager
    
    var body: some View {
        VStack {
            Text("Build Your Dance Routine")
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
                            }
                            .onMove(perform: moveSteps)
                            .onInsert(of: [UTType.plainText], perform: insertSteps)
                        }
                        .frame(maxWidth: 200)
                    }
                    .onDrop(of: [UTType.plainText], isTargeted: nil, perform: handleDrop(providers:))
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            
            Button("Save Routine") {
                let newRoutine = DanceRoutine(name: routineName, steps: routineSteps)
                routineManager.saveRoutine(newRoutine)
                routineName = ""
                routineSteps = []
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
}

struct RoutineBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        RoutineBuilderView().environmentObject(RoutineManager())
    }
}
