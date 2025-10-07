#ifndef FLUTTER_PLUGIN_WEBVIEW2_EGOV_H_
#define FLUTTER_PLUGIN_WEBVIEW2_EGOV_H_


// Importações do Flutter - usando aspas duplas, que agora funcionam.
#include "flutter/plugin_registrar_windows.h"
#include <memory>
#include <optional>

// A classe do plugin precisa herdar de Plugin e WindowProcDelegate.
class Webview2Egov : public flutter::Plugin, public flutter::WindowProcDelegate {
public:
    // Construtor obrigatório para a classe do plugin.
    Webview2Egov(flutter::PluginRegistrarWindows* registrar);
    virtual ~Webview2Egov();

    // Método estático de registro.
    static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);

    // Implementação do WindowProcDelegate para gerenciar o redimensionamento.
    // O 'override' agora funcionará corretamente.
    std::optional<LRESULT> HandleWindowProc(HWND hwnd, UINT message, WPARAM wparam, LPARAM lparam);

private:
    // Mantenha as variáveis de estado aqui, se necessário no futuro.
};

void Webview2EgovRegisterWithRegistrar(FlutterDesktopPluginRegistrarRef registrar);

#endif  // FLUTTER_PLUGIN_WEBVIEW2_EGOV_H_
