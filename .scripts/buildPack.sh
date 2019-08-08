#!/bin/bash
set -e

modpack_config=modpack.json
modpack_output_zip=modpack.zip
build_folder=build
workspace_path=$(pwd)
download_forge_pattern='https://files.minecraftforge.net/maven/net/minecraftforge/forge/%version%/forge-%version%-universal.jar'

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
    if [ "$2" ]; then
        progress_flag='--show-progress'
    fi

    wget --content-disposition -q $progress_flag $download_url || (echo "Failed to download $download_url" && exit 1)
}

function install_forge {

    pushd "bin" > /dev/null
    forge_version=$(jq -r '.forgeVersion' "${workspace_path}/${modpack_config}")
    
    echo "Download forge version $forge_version"
    download_file ${download_forge_pattern//%version%/${forge_version}} true
    mv ./*.jar 'modpack.jar'

    popd > /dev/null
}

function read_mods {
    echo 'Collect mods...'

    mod_urls=$(jq -r '.mods[].url' "${workspace_path}/${modpack_config}")

    for mod in ${mod_urls[@]}; do
        if [[ "$mod" == "https://www.curseforge.com/minecraft/"* ]]; then 
            [[ "$mod" == *"/file" ]] || mod+='/file'
            echo "Add mod(curseforge): $mod"
        else
            echo "Add mod: $mod"
        fi;
        mods_list+=("$mod")
    done
}

function install_mods {
    echo 'Downloading mods'
    pushd "mods" > /dev/null
    export -f download_file
    echo ${mods_list[@]} | xargs -n 1 -P 8 -I {} -d ' ' bash -c 'download_file "{}" && printf '.''
    printf 'Finished\n'
    popd > /dev/null
}

function copy_overrides {
    echo 'Copy overrides folder in modpack...'
    cp -r -v "$workspace_path/overrides/." .
}

### Main ###

modpack_structure

install_forge

read_mods

install_mods

copy_overrides

echo 'Create zip...'
zip -9 -r "$modpack_output_zip" .

echo "Created $modpack_output_zip"
