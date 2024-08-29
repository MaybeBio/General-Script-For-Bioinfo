#!/bin/bash

#----------------------------------------------------

ZHTtype=$1   将第一个命令行参数赋给变量 ZHTtype，本来是PDXtype，修改成了ZHTtype，应该就是文件名，最后的标识之类的，或者我可以使用hic-pro来进行标注        
FOLDER=$2   将第二个命令行参数赋给变量 FOLDER，它用于指定数据所在的文件夹，个人推测这里是不是hicpro输出数据文件的文件夹，比如说/mnt/disk4/haitao/bysj_seu/geo_data/hic/hicpro_output/

echo 'bash' $0 $1 $2 >> cmdRun.txt   将文本 'sh' $0 $1 $2 追加到文件，$0、$1 和 $2 是特殊变量，分别表示脚本名称和第一个和第二个命令行参数，所以我觉得可能是这样的，即sh 本脚本 文件名 参数名；所以这里可能是有一个统一的脚本执行文件，里面写满了命令，注意这个cmdRun.TXT！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！但其实后面一直就只用到了$2参数，只有下面是用了这个参数$1，应该是文件的标记名字然后这里的sh也要修改成bash
        ！！！！！！！！！！！！！！！！！！！！！！！！！未搞清楚下面的命名
OUTmapstat=${ZHTtype}-mapstat.txt      创建一个名为 OUTmapstat 的变量，其值是 ZHTtype 变量的值与字符串 -mapstat.txt 的连接
OUTpairstat=${ZHTtype}-pairstat.txt     创建一个名为 OUTpairstat 的变量，其值是 ZHTtype 变量的值与字符串 -pairstat.txt 的连接
OUTmergestat=${ZHTtype}-mergestat.txt      创建一个名为 OUTmergestat 的变量，其值是 ZHTtype 变量的值与字符串 -mergestat.txt 的连接
OUTRSstat=${ZHTtype}-RSstat.txt        创建一个名为 OUTRSstat 的变量，其值是 ZHTtype 变量的值与字符串 -RSstat.txt 的连接

#----------------------------------------------------  应该就是各种hic-pro过程中的统计文件stat

mapstatSuffix="*_R1_hg19.mapstat"    创建一个名为 mapstatSuffix 的变量，其值是字符串 *_R1_hg38.mapstat，我用的是hg19，这里应该是hic输出bowtie输出中的bwt2中的rep中的统计文件!!!!!
pairstatSuffix="*_hg19.bwt2pairs.pairstat"    创建一个名为 pairstatSuffix 的变量，其值是字符串 *.bwt2pairs.pairstat，同样同上，但是这里我觉得应该修改为_hg19.bwt2pairs.pairstat，因为唯一没有变化的应该就是前面的rep文件名!!!!!!
mergestatSuffix="_allValidPairs.mergestat"      创建一个名为 mergestatSuffix 的变量，其值是字符串 _allValidPairs.mergestat，这个目录是在stat下面
RSstatSuffix="*_hg19.bwt2pairs.RSstat"    创建一个名为 RSstatSuffix 的变量，其值是字符串 *_hg38.bwt2pairs.RSstat，我用的是hg19；后面参考实际操作的行第181行时，注意目录修改为了data，而不是stat，因为stat中的后缀不一样，但是查看之后可以发现data中的Rstat和stat中的mRstat数据是一样的!!!!!!!!
 

qc_metrics_temp=temp.txt    创建一个名为 qc_metrics_temp 的变量，其值是字符串 temp.txt

#----------------------------------------------------

