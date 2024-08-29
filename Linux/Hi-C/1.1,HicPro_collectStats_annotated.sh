#!/bin/bash

#----------------------------------------------------

ZHTtype=$1   ����һ�������в����������� ZHTtype��������PDXtype���޸ĳ���ZHTtype��Ӧ�þ����ļ��������ı�ʶ֮��ģ������ҿ���ʹ��hic-pro�����б�ע        
FOLDER=$2   ���ڶ��������в����������� FOLDER��������ָ���������ڵ��ļ��У������Ʋ������ǲ���hicpro��������ļ����ļ��У�����˵/mnt/disk4/haitao/bysj_seu/geo_data/hic/hicpro_output/

echo 'bash' $0 $1 $2 >> cmdRun.txt   ���ı� 'sh' $0 $1 $2 ׷�ӵ��ļ���$0��$1 �� $2 ������������ֱ��ʾ�ű����ƺ͵�һ���͵ڶ��������в����������Ҿ��ÿ����������ģ���sh ���ű� �ļ��� �����������������������һ��ͳһ�Ľű�ִ���ļ�������д�������ע�����cmdRun.TXT��������������������������������������������������������������������ʵ����һֱ��ֻ�õ���$2������ֻ�������������������$1��Ӧ�����ļ��ı������Ȼ�������shҲҪ�޸ĳ�bash
        ��������������������������������������������������δ��������������
OUTmapstat=${ZHTtype}-mapstat.txt      ����һ����Ϊ OUTmapstat �ı�������ֵ�� ZHTtype ������ֵ���ַ��� -mapstat.txt ������
OUTpairstat=${ZHTtype}-pairstat.txt     ����һ����Ϊ OUTpairstat �ı�������ֵ�� ZHTtype ������ֵ���ַ��� -pairstat.txt ������
OUTmergestat=${ZHTtype}-mergestat.txt      ����һ����Ϊ OUTmergestat �ı�������ֵ�� ZHTtype ������ֵ���ַ��� -mergestat.txt ������
OUTRSstat=${ZHTtype}-RSstat.txt        ����һ����Ϊ OUTRSstat �ı�������ֵ�� ZHTtype ������ֵ���ַ��� -RSstat.txt ������

#----------------------------------------------------  Ӧ�þ��Ǹ���hic-pro�����е�ͳ���ļ�stat

mapstatSuffix="*_R1_hg19.mapstat"    ����һ����Ϊ mapstatSuffix �ı�������ֵ���ַ��� *_R1_hg38.mapstat�����õ���hg19������Ӧ����hic���bowtie����е�bwt2�е�rep�е�ͳ���ļ�!!!!!
pairstatSuffix="*_hg19.bwt2pairs.pairstat"    ����һ����Ϊ pairstatSuffix �ı�������ֵ���ַ��� *.bwt2pairs.pairstat��ͬ��ͬ�ϣ����������Ҿ���Ӧ���޸�Ϊ_hg19.bwt2pairs.pairstat����ΪΨһû�б仯��Ӧ�þ���ǰ���rep�ļ���!!!!!!
mergestatSuffix="_allValidPairs.mergestat"      ����һ����Ϊ mergestatSuffix �ı�������ֵ���ַ��� _allValidPairs.mergestat�����Ŀ¼����stat����
RSstatSuffix="*_hg19.bwt2pairs.RSstat"    ����һ����Ϊ RSstatSuffix �ı�������ֵ���ַ��� *_hg38.bwt2pairs.RSstat�����õ���hg19������ο�ʵ�ʲ������е�181��ʱ��ע��Ŀ¼�޸�Ϊ��data��������stat����Ϊstat�еĺ�׺��һ�������ǲ鿴֮����Է���data�е�Rstat��stat�е�mRstat������һ����!!!!!!!!
 

qc_metrics_temp=temp.txt    ����һ����Ϊ qc_metrics_temp �ı�������ֵ���ַ��� temp.txt

#----------------------------------------------------

