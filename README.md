<p align="center">
  <pre>
       /$$       /$$           /$$   /$$                 /$$
      | $$      | $$          | $$  | $$                | $$
  /$$$$$$$  /$$$$$$$  /$$$$$$$| $$  | $$  /$$$$$$$  /$$$$$$$
 /$$__  $$ /$$__  $$ /$$_____/| $$$$$$$$ /$$_____/ /$$__  $$
| $$  | $$| $$  | $$| $$      |_____  $$| $$      | $$  | $$
| $$  | $$| $$  | $$| $$            | $$| $$      | $$  | $$
|  $$$$$$$|  $$$$$$$|  $$$$$$$      | $$|  $$$$$$$|  $$$$$$$
 \_______/ \_______/ \_______/      |__/ \_______/ \_______/
  </pre>
</p>

This project implements diverse double-compiling (DDC) in a callable Github Action workflow.
The [DDC workflow](https://github.com/chains-project/ddc4cd/tree/main/.github/workflows/ddc.yml) can be found in the .github directory along with helper scripts used during during the run.

To run the DDC process locally one can clone this repository and use the run_ddc.sh script, after installing [Nix](https://nix.dev/).

Another repository, [tcc-hardened](https://github.com/chains-project/tcc-hardened/), shows how to call this workflow to release a DDC'd C compiler.
