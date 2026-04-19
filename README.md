# dotfiles.nix

Ma configuration personnelle [NixOS](https://nixos.org/) et [Home Manager](https://github.com/nix-community/home-manager), gérée de façon déclarative et reproductible.

## Table des matières

- [Prérequis](#prérequis)
- [Installation](#installation)
  - [1. Flasher NixOS sur une clé USB](#1-flasher-nixos-sur-une-clé-usb)
  - [2. Cloner la configuration](#2-cloner-la-configuration)
  - [3. Appliquer la configuration système](#3-appliquer-la-configuration-système)
  - [4. Appliquer la configuration utilisateur](#4-appliquer-la-configuration-utilisateur)
  - [5. Redémarrer](#5-redémarrer)
- [Post-installation](#post-installation)
  - [6. Importer les clés SSH et GPG depuis Google Drive](#6-importer-les-clés-ssh-et-gpg-depuis-google-drive)
  - [7. Importer la clé GPG et l'ownership trust](#7-importer-la-clé-gpg-et-lownership-trust)
  - [8. Configurer le password store](#8-configurer-le-password-store)
- [Structure du dépôt](#structure-du-dépôt)
- [Mise à jour](#mise-à-jour)

---

## Prérequis

- Une clé USB d'au moins **2 Go**
- Un outil de flashage : [Balena Etcher](https://etcher.balena.io/), `dd`, ou `cp`
- L'ISO NixOS disponible sur [nixos.org/download](https://nixos.org/download)
- Un accès à Google Drive pour récupérer les clés SSH et GPG

---

## Installation

### 1. Flasher NixOS sur une clé USB

Télécharge l'ISO NixOS depuis le site officiel, puis flashe-la sur ta clé USB.

**Avec `dd` (Linux/macOS) :**

```bash
# Remplace /dev/sdX par le bon périphérique (vérifie avec lsblk)
sudo dd if=nixos-*.iso of=/dev/sdX bs=4M status=progress conv=fsync
```

**Avec Balena Etcher :**

Lance Etcher, sélectionne l'ISO, choisis ta clé USB, puis clique sur *Flash*.

> ⚠️ **Attention :** toutes les données sur la clé USB seront effacées.

Démarre ensuite ta machine sur la clé USB (via le menu boot de ton BIOS/UEFI).

---

### 2. Cloner la configuration

Une fois dans l'environnement live NixOS, clone ce dépôt dans `~/.dotfiles` :

```bash
nix-shell -p git

git clone https://github.com/BenjaminDebotte/dotfiles.nix ~/.dotfiles
```

---

### 3. Appliquer la configuration système

Depuis le répertoire de la configuration, applique la configuration NixOS :

```bash
cd ~/.dotfiles

sudo nixos-rebuild switch --flake .#<nom-de-ta-machine>
```

> 💡 Remplace `<nom-de-ta-machine>` par le nom de host défini dans ta configuration (ex: `nixos-desktop`).

---

### 4. Appliquer la configuration utilisateur

Une fois le système reconstruit, applique la configuration Home Manager :

```bash
home-manager switch --flake .#<ton-utilisateur>
```

> 💡 Remplace `<ton-utilisateur>` par le nom d'utilisateur défini dans ta configuration Home Manager.

---

### 5. Redémarrer

Redémarre la machine pour t'assurer que tous les changements sont bien appliqués :

```bash
sudo reboot
```

---

## Post-installation

### 6. Importer les clés SSH et GPG depuis Google Drive

Monte ou accède à ton Google Drive pour récupérer tes clés. Par exemple avec `rclone` (si configuré) :

```bash
# Copie tes clés depuis Drive vers un dossier temporaire sécurisé
rclone copy drive:/keys ~/keys-backup
```

Ou via le navigateur / un autre moyen de ton choix. Place ensuite tes clés SSH au bon endroit :

```bash
cp ~/keys-backup/id_ed25519 ~/.ssh/
cp ~/keys-backup/id_ed25519.pub ~/.ssh/
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
```

---

### 7. Importer la clé GPG et l'ownership trust

Importe ta clé GPG privée depuis le fichier récupéré sur Drive :

```bash
gpg --import ~/keys-backup/private-key.asc
```

Puis restaure le niveau de confiance (*owner trust*) :

```bash
gpg --import-ownertrust ~/keys-backup/ownertrust.txt
```

Vérifie que la clé est bien importée et marquée comme *ultimate* :

```bash
gpg --list-secret-keys
```

> 🔒 Supprime les fichiers de clés temporaires une fois l'import terminé :
> ```bash
> rm -rf ~/keys-backup
> ```

---

### 8. Configurer le password store

Clone le dépôt du password store :

```bash
git clone https://github.com/BenjaminDebotte/passwordstore ~/.password-store
```

Le store est chiffré avec ta clé GPG. Vérifie que tout fonctionne en listant les entrées :

```bash
pass ls
```

Si le store a été initialisé avec une ancienne clé, réinitialise-le avec ta clé importée :

```bash
pass init <ton-gpg-key-id>
```

> 💡 Retrouve ton `<ton-gpg-key-id>` avec `gpg --list-secret-keys --keyid-format LONG`.

---

## Structure du dépôt

```
dotfiles.nix/
├── flake.nix          # Point d'entrée Nix Flake
├── flake.lock         # Lock file des dépendances
├── nixos/             # Configurations système NixOS
│   ├── configuration.nix
│   └── hardware-configuration.nix
└── home/              # Configurations utilisateur Home Manager
    ├── home.nix
    └── modules/
```

---

## Mise à jour

Pour mettre à jour les inputs du flake (nixpkgs, home-manager, etc.) :

```bash
cd ~/.dotfiles
nix flake update

# Puis reconstruire
sudo nixos-rebuild switch --flake .#<nom-de-ta-machine>
home-manager switch --flake .#<ton-utilisateur>
```

---

> Ce dépôt est personnel et taillé pour ma machine. Sens-toi libre de t'en inspirer, mais adapte-le à tes besoins avant de l'utiliser tel quel.