for folder in $FOLDER/logs/*/; do        ��ϵ��6�У�������/mnt/disk4/haitao/bysj_seu/geo_data/hic/hicpro_output/������ $FOLDER/logs/*/ �µ������ļ���

	foldername=$(basename $folder)           �� $folder �Ļ����ļ�������������·�����ļ�������ֵ������ foldername����Ӧ�þ���HMEC_rep1�ȵ�����

	qc_metrics=$foldername"_mapping_statistics.txt"    �� foldername �� _mapping_statistics.txt �������������������ֵ������ qc_metrics������������������������ڴ洢ĳ���ʿ�ͳ�����ݵ��ļ�����������HMEC_rep1_mapping_statistics.txt

	echo -e "Sample\nTotal\nMapped\nGlobal\nLocal" > $qc_metrics    �� "Sample\nTotal\nMapped\nGlobal\nLocal" ����ַ���д�뵽�ļ� $qc_metrics �С����� \n �ǻ��з���-e������ת���ַ�

	tempCol=$foldername"_tempCol.txt"                �� foldername �� _tempCol.txt �������������������ֵ������ tempCol������������������������ڴ洢ĳ����ʱ�е��ļ�����������HMEC_rep1_tempCol.txt

	#************
	# Collect stats from the first alignment round         �ռ���һ�ֱȶԣ�alignment����ͳ����Ϣ���Ӵ˴���ʼ������stat�ļ�ǰ׺�е�SRR�޸�Ϊ��Ӧ������rep����
	#************

	file1=$FOLDER/bowtie_results/bwt2/${foldername}/${foldername}${mapstatSuffix}       ���ݵ�6��ע�⣬��/mnt/disk4/haitao/bysj_seu/geo_data/hic/hicpro_output/������bwt2֮�����HMEC_rep1�����ݵ�17�о���HMEC_rep1_R1_hg19.mapstat��ע�⵽ʵ���ļ���SRR13755462_R1_hg19.mapstat�����ǵ�������hicpro�����ļ��е�ʱ��SRR�ĳ��˺������ļ�rep���֣�������ǰ���6�еĵط��޸��ļ���HMEC_rep1�޸ĳɶ�Ӧ��SRR�֣�������ֱ�ӽ�bwt2/rep��Ӧ���ļ����н����е�stat�ļ�������ǰ׺SRR�޸ĳɶ�Ӧ��rep���֣�����������������������������������
	file2=$FOLDER/bowtie_results/bwt2/${foldername}/${foldername}${mapstatSuffix/R1/R2}	     �� file2 ��Ϊ ${FOLDER}/bowtie_results/bwt2/${foldername}/${foldername}${mapstatSuffix/R1/R2}������ ${mapstatSuffix/R1/R2} �ǽ� mapstatSuffix �е� R1 �滻Ϊ R2������bwt2�е�����statͳ���ļ�����ȫ�ˣ����ǻ��и�pairstat�ļ�û�д���

	total=($(grep "total" $file1))  �� total ��Ϊ $file1 �а��� total ���е����ݣ�ͳ�Ƶ���HMEC_rep1_R1_hg19.mapstat��Ϊʲô���ﲻͳ��R2���������Ƕ�һ�����ǲ���������𣬣�������������һ�£����ڸò��ֵ����ݣ�������ȫ�ֵĽű�֮����total�Ǳ�mapped����С�ģ����˾��û��ǽ�total�ϲ������������ǲ��������⣬��������fqһ�£��޸ĵĻ��ͻ��ǰ�������ģ��޸�Ϊtotal1һ��2��Ȼ����������ӡ��� total1=($(grep "total" $file1))��total2=($(grep "total" $file2))��������57��ǰ����totalSUM=`echo "${total1[1]}+${total2[1]}" | bc`��Ȼ�����61���޸ĳ�totalSUM������������������������������������������

	mapped1=($(grep "mapped" $file1))   ͬ�Ͻ� mapped1 ��Ϊ $file1 �а��� mapped ���е�����
	mapped2=($(grep "mapped" $file2))   ͬ�Ͻ� mapped2 ��Ϊ $file2 �а��� mapped ���е�����

	global1=($(grep "global" $file1))      ͬ�Ͻ� global1 ��Ϊ $file1 �а��� global ���е�����
	global2=($(grep "global" $file2))      ͬ�Ͻ� global2 ��Ϊ $file2 �а��� global ���е�����

	local1=($(grep "local" $file1))   ͬ�Ͻ� local1 ��Ϊ $file1 �а��� local ���е�����
        local2=($(grep "local" $file2))     ͬ�Ͻ� local2 ��Ϊ $file2 �а��� local ���е�����

	#************

	mappedSUM=`echo "${mapped1[1]}+${mapped2[1]}" | bc`   ���� mapped1 �� mapped2 �ĵڶ���Ԫ�صĺͣ������������ mappedSUM��Ӧ���Ǽ���R1/R2������һ��rep��˫�˲���
	globalSUM=`echo "${global1[1]}+${global2[1]}" | bc`     ������� global1 �� global2 �ĵڶ���Ԫ�صĺͣ������������ globalSUM
	localSUM=`echo "${local1[1]}+${local2[1]}" | bc`    ���� local1 �� local2 �ĵڶ���Ԫ�صĺͣ������������ localSUM

	echo -e "$foldername\n${total[1]}\n${mappedSUM}\n${globalSUM}\n${localSUM}" >> $tempCol     �� $foldername��${total[1]}��${mappedSUM}��${globalSUM}��${localSUM} д���35�е�����$tempCol�����ǽ�����һ�����Ȼ���һ�о���ͳ������������

        paste $qc_metrics $tempCol > $qc_metrics_temp    �ο���31�У�35�У��Լ�61�У��� $qc_metrics �� $tempCol �ϲ���һ���ļ����������д�� $qc_metrics_temp��Ӧ���ǽ��ļ����кϲ�
        mv $qc_metrics_temp $qc_metrics   �� $qc_metrics_temp ������Ϊ $qc_metrics

