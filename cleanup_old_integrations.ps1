$paths = @(
  "lib\core\config",
  "lib\services\ai",
  "lib\services\voice",
  "backend"
)
foreach ($path in $paths) {
  if (Test-Path $path) { Remove-Item $path -Recurse -Force }
}
Write-Host "Removed legacy AI, voice, config, and backend folders." -ForegroundColor Green
Write-Host "Now run: flutter clean; flutter pub get; flutter run -d windows" -ForegroundColor Cyan
