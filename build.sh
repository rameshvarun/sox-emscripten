# Activate last Emscripten version.
emsdk install 3.1.26
emsdk activate 3.1.26

# Download and unzip Sox version.
wget 'https://downloads.sourceforge.net/project/sox/sox/14.4.2/sox-14.4.2.tar.gz'
tar -xf sox-14.4.2.tar.gz

cd sox-14.4.2
sed -i '/\w*#error FIX NEEDED HERE/d' src/formats.c
emconfigure ./configure --disable-stack-protector

emmake make -s
emmake make DESTDIR="$PWD/local_install_dir" install

emcc -s WASM=1 \
    src/sox.c \
    -s "STRICT=1" \
    -s "ALLOW_MEMORY_GROWTH=1" \
    -s "WASM=1" \
    -s "MODULARIZE=1" \
    -s EXPORT_NAME="SOXModule" \
    -s EXTRA_EXPORTED_RUNTIME_METHODS=["FS"] \
    -s LLD_REPORT_UNDEFINED \
    -s ALLOW_UNIMPLEMENTED_SYSCALLS\
    ./local_install_dir/usr/local/lib/libsox.a \
    -I sox/src \
    -o ../sox.js