for folder in $FOLDER/logs/*/; do        联系低6行，推理是/mnt/disk4/haitao/bysj_seu/geo_data/hic/hicpro_output/，遍历 $FOLDER/logs/*/ 下的所有文件夹

	foldername=$(basename $folder)           将 $folder 的基本文件名（即不包含路径的文件名）赋值给变量 foldername，那应该就是HMEC_rep1等等名称

	qc_metrics=$foldername"_mapping_statistics.txt"    将 foldername 和 _mapping_statistics.txt 连接起来，并将结果赋值给变量 qc_metrics。这个变量名看起来像是用于存储某种质控统计数据的文件名，类似于HMEC_rep1_mapping_statistics.txt

	echo -e "Sample\nTotal\nMapped\nGlobal\nLocal" > $qc_metrics    将 "Sample\nTotal\nMapped\nGlobal\nLocal" 这个字符串写入到文件 $qc_metrics 中。其中 \n 是换行符，-e是启用转义字符

	tempCol=$foldername"_tempCol.txt"                将 foldername 和 _tempCol.txt 连接起来，并将结果赋值给变量 tempCol。这个变量名看起来像是用于存储某种临时列的文件名，类似于HMEC_rep1_tempCol.txt

	#************
	# Collect stats from the first alignment round         收集第一轮比对（alignment）的统计信息，从此处开始将所有stat文件前缀中的SRR修改为对应的样本rep名字
	#************

	file1=$FOLDER/bowtie_results/bwt2/${foldername}/${foldername}${mapstatSuffix}       根据第6行注意，是/mnt/disk4/haitao/bysj_seu/geo_data/hic/hicpro_output/，进入bwt2之后根据HMEC_rep1，根据第17行就是HMEC_rep1_R1_hg19.mapstat，注意到实际文件是SRR13755462_R1_hg19.mapstat，就是当初我在hicpro建立文件夹的时候将SRR改成了后续的文件rep名字，可以在前面第6行的地方修改文件名HMEC_rep1修改成对应的SRR字，或者是直接将bwt2/rep对应的文件夹中将所有的stat文件，将其前缀SRR修改成对应的rep名字！！！！！！！！！！！！！！！！！！
	file2=$FOLDER/bowtie_results/bwt2/${foldername}/${foldername}${mapstatSuffix/R1/R2}	     将 file2 设为 ${FOLDER}/bowtie_results/bwt2/${foldername}/${foldername}${mapstatSuffix/R1/R2}，其中 ${mapstatSuffix/R1/R2} 是将 mapstatSuffix 中的 R1 替换为 R2，这样bwt2中的所有stat统计文件都完全了，但是还有个pairstat文件没有处理

	total=($(grep "total" $file1))  将 total 设为 $file1 中包含 total 的行的内容，统计的是HMEC_rep1_R1_hg19.mapstat，为什么这里不统计R2，看数据是都一样，是测序的问题吗，！！！！！更正一下，对于该部分的内容，在运行全局的脚本之后发现total是比mapped下面小的，个人觉得还是将total合并起来，可能是测序处理问题，所以两个fq一致，修改的话就还是按照下面的，修改为total1一级2，然后再两个相加。即 total1=($(grep "total" $file1))，total2=($(grep "total" $file2))，再下面57行前面是totalSUM=`echo "${total1[1]}+${total2[1]}" | bc`，然后就是61行修改成totalSUM！！！！！！！！！！！！！！！！！！！！！

	mapped1=($(grep "mapped" $file1))   同上将 mapped1 设为 $file1 中包含 mapped 的行的内容
	mapped2=($(grep "mapped" $file2))   同上将 mapped2 设为 $file2 中包含 mapped 的行的内容

	global1=($(grep "global" $file1))      同上将 global1 设为 $file1 中包含 global 的行的内容
	global2=($(grep "global" $file2))      同上将 global2 设为 $file2 中包含 global 的行的内容

	local1=($(grep "local" $file1))   同上将 local1 设为 $file1 中包含 local 的行的内容
        local2=($(grep "local" $file2))     同上将 local2 设为 $file2 中包含 local 的行的内容

	#************

	mappedSUM=`echo "${mapped1[1]}+${mapped2[1]}" | bc`   计算 mapped1 和 mapped2 的第二个元素的和，并将结果赋给 mappedSUM，应该是计算R1/R2，就是一个rep的双端测序
	globalSUM=`echo "${global1[1]}+${global2[1]}" | bc`     代码计算 global1 和 global2 的第二个元素的和，并将结果赋给 globalSUM
	localSUM=`echo "${local1[1]}+${local2[1]}" | bc`    计算 local1 和 local2 的第二个元素的和，并将结果赋给 localSUM

	echo -e "$foldername\n${total[1]}\n${mappedSUM}\n${globalSUM}\n${localSUM}" >> $tempCol     将 $foldername、${total[1]}、${mappedSUM}、${globalSUM}、${localSUM} 写入第35行的数据$tempCol，就是建立了一个表格，然后第一列就是统计数据属性列

        paste $qc_metrics $tempCol > $qc_metrics_temp    参考第31行，35行，以及61行，将 $qc_metrics 和 $tempCol 合并成一个文件，并将结果写入 $qc_metrics_temp，应该是将文件按列合并
        mv $qc_metrics_temp $qc_metrics   将 $qc_metrics_temp 重命名为 $qc_metrics

