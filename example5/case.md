destroy resources:

to deploy:
```
az deployment group validate --name xyz --resource-group bp-rg-test-05 --mode Complete --template-file .\main.bicep --parameters .\parameters.json
```

steps:
1. have a resource group 05 created from portal upfront
2. create resources
3. comment out st
4. present execution with what-if
5. execute deployment