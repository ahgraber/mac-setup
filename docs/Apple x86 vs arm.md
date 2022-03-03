# Working with Apple arm64 architecture

For most applications, native vs. emulated modes do not need to be user-managed.
However, for development purposes, managing the entire stack's architecture may become necessary.

## Emulated terminal environment

For an x86 (Rosetta-emulated) environment, create an emulated `Terminal.app`:

1. Open `Finder`
2. Hit `cmd + shift + U` to open the Utilities folder
3. Right-click + `Duplicate` Terminal.app
4. Right-click + `Rename` the duplicate to something obvious - 'RosettaTerm'
5. Right-click + `Get Info` on the duplicate and check the box for `Open Using Rosetta`

> Architecture of installed software _must be fully consistent_ across the entirety of the stack.
> You cannot mix e.g. arm64 homebrew packages with x86 Python packages.

Use this emulated terminal for all tasks associated with an emulated architecture.

## Homebrew

Homebrew can be installed in parallel on Apple Silicon macs.

The `arm64` package will be installed in `/opt/homebrew/`
The `x86_64/i386` package will be installed in `/usr/local/` (install with the emulated Terminal)
[Reference](https://www.notion.so/Run-x86-Apps-including-homebrew-in-the-Terminal-on-Apple-Silicon-8350b43d97de4ce690f283277e958602)
[Reference](https://www.wisdomgeek.com/development/installing-intel-based-packages-using-homebrew-on-the-m1-mac/)

> It appears that homebrew is smart enough to autodetect architecture and adjust HOMEBREW_PREFIX accordingly 👍

We can set the zsh environment to auto-detect architecture by adding the following to `.zshrc`

```sh
### Autodetect architecture (and set `brew` path)
if [[ "$(sysctl -a | grep machdep.cpu.brand_string)" == *Apple* ]]; then
  archcheck=$(/usr/bin/arch)
  typeset -g archcheck
  case $archcheck in
    arm64)
      archcheck+=' (Native)'
      if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        alias brew='/opt/homebrew/bin/brew'
      fi
    ;;
    i386|x86_64)
      archcheck+=' (Rosetta)'
      if [[ -f /usr/local/homebrew/bin/brew ]]; then
        eval "$(/usr/local/homebrew/bin/brew shellenv)"
        alias brew='/usr/local/homebrew/bin/brew'
      fi
    ;;
    *)
      archcheck+=' (Unknown)'
    ;;
  esac

  # add arch to p10k
  function prompt_my_arch() {
    p10k segment -f 250 -i '💻' -t "${archcheck//\%/%%}"
  }

  POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS+=my_arch  # to specify location, modify ~/.p10k.zsh
fi
```

Alternatively, using the `arch` command, we can specify the architecture under which to run a single process;
however, I have found it more consistent to simply use native vs "rosetta" terminal.

```sh
/usr/bin/arch -x86_64 /path/to/exe     # 64-bit x86
/usr/bin/arch -arm64 /path/to/exe      # arm64
```

[Reference](https://gist.github.com/joshdholtz/d1a7295c51e031a8de7e11c36f25ab61)

## Anaconda

[`mambaforge`](https://github.com/conda-forge/miniforge#mambaforge) has support for native arm64 architecture
and comes with `mamba` preinstalled

Conda envs can be restricted to specific architectures:
Allowed CONDA_SUBDIR architectures include:

- `linux-64`
- `linux-aarch64`
- `linux-ppc64le`
- `osx-64`
- `osx-arm64`
- `win-32`
- `win-64`

see also [stackoverflow](https://stackoverflow.com/questions/33709391/using-multiple-python-engines-32bit-64bit-and-2-7-3-5/58014896#58014896)
and [github gist](https://gist.github.com/ahgraber/47fc18c9eb857c8afa9b4786de8a43b1)

Create an environment with a specific architecture requirement:

```sh
env_name="changeme"
# set arch for new environment
CONDA_SUBDIR=osx-arm64 conda create -n "$env_name"
# ensure subsequent installs respect arch
conda env config vars set CONDA_SUBDIR=osx-arm64 --name "$env_name"
conda deactivate "$env_name"
conda activate "$env_name"
unset env_name

# conda activate <env_name>
# conda install -n <env_name> ...
```
