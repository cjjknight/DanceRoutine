import SwiftUI
import UniformTypeIdentifiers

struct RoutineBuilderView: View {
    @State private var routineSteps: [DanceStep]
    @State private var routineName: String
    @State private var isEditing: Bool
    @State private var routineId: UUID?
    @State private var showingAddNewStep = false
    @State private var showingEditStep = false
    @State private var selectedStep: DanceStep?
    
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
                        ForEach(routineManager.availableSteps) { step in
                            Text(step.name)
                                .onDrag {
                                    NSItemProvider(object: step.name as NSString)
                                }
                                .onTapGesture(count: 2) {
                                    addStepToRoutine(step: step)
                                }
                                .swipeActions {
                                    Button("Edit") {
                                        selectedStep = step
                                        showingEditStep.toggle()
                                    }
                                    .tint(.blue)
                                    
                                    Button("Delete", role: .destructive) {
                                        if let index = routineManager.availableSteps.firstIndex(where: { $0.id == step.id }) {
                                            routineManager.availableSteps.remove(at: index)
                                        }
                                    }
                                }
                        }
                        
                        Button("Add New Step") {
                            showingAddNewStep.toggle()
                        }
                        .sheet(isPresented: $showingAddNewStep) {
                            AddNewStepView().environmentObject(routineManager)
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
        .sheet(item: $selectedStep) { step in
            EditStepView(step: step).environmentObject(routineManager)
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
                        if let step = routineManager.availableSteps.first(where: { $0.name == stepName }) {
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
                        if let step = routineManager.availableSteps.first(where: { $0.name == stepName }) {
                            routineSteps.append(step)
                        } else if let step = routineSteps.first(where: { $0.name == stepName }) {
                            routineSteps.removeAll { $0 == step }
                            routineManager.availableSteps.append(step)
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
