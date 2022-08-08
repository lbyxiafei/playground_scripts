az login
cd ~/Repos/MCIO-CAPLA-ZEROTOUCHPLANNINGSERVICE/src/Ztp/Functions/DocumentStore/StarLord
func azure functionapp fetch-app-settings 'DocumentStoreTest' --output-file local.settings.json
func settings decrypt
cd ~/Repos/MCIO-CAPLA-ZEROTOUCHPLANNINGSERVICE/