docs := general present present_instructions

all: createDir $(docs)

createDir:
	if not exist "docs" mkdir docs

$(docs):
	pandoc -d config/$@.yaml