done

paste *"_mapping_statistics.txt" | cut -f1,2,4,6,8,10,12 > $OUTmapstat   将所有以 _mapping_statistics.txt 结尾的文件合并成一个文件，并将结果写入 $OUTmapstat。然后，它使用 cut 命令提取文件的第1、2、4、6、8、10 和 12 列，并将结果写入 $OUTmapsta，参考第31+63行，文件qc_metrics应该就是_mapping_statistics.txt文件

rm *"_mapping_statistics.txt"    删除所有以 _mapping_statistics.txt 结尾的文件


#----------------------------------------------------
# Second set of stats       第2轮统计应该是参考第一轮，第一轮结束的文件都要清空

qc_metrics_temp=temp.txt     将 qc_metrics_temp 设为 temp.txt

#----------------------------------------------------

for folder in $FOLDER/logs/*/; do

	foldername=$(basename $folder)

	qc_metrics=$foldername"_pairstat.txt"   参考第42行，就是剩余的stat文件需要统计，bwt2中类似HMEC_rep1_pairstat.txt，上面处理都同上第一次

	echo -e "Sample\nTotal_pairs_processed\nUnmapped_pairs\nUnique_paired_alignments\nMultiple_pairs_alignments\nPairs_with_singleton\nReported_pairs" > $qc_metrics  将 "Sample\nTotal_pairs_processed\nUnmapped_pairs\nUnique_paired_alignments\nMultiple_pairs_alignments\nPairs_with_singleton\nReported_pairs" 这个字符串写入到文件 $qc_metrics 中。其中 \n 是换行符，同理就是建了一个表格，第一列是属性名     

	tempCol=$foldername"_tempCol.txt"   将 foldername 和 _tempCol.txt 连接起来，并将结果赋值给变量 tempCol。这个变量名看起来像是用于存储某种临时列的文件名，类似HMEC_rep1_tempCol.txt

	#************
	# Collect stats
	#************

	pairstatFile=$FOLDER/bowtie_results/bwt2/$foldername/${foldername}${pairstatSuffix}   参考第18，41行，就是将 pairstatFile 设为 ${FOLDER}/bowtie_results/bwt2/${foldername}/${foldername}${pairstatSuffix}，其中 ${FOLDER} 是之前定义的变量，表示数据所在的文件夹，${foldername} 是之前定义的变量，表示当前文件夹的名称，${pairstatSuffix} 是之前定义的变量，表示文件名的后缀，就是第18行的统计文件，类似HMEC_rep1.bwt2pairs.pairstat,但是原文件夹下没有这个文件，所有应该修改第18行，修改后缀之后就是HMEC_rep1_hg19.bwt2pairs.pairstat！！！！！！！！！！！！！！！！！！

	pairsProcessed=($(grep "Total_pairs_processed" $pairstatFile))	
	unmapped=($(grep "Unmapped_pairs" $pairstatFile))
	uniqPairedAlign=($(grep "Unique_paired_alignments" $pairstatFile))
	mltplPairsAlign=($(grep "Multiple_pairs_alignments" $pairstatFile))
	pairsWithSingl=($(grep "Pairs_with_singleton" $pairstatFile))
	reportedPairs=($(grep "Reported_pairs" $pairstatFile))   将 reportedPairs 设为 $pairstatFile 中包含 Reported_pairs 的行的内容，上面同理，都是收集抓取上面的行数内容

	echo -e "$foldername\n${pairsProcessed[1]}\n${unmapped[1]}\n${uniqPairedAlign[1]}\n${mltplPairsAlign[1]}\n${pairsWithSingl[1]}\n${reportedPairs[1]}" >> $tempCol   将 $foldername、${pairsProcessed[1]}、${unmapped[1]}、${uniqPairedAlign[1]}、${mltplPairsAlign[1]}、${pairsWithSingl[1]} 和 ${reportedPairs[1]} 写入 $tempCol，参考第88行

        paste $qc_metrics $tempCol > $qc_metrics_temp
        mv $qc_metrics_temp $qc_metrics     参考上面第63/64行

        rm -r $tempCol

done

paste *"_pairstat.txt" | cut -f1,2,4,6,8,10,12 > $OUTpairstat       将所有以 _pairstat.txt 结尾的文件合并成一个文件，并将结果写入 $OUTpairstat。然后，它使用 cut 命令提取文件的第1、2、4、6、8、10 和 12 列，并将结果写入 $OUTpairstat

rm *"_pairstat.txt"           删除所有以 _pairstat.txt 结尾的文件


#----------------------------------------------------
# Third set of stats

qc_metrics_temp=temp.txt    同上又是清空了

#----------------------------------------------------

for folder in $FOLDER/logs/*/; do

	foldername=$(basename $folder)

	qc_metrics=$foldername"_mergestat.txt"   将 foldername 和 _mergestat.txt 连接起来，并将结果赋值给变量 qc_metrics。这个变量名看起来像是用于存储某种质控统计数据的文件名，类似HMEC_rep1_mergestat.txt

	echo -e "Sample\nvalid_interaction\nvalid_interaction_rmdup\ntrans_interaction\ncis_interaction\ncis_shortRange\ncis_longRange" > $qc_metrics    将 "Sample\nvalid_interaction\nvalid_interaction_rmdup\ntrans_interaction\ncis_interaction\ncis_shortRange\ncis_longRange" 这个字符串写入到文件 $qc_metrics 中。其中 \n 是换行符,同上就是写表格

	tempCol=$foldername"_tempCol.txt"   将 foldername 和 _tempCol.txt 连接起来，并将结果赋值给变量 tempCol。这个变量名看起来像是用于存储某种临时列的文件名，类似HMEC_rep1_tempCol.txt

	#************
	# Collect stats from the first alignment round
	#************

	file=$FOLDER/hic_results/stats/${foldername}/${foldername}${mergestatSuffix}	  将 file 设为 ${FOLDER}/hic_results/data/${foldername}/${foldername}${mergestatSuffix}，其中 ${FOLDER} 是之前定义的变量，表示数据所在的文件夹，${foldername} 是之前定义的变量，表示当前文件夹的名称，${mergestatSuffix} 是之前定义的变量，表示文件名的后缀。参考第19行，即类似HMEC_rep1_allValidPairs.mergestat,但是我实际看一下，这个文件应该不是在data目录下，应该是在stats文件夹下，所以从$FOLDER/hic_results/data/${foldername}/${foldername}${mergestatSuffix}修改为$FOLDER/hic_results/stats/${foldername}/${foldername}${mergestatSuffix}！！！！！！！！！！！！！！！！！
 
	valid=($(grep "valid_interaction" $file))
	validrmdup=($(grep "valid_interaction_rmdup" $file))
	trans=($(grep "trans_interaction" $file))
	cis=($(grep "cis_interaction" $file))
	short=($(grep "cis_shortRange" $file))
	long=($(grep "cis_longRange" $file))     将 long 设为 $file 中包含 cis_longRange 的行的内容，同之前抓取文件内容

	echo -e "$foldername\n${valid[1]}\n${validrmdup[1]}\n${trans[1]}\n${cis[1]}\n${short[1]}\n${long[1]}" >> $tempCol   将 $foldername、${valid[1]}、${validrmdup[1]}、${trans[1]}、${cis[1]}、${short[1]} 和 ${long[1]} 写入 $tempCol，同上

        paste $qc_metrics $tempCol > $qc_metrics_temp      
        mv $qc_metrics_temp $qc_metrics      还是同上

        rm -r $tempCol

