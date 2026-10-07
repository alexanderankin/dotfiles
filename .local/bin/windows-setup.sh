winget install -e --id JetBrains.Toolbox --accept-package-agreements --accept-source-agreements
winget install -e --id jqlang.jq --accept-package-agreements --accept-source-agreements
winget install -e --id Python.Python.3.11 --accept-package-agreements --accept-source-agreements
winget install -e --id Python.Python.3.12 --accept-package-agreements --accept-source-agreements
winget install -e --id Python.Python.3.13 --accept-package-agreements --accept-source-agreements
winget install -e --id Python.Python.3.14 --accept-package-agreements --accept-source-agreements
winget install -e --id OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements
winget install -e --id GnuWin32.Zip --accept-package-agreements --accept-source-agreements
winget install -e --id GnuWin32.UnZip --accept-package-agreements --accept-source-agreements
export PATH="$PATH:$(cygpath -w /c/Program\ Files\ \(x86\)/GnuWin32/bin)"
curl -s "https://get.sdkman.io" | bash
. ~/.sdkman/bin/sdkman-init.sh
sdk install java
sdk install jbang
sdk install gradle 9.6.1
sdk install java 25.4.4.1+1-graalce
sdk default java 25.0.4-tem
# manually copy folder if it cannot do it
cd .sdkman/candidates/java/
rm -rf current/
cp -r 25.0.4-tem/ current/
