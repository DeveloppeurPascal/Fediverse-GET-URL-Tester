# Fediverse-GET-URL-Tester

A simple program to check what endpoints of Fediverse websites (or ActivityPub compatible websites) answer to GET requests.

## About the project

This program has been coded in [Delphi 11.2 Alexandria](https://developpeur-pascal.fr/delphi.html) from [Embarcadero Technologies](https://www.embarcadero.com/).

Source code is available on [GitHub](https://github.com/DeveloppeurPascal/Fediverse-GET-URL-Tester).

The binary for Windows and Mac are available as shareware. A license can be bought from [Gumroad](https://olfsoftware.gumroad.com/l/FediverseGETURLTester).

## Dependencies

The project uses those libraries as git modules :

* [DeveloppeurPascal/librairies](https://github.com/DeveloppeurPascal/librairies) in the sub folder ./lib-externe/librairies
* [DeveloppeurPascal/AboutDialog-Delphi-Component](https://github.com/DeveloppeurPascal/AboutDialog-Delphi-Component) in the folder ./lib-externe/AboutDialog-Delphi-Component

## How it works

Look at screen captures folder to see how this program works.

![Home Screen](ScreenCaptures/home.png)

* The button "About" show a copyright dialog box.
* The button "Register" open the web browser and go to the shop.
* The button "Close" close the program.
* The edit field needs the URL you want to call. After filling the URL, choose if you want the result as JSON ou HTML. It changes the "Accept" header and the answer will depend on the web server you call.

## Features

* get answer for a URL as text/html (web pages and other contents)
* get answer for a URL as application/ld-json (JSON LD or JSON used by ActivityPub)
* get ActivityPub URL for a Fediverse user account from WebFinger if available on user's domain
