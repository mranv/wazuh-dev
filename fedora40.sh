# Update dnf
sudo dnf update -y

# Install tools and libraries
sudo dnf install -y cppcheck astyle valgrind lcov clang-tools-extra

# Install mingw
if [ "$1" == "winagent" ]; then
  sudo dnf install -y mingw64-gcc mingw64-gcc-c++ mingw32-gcc-c++ mingw64-nsis
else
  echo "Skipping mingw installation for this target"
fi

# Install wine
if [ "$1" == "winagent" ]; then
  sudo dnf install -y wine.i686 wine.x86_64
else
  echo "Skipping wine installation for this target"
fi

# Install CMocka
if [ "$1" == "winagent" ]; then
  echo "Installing CMocka by sources with 'winagent' required flags"
  cd /tmp
  curl -L https://git.cryptomilk.org/projects/cmocka.git/snapshot/stable-1.1.tar.gz | \
  tar zvx -C /tmp/ && \
  sed -i "s|ON|OFF|g" /tmp/stable-1.1/DefineOptions.cmake && \
  mkdir /tmp/stable-1.1/build && \
  cd /tmp/stable-1.1/build && \
  cmake -DCMAKE_C_COMPILER=i686-w64-mingw32-gcc -DCMAKE_C_LINK_EXECUTABLE=i686-w64-mingw32-ld -DCMAKE_INSTALL_PREFIX=/usr/i686-w64-mingw32/ -DCMAKE_SYSTEM_NAME=Windows -DCMAKE_BUILD_TYPE=Release .. && \
  make && \
  sudo make install && \
  cd $HOME
else
  echo "Installing CMocka directly from dnf"
  sudo dnf install -y cmocka-devel
fi
