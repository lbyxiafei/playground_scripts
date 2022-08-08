az login
cd ~/Repos/MCIO-CAPLA-ZEROTOUCHPLANNINGSERVICE/src/Ztp/PrioritizationFunction
func azure functionapp fetch-app-settings 'prioritizationtest' --output-file local.settings.json
func settings decrypt
cd ~/Repos/MCIO-CAPLA-ZEROTOUCHPLANNINGSERVICE/