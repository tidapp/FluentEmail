#!/bin/bash

set -xeo pipefail

#find . -name '*.csproj' -o -name '*.sln' | xargs -I{} dotnet clean {}
#find . -type d -name obj -o -name bin | xargs rm -R
dotnet clean .
dotnet build --configuration Release
dotnet test
dotnet pack --configuration Release
for i in ./src/Senders/FluentEmail.Mailgun ./src/FluentEmail.Core; do
    file="$(ls -1 $i/bin/Release/FluentEmail.*.nupkg | sort -nr | head -n1)"
    dotnet nuget push "$file" --source github
done
