# SoX Emscripten

SoX (https://sox.sourceforge.net/) compiled to WASM using Emscripten. Based off https://github.com/IPS-LMU/wasmsox, but with some changes, including modularization.

This is a direct port of the SOX command line - to use it you add files to the virtual file system and call the module using virtual command-line args. Here's a simple example of converting RAW PCM data to a WAV file.

```html
<script src="https://cdn.jsdelivr.net/gh/rameshvarun/sox-emscripten@0.1.0/build/sox.js"></script>
<script>
const module = {
    arguments: ["-r", "8000", "-L", "-e",
        "signed-integer", "-b", "16", "-c", "1",
        "input.raw", "output.wav"],
    preRun: () => {
        module.FS.writeFile("input.raw", new Uint8Array(inputArrayBuffer));
    },
    postRun: () => {
        let output = module.FS.readFile("output.wav", {
            encoding: "binary",
        });
    },
};
SOXModule(module);
</script>
```
