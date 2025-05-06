@echo off
:: Auto-updates Gradle and AGP safely with visible output

echo === Updating Android Gradle Plugin version to 8.2.1 ===
powershell -Command "try { (Get-Content android\build.gradle) -replace 'com.android.tools.build:gradle:[0-9\.]+', 'com.android.tools.build:gradle:8.2.1' | Set-Content android\build.gradle; Write-Host '✓ AGP version updated.' } catch { Write-Host '✗ Failed to update build.gradle'; exit 1 }"

echo === Updating Gradle Wrapper to 8.4 ===
powershell -Command "try { (Get-Content android\gradle\wrapper\gradle-wrapper.properties) -replace 'distributionUrl=.*', 'distributionUrl=https\://services.gradle.org/distributions/gradle-8.4-all.zip' | Set-Content android\gradle\wrapper\gradle-wrapper.properties; Write-Host '✓ Gradle wrapper updated.' } catch { Write-Host '✗ Failed to update gradle-wrapper.properties'; exit 1 }"

echo === Cleaning Flutter project ===
flutter clean || echo "✗ flutter clean failed"

echo.
echo === All done! Now open terminal and run: ===
echo flutter pub get
echo flutter run
echo.
pause
