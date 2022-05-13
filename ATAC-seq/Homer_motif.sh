#findMotifsGenome.pl Motif_Custom/AR_bound_AAA_only.bed mm9 Motif_Custom/AR_bound_AAA_only -size 100 &

#findMotifsGenome.pl Motif_Custom/AR_bound_EYFP_only.bed mm9 Motif_Custom/AR_bound_EYFP_only -size 100 &

#findMotifsGenome.pl Motif_Custom/AR_bound_both.bed mm9 Motif_Custom/AR_bound_both -size 100 &

#findMotifsGenome.pl Motif_Custom/AR_bound_neither.bed mm9 Motif_Custom/AR_bound_neither -size 100

findMotifsGenome.pl Motif_Custom/AR_bound_AAA_only.bed mm9 Motif_Custom/AR_bound_neither \
-bg Motif_Custom/AR_bound_neither.bed -p 4 -size 100 