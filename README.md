# Overview

**Title:** stonecutters 
**Category:** Crypto  
**Flag:** libctf{malleability_will_break_your_crypto}  
**Difficulty:** easy to moderate  

# Usage

The following will pull the latest 'elttam/ctf-stonecutters' image from DockerHub, run a new container named 'libctfso-stonecutters', and publish the vulnerable service on port 80:

```sh
docker run --rm \
  --publish 80:80 \
  --name libctfso-stonecutters \
  elttam/ctf-stonecutters:latest
```

# Build (Optional)

If you prefer to build the 'elttam/ctf-stonecutters' image yourself you can do so first with:

```sh
docker build ${PWD} \
  --tag elttam/ctf-stonecutters:latest
```
