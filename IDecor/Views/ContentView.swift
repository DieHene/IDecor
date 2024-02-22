import SwiftUI

struct ContentView: View {
    @State private var alertVisible: Bool = true
    
    @State private var objects: [ARModel] = [ARModel(id: "chair", sysName: "chair", scale: 0.6),
                                             ARModel(id: "tv", sysName: "tv", scale: 0.5),
                                             ARModel(id: "gramophone", sysName: "music.quarternote.3", scale: 0.6)]
    
    var body: some View {
        CustomARViewRepresentable()
            .ignoresSafeArea()
            .overlay (alignment: .bottom) {
                ScrollView(.horizontal) {
                    HStack {
                        Button {
                            ARManager.shared.actionStream.send(.removeAllAnchors)
                        } label: {
                            Image(systemName: "trash")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .padding()
                                .background(.regularMaterial)
                        }
                        
                        ForEach(objects, id: \.self) { object in
                            Button {
                                ARManager.shared.actionStream.send(.placeObject(object: object.id, scale: object.scale))
                            } label: {
                                Image(systemName: object.sysName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .padding()
                                    .background(.regularMaterial)
                            }
                        }
                    }
                    .padding()
                }
            }
            .alert(isPresented: $alertVisible) {
                Alert(title: Text("Wichtiger Hinweis"),
                      message: Text("Vor dem Platzieren von Objekten die Oberfläche langsam mit der Kamera einscannen"),
                      dismissButton: .default(Text("Ok")))
            }
    }
}
