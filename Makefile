docs := general present

all: createDir $(docs)

createDir:
	if not exist "docs" mkdir docs

$(docs):
	pandoc -d config/$@.yaml

# general:
# 	pandoc -d config/general.yaml

# present:
# 	pandoc -d config/present.yaml