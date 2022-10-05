

# Docker container with Julia  and CUDA for production environments.

Monolithic docker container for running Julia with GPU; there is no need to provide  ` Project.toml , Manifest.toml`  separately, all the packages should be added or removed inside our [Dockerfile](Dockerfile) in the last `RUN` layer, so it takes just seconds to re-build the image after updating your packages. 


## Building

Download this repo to your local machine then open your CMD in the folder and type : 

```
docker build -t  julia:cuda  .
```

Or, replace `julia:cuda`  with  your  `<name:tag>`.

## Running

We run our container with mounting a volume into the repo's folder in your local machine  :

```
docker run --gpus all -it --rm -v $(pwd):/myapp julia:cuda

```

which, immedaitely falls into the container's shell in `/myapp` workdir. Type `ls` to see your volume files:

```
root@xxxxxxx:/myapp# ls
Dockerfile  README.md  test_GANs.jl

```
Then type `ls ..` to see the root directory. Spot the Julia folder  :

```
root@xxxxxxx:/myapp# ls ..
NGC-DL-CONTAINER-LICENSE    dev          lib     media  proc  srv  var
bin                         etc          lib32   mnt    root  sys
boot                        home         lib64   myapp  run   tmp
cuda-keyring_1.0-1_all.deb  julia-1.8.2  libx32  opt    sbin  usr

```
Type ` julia ` to fall into the REPL :
```
root@xxxxxxx:/myapp# julia
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.8.2 (2022-09-29)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

julia> 
```

Press `Ctr+D` to get back to the container's shell.

If you need to fall into the REPL instead of the container's shell after running the container, just simply add this command after the WORKDIR in our Dockerfile then rebuild the image :

```
WORKDIR /myapp

CMD ["julia"]
```

## Testing with Deep Convolutional Generative Adversarial Networks 

The included [test_GANs.jl](test_GANs.jl) is taken from [Flux Model Zoo](https://github.com/FluxML/model-zoo)

All necessary packages were installed inside our Dockerfile.

Just type this command to run the test:
```
root@xxxxxxx:/myapp# julia test_GANs.jl
```
then give permission to download the MNIST dataset into your container.  Note that this is ephemeral, after shutting down the container the downloaded data will be lost.

To monitor your GPU usage open another `CMD` then type: 

```
watch -n -1 nvidia-smi
```

the test consumed about 80% of  RTX 3070 GPU :

```
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 515.65.01    Driver Version: 515.65.01    CUDA Version: 11.7     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  NVIDIA GeForce ...  On   | 00000000:01:00.0 Off |                  N/A |
| N/A   60C    P0   128W /  N/A |   7959MiB /  8192MiB |     83%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+

```


after 2-3 minutes, the test ends and you see a new folder : `output` created in your volume. Open it and see the genereated images. 

This proves that everyhing works fine . 

## Creating you own container

I kept the Dockerfile as simple as possible. Besides updating  `ARG`s , remeber that in the shell you spotted the location of the julia folder, knowing that directory, you might define your [Environment Variables](https://docs.julialang.org/en/v1/manual/environment-variables/#Environment-Variables) by `ENV` syntax in your Dockerfile.








