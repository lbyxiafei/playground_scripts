az login
cd ~/Repos/MCIO-CAPLA-ZEROTOUCHPLANNINGSERVICE/src/Ztp/MdmFunctions
func azure functionapp fetch-app-settings 'mdmfunctionstest' --output-file local.settings.json
func settings decrypt
cd ~/Repos/MCIO-CAPLA-ZEROTOUCHPLANNINGSERVICE/