# apprentice-install

Install scripts for APHA bioinformatics apprentice project.

The scripts within this repository will automatically download and install the required software for
the APHA bioinformatics project. These are:

- [Nextflow](https://github.com/nextflow-io/nextflow)
- [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
- [fastp](https://github.com/OpenGene/fastp)
- [Trimmomatic](https://github.com/usadellab/Trimmomatic)
- [Unicycler](https://github.com/rrwick/Unicycler)
- [prokka](https://github.com/tseemann/prokka)
- [MultiQC](https://github.com/ewels/MultiQC)

along with all of their depedencies.

## Installation

To dowload and run the install script, execute the following commands from within your user home
directory (e.g. `/home/nickpestell`):

1. `sudo apt-get update`
2. `sudo apt-get install git`
3. `git clone https://github.com/nick-pestell/apprentice-install.git`
4. `cd apprentice-install`
5. `bash install.bash`

If ran with no errors the final output should be:

```
Installation complete!
Apprentices, YOU ROCK!
```
