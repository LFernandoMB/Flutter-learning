# Gerando instaladores Projeto InAppWebView


## Gerar Release
- flutter run -d windows --release


## Gerar MSIX
- flutter pub run msix:create


## Gerar MSI

** Gerar GUID **
- [guid]::NewGuid()
- Adicionar o GUID no 'UpgradeCode' do script installer.wxs

** Gerar AppFiles.wsx **
- heat dir "..\build\windows\x64\runner\Release" -cg AppFiles -dr INSTALLFOLDER -gg -sfrag -srd -scom -sreg -sval -suid -var var.SourceDir -out AppFiles.wxs

** Compila o XML **
- candle installer.wxs AppFiles.wxs -dSourceDir="..\build\windows\x64\runner\Release"

** Gera o Instalador **
- light installer.wixobj AppFiles.wixobj -dSourceDir="..\build\windows\x64\runner\Release" -o MoldeIDEB.msi
