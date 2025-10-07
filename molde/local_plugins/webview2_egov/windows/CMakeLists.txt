cmake_minimum_required(VERSION 3.14)
project(webview2_egov_plugin LANGUAGES CXX)

# ========================
# 🧩 Configuração do Flutter
# ========================
set(FLUTTER_EPHEMERAL_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../windows/flutter/ephemeral")
set(FLUTTER_CPPW_WRAPPER_DIR "${FLUTTER_EPHEMERAL_DIR}/cpp_client_wrapper")
set(FLUTTER_CPPW_INCLUDE_DIR "${FLUTTER_CPPW_WRAPPER_DIR}/include")

# ===============================
# 🌐 Caminho do SDK do WebView2
# ===============================
set(WEBVIEW2_NATIVE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../../../../windows/packages/Microsoft.Web.WebView2.1.0.2420.47/build/native")

# Debug route to WebView2
# if(EXISTS "${WEBVIEW2_NATIVE_DIR}/x64/WebView2LoaderStatic.lib")
#   message(STATUS "✅ WebView2LoaderStatic.lib encontrado em ${WEBVIEW2_NATIVE_DIR}/x64/")
#   set(WEBVIEW2_LIB_PATH "${WEBVIEW2_NATIVE_DIR}/x64/WebView2LoaderStatic.lib")
# elseif(EXISTS "${WEBVIEW2_NATIVE_DIR}/arm64/WebView2LoaderStatic.lib")
#   message(STATUS "✅ WebView2LoaderStatic.lib encontrado em ${WEBVIEW2_NATIVE_DIR}/arm64/")
#   set(WEBVIEW2_LIB_PATH "${WEBVIEW2_NATIVE_DIR}/arm64/WebView2LoaderStatic.lib")
# else()
#   message(WARNING "⚠️ WebView2LoaderStatic.lib NÃO encontrado! Caminho verificado:")
#   message(WARNING "    ${WEBVIEW2_NATIVE_DIR}/x64/WebView2LoaderStatic.lib")
#   message(WARNING "    ${WEBVIEW2_NATIVE_DIR}/arm64/WebView2LoaderStatic.lib")
# endif()

# Inclui headers do WebView2
include_directories("${WEBVIEW2_NATIVE_DIR}/include")

# ===============================
# 🧱 Criação da biblioteca do plugin
# ===============================
add_library(webview2_egov_plugin SHARED
  "webview2_egov.cpp"
)

# Permite escrita concorrente em .pdb
target_compile_options(webview2_egov_plugin PRIVATE /FS)

# Requer C++17
target_compile_features(webview2_egov_plugin PUBLIC cxx_std_17)

# ===============================
# 📂 Includes principais
# ===============================
target_include_directories(webview2_egov_plugin PUBLIC
  "${CMAKE_CURRENT_SOURCE_DIR}"
  "${CMAKE_CURRENT_SOURCE_DIR}/.."
  "${CMAKE_CURRENT_SOURCE_DIR}/webview2_egov"
  "${CMAKE_CURRENT_SOURCE_DIR}/windows"
  "${FLUTTER_EPHEMERAL_DIR}"
  "${FLUTTER_CPPW_INCLUDE_DIR}"
)

# ===============================
# 🔗 Linkagem de bibliotecas
# ===============================
if(EXISTS "${WEBVIEW2_NATIVE_DIR}/x64/WebView2LoaderStatic.lib")
  message(STATUS "✅ WebView2LoaderStatic.lib encontrado em ${WEBVIEW2_NATIVE_DIR}/x64/")
  set(WEBVIEW2_LIB_PATH "${WEBVIEW2_NATIVE_DIR}/x64/WebView2LoaderStatic.lib")
elseif(EXISTS "${WEBVIEW2_NATIVE_DIR}/arm64/WebView2LoaderStatic.lib")
  message(STATUS "✅ WebView2LoaderStatic.lib encontrado em ${WEBVIEW2_NATIVE_DIR}/arm64/")
  set(WEBVIEW2_LIB_PATH "${WEBVIEW2_NATIVE_DIR}/arm64/WebView2LoaderStatic.lib")
else()
  message(WARNING "⚠️ WebView2LoaderStatic.lib NÃO encontrado! Verifique o caminho do pacote WebView2.")
endif()

target_link_libraries(webview2_egov_plugin PRIVATE
  flutter
  flutter_wrapper_plugin
  WindowsApp
  "${WEBVIEW2_LIB_PATH}"
)

# Exporta símbolos automaticamente no Windows
set_target_properties(webview2_egov_plugin PROPERTIES
  WINDOWS_EXPORT_ALL_SYMBOLS ON
)

# ===============================
# 🔍 Auto-detecção do SDK WebView2
# ===============================
message(STATUS "🔍 Procurando WebView2.h...")

find_path(WEBVIEW2_INCLUDE_DIR
  NAMES WebView2.h
  HINTS
    "${CMAKE_CURRENT_SOURCE_DIR}/../../../windows/packages"
    "${CMAKE_CURRENT_SOURCE_DIR}/../../../../windows/packages"
    "${CMAKE_CURRENT_SOURCE_DIR}/../../../../../windows/packages"
    "${CMAKE_CURRENT_SOURCE_DIR}/../../../../../../windows/packages"
  PATH_SUFFIXES
    Microsoft.Web.WebView2.1.0.2420.47/build/native/include
    build/native/include
)

if(WEBVIEW2_INCLUDE_DIR)
  message(STATUS "✅ WebView2 SDK encontrado em: ${WEBVIEW2_INCLUDE_DIR}")
  target_include_directories(webview2_egov_plugin PUBLIC "${WEBVIEW2_INCLUDE_DIR}")
else()
  message(WARNING "⚠️ WebView2 SDK não encontrado automaticamente. Verifique se o pacote NuGet foi instalado em windows/packages/.")
endif()

# ===============================
# 🧰 Windows Implementation Library (WIL)
# ===============================
find_path(WIL_INCLUDE_DIR
  NAMES wil/com.h
  HINTS
    "${CMAKE_CURRENT_SOURCE_DIR}/../../../windows/packages"
    "${CMAKE_CURRENT_SOURCE_DIR}/../../../../windows/packages"
    "${CMAKE_CURRENT_SOURCE_DIR}/../../../../../windows/packages"
    "${CMAKE_CURRENT_SOURCE_DIR}/../../../../../../windows/packages"
  PATH_SUFFIXES
    Microsoft.Windows.ImplementationLibrary.1.0.230629.1/include
    include
)

if(WIL_INCLUDE_DIR)
  message(STATUS "✅ WIL encontrado em: ${WIL_INCLUDE_DIR}")
  target_include_directories(webview2_egov_plugin PUBLIC "${WIL_INCLUDE_DIR}")
else()
  message(WARNING "⚠️ WIL não encontrado. Verifique se o pacote foi instalado com NuGet.")
endif()