done

paste *"_mergestat.txt" | cut -f1,2,4,6,8,10,12 > $OUTmergestat      将所有以 _mergestat.txt 结尾的文件合并成一个文件，并将结果写入 $OUTmergestat。然后，它使用 cut 命令提取文件的第1、2、4、6、8、10 和 12 列，并将结果写入 $OUTmergestat，同上

rm *"_mergestat.txt" 

#----------------------------------------------------
# Fourth set of stats

qc_metrics_temp=temp.txt

#----------------------------------------------------

for folder in $FOLDER/logs/*/; do

	foldername=$(basename $folder)

	qc_metrics=$foldername"_RSstat.txt"      同上，类似HMEC_rep1_RSstat.txt

	echo -e "Sample\nValid_interaction_pairs\nValid_interaction_pairs_FF\nValid_interaction_pairs_RR\nValid_interaction_pairs_RF\nValid_interaction_pairs_FR\nDangling_end_pairs\nReligation_pairs\nSelf_Cycle_pairs\nSingle-end_pairs\nDumped_pairs" > $qc_metrics   将 "Sample\nValid_interaction_pairs\nValid_interaction_pairs_FF\nValid_interaction_pairs_RR\nValid_interaction_pairs_RF\nValid_interaction_pairs_FR\nDangling_end_pairs\nReligation_pairs\nSelf_Cycle_pairs\nSingle-end_pairs\nDumped_pairs" 这个字符串写入到文件 $qc_metrics 中。其中 \n 是换行符

	tempCol=$foldername"_tempCol.txt"

	#************
	# Collect stats from the first alignment round
	#************

	file=$FOLDER/hic_results/data/${foldername}/${foldername}${RSstatSuffix}     参考第20行，类似HMEC_rep1_hg19.bwt2pairs.RSstat，确实是在data下面，但是要注意对应的后缀，然后SRR修改成rep名字！！！！！！！！！！

	valid=($(grep "Valid_interaction_pairs" $file))
	validFF=($(grep "Valid_interaction_pairs_FF" $file))
	validRR=($(grep "Valid_interaction_pairs_RR" $file))
	validRF=($(grep "Valid_interaction_pairs_RF" $file))
	validFR=($(grep "Valid_interaction_pairs_FR" $file))
	dangling=($(grep "Dangling_end_pairs" $file))
	religation=($(grep "Religation_pairs" $file))
	self=($(grep "Self_Cycle_pairs" $file))
	send=($(grep "Single-end_pairs" $file))
	dumped=($(grep "Dumped_pairs" $file))   同上抓取内容

	#************

	echo -e "$foldername\n${valid[1]}\n${validFF[1]}\n${validRR[1]}\n${validRF[1]}\n${validFR[1]}\n${dangling[1]}\n${religation[1]}\n${self[1]}\n${send[1]}\n${dumped[1]}" >> $tempCol   将 $foldername、${valid[1]}、${validFF[1]}、${validRR[1]}、${validRF[1]}、${validFR[1]}、${dangling[1]}、${religation[1]}、${self[1]}、${send[1]} 和 ${dumped[1]} 写入 $tempCol，同上

        paste $qc_metrics $tempCol > $qc_metrics_temp    
        mv $qc_metrics_temp $qc_metrics

        rm -r $tempCol

done

paste *"_RSstat.txt" | cut -f1,2,4,6,8,10,12 > $OUTRSstat      

rm *"_RSstat.txt"     全都同上







