az login
cd ~/Repos/MCIO-CAPLA-ZEROTOUCHPLANNINGSERVICE/src/Ztp/ZTPQueryEngineFunctionApp
func azure functionapp fetch-app-settings 'ztpqueryenginetest' --output-file local.settings.json
func settings decrypt
cd ~/Repos/MCIO-CAPLA-ZEROTOUCHPLANNINGSERVICE/