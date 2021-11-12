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

> Architecture of installed software _must be fully consistent_ across the entirety of the stack.  You cannot mix e.g. arm64 homebrew packages with x86 Python packages.

Use this emulated terminal for all tasks associated with an emulated architecture.

## Homebrew

Homebrew can be installed in parallel on Apple Silicon macs.

The `arm64` package will be installed in `/opt/homebrew/`
The `x86_64/i386` package will be installed  in `/usr/local/` (install with the emulated Terminal)
[Reference](https://www.notion.so/Run-x86-Apps-including-homebrew-in-the-Terminal-on-Apple-Silicon-8350b43d97de4ce690f283277e958602)

> It appears that homebrew is smart enough to autodetect architecture and adjust HOMEBREW_PREFIX accordingly 👍

We can set the zsh environment to auto-detect architecture by adding the following to `.zshrc`

```sh
archcheck () {
   if [ "$(uname -p)" = "i386" ]; then
     echo "Running in i386 mode (Rosetta)"
     eval "$(/usr/local/homebrew/bin/brew shellenv)"
     alias brew='/usr/local/homebrew/bin/brew'
   elif
     echo "Running in ARM mode (M1)"
     eval "$(/opt/homebrew/bin/brew shellenv)"
     alias brew='/opt/homebrew/bin/brew'
   else
     echo "Unknown architecture detected: $(uname -p) // $(arch)"
   fi
}
alias native="arch -arm64 zsh && archcheck"
alias rosetta="arch -x86_64 zsh && archcheck"
```

> Note: the `rosetta` alias is kind of buggy; recommend using only the emulated terminal

Alternatively, using the `arch` command, we can specify the architecture under which to run a single process:

```sh
/usr/bin/arch -x86_64 /path/to/exe     # 64-bit x86
/usr/bin/arch -arm64 /path/to/exe      # arm64
```

[Reference](https://gist.github.com/joshdholtz/d1a7295c51e031a8de7e11c36f25ab61)

## Anaconda

[`mambaforge`](https://github.com/conda-forge/miniforge#mambaforge) has support for native arm64 architecture and comes with `mamba` preinstalled

Conda envs can be restricted to specific architectures:

Create an environment with a specific architecture requirement:

```sh
env_name="changeme"
# set arch for new environment
CONDA_SUBDIR=osx-arm64 conda create -n "$env_name"
# ensure subsequent installs respect arch
conda env --name "$env_name" config vars set CONDA_SUBDIR=osx-arm64
unset env_name

# conda activate <env_name>
# conda install -n <env_name> ...
```
