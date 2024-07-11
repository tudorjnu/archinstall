# archinstall

Install base:

```sh
pacstrap -K /mnt \
  base base-devel \
  linux linux-headers \
  linux-lts linux-lts-headers \
  linux-firmware \
  neovim git 
```

