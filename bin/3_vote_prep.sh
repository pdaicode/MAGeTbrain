#!/bin/bash
#
# Prepare for voting / validation by getting things ready to run on the cluster.
#
# This includes:
#  - TARing up the labels so that they can be moved to each node
#  - consolidating the similarity scores into single CSV files (to save space)
#
# 


output_dir=$PWD/output

echo "Consolidating scores..."
for scoretype in xcorr; do 
    csv=$output_dir/$scoretype.csv
    for t in $output_dir/scores/*; do
        for s in $t/*; do
            scorefile=$s/$scoretype.txt
            if [ ! -e $scorefile ]; then
                echo "WARNING: $scorefile expected but not found!" 1>&2
                continue
            fi
            subject_stem=$(basename $s)
            template_stem=$(basename $(dirname $s))
            echo $template_stem, $subject_stem, $(cat $scorefile)
        done
    done > $csv
done

echo "TARing labels..."
cd $output_dir && tar czf labels.tar.gz labels/

echo "If the above completed without errors, you can now safely remove the folders:"
echo "    $output_dir/scores"
echo "    $output_dir/labels"
echo
