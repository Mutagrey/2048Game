//
//  CustomBlurView.swift
//  2048Game
//
//  Created by Sergey Petrov on 15.09.2022.
//

import SwiftUI

struct CustomBlurView: UIViewRepresentable {
    var effect: UIBlurEffect.Style
    var onChange: (UIVisualEffectView) -> ()
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: effect))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        DispatchQueue.main.async {
            onChange(uiView)
        }
    }

}
 
extension UIVisualEffectView {
    var backDrop: UIView? {
        return subView(forClass: NSClassFromString("_UIVisualEffectBackdropView"))
    }
    
    var gaussianBlur: NSObject? {
        return backDrop?.value(key: "filters", filter: "gaussianBlur")
    }
    
    var saturation: NSObject?{
        return backDrop?.value(key: "filters", filter: "colorSaturate")
    }
    
    var gaussianBlurRadius: CGFloat{
        get{
            return gaussianBlur?.values?["inputRadius"] as? CGFloat ?? 0
        }
        set{
            gaussianBlur?.values?["inputRadius"] = newValue
            applyNewEffects()
        }
    }
    
    var saturationAmount: CGFloat{
        get{
            return saturation?.values?["inputAmount"] as? CGFloat ?? 0
        }
        set{
            saturation?.values?["inputAmount"] = newValue
            applyNewEffects()
        }
    }
    
    func applyNewEffects() {
        backDrop?.perform(Selector("applyRequestedFilterEffects"))
    }
}

extension NSObject{
    var values: [String: Any]? {
        get{
            return value(forKey: "requestedValues") as? [String: Any]
        }
        set{
            setValue(newValue, forKeyPath: "requestedValues")
        }
    }
    func value(key: String, filter: String)-> NSObject?{
        (value(forKey: key) as? [NSObject])?.first(where: { obj in
            return obj.value(forKeyPath: "filterType") as? String == filter
        })
    }
}

extension UIView{
    func subView(forClass: AnyClass?) -> UIView?{
        return subviews.first { view in
            type(of: view) == forClass
        }
    }
}

struct CustomBlurView_Previews: PreviewProvider {
    static var previews: some View {
        TestBlurEffects()


    }
}

struct TestBlurEffects: View {
    
    @State private var blurView: UIVisualEffectView = .init()
    @State private var defaultBlurRadius: CGFloat = 0
    @State private var defaultSaturationAmount: CGFloat = 0
    @State private var progress: CGFloat = 0
    @State private var activateGlassMorphism: Bool = false
    var body: some View{
        ZStack{
            LinearGradient(colors: [.black.opacity(0.2), .black.opacity(0.5), .black.opacity(0.8), .black], startPoint: .topLeading, endPoint: .bottom)
                .ignoresSafeArea()
            
            Circle()
                .fill(.indigo.gradient)
                .frame(width: 300, height: 300)
                .offset(x: 150, y: -90)
            
            Circle()
                .fill(.yellow.gradient)
                .frame(width: 150, height: 150)
                .offset(x: -150, y: 90)
            
            Circle()
                .fill(.red .gradient)
                .frame(width: 80, height: 80)
                .offset(x: -40, y: -100)
            
            GlassMorphicCard()
            Toggle("Activate GlassMorphism", isOn: $activateGlassMorphism)
                .modifier(CustomTextModifier(font: .callout))
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding()
                .onChange(of: activateGlassMorphism) { newValue in
                    // Changing blur radius and saturation
                    blurView.gaussianBlurRadius = (activateGlassMorphism ? 10 : defaultBlurRadius)
                    blurView.saturationAmount = (activateGlassMorphism ? 1.8 : defaultSaturationAmount)
                }

        }
    }
    
    @ViewBuilder
    func GlassMorphicCard()->some View{
        ZStack {
            CustomBlurView(effect: .systemUltraThinMaterialDark) { view in
                blurView = view
                if defaultBlurRadius == 0 { defaultBlurRadius = view.gaussianBlurRadius}
                if defaultSaturationAmount == 0 { defaultSaturationAmount = view.saturationAmount}
            }
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            
            // GlassMorphic Card
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(
                    .linearGradient(colors: [
                        .white.opacity(0.25),
                        .white.opacity(0.05),
                        .clear
                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .blur(radius: 5)
            
            // Borders
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .stroke(
                    .linearGradient(colors: [
                        .white.opacity(0.6),
                        .clear,
                        .purple.opacity(0.2),
                        .purple.opacity(0.5),
                        .clear
                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                    ,lineWidth: 2)

        }
        //Shadows
        .shadow(color: .black.opacity(0.15), radius: 5, x: -10, y: 10)
        .shadow(color: .black.opacity(0.15), radius: 5, x: 10, y: -10)
        .overlay {
            // MARK: Content
            CardContent()
                .opacity(activateGlassMorphism ? 1 : 0)
                .animation(.easeInOut(duration: 0.5), value: activateGlassMorphism)
        }
        .frame(height: 220)
        .padding()
    }
    
    @ViewBuilder
    func CardContent()->some View{
        VStack(alignment: .leading, spacing: 10) {
            HStack{
                Text("MEMBERSHIP")
                    .modifier(CustomTextModifier(font: .callout))
                Image(systemName: "creditcard.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                    .foregroundColor(.white)
            }
            Spacer()
            
            Text("MR. GREY")
                .modifier(CustomTextModifier(font: .title2))
            Text("MUTAGREY")
                .modifier(CustomTextModifier(font: .callout))
        }
        .padding(20)
        .padding(.vertical, 10)
        .blendMode(.overlay)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}


// MARK: - Custom Modifiers for Text
struct CustomTextModifier: ViewModifier {
    var font: Font
    func body(content: Content) -> some View {
        content
            .font(font)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .kerning(1.2)
            .shadow(radius: 15)
            .frame(maxWidth: .infinity, alignment: .leading)
        
    }
    
    
}