done

paste *"_mapping_statistics.txt" | cut -f1,2,4,6,8,10,12 > $OUTmapstat   �������� _mapping_statistics.txt ��β���ļ��ϲ���һ���ļ����������д�� $OUTmapstat��Ȼ����ʹ�� cut ������ȡ�ļ��ĵ�1��2��4��6��8��10 �� 12 �У��������д�� $OUTmapsta���ο���31+63�У��ļ�qc_metricsӦ�þ���_mapping_statistics.txt�ļ�

rm *"_mapping_statistics.txt"    ɾ�������� _mapping_statistics.txt ��β���ļ�


#----------------------------------------------------
# Second set of stats       ��2��ͳ��Ӧ���ǲο���һ�֣���һ�ֽ������ļ���Ҫ���

qc_metrics_temp=temp.txt     �� qc_metrics_temp ��Ϊ temp.txt

#----------------------------------------------------

for folder in $FOLDER/logs/*/; do

	foldername=$(basename $folder)

	qc_metrics=$foldername"_pairstat.txt"   �ο���42�У�����ʣ���stat�ļ���Ҫͳ�ƣ�bwt2������HMEC_rep1_pairstat.txt�����洦��ͬ�ϵ�һ��

	echo -e "Sample\nTotal_pairs_processed\nUnmapped_pairs\nUnique_paired_alignments\nMultiple_pairs_alignments\nPairs_with_singleton\nReported_pairs" > $qc_metrics  �� "Sample\nTotal_pairs_processed\nUnmapped_pairs\nUnique_paired_alignments\nMultiple_pairs_alignments\nPairs_with_singleton\nReported_pairs" ����ַ���д�뵽�ļ� $qc_metrics �С����� \n �ǻ��з���ͬ����ǽ���һ����񣬵�һ����������     

	tempCol=$foldername"_tempCol.txt"   �� foldername �� _tempCol.txt �������������������ֵ������ tempCol������������������������ڴ洢ĳ����ʱ�е��ļ���������HMEC_rep1_tempCol.txt

	#************
	# Collect stats
	#************

	pairstatFile=$FOLDER/bowtie_results/bwt2/$foldername/${foldername}${pairstatSuffix}   �ο���18��41�У����ǽ� pairstatFile ��Ϊ ${FOLDER}/bowtie_results/bwt2/${foldername}/${foldername}${pairstatSuffix}������ ${FOLDER} ��֮ǰ����ı�������ʾ�������ڵ��ļ��У�${foldername} ��֮ǰ����ı�������ʾ��ǰ�ļ��е����ƣ�${pairstatSuffix} ��֮ǰ����ı�������ʾ�ļ����ĺ�׺�����ǵ�18�е�ͳ���ļ�������HMEC_rep1.bwt2pairs.pairstat,����ԭ�ļ�����û������ļ�������Ӧ���޸ĵ�18�У��޸ĺ�׺֮�����HMEC_rep1_hg19.bwt2pairs.pairstat������������������������������������

	pairsProcessed=($(grep "Total_pairs_processed" $pairstatFile))	
	unmapped=($(grep "Unmapped_pairs" $pairstatFile))
	uniqPairedAlign=($(grep "Unique_paired_alignments" $pairstatFile))
	mltplPairsAlign=($(grep "Multiple_pairs_alignments" $pairstatFile))
	pairsWithSingl=($(grep "Pairs_with_singleton" $pairstatFile))
	reportedPairs=($(grep "Reported_pairs" $pairstatFile))   �� reportedPairs ��Ϊ $pairstatFile �а��� Reported_pairs ���е����ݣ�����ͬ�������ռ�ץȡ�������������

	echo -e "$foldername\n${pairsProcessed[1]}\n${unmapped[1]}\n${uniqPairedAlign[1]}\n${mltplPairsAlign[1]}\n${pairsWithSingl[1]}\n${reportedPairs[1]}" >> $tempCol   �� $foldername��${pairsProcessed[1]}��${unmapped[1]}��${uniqPairedAlign[1]}��${mltplPairsAlign[1]}��${pairsWithSingl[1]} �� ${reportedPairs[1]} д�� $tempCol���ο���88��

        paste $qc_metrics $tempCol > $qc_metrics_temp
        mv $qc_metrics_temp $qc_metrics     �ο������63/64��

        rm -r $tempCol

done

paste *"_pairstat.txt" | cut -f1,2,4,6,8,10,12 > $OUTpairstat       �������� _pairstat.txt ��β���ļ��ϲ���һ���ļ����������д�� $OUTpairstat��Ȼ����ʹ�� cut ������ȡ�ļ��ĵ�1��2��4��6��8��10 �� 12 �У��������д�� $OUTpairstat

rm *"_pairstat.txt"           ɾ�������� _pairstat.txt ��β���ļ�


#----------------------------------------------------
# Third set of stats

qc_metrics_temp=temp.txt    ͬ�����������

#----------------------------------------------------

for folder in $FOLDER/logs/*/; do

	foldername=$(basename $folder)

	qc_metrics=$foldername"_mergestat.txt"   �� foldername �� _mergestat.txt �������������������ֵ������ qc_metrics������������������������ڴ洢ĳ���ʿ�ͳ�����ݵ��ļ���������HMEC_rep1_mergestat.txt

	echo -e "Sample\nvalid_interaction\nvalid_interaction_rmdup\ntrans_interaction\ncis_interaction\ncis_shortRange\ncis_longRange" > $qc_metrics    �� "Sample\nvalid_interaction\nvalid_interaction_rmdup\ntrans_interaction\ncis_interaction\ncis_shortRange\ncis_longRange" ����ַ���д�뵽�ļ� $qc_metrics �С����� \n �ǻ��з�,ͬ�Ͼ���д���

	tempCol=$foldername"_tempCol.txt"   �� foldername �� _tempCol.txt �������������������ֵ������ tempCol������������������������ڴ洢ĳ����ʱ�е��ļ���������HMEC_rep1_tempCol.txt

	#************
	# Collect stats from the first alignment round
	#************

	file=$FOLDER/hic_results/stats/${foldername}/${foldername}${mergestatSuffix}	  �� file ��Ϊ ${FOLDER}/hic_results/data/${foldername}/${foldername}${mergestatSuffix}������ ${FOLDER} ��֮ǰ����ı�������ʾ�������ڵ��ļ��У�${foldername} ��֮ǰ����ı�������ʾ��ǰ�ļ��е����ƣ�${mergestatSuffix} ��֮ǰ����ı�������ʾ�ļ����ĺ�׺���ο���19�У�������HMEC_rep1_allValidPairs.mergestat,������ʵ�ʿ�һ�£�����ļ�Ӧ�ò�����dataĿ¼�£�Ӧ������stats�ļ����£����Դ�$FOLDER/hic_results/data/${foldername}/${foldername}${mergestatSuffix}�޸�Ϊ$FOLDER/hic_results/stats/${foldername}/${foldername}${mergestatSuffix}����������������������������������
 
	valid=($(grep "valid_interaction" $file))
	validrmdup=($(grep "valid_interaction_rmdup" $file))
	trans=($(grep "trans_interaction" $file))
	cis=($(grep "cis_interaction" $file))
	short=($(grep "cis_shortRange" $file))
	long=($(grep "cis_longRange" $file))     �� long ��Ϊ $file �а��� cis_longRange ���е����ݣ�֮ͬǰץȡ�ļ�����

	echo -e "$foldername\n${valid[1]}\n${validrmdup[1]}\n${trans[1]}\n${cis[1]}\n${short[1]}\n${long[1]}" >> $tempCol   �� $foldername��${valid[1]}��${validrmdup[1]}��${trans[1]}��${cis[1]}��${short[1]} �� ${long[1]} д�� $tempCol��ͬ��

        paste $qc_metrics $tempCol > $qc_metrics_temp      
        mv $qc_metrics_temp $qc_metrics      ����ͬ��

        rm -r $tempCol

