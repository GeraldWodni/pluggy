# pluggy
WiFi Socket mini web-based standalone IDE - based on NodeMCU

## Installation
_TODO: Simple installation by providing an image including all lua files, until then please use the following instructions:_

### Flash NodeMCU
Get a WiFi Socket or another ESP8266 and NodeMCU compatible device.
Install NodeMCU. (_TODO: provide link to image / place image in repo?_)

### Get an upload tool
In order to transfer files onto the ESP's flash you need an uploader like [ESPlorer](https://esp8266.ru/esplorer/).

### Upload Pluggy
1. Using above tool upload `init.lua`.
1. Reset the device, __attention: the BaudRate is now 57600__.
1. Proceed to upload the following files:
-- `response.lua`
-- `pluggy.lua`
-- `files.lua`

## Usage
Now that you have pluggy up and running here is how you get some use out of it:

### Connect pluggy to your WiFi
by issuing the following commands in your lua terminal:
```lua
    wifi.setmode(wifi.STATION, true)
    wifi.sta.config({
        ssid = "<your ssid>",
        pwd = "<your password>",
        save = true
    })
```
Setting save to true will allow your configuration to survive resets.
Reset the device to allow the webserver to reconnect.

### First Contact
You can now reach your pluggy via webbrowser using http://pluggy.local

#### Usefull features
1. http://pluggy.local/debug will show you details about your current request
1. http://pluggy.local/files allows up-/down-loading as well as editing your (source-)files
1. http://pluggy.local/routes shows you all registered routes

#### Read the Source!
This documentation is very terse, read the source to understand pluggy's full potetntial ;)

## Content

Content is hold in the /content folder. Use dish.sh to create a dist folder with minified, gzippec content. Some nodejs-modules are required to do that: install with `sudo npm install -g uglify-js clean-css-cli html-minifier`)

Then just run `./dish.sh` and upload the contents of `/dist` using the upload function of the editor:
http://pluggy.local/files/show/editor.html
