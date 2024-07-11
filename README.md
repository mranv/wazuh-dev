<h1 align="center">
<br>
<img src=assets/200049806-72f38220-1182-401b-8d5b-ea9e57a21903.gif >
<br>
<strong>wazuh-dev: A Development Environment Setup</strong>
</h1>

This repository provides scripts and tools to set up a development environment for Wazuh, an open-source security monitoring platform. The setup instructions cover both CentOS and Debian-based systems.

## CentOS Setup

### Installation Steps

1. **Install Dependencies:**

   ```bash
   sudo yum install -y make cmake gcc gcc-c++ python3 python3-policycoreutils automake autoconf libtool openssl-devel yum-utils
   ```

2. **Install Custom GCC:**

   ```bash
   curl -OL http://packages.wazuh.com/utils/gcc/gcc-9.4.0.tar.gz && \
   tar xzf gcc-9.4.0.tar.gz && \
   cd gcc-9.4.0/ && \
   ./contrib/download_prerequisites && \
   ./configure --enable-languages=c,c++ --prefix=/usr --disable-multilib --disable-libsanitizer && \
   make -j$(nproc) && \
   sudo make install && \
   sudo ln -fs /usr/bin/g++ /bin/c++ && \
   sudo ln -fs /usr/bin/gcc /bin/cc && \
   cd .. && \
   sudo rm -rf gcc-* && \
   sudo scl enable devtoolset-7 bash
   ```

3. **Enable Powertools Repository:**

   ```bash
   sudo yum-config-manager --enable powertools
   ```

4. **Install libstdc++-static:**

   ```bash
   sudo yum install libstdc++-static -y
   ```

5. **Optional: Install CMake 3.18 from Sources:**

   ```bash
   curl -OL https://packages.wazuh.com/utils/cmake/cmake-3.18.3.tar.gz && \
   tar -zxf cmake-3.18.3.tar.gz && \
   cd cmake-3.18.3 && \
   ./bootstrap --no-system-curl && \
   make -j$(nproc) && \
   sudo make install && \
   cd .. && \
   sudo rm -rf cmake-*
   ```

6. **Set PATH Environment Variable:**

   ```bash
   export PATH=/usr/local/bin:$PATH
   ```

7. **Optional: Install Python Build Dependencies:**

   ```bash
   sudo yum install epel-release yum-utils -y
   sudo yum-builddep python34 -y
   ```

8. **Clean the environment:**
   ```bash
   curl -Ls https://github.com/wazuh/wazuh/archive/v4.8.0.tar.gz | tar zx
   cd wazuh-4.8.0
   make -C src clean
   make -C src clean-deps
   ```

## Debian Setup

### Installation Steps

1. **Install Dependencies:**

   ```bash
   sudo apt-get update && \
   sudo apt-get install -y python gcc g++ make libc6-dev curl policycoreutils automake autoconf libtool libssl-dev
   ```

2. **Install CMake 3.18 from Sources:**

   ```bash
   curl -OL https://packages.wazuh.com/utils/cmake/cmake-3.18.3.tar.gz && \
   tar -zxf cmake-3.18.3.tar.gz && \
   cd cmake-3.18.3 && \
   ./bootstrap --no-system-curl && \
   make -j$(nproc) && \
   sudo make install && \
   cd .. && \
   sudo rm -rf cmake-*
   ```

3. **Optional: Install Python Build Dependencies:**

   ```bash
   echo "deb-src http://archive.ubuntu.com/ubuntu $(lsb_release -cs) main" | sudo tee -a /etc/apt/sources.list
   sudo apt-get update
   sudo apt-get build-dep python3 -y
   ```

4. **Clean the environment:**
   ```bash
   curl -Ls https://github.com/wazuh/wazuh/archive/v4.8.0.tar.gz | tar zx
   cd wazuh-4.8.0
   make -C src clean
   make -C src clean-deps
   ```
