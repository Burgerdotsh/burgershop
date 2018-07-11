# burgershop

*Builds your Burgerfile.json locally*

### Usage 

```bash
#Build Burgerfile.json or .burger/Burgerfile.json
burgershop

#Build folder/Burgerfile.json or folder/.burger/Burgerfile.json
burgershop folder 

#Build folder/production.json or folder/.burger/production.json
burgershop folder:production

#Build folder/devimage.json or folder/.burger/devimage.json
burgershop ./folder/devimage

#Build from remote Burger.json file
burgershop http://myfiles.com/Burger.json

#Build tar archive, tar/devimage.json or tar/.burger/devimage.json
burgershop http://myfiles.com/Burger.tar devimage

#Build repository, default branch, Burgerfile.json or .burger/Burgerfile.json
burgershop https://git.github.com/repo.git

#Build repository, feature branch, Burgerfile.json or .burger/Burgerfile.json
burgershop https://git.github.com/repo.git feature
```

### Suggestion for sub-scripts

```bash

# Fill order - lint and generate dockerfile
burgershop order [urn]

# Build image
burger cook [urn]

# Run tests
burger test [urn]
```

### Options
```bash
burger uri \
    --name "image-name" \
    --tag "tagged" \
    --cache-dir "mycache"
```
=======
# burgershop
Build your Burgerfile.json locally
>>>>>>> 964c4bfd46ab9d252cf766f2f9341ae578b3c376
