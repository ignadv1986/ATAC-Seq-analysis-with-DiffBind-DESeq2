sample=$(basename "$bam" .mLb.clN.sorted.bam)
echo "Calling peaks on $sample ..."
macs2 callpeak -t "$bam" -f BAM -g hs -n "$sample" --nomodel --shift -100 --extsize 200 -q 0.01
done
