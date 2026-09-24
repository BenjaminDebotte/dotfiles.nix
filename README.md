# dotfiles.nix

Ma configuration personnelle [NixOS](https://nixos.org/) et [Home Manager](https://github.com/nix-community/home-manager), gérée de façon déclarative, modulaire et reproductible avec Flakes et [`nh`](https://github.com/viperML/nh).

## Table des matières

- [Structure du dépôt](#structure-du-dépôt)
- [Installation](#installation)
  - [1. Créer et flasher l'ISO d'installation](#1-créer-et-flasher-liso-dinstallation)
  - [2. Cloner la configuration](#2-cloner-la-configuration)
  - [3. Appliquer la configuration (Système + Home Manager)](#3-appliquer-la-configuration-système--home-manager)
  - [4. Redémarrer](#4-redémarrer)
- [Post-installation](#post-installation)
  - [5. Importer les clés SSH et GPG depuis Google Drive](#5-importer-les-clés-ssh-et-gpg-depuis-google-drive)
  - [6. Configurer le password store](#6-configurer-le-password-store)
- [Commandes courantes (Taskfile)](#commandes-courantes-taskfile)
- [Mise à jour](#mise-à-jour)

---

## Structure du dépôt

```
dotfiles.nix/
├── flake.nix              # Routeur principal déclaratif (~70 lignes)
├── flake.lock             # Lockfile des versions épinglées
├── nix/
│   ├── dev.nix            # Formatage (treefmt/alejandra), pre-commit hooks et devShell
│   └── overlays.nix       # Overlays centralisés (unstable, neovim-nightly, herdr, firefox-addons)
├── system/
│   ├── configuration.nix  # Manifeste d'activation des options `mySystem.*` de la machine
│   ├── hardware-configuration.nix # Spécifique à la machine (généré automatiquement)
│   ├── iso.nix            # Configuration minimale pour clé USB Live/Rescue
│   └── modules/           # Modules système déclaratifs (River, virtualisation, audio, etc.)
├── home/
│   ├── default.nix        # Point d'entrée Home Manager
│   ├── user/              # Modules utilisateur (neovim, shell, packages, git, etc.)
│   └── config/            # Fichiers de configuration statiques (waybar, river, kitty, etc.)
└── Taskfile.yml           # Raccourcis de gestion du système et du repo
```

---

## Installation

### 1. Créer et flasher l'ISO d'installation

Tu peux générer l'ISO minimale d'installation personnalisée directement depuis ce dépôt :

```bash
# Générer l'image ISO
nix build .#nixosConfigurations.iso.config.system.build.isoImage

# Flasher sur la clé USB (remplace /dev/sdX par ton périphérique)
sudo dd if=result/iso/*.iso of=/dev/sdX bs=4M status=progress conv=fsync
```

Démarre ensuite la machine cible sur la clé USB (via le menu boot BIOS/UEFI).

---

### 2. Cloner la configuration

Une fois dans l'environnement live NixOS, clone ce dépôt dans `~/.dotfiles` :

```bash
nix-shell -p git

git clone https://github.com/BenjaminDebotte/dotfiles.nix ~/.dotfiles
```

---

### 3. Appliquer la configuration (Système + Home Manager)

Grâce à l'intégration de Home Manager dans NixOS, une seule commande déploie l'OS et l'environnement utilisateur de façon atomique :

```bash
cd ~/.dotfiles

# Déployer avec nh
nh os switch .

# Ou avec nixos-rebuild standard
sudo nixos-rebuild switch --flake .#nixos
```

---

### 4. Redémarrer

Redémarre la machine pour finaliser le démarrage sur ta nouvelle génération :

```bash
sudo reboot
```

---

## Post-installation

### 5. Importer les clés SSH et GPG depuis Google Drive

Récupère tes clés SSH et GPG sauvegardées :

```bash
# Copie tes clés SSH
cp ~/keys-backup/id_ed25519 ~/.ssh/
cp ~/keys-backup/id_ed25519.pub ~/.ssh/
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub

# Importer la clé GPG et le niveau de confiance
gpg --import ~/keys-backup/private-key.asc
gpg --import-ownertrust ~/keys-backup/ownertrust.txt
```

---

### 6. Configurer le password store

Clone ton dépôt de mots de passe chiffré :

```bash
git clone https://github.com/BenjaminDebotte/passwordstore ~/.password-store
pass ls
```

---

## Commandes courantes (Taskfile)

Ce dépôt inclut un `Taskfile.yml` pour faciliter toutes les opérations courantes via `task` :

| Commande | Description |
| :--- | :--- |
| `task switch` | Reconstruit et applique la configuration NixOS + Home Manager (`nh os switch`) |
| `task test` | Teste la configuration sans l'appliquer (dry-run) |
| `task boot` | Applique la configuration pour le prochain démarrage |
| `task update` | Met à jour les inputs du flake (`nix flake update`) |
| `task fmt` | Formate tous les fichiers Nix avec Alejandra (`nix fmt`) |
| `task lint` | Vérifie les anti-patterns Nix avec Statix |
| `task deadcode` | Détecte le code mort avec Deadnix |
| `task clean` | Nettoie les anciennes générations et le store (`nh clean`) |
| `task diff` | Affiche le diff des paquets modifiés depuis la dernière génération |
| `task iso` | Compile l'image ISO d'installation minimale |

---

## Mise à jour

Pour mettre à jour les inputs et appliquer les changements :

```bash
task update
task switch
```
