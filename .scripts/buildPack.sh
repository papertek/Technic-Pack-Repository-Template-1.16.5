#!/bin/bash
set -e

mod_input_file=mods.txt
modpack_output_zip=modpack.zip
build_folder=build
workspace_path=$(pwd)

mods_list=()

function modpack_structure {
    if [ -d "$build_folder" ]; then
        echo 'Clean up build folder...'
        rm -rf "$build_folder"
    fi

    echo 'Creating modpack folder structure...'
    [ -d "$build_folder" ] || mkdir "$build_folder"
    [ -d "$build_folder/bin" ] || mkdir "$build_folder/bin"
    [ -d "$build_folder/mods" ] || mkdir "$build_folder/mods"
    cd "$build_folder"
}

function download_file {
    download_url="$1"
    wget --content-disposition -q --show-progress $download_url 
}

function install_forge {
    echo 'Copy forge into modpack...'
    cp "${workspace_path}/bin/$(ls "${workspace_path}/bin/" | head -n 1)" 'bin/modpack.jar'
}

function read_mods {
    echo 'Detect mods...'
    while read -r download_line; do
        if [[ "$download_line" == "https://www.curseforge.com/minecraft/"* ]] && [[ "$download_line" != *"/file" ]]; then 
            download_line+='/file'
            echo "Add mod(curseforge): $download_line"
        else
            echo "Add mod: $download_line"
        fi;

        mods_list+=("$download_line")        
    done < "${workspace_path}/${mod_input_file}"
}

function install_mods {
    echo 'Downloading mods...'
    pushd "mods" > /dev/null
    export -f download_file
    echo ${mods_list[@]} | xargs -n 1 -P 8 -I {} -d ' ' bash -c 'download_file "{}"'
    popd > /dev/null
}

function copy_overrides {
    echo 'Copy overrides folder in modpack...'
    cp -r "$workspace_path/overrides/." .
}

### Main ###

modpack_structure

install_forge

read_mods

install_mods

copy_overrides

echo 'Create zip...'
zip -r "$modpack_output_zip" .

echo "Created $modpack_output_zip"
