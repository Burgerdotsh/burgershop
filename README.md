# burger-local

*Builds your Burgerfile.json locally*


### Usage 

```bash
#Build Burgerfile.json or .burger/Burgerfile.json
burger

#Build folder/Burgerfile.json or folder/.burger/Burgerfile.json
burger folder 

#Build folder/production.json or folder/.burger/production.json
burger folder:production

#Build folder/devimage.json or folder/.burger/devimage.json
burger ./folder/devimage

#Build from remote Burger.json file
burger http://myfiles.com/Burger.json

#Build tar archive, tar/devimage.json or tar/.burger/devimage.json
burger http://myfiles.com/Burger.tar devimage

#Build repository, default branch, Burgerfile.json or .burger/Burgerfile.json
burger https://git.github.com/repo.git

#Build repository, feature branch, Burgerfile.json or .burger/Burgerfile.json
burger https://git.github.com/repo.git feature

#Build repository, ref/commit, Burgerfile.json or .burger/Burgerfile.json
burger https://git.github.com/repo.git e365cf6

#Build repository, ref/commit, 
# image-prod.json or .burger/image-prod.json or image-prod/Burgerfile.json
burger https://git.github.com/repo.git e365cf6/image-prod

#Build repository, ref/commit, images/test or images/test.json
burger https://git.github.com/repo.git e365cf6/images/test

#Build repository, ref/commit, images/production or images/production.json
burger https://git.github.com/repo.git e365cf6/images:production
```

### Suggestion for sub-scripts

```bash

# Fill order - lint and generate dockerfile
burger-local order [urn]

# Build image
burger cook [urn]/[hash]

# Run tests
burger test [urn]/[hash]
```

### Options
```bash
burger uri \
    --name "image-name" \
    --tag "tagged" \
    --cache-dir "mycache"
```
