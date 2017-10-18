#!/bin/sh


################################################################################
# The purpose of this script is to calculate mean images for the entire FOV.   #
################################################################################


#-------------------------------------------------------------------------------
# Define session IDs & paths:

# Functional runs (input):
aryRunIDs=(func_01 \
           func_02 \
           func_03 \
           func_04 \
           func_05 \
           func_06 \
           func_07 \
           func_08 \
           func_09 \
           func_10)

# Parent path:
strPathParent="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/"

# Paths to input directories (corresponding to output directories):
aryIn=(${strPathParent}func_regAcrssRuns)

# Paths to output directories (corresponding to input directories):
aryOut=(${strPathParent}func_regAcrssRuns_tsnr)
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Preparations:

# How many runs to include:
varNumRuns=${#aryRunIDs[@]}

# Subtract one (because indexing starts from zero):
varNumRuns=`bc <<< ${varNumRuns}-1`

# Sequence to access input array:
lstRuns=$(seq 0 ${varNumRuns})

# How many conditions to include:
varNumCons=${#aryIn[@]}

# Subtract one (because indexing starts from zero):
varNumCons=`bc <<< ${varNumCons}-1`

# Sequence to access input array:
lstCons=$(seq 0 ${varNumCons})
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Main for loop through conditions:

for index_0 in ${lstCons[@]}
do
	#-----------------------------------------------------------------------
	# Set temporary strings for condition:
	str_tmp_in="${aryIn[${index_0}]}/"
	str_tmp_out="${aryOut[${index_0}]}/"
	#-----------------------------------------------------------------------


	#-----------------------------------------------------------------------
	# Create 3D tSNR images for all functional time series:

	echo "-----------------------------------------------------------------"
	echo "----- Create 3D tSNR images for all functional time series: -----"
	for index_1 in ${lstRuns[@]}
	do
		str_temp_1="${str_tmp_in}${aryRunIDs[${index_1}]}.nii"
		str_temp_2="${str_tmp_out}${aryRunIDs[${index_1}]}_mean.nii"
		str_temp_3="${str_tmp_out}${aryRunIDs[${index_1}]}_sd.nii"
		str_temp_4="${str_tmp_out}${aryRunIDs[${index_1}]}_tSNR.nii"

		echo "fslmaths ${str_temp_1} -Tmean ${str_temp_2}"
		fslmaths ${str_temp_1} -Tmean ${str_temp_2}

		echo "fslmaths ${str_temp_1} -Tstd ${str_temp_3}"
		fslmaths ${str_temp_1} -Tstd ${str_temp_3}

		echo "fslmaths ${str_temp_2} -div ${str_temp_3} ${str_temp_4}"
		fslmaths ${str_temp_2} -div ${str_temp_3} ${str_temp_4}

		echo "done"
	done
	echo "-----------------------------------------------------------------"
	#-----------------------------------------------------------------------


	#-----------------------------------------------------------------------
	# Create mean 3D tSNR image:

	echo "----- Create mean 3D tSNR image: -----"

	# The name of the final combined mean tSNR image (i.e. the average of
	# the individual tSNR images):
	str_temp_5="${str_tmp_out}combined_mean_tSNR.nii.gz"

	# Counter that is used to divide the sum of all individual tSNR images
	# by N at the end:
	var_count=$((0))

	for index_1 in ${lstRuns[@]}
	do
		str_temp_4="${str_tmp_out}${aryRunIDs[${index_1}]}_tSNR.nii.gz"

		if [[ ${index_1} = 0 ]]
		then
			# The starting point for the combined tSNR image is the
			# first individual tSNR image. The other individual tSNR
			# images are subsequently added.
			echo "cp ${str_temp_4} ${str_temp_5}"
			cp ${str_temp_4} ${str_temp_5}
		else
			echo "fslmaths ${str_temp_5} -add ${str_temp_4} ${str_temp_5}"
			fslmaths ${str_temp_5} -add ${str_temp_4} ${str_temp_5}
		fi
		var_count=$((var_count+1))
		echo "count: ${var_count}"
	done

	# Divide sum of all individual tSNR images by N:
	echo "fslmaths ${str_temp_5} -div ${var_count} ${str_temp_5}"
	fslmaths ${str_temp_5} -div ${var_count} ${str_temp_5}
	echo "-----------------------------------------------------------------"
	#-----------------------------------------------------------------------


	#-----------------------------------------------------------------------
	# Create combined mean image of all time series:

	echo "----- Create combined mean image of all time series: -----"

	# The name of the final combined mean image (i.e. the average mean image
	# of all functional time series):
	str_temp_6="${str_tmp_out}combined_mean.nii.gz"

	# Counter that is used to divide the sum of all individual mean images
	# at the end:
	var_count=$((0))

	for index_1 in ${lstRuns[@]}
	do
		str_temp_2="${str_tmp_out}${aryRunIDs[${index_1}]}_mean.nii.gz"

		if  [[ ${index_1} = 0 ]]
		then
			# The combined mean image is initially set to the first
			# individual mean image.  The other individual mean
			# images are subsequently added.
			echo "cp ${str_temp_2} ${str_temp_6}"
			cp ${str_temp_2} ${str_temp_6}
		else
			echo "fslmaths ${str_temp_6} -add ${str_temp_2} ${str_temp_6}"
			fslmaths ${str_temp_6} -add ${str_temp_2} ${str_temp_6}
		fi

		var_count=$((var_count+1))
		echo "count: ${var_count}"
	done

	# Divide sum of all images by N:
	echo "fslmaths ${str_temp_6} -div ${var_count} ${str_temp_6}"
	fslmaths ${str_temp_6} -div ${var_count} ${str_temp_6}
	echo "--------------------------------------------------------------"
	#-----------------------------------------------------------------------
done

