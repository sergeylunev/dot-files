#!/bin/bash

wget https://github.com/TheAssassin/AppImageLauncher/releases/download/v3.0.0-beta-2/appimagelauncher_3.0.0-beta-2-gha280.e110527_amd64.deb
sudo gdebi --non-interactive appimagelauncher_3.0.0-beta-2-gha280.e110527_amd64.deb 
rm appimagelauncher_3.0.0-beta-2-gha280.e110527_amd64.deb 