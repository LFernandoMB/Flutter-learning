#include "webview2_egov/webview2_egov.h"

// Inclusões do Flutter
#include "flutter/method_channel.h"
#include "flutter/standard_method_codec.h"

// Inclusões de C++ e Win32
#include <windows.h>
#include <wrl.h> 
#include <WebView2.h>
#include <wil/com.h>
#include <atlbase.h> // Para conversão de strings
#include <string>
#include <memory>

#include <flutter/plugin_registrar_windows.h>



void Webview2EgovRegisterWithRegistrar(FlutterDesktopPluginRegistrarRef registrar_ref) {
  auto registrar = flutter::PluginRegistrarManager::GetInstance()
                       ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar_ref);
  Webview2Egov::RegisterWithRegistrar(registrar);
}


// Definições de namespace para simplificar
using namespace Microsoft::WRL;

namespace {
    // ... (O restante das funções utilitárias e variáveis globais) ...
    HWND g_parent_hwnd = nullptr;
    wil::com_ptr<ICoreWebView2Controller> g_controller;
    wil::com_ptr<ICoreWebView2> g_webview;
    
    std::wstring string_to_wstring(const std::string& str) {
        if (str.empty()) return L"";
        int size_needed = MultiByteToWideChar(CP_UTF8, 0, &str[0], (int)str.size(), NULL, 0);
        std::wstring wstrTo(size_needed, 0);
        MultiByteToWideChar(CP_UTF8, 0, &str[0], (int)str.size(), &wstrTo[0], size_needed);
        return wstrTo;
    }
    
void ResizeWebView(HWND hwnd) {
    if (g_controller) {
        RECT bounds;
        GetClientRect(hwnd, &bounds);
        g_controller->put_Bounds(bounds);
    }
}

void DisposeWebView() {
    if (g_controller) {
        g_controller->Close();
        g_controller.reset();
        g_webview.reset();
    }
}

void ShowWebView(const std::string& url) {
    if (g_webview) {
        g_webview->Navigate(string_to_wstring(url).c_str());
        return;
    }

    if (!g_parent_hwnd) return;

    CreateCoreWebView2EnvironmentWithOptions(
        nullptr, nullptr, nullptr,
        Callback<ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler>(
            [url](HRESULT result, ICoreWebView2Environment* env) -> HRESULT {
                if (FAILED(result) || !env) return result;

                env->CreateCoreWebView2Controller(
                    g_parent_hwnd,
                    Callback<ICoreWebView2CreateCoreWebView2ControllerCompletedHandler>(
                        [url](HRESULT result, ICoreWebView2Controller* controller) -> HRESULT {
                            if (FAILED(result) || !controller) return result;

                            g_controller = controller;
                            g_controller->get_CoreWebView2(&g_webview);

                            wil::com_ptr<ICoreWebView2Controller2> controller2;
                            controller->QueryInterface(IID_PPV_ARGS(&controller2));
                            if (controller2) {
                                COREWEBVIEW2_COLOR bgColor = {255, 255, 255, 255}; 
                                controller2->put_DefaultBackgroundColor(bgColor);
                            }

                            ResizeWebView(g_parent_hwnd);

                            // g_controller->NotifyParentWindowPositionChanged();
                            g_controller->put_IsVisible(TRUE);
                            g_webview->Navigate(string_to_wstring(url).c_str());

                            return S_OK;
                        })
                        .Get());
                return S_OK;
            })
            .Get());
}

}  // namespace

// --- Globais ---
WNDPROC g_original_wndproc = nullptr;

// Função de interceptação da janela (para resize do WebView)
LRESULT CALLBACK WebView2WndProc(HWND hwnd, UINT message, WPARAM wparam, LPARAM lparam) {
    if (message == WM_SIZE) {
        ResizeWebView(hwnd);
    }
    // Encaminha para o procedimento original do Flutter
    return CallWindowProc(g_original_wndproc, hwnd, message, wparam, lparam);
}

// Implementação do Construtor
Webview2Egov::Webview2Egov(flutter::PluginRegistrarWindows* registrar) {
    g_parent_hwnd = registrar->GetView()->GetNativeWindow();
    g_original_wndproc = reinterpret_cast<WNDPROC>(
        SetWindowLongPtr(g_parent_hwnd, GWLP_WNDPROC, reinterpret_cast<LONG_PTR>(WebView2WndProc))
    );
}

void Webview2Egov::RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "webview2_egov",
          &flutter::StandardMethodCodec::GetInstance());

  // Define a função de callback para o canal de comunicação
  channel->SetMethodCallHandler(
      [](const flutter::MethodCall<flutter::EncodableValue>& call,
         std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
        // Implementação básica do MethodCallHandler
        if (call.method_name().compare("showWebView") == 0) {
            const auto* arguments = std::get_if<flutter::EncodableMap>(call.arguments());
            if (arguments) {
                const auto& url_value = arguments->at(flutter::EncodableValue("url"));
                const std::string& url = std::get<std::string>(url_value);
                ShowWebView(url);
                result->Success(flutter::EncodableValue(true));
                return;
            }
            result->Error("ARGUMENT_ERROR", "URL não fornecida.");
        } else if (call.method_name().compare("disposeWebView") == 0) {
            DisposeWebView();
            result->Success(flutter::EncodableValue(true));
        } else {
            result->NotImplemented();
        }
      });

  // Instancia e registra o plugin, passando o registrar para o construtor.
  auto plugin = std::make_unique<Webview2Egov>(registrar);
  registrar->AddPlugin(std::move(plugin));
}


std::optional<LRESULT> Webview2Egov::HandleWindowProc(HWND hwnd, UINT message, WPARAM wparam, LPARAM lparam) {
    if (message == WM_SIZE) {
        ResizeWebView(hwnd);
    }
    return std::nullopt;
}
Webview2Egov::~Webview2Egov() {
    // Garante que o WebView2 seja fechado antes do plugin ser destruído.
    DisposeWebView();
}