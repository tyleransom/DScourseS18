#!/bin/bash

#
# Pythonbatch will prepare and submit a Python job to the SLURM queue on the 
# OSCER cluster at OU
#
# Original script written by Tyler Ransom.
#

# Test usage; if incorrect, output correct usage
if [ "$#" -gt 4  -o  "$#" -eq 0 ]; then
    echo "********************************************************************"
    echo "*                        Pythonbatch version 0.1                   *"
    echo "********************************************************************"
    echo "The 'Pythonbatch' script submits Python batch jobs to the OSCER cluster."
    echo ""
    echo "Usage is:"
    echo "         Pythonbatch <input_file.py> <output_file.log> <length_of_time in DD:HH:MM:SS format> <email>"
    echo ""
    echo "Spaces in the filename or directory name may cause failure."
    echo ""
else
    # Stem and extension of file
    filestem=`echo $1 | cut -f1 -d.`
    extension=`echo $1 | cut -f2 -d.`

    # Test if file exist
    if [ ! -r $1 ]; then
        echo ""
        echo "File does not exist"
        echo ""
    elif [ $extension != py ]; then
        echo ""
        echo "Invalid input file, must be a py-file"
        echo ""
    else
        # Direct output, conditional on number of arguments
        if [ "$#" -eq 1 ]; then
            output=$filestem.log
        else
            output=$2
        fi

        # Use user-defined 'TMPDIR' if possible; else, use /tmp
        if [[ -n $TMPDIR ]]; then
            pathy=$TMPDIR
        else
            pathy=/scratch/$USER
        fi

        # Script time as third argument
        timelen=$3

        # Email address as fourth argument
        emailadd=$4

        # Tempfile for the script
        shell=`mktemp $pathy/shell.XXXXXX` || exit 1
        chmod 700 $shell

        # Create script
        echo "#!/bin/bash"                      >> $shell

        # SLURM metacommands
        echo "#SBATCH --partition=normal"       >> $shell
        echo "#SBATCH --ntasks=1"               >> $shell
        echo "#SBATCH --mem=1024"               >> $shell
        echo "#SBATCH --job-name=Pythonbatch"   >> $shell
        echo "#SBATCH --output=$output"         >> $shell
        echo "#SBATCH --mail-type=ALL"          >> $shell
        echo "#SBATCH --mail-user=$emailadd"    >> $shell
        echo "#SBATCH --time=$timelen"          >> $shell
        echo "pwd"                              >> $shell
        echo "date"                             >> $shell
        echo "srun /usr/bin/python ${filestem}.${extension}" >> $shell
        sbatch $shell
    fi
fi
