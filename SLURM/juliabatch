#!/bin/bash

#
# juliabatch will prepare and submit a julia job to the SLURM queue on the 
# OSCER cluster at OU
#
# Original script written by Tyler Ransom.
#

# Test usage; if incorrect, output correct usage
if [ "$#" -gt 4  -o  "$#" -eq 0 ]; then
    echo "********************************************************************"
    echo "*                       juliabatch version 0.1                     *"
    echo "********************************************************************"
    echo "The 'juliabatch' script submits julia batch jobs to the OSCER cluster."
    echo ""
    echo "Usage is:"
    echo "         juliabatch <input_file.jl> <output_file.log> <length_of_time in DD:HH:MM:SS format> <email>"
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
    elif [ $extension != jl ]; then
        echo ""
        echo "Invalid input file, must be a jl-file"
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
        echo "#SBATCH --job-name=juliabatch"    >> $shell
        echo "#SBATCH --output=$output"         >> $shell
        echo "#SBATCH --mail-type=ALL"          >> $shell
        echo "#SBATCH --mail-user=$emailadd"    >> $shell
        echo "#SBATCH --time=$timelen"          >> $shell
        echo "pwd"                              >> $shell
        echo "date"                             >> $shell
        echo "srun /home/ransom/julia-903644385b/bin/julia ${filestem}.${extension}" >> $shell
        sbatch $shell
    fi
fi
