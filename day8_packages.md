# Day 8: Package Management + Building .deb

## APT basics
- `sources.list` defines repos (Debian 13 Trixie, main + security + updates)
- `deb-src` lines enable `apt source <pkg>` for source downloads
- `apt update` refreshes index
- `apt upgrade` installs newer versions
- `apt-mark hold <pkg>` freezes version
- Pin priority: `/etc/apt/preferences.d/<name>`

## Compile from source (classic)
```bash
wget <tarball>
tar -xzf <tarball>
cd <dir>
./configure --prefix=/usr/local
make
sudo make install
