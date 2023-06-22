/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import SwiftUI


struct LoginView: View {
  
  //--------------------------------------------------------------------------//
  // View Model(s)
  
  @EnvironmentObject var accountViewModel: AccountViewModel
  
  
  //--------------------------------------------------------------------------//
  // States
  
  enum LoginViewState {
    case description
    case login
    case signup
  }
  @State var viewState: LoginViewState = .description
  
  @State var name:     String = ""
  @State var phone:    String = ""
  @State var email:    String = ""
  @State var password: String = ""
  
  @State private var _showPasswordResetModal: Bool = false
  
  
  //--------------------------------------------------------------------------//
  // View
  
  var body: some View {
    GeometryReader { geo in
      ZStack { // overlay view onto the bg
        LoginBackgroundView()
          .onTapGesture { self.hideKeyboard() } // FIXME: make scrollview not cover ontapgesture
          .opacity({
            if self.viewState == .description {
              return 1
            }
            return 0.3
          }())
        
        //
        // content
        VStack {
          ScrollView { // form
            VStack(alignment: .center, spacing: 12) {
              
              Spacer()
                .frame(height: geo.safeAreaInsets.top)
              
//              FSText("\(geo.size.debugDescription)")
              
              /// FIXME: this is absolutely TERRIBLE. PLEASE PLEASE PLEASE,
              /// figure this one out
              /// hey this is me from the future. it isn't nearly as fucked up as
              /// FSModal. that shit is ACTUALLY terrible. this is nothin', kiddo
              Spacer()
                .frame(height: geo.size.height / 5)
                .allowsHitTesting(false)
              
              Image("login_logo")
                .resizable()
                .scaledToFit()
                .frame(width: geo.size.width / 1.25)
                .onTapGesture {
                  self.accountViewModel.login(
                    email: "dessie04@example.org",
                    password: "password"
                  )
                }
              
              if self.viewState == .description {
                FSText(
                  "No te quedes sin mesa",
                  font: .heading2,
                  alignment: .center,
                  multilineAlignment: .center
                )
                FSText(
                  "Descubre las mesas libres en tiempo real y reserva en los mejores restaurantes",
                  font: .lead,
                  alignment: .center,
                  multilineAlignment: .center
                )
              }
              if self.viewState == .login {
                FSTextField("Correo", icon: .mail, text: $email, keyboardType: .emailAddress)
                FSTextField("Contraseña", icon: .lock, type: .password, text: $password, keyboardType: .asciiCapable)
                FSText("¿Olvidaste tu contraseña?", font: .bodyBold, alignment: .trailing, multilineAlignment: .trailing)
                  .onTapGesture {
                    self._showPasswordResetModal.toggle()
                  }
                FSText("¿Aún no tienes cuenta? Regístrate", alignment: .trailing, multilineAlignment: .trailing)
                  .onTapGesture {
                    self.viewState = .signup
                  }
              }
              if self.viewState == .signup {
                FSTextField("Nombre", icon: .profile, text: $name)
                FSTextField("Teléfono", icon: .phone, text: $phone, keyboardType: .phonePad)
                FSTextField("Correo", icon: .mail, text: $email, keyboardType: .emailAddress)
                FSTextField("Contraseña", icon: .lock, type: .password, text: $password, keyboardType: .asciiCapable)
                FSText("¿Ya tienes cuenta? Inicia sesión", alignment: .trailing, multilineAlignment: .trailing)
                  .onTapGesture {
                    self.viewState = .login
                  }
              }
              
            }
            .frame(maxHeight: .infinity, alignment: .center)
            .padding(.horizontal, FSUnit.side(.xl))
            
            
          } // form ends here
//          .onTapGesture { self.hideKeyboard() }
          .frame(maxHeight: .infinity, alignment: .center)
          
          
          VStack { // bottom actions
            if self.viewState == .signup
            || self.viewState == .description {
              FSButton("Crear cuenta", type: .primary) {
                if self.viewState == .signup {
                  self.accountViewModel.register(
                    name: self.name,
                    email: self.email,
                    password: self.password,
                    phone: self.phone
                  )
                } else {
                  self.viewState = .signup
                }
              }
            }
            if self.viewState == .login
            || self.viewState == .description {
              FSButton("Iniciar sesión", type: .primary) {
                if self.viewState == .login {
                  print("ey")
                  self.accountViewModel.login(
                    email: self.email,
                    password: self.password
                  )
                } else {
                  self.viewState = .login
                }
              }
            }
          } // bottom actions ends here
          .padding([.horizontal, .bottom], FSUnit.side(.xl))
          .padding(.bottom, geo.safeAreaInsets.bottom)
          
        } // view vstack ends here
      }
      .frame(maxHeight: .infinity)
      .background(Color.primaryBg)
      .ignoresSafeArea() // manually handle safe area insets to allow unclipped overscroll
      
    } // background zstack ends here
    .errorAlert(error: self.$accountViewModel.error)
    .sheet(isPresented: self.$_showPasswordResetModal) {
      LoginPasswordResetModal()
    }
  }
}


struct LoginBackgroundView: View {
  var body: some View {
      GeometryReader { geo in
      ZStack {
        Color.primaryBg
          .ignoresSafeArea()
        
        //
        // navbar
        ZStack {
          Rectangle()
            .frame(width: geo.size.width, height: geo.safeAreaInsets.top)
            .foregroundColor(Color.highlightBg)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea()
        
        //
        // gesture bar
        ZStack(alignment: .bottom) {
          Rectangle()
            .frame(width: geo.size.width, height: geo.safeAreaInsets.bottom)
            .foregroundColor(Color.secondaryBg)
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        
        //
        // bg
        VStack {
          Image("login_top")
            .resizable()
            .scaledToFit()
            .frame(width: geo.size.width)
            .foregroundColor(Color.highlightBg)
          
          Spacer()
          
          Image("login_bottom")
            .resizable()
            .scaledToFit()
            .frame(width: geo.size.width)
            .foregroundColor(Color.secondaryBg)
        }
        
        //
        // icons
        ZStack(alignment: .bottom) {
          Image("login_bottom_time")
            .resizable()
            .frame(
              width: geo.size.width,
              height: geo.size.width
            )
            .rotationEffect(Angle(degrees: 35))
            .offset(x: geo.size.width / 4, y: geo.safeAreaInsets.bottom * 1.5)
            .foregroundColor(Color.tertiaryBg)
            .opacity(0.5)
          
          Image("login_bottom_fork")
            .resizable()
            .frame(
              width: geo.size.width,
              height: geo.size.width
            )
            .rotationEffect(Angle(degrees: 15))
            .offset(y: geo.safeAreaInsets.bottom * 1.5)
            .foregroundColor(Color.tertiaryBg)
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        
      }
      .frame(maxHeight: .infinity)
    }
  }
}


struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView()
  }
}
