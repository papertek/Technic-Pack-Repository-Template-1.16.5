# Technic Pack Repository Template

This is my template for hosting modpacks for the [Technic Minecraft Launcher](https://www.technicpack.net/) on github.

## Usage

* Clone the repository
* Remove the `LICENCE.md` and this `README.md` (Additional: Create your own ones)
* Change the `modpack.json` to match your expectations
    * Set your forge version (it should not contain any spaces in the version!)
    * Get with the ids from CurseForge __(recommended)__ of your mods. The `projectId` can be found on the mods details and the `fileId` is the last part of the download link. The name is optional.
    * or add your url into `modpack.json` (make sure the links are pointing directly to the `*.jar`)
    * If you want to take notes, append to any objekt `"note": "Something something"` with your text.
* Put any file or folder which should also be in the compressed modpack into `overrides` (All files will be located in the pack's root)
* Enable travis on your repository
* Setup your GitHub Token as environment variable `GH_DEPLOY_KEY` on travis.
* Edit the `GH_REF` env variable in the `.travis.yml` and set your repro reference.

## Create a modpack zip

* If the points above are done correctly every push or edit of the master branch will create the modpack on the `dist` branch.
* Now use the download link from the `modpack.zip` in the dist branch and put it into the modpack settings.

