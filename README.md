![license](https://img.shields.io/github/license/hhk7734/odroid-config)
![version](https://img.shields.io/github/v/tag/hhk7734/odroid-config?sort=semver)
![language](https://img.shields.io/github/languages/top/hhk7734/odroid-config)

# odroid-config

## Installation

### PPA

```bash
sudo add-apt-repository -y ppa:hardkernel/ppa \
&& sudo apt update \
&& sudo apt install -y odroid-config
```

### Manual

```bash
git clone https://github.com/hhk7734/odroid-config.git \
&& cd odroid-config \
&& sudo make install \
&& cd .. && sudo rm -rf odroid-config
```

## Usage

```bash
sudo odroid-config
```

![odroid-config](./odroid-config.png)
