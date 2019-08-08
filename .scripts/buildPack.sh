#!/bin/bash
set -e

mod_input_file=mods.txt
modpack_output_zip=modpack.zip
build_folder=build
workspace_path=$(pwd)

function modpack_structure {
    if [[ -d "$build_folder" ]]; then
        echo 'Clean up build folder...'
        rm -rf "$build_folder"
    fi

    echo 'Creating modpack folder structure...'
    [ -d "$build_folder" ] || mkdir "$build_folder"
    [ -d "$build_folder/bin" ] || mkdir "$build_folder/bin"
    [ -d "$build_folder/mods" ] || mkdir "$build_folder/mods"
    cd "$build_folder"
}

function install_forge {
    echo 'Copy forge into modpack...'
    cp "${workspace_path}/bin/$(ls "${workspace_path}/bin/" | head -n 1)" 'bin/modpack.jar'
}

function install_mods {
    echo 'Download mods in modpack...'
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
}

function copy_overrides {
    echo 'Copy overrides folder in modpack...'
    cp -r "$workspace_path/overrides/." .
}

### Main ###

modpack_structure

install_forge

install_mods

copy_overrides

echo 'Create zip...'
zip -r "$modpack_output_zip" .

echo "Created $modpack_output_zip"
