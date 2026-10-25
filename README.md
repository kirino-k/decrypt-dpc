# decrypt-dpc

**For AnonDPC Ver 1.13**

## Requirements

Windows

- [WSL2 (Ubuntu LTS)](https://learn.microsoft.com/en-us/windows/wsl/install)
- [Docker Engine](https://docs.docker.com/engine/install/ubuntu/)
- [Git](https://git-scm.com/install/linux)

Mac OS

- [Colima](https://github.com/abiosoft/colima)
- [Docker Cli](https://formulae.brew.sh/formula/docker)
- [Git](https://git-scm.com/install/mac)

## Quick Start

Clone the repository with Git.

```
git clone https://www.github.com/kkirino/decrypt-dpc.git
cd decrypt-dpc
```

Place the private key file and the encrypted files into the `./key` directory and the `./encrypted` directory, respectively.

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

For Ubuntu on WSL2 (Windows)

```{bash}
docker build -t decrypt-dpc:latest .
docker run --rm -v $(pwd):/home/ubuntu/app decrypt-dpc:latest
```

For Mac OS

```{bash}
colima start
docker build -t decrypt-dpc:latest .
docker run --rm -v $(pwd):/home/ubuntu/app decrypt-dpc:latest
```

## Output

Data files are expanded in the `./expanded` directory.

```
./expanded
└── XXXXXXXXX
    └── yyyyMMddHHmmss
        ├── DPCデータ
        │   ├── Dn_XXXXXXXXX_yyMM.txt.gz
        │   ├── EFg_XXXXXXXXX_yyMM.txt.gz
        │   ├── EFn_XXXXXXXXX_yyMM.txt.gz
        │   ├── FF1_XXXXXXXXX_yyMM.txt.gz
        │   ├── FF4_XXXXXXXXX_yyMM.txt.gz
        │   ├── Hn_XXXXXXXXX_yyMM.txt.gz
       ... ...
        │   └── ...
        └── 匿名化レジストリデータファイル.csv.gz
```