done

paste *"_mergestat.txt" | cut -f1,2,4,6,8,10,12 > $OUTmergestat      �������� _mergestat.txt ��β���ļ��ϲ���һ���ļ����������д�� $OUTmergestat��Ȼ����ʹ�� cut ������ȡ�ļ��ĵ�1��2��4��6��8��10 �� 12 �У��������д�� $OUTmergestat��ͬ��

rm *"_mergestat.txt" 

#----------------------------------------------------
# Fourth set of stats

qc_metrics_temp=temp.txt

#----------------------------------------------------

for folder in $FOLDER/logs/*/; do

	foldername=$(basename $folder)

	qc_metrics=$foldername"_RSstat.txt"      ͬ�ϣ�����HMEC_rep1_RSstat.txt

	echo -e "Sample\nValid_interaction_pairs\nValid_interaction_pairs_FF\nValid_interaction_pairs_RR\nValid_interaction_pairs_RF\nValid_interaction_pairs_FR\nDangling_end_pairs\nReligation_pairs\nSelf_Cycle_pairs\nSingle-end_pairs\nDumped_pairs" > $qc_metrics   �� "Sample\nValid_interaction_pairs\nValid_interaction_pairs_FF\nValid_interaction_pairs_RR\nValid_interaction_pairs_RF\nValid_interaction_pairs_FR\nDangling_end_pairs\nReligation_pairs\nSelf_Cycle_pairs\nSingle-end_pairs\nDumped_pairs" ����ַ���д�뵽�ļ� $qc_metrics �С����� \n �ǻ��з�

	tempCol=$foldername"_tempCol.txt"

	#************
	# Collect stats from the first alignment round
	#************

	file=$FOLDER/hic_results/data/${foldername}/${foldername}${RSstatSuffix}     �ο���20�У�����HMEC_rep1_hg19.bwt2pairs.RSstat��ȷʵ����data���棬����Ҫע���Ӧ�ĺ�׺��Ȼ��SRR�޸ĳ�rep���֣�������������������

	valid=($(grep "Valid_interaction_pairs" $file))
	validFF=($(grep "Valid_interaction_pairs_FF" $file))
	validRR=($(grep "Valid_interaction_pairs_RR" $file))
	validRF=($(grep "Valid_interaction_pairs_RF" $file))
	validFR=($(grep "Valid_interaction_pairs_FR" $file))
	dangling=($(grep "Dangling_end_pairs" $file))
	religation=($(grep "Religation_pairs" $file))
	self=($(grep "Self_Cycle_pairs" $file))
	send=($(grep "Single-end_pairs" $file))
	dumped=($(grep "Dumped_pairs" $file))   ͬ��ץȡ����

	#************

	echo -e "$foldername\n${valid[1]}\n${validFF[1]}\n${validRR[1]}\n${validRF[1]}\n${validFR[1]}\n${dangling[1]}\n${religation[1]}\n${self[1]}\n${send[1]}\n${dumped[1]}" >> $tempCol   �� $foldername��${valid[1]}��${validFF[1]}��${validRR[1]}��${validRF[1]}��${validFR[1]}��${dangling[1]}��${religation[1]}��${self[1]}��${send[1]} �� ${dumped[1]} д�� $tempCol��ͬ��

        paste $qc_metrics $tempCol > $qc_metrics_temp    
        mv $qc_metrics_temp $qc_metrics

        rm -r $tempCol

done

paste *"_RSstat.txt" | cut -f1,2,4,6,8,10,12 > $OUTRSstat      

rm *"_RSstat.txt"     ȫ��ͬ��







