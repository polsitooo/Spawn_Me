// ContentView.swift
import SwiftUI
import UserNotifications

struct NotificationTemplate: Identifiable, Codable {
    let id: Int
    let title: String
    let content: String
}

struct ContentView: View {
    @State private var templates: [NotificationTemplate] = []
    @State private var selectedTemplate: NotificationTemplate?
    @State private var customTitle: String = ""
    @State private var customContent: String = ""
    @State private var delay: Double = 3.0
    
    @State private var showSettings: Bool = false
    @State private var showTemplateList: Bool = false
    @State private var showAddTemplate: Bool = false
    
    private let templatesKey = "SavedTemplates"

    var body: some View {
        NavigationView {
            VStack {
                // MARK: - Template Management Section
                HStack(spacing: 16) {
                    // Show Templates Button
                    Button(action: {
                        showTemplateList = true
                    }) {
                        HStack {
                            Image(systemName: "list.bullet")
                            Text("Show Templates")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                    
                    // Add Template Button
                    Button(action: {
                        showAddTemplate = true
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add Template")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                // MARK: - Input Fields Section
                VStack(alignment: .leading, spacing: 12) {
                    TextField("Notification Title", text: $customTitle)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .shadow(radius: 2)

                    TextField("Notification Text", text: $customContent)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .shadow(radius: 2)
                }
                .padding()

                // MARK: - Delay Control Section
                VStack {
                    Text("Spawn Delay: \(Int(delay)) seconds")
                        .font(.headline)
                    Slider(value: $delay, in: 1...60, step: 1)
                        .accentColor(.blue)
                }
                .padding()

                // MARK: - Notification Buttons
                HStack {
                    // Immediate notification button
                    Button(action: { sendImmediateNotification() }) {
                        Text("Spawn Now!")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(
                                gradient: Gradient(colors: [.green, .blue]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                            .cornerRadius(10)
                            .shadow(radius: 4)
                    }
                    
                    // Delayed notification button
                    Button(action: { sendDelayedNotification() }) {
                        Text("Spawn with Delay")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(
                                gradient: Gradient(colors: [.blue, .purple]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                            .cornerRadius(10)
                            .shadow(radius: 4)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            // MARK: - Navigation Bar Configuration
            .navigationBarItems(
                leading: Button(action: {
                    showSettings = true
                }) {
                    Image(systemName: "gear")
                        .imageScale(.large)
                        .foregroundColor(.blue)
                }
                .sheet(isPresented: $showSettings) {
                    SettingsView()
                }
            )
            .navigationTitle("Blue Loader C2")
            .onAppear { loadTemplates() }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        // MARK: - Template Management Sheets
        .sheet(isPresented: $showTemplateList) {
            TemplateListView(templates: $templates, onSelect: { template in
                customTitle = template.title
                customContent = template.content
                selectedTemplate = template
            })
        }
        .sheet(isPresented: $showAddTemplate) {
            AddTemplateView(templates: $templates) { newTemplate in
                templates.append(newTemplate)
                saveTemplates()
            }
        }
    }

    // MARK: - Helper Functions
    
    func sendImmediateNotification() {
        NotificationManager.shared.sendImmediateNotification(
            title: customTitle,
            message: customContent
        )
    }
    
    func sendDelayedNotification() {
        NotificationManager.shared.sendDelayedNotification(
            title: customTitle,
            message: customContent,
            delay: delay
        )
    }

    func loadTemplates() {
        if let data = UserDefaults.standard.data(forKey: templatesKey) {
            do {
                templates = try JSONDecoder().decode([NotificationTemplate].self, from: data)
            } catch {
                print("Error decoding templates: \(error.localizedDescription)")
            }
        }
    }
    
    private func saveTemplates() {
        do {
            let data = try JSONEncoder().encode(templates)
            UserDefaults.standard.set(data, forKey: templatesKey)
        } catch {
            print("Error saving templates: \(error.localizedDescription)")
        }
    }
}