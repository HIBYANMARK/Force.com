sfdx force:org:create -f config/project-scratch-def.json -d 30 -s --wait 60

# Install packages

# FlowActionsBasePack
sfdx force:package:install --package 04t4W00000308RmQAI -w 5

# FlowScreenComponentsBasePack
sfdx force:package:install --package 04t5G0000047xMDQAY -w 5

# GetLayoutFields
sfdx force:package:install --package 04tB0000000P0ByIAK -w 5

# recordDetail_1
sfdx force:package:install --package 04t5G0000047xDuQAI -w 5

# ItemsToApprove
sfdx force:package:install --package 04tf4000004PtLGAA0 -w 5

sfdx force:source:push
sfdx force:org:open
