# decrypt-dpc

**For AnonDPC Ver 1.13**

## Requirements

Windows

- [PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/install/install-powershell-on-windows)
- [WSL2](https://learn.microsoft.com/en-us/windows/wsl/install)
- [WSL container](https://learn.microsoft.com/en-us/windows/wsl/wsl-container)
- [Git]()

Mac OS

- [Colima](https://github.com/abiosoft/colima)
- [Docker Cli](https://formulae.brew.sh/formula/docker)
- [Git]()

## Quick Start

Clone the repository with Git.

```
git clone https://www.github.com/kkirino/decrypt-dpc.git
cd decrypt-dpc
```

Place the private key file and the encrypted files into the "./key" directory and the "./encrypted" directory, respectively.

```
.
├── compose.yaml
├── Dockerfile
├── encrypted
│   └── README
├── key
│   └── README
├── Makefile
├── README.md
└── script
    ├── decrypt.sh
    ├── expand.sh
    ├── main.sh
    └── splitaeskey.c
```

For Windows

```{PowerShell}
wslc build -t decrypt-dpc:latest .
wslc run --rm -v $(pwd):/home/ubuntu/app decrypt-dpc:latest
```

For Mac OS

```{bash}
colima start
docker build -t decrypt-dpc:latest .
docker run --rm -v $(pwd):/home/ubuntu/app decrypt-dpc:latest
```

