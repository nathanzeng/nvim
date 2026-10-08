# After macos golden gate, I had to do this
# `sudo DEVELOPER_DIR=/Library/Developer/CommandLineTools CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/neovim" make`

# Current method for building from source
sudo make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/neovim" &&
  sudo make install
