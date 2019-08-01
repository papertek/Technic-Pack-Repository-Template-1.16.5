#!/bin/bash
set -e

mod_input_file=mods.txt
modpack_output_zip=modpack.zip

workspace_path=$(pwd)
if [[ -d build ]]; then
    echo 'Clean up from last build'
    rm -rf 'build'
fi

echo 'Creating modpack structure...'
[ -d 'build' ] || mkdir 'build'
pushd 'build' > /dev/null

echo 'Copy forge into modpack...'
[ -d 'bin' ] || mkdir 'bin'
cp "${workspace_path}/bin/$(ls "${workspace_path}/bin/" | head -n 1)" 'bin/modpack.jar'

echo 'Download mods in modpack...'
[ -d "mods" ] || mkdir -p "mods"
pushd "mods" > /dev/null
while read -r download_line; do
    if [[ $download_line == "https://www.curseforge.com/minecraft/mc-mods"* ]]; then
        # Add '/file' if not on download link
        [[ "$download_line" == */file ]] || download_line+='/file'
        echo "Downloading $download_line"
        wget --content-disposition -q --show-progress $download_line    
    else
        echo "Ignoring download link, its not from curseforge! Link: $download_line"
    fi; 
done < "${workspace_path}/${mod_input_file}"
popd > /dev/null


echo 'Copy overrides folder in modpack...'
cp -r "$workspace_path/overrides/." .
rm '.empty'

echo 'Create zip...'
zip -r "$modpack_output_zip" .

popd > /dev/null

echo "Created $modpack_output_zip"
