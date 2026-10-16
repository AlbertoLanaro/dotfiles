# Dotfiles

Personal Zsh, tmux, Vim and Neovim configuration for **macOS on Apple Silicon**,
with Homebrew installed in `/opt/homebrew`. Paths inside the home directory use
`$HOME`, so the account name does not need to match the original machine.

This restores the terminal environment. Credentials, project files, runtime
versions, application data and the full list of applications from the original
Mac are intentionally not included. Intel Macs and Linux need changes to the
Homebrew paths and macOS-specific aliases.

## 1. Install the tools

Install Apple's Command Line Tools and wait for installation to finish:

```sh
xcode-select --install
```

Install [Homebrew](https://brew.sh/) using its official instructions. Then:

```sh
eval "$(/opt/homebrew/bin/brew shellenv)"
mkdir -p "$HOME/repos"
git clone https://github.com/AlbertoLanaro/dotfiles.git "$HOME/repos/dotfiles"
cd "$HOME/repos/dotfiles"
brew bundle install
```

The [Brewfile](Brewfile) includes tools called by the shell configuration,
aliases and functions, plus the terminal font. Homebrew installs their own
dependencies automatically. It is not an inventory of all software installed
on the original Mac. `git-flow-next` supplies the `git flow` command used by
the Oh My Zsh plugin; the original Homebrew `git-flow` formula is deprecated.

Open Docker Desktop once and complete its setup before using `lzd` or Docker
commands. The `zed` cask supplies the editor used by `zf`. macOS already supplies
Vim and the commands used by the Finder and network-quality aliases.

## 2. Install Oh My Zsh and tmux plugins

Run these commands on a new machine. If a destination already exists, keep it
and inspect it instead of cloning over it.

```sh
git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
```

Cloning Oh My Zsh directly leaves the existing `.zshrc` and login shell alone.
The configured `refined` theme and six Zsh plugins are included in that checkout.

Restore the tmux plugins at the revisions used by this configuration:

```sh
mkdir -p "$HOME/.tmux/plugins"
while read -r repository revision; do
  destination="$HOME/.tmux/plugins/${repository##*/}"
  git clone "https://github.com/$repository.git" "$destination" || break
  git -C "$destination" checkout "$revision" || break
done <<'PLUGINS'
tmux-plugins/tpm 99469c4a9b1ccf77fade25842dc7bafbc8ce9946
catppuccin/tmux cece0c36772483d1343bcace2b1cedb007057c2e
tmux-plugins/tmux-cpu 98d787191bc3e8f19c3de54b96ba1caf61385861
tmux-plugins/tmux-sensible 25cb91f42d020f675bb0a2ce3fbd3a5d96119efa
christoomey/vim-tmux-navigator 38b1d0402c4600543281dc85b3f51884205674b6
tmux-plugins/tmux-yank acfd36e4fcba99f8310a7dfb432111c242fe7392
PLUGINS
```

The Catppuccin revision matters: this config uses its older option names.
Upgrading the theme requires migrating those options. Keep these checkouts
unchanged for a restore; TPM updates may move them to newer code.

## 3. Choose initial Node and Python versions

Runtime versions belong to projects, not to this repository. Install an initial
Node LTS and Python 3 before loading the new shell configuration:

```sh
export NVM_DIR="$HOME/.nvm"
mkdir -p "$NVM_DIR"
source /opt/homebrew/opt/nvm/nvm.sh
nvm install --lts
nvm alias default 'lts/*'

pyenv install -s 3
pyenv global "$(pyenv latest -i 3)"
```

The shell automatically reads `.nvmrc` when entering a project, installs a
missing Node version, and returns to the NVM default when leaving it. Python
projects can select their interpreter with `.python-version`. Python builds
require the Command Line Tools; consult the [pyenv build instructions](https://github.com/pyenv/pyenv/wiki#suggested-build-environment)
if a build reports missing development libraries.

## 4. Link the configuration files

Run the following in Zsh. Existing files or symlinks are moved into a unique
backup directory, preserving their relative paths. No credentials are copied.

```sh
repo="$HOME/repos/dotfiles"
backup="$(mktemp -d "$HOME/dotfiles-backup.XXXXXX")"
while IFS= read -r relative; do
  target="$HOME/$relative"
  mkdir -p "$(dirname "$target")"
  if [ -e "$target" ] || [ -L "$target" ]; then
    mkdir -p "$backup/$(dirname "$relative")"
    mv "$target" "$backup/$relative" || break
  fi
  ln -s "$repo/$relative" "$target" || break
done <<'FILES'
.zshenv
.zprofile
.zshrc
.tmux.conf
.vimrc
.config/nvim/init.lua
.config/nvim/lazy-lock.json
.config/bat/themes/Catppuccin Macchiato.tmTheme
FILES
```

Keep `~/.config/zsh` as a local directory. Do not symlink all of `.config` into
this repository: it also contains credentials and unrelated application state.
Rust, Go, LM Studio and extra archive-extraction backends can be installed when
needed. Their optional paths are retained, but they are not startup requirements.

## 5. Finish the setup

Build bat's theme cache and start a fresh login shell:

```sh
bat cache --build
exec /opt/homebrew/bin/zsh -l
```

Configure the terminal to launch `/opt/homebrew/bin/zsh` as a login shell if you
want to use Homebrew's Zsh. Changing the account's default shell is optional.

Start tmux with `tmux`. Its prefix is **Ctrl-a**. With TPM installed,
**Ctrl-a, Shift-i** installs any missing plugins declared in `.tmux.conf`.
The commands above already install the current plugin set.

Start Neovim with `nvim`. The configuration bootstraps lazy.nvim. Run
`:Lazy restore` to restore plugins from the committed `lazy-lock.json`, then
restart Neovim. Use restore rather than update when reproducing this setup.
See [lazy.nvim's lockfile documentation](https://lazy.folke.io/usage/lockfile).

In the terminal's font settings, select **CaskaydiaCove Nerd Font Propo Regular**.
The original iTerm profile uses size **13**, with the same font at size **14**
for non-ASCII text. The font is installed by the Brewfile; iTerm itself is an
optional manual install. Terminal profiles, colors and other GUI preferences
are not restored by these files.

## 6. Add local credentials if needed

The shell works without a credentials file. To add local exports:

```sh
mkdir -p "$HOME/.config/zsh"
(umask 077; touch "$HOME/.config/zsh/secrets.zsh")
chmod 600 "$HOME/.config/zsh/secrets.zsh"
nvim "$HOME/.config/zsh/secrets.zsh"
```

Put any required exports in that file, never in `.zshrc`. It is sourced by the
shell and excluded by `.gitignore`. Kubernetes credentials, SSH keys, cloud
credentials and project `.env` files must be restored separately through a
private backup or credential manager. When `~/.kube` exists, the configuration
loads files named `config*` directly inside it into `KUBECONFIG`.

## 7. Verify and maintain

```sh
brew bundle check --file="$HOME/repos/dotfiles/Brewfile"
zsh -n "$HOME/.zshrc"
bat --list-themes | command grep -F 'Catppuccin Macchiato'
node --version
python --version
```

Check tab completion, `z` navigation and `v`. In tmux, check the top status bar,
**Ctrl-h/j/k/l** navigation between panes and Neovim splits, and copying text.
**Shift-Left/Right** should not change tmux windows.

Configuration files are symlinked: later edits are edits to this checkout.
Review `git diff` before committing, including changes to `lazy-lock.json`.
Add a Brewfile entry only when the configuration starts depending on a tool.
[Homebrew Bundle](https://docs.brew.sh/Brew-Bundle-and-Brewfile) installs available
package versions; this repository does not freeze the whole operating system.

The bundled bat theme comes from [Catppuccin for bat](https://github.com/catppuccin/bat)
and retains its [MIT license](.config/bat/themes/LICENSE).
