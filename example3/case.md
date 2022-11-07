chickend and egg [different repositories, kv + role ass in one, aks in second]:

1. have resource deployed upfront from repo1 and repo2
2. describe the diagram and dependencies between two repos
3. describe the kv and access policies (and present what is assigned)
4. describe the aks assignmed for managed identity
5. think about adding more kv policies and then comment out mui policies
6. run what-if -> checks that you can miss all policies except the one for mui or talk about adding union
7. change parameters for kvpolicies - add permission for mui
8. propose to use something like isNew for parameter, present existing (but for new environment will fail)