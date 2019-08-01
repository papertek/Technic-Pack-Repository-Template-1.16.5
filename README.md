# Technic Pack Repository Template

This is my template for hosting modpacks for the [Technic Minecraft Launcher](https://www.technicpack.net/) on github.

## Usage

* Clone the repository
* Put your forge jar into the `bin` folder. (Use the original name format!)
* Write the download urls from [__curseforge__](https://www.curseforge.com/minecraft/mc-mods) for the mods in the `mod.txt` line per line
* Put any file or folder which should also be in the compressed modpack into `overrides` (All files will be located in the pack's root)
* Enable travis on your repository
* Setup your GitHub Token as environment variable `GH_DEPLOY_KEY` on travis.
* Edit the `GH_REF` env variable in the `.travis.yml` and set your repro reference.

## Create a modpack zip

* Create a Tag with a version number and let the magic happen.
* Now use the download link from the `modpack.zip` in the dist branch and put it into the modpack settings.

