NAME=$1
cat $NAME | awk '{l[lines++] =$0}
                    END {
                        for ( i= lines -1; i >=0 ; i--) 
                            if (length(l[i])>1){print l[i]}
                        }'
