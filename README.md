Follow these steps for start work:
1) Open windows command line(cmd)
2) Change folder to your project folder(cd <your project path>)
3) Create scratch org(sfdx force:org:create -f ./config/project-scratch-def.json -a <scratch org username/alias>)
4) Add your user to permission set(sfdx force:user:permset:assign --permsetname Task2_Permission_Set --targetusername <user name>)
5) Open your scratch org(sfdx force:org:open -u <scratch org username/alias>)
