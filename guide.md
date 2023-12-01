```sh
git submodule update --init --recursive
cd kali-nethunter-kernel
./build.sh

# Set up environment & download toolchains
# Configure & compile kernel from scratch
# Create NetHunter zip
# Exit

cp -r nethunter/* ../kali-nethunter-project/nethunter-installer/devices/thirteen/pyxis
cd ../kali-nethunter-project/nethunter-installer
python3 build.py -d pyxis --thirteen --kernel
```
