From: Dave Chinner <david@fromorbit.com>
Subject: Re: [XFS Tests Punch Hole 2/3 v3] XFS TESTS: Add Fallocate Punch
 Hole Test Routines
Date: Thu, 19 May 2011 11:31:44 +1000
Message-ID: <20110519013144.GF32466@dastard>
References: <4DD43300.6010908@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs-oss <xfs@oss.sgi.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:5975 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753101Ab1ESBbs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 May 2011 21:31:48 -0400
Content-Disposition: inline
In-Reply-To: <4DD43300.6010908@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 18, 2011 at 01:58:40PM -0700, Allison Henderson wrote:
> This patch adds low level routines to common.punch
> for populating test files and punching holes in them using
> fallocate.  When a hole is punched, file is then analyzed to
> verify that the hole was punched correctly.  These routines will
> be used to test various corner cases in the new fallocate
> punch hole tests.

So what condition does this test cover that test 252 doesn't? 

> 
> Signed-off-by: Allison Henderson <achender@us.ibm.com>
> ---
> :100644 100644 e2da5d8... 778389a... M	common.punch
>  common.punch |  393 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 393 insertions(+), 0 deletions(-)
> 
> diff --git a/common.punch b/common.punch
> index e2da5d8..778389a 100644
> --- a/common.punch
> +++ b/common.punch
> @@ -377,3 +377,396 @@ _test_generic_punch()
>  		-c "$map_cmd -v" $testfile | $filter_cmd
>  	[ $? -ne 0 ] && die_now
>  }
> +
> +
> +#_fill_file()
> +#
> +#Fills a file with the given byte value up to the
> +#given number of bytes.
> +#
> +# $1: The name of the file to fill
> +# $2: The byte value to fill the file with
> +# $3: The number of bytes to put in the file
> +# $4: The block size used when copying in 
> +#     "block" sized chunks of data
> +_fill_file() {
> +	local file_to_fill=$1
> +	local byte_value=$2
> +	local number_of_bytes=$3
> +	local blk_size=$4
> +	
> +	remaining_bytes=$number_of_bytes
> +	blk=""
> +
> +	for (( i=0; i<blk_size; i++ ))
> +	do
> +		blk=$blk$byte_value
> +	done
> +
> +	while [ $remaining_bytes -ge $blk_size ]
> +	do
> +		printf "$blk" >> $file_to_fill
> +		remaining_bytes=$(($remaining_bytes - $blk_size))
> +	done
> +
> +	for (( i=0; i<$remaining_bytes; i++ ))
> +	do
> +		printf "$byte_value" >> $file_to_fill
> +	done
> +	
> +
> +}

Ummm, do you really need to reinvent the wheel?

$XFS_IO_PROG -F -f -c "pwrite -S $byte_value -b $blk_size 0 $number_of_bytes" $file_to_fill

> +
> +# _hole_test()
> +#
> +# Punches a hole in the test file.
> +# The hole is the checked to make sure the correct number
> +# of blocks are released and the associated extents are 
> +# removed
> +#
> +# Usage: _hole_test [options] file_name hole_offset hole_length
> +# Options:
> +#    -c <length> Create a file of the given length full of data to punch a hole in

rm -f $file_name
$XFS_IO_PROG -F -f -c "t $length" $file_name

> +#    -p <length> Preallocate a file to the given length to punch a hole in

$XFS_IO_PROG -F -f -c "falloc 0 $length" $file_name

> +#    -s          Sync the file before punching the hole

$XFS_IO_PROG -F -f -c "fsync" $file_name

> +#    -m          Remount the device before punching the hole
....
> +		umount $TEST_DEV
> +		mount $TEST_DEV $TEST_DIR

If you need remounts during the test, it should be using the scratch
device, I think.

> +#
> +# This test is successful when the following conditions are met:
> +#  - ls shows that the number of blocks occupied by the file
> +#    has decreased by the number of blocks punched out.

There's no guarantee that a filesystem will punch the number of
blocks you expect.

> +#  - df shows number of available blocks has increased by the number
> +#    of blocks punched out

Ditto - indeed, punching blocks can lead to allocation for things
like extent tree splits because the number of extent records
increases.

> +#  - File frag shows that the blocks punched out are absent from
> +#    the extents

Probably the best method, though we tend to use the xfs_io output
because we already have a lot of parsing functions for it.

> +#  - The test file contains zeros where the hole should be
> +# 
> +_hole_test() {
> +
> +	err=0
> +	sflag=
> +	mflag=
> +	pflag=
> +	cflag=
> +	lflag=
> +	oflag=
> +	OPTIND=1
> +	while getopts 'smc:p:' OPTION
> +	do
> +		case $OPTION in
> +		s)	sflag=1
> +		;;
> +		m)	mflag=1
> +		;;
> +		p)	pflag="$OPTARG"
> +		;;
> +		c)	cflag="$OPTARG"
> +		;;
> +		?)	echo Invalid flag
> +		echo "Usage: $(basename $0): [options]  file_name hole_offset hole_length" >&2
> +		echo "Options:" >&2
> +		echo "-c <length> Create a file of the given length full of data to punch a hole in" >&2
> +		echo "-p <length> Preallocate a file to the given length to punch a hole in" >&2
> +		echo "-s          Sync the file before punching the hole" >&2
> +		echo "-m          Remount the device before punching the hole"
> +		exit 1
> +		;;
> +		esac
> +	done
> +	shift $(($OPTIND - 1))
> +
> +	local file_name=$1
> +	local hole_offset=$2
> +	local hole_length=$3
> +	local hole_offset_orig=$hole_offset
> +	local hole_length_orig=$hole_length
> +
> +	if [ "$cflag" ]; then
> +		local file_length=$cflag
> +	elif [ "$pflag" ]; then
> +		local file_length=$pflag
> +	else
> +		local file_length=`ls -ls $file_name | cut -d ' ' -f6`
> +	fi
> +
> +	# If the hole to punch out extends off the edge of the file, 
> +	# then we need to expect a smaller hole to be punched
> +	if [ $hole_offset -ge $file_length ]; then
> +		local hole_length=0
> +		local hole_offset=$file_length
> +	elif [ $(($hole_offset + $hole_length)) -gt $file_length ]; then
> +		local hole_length=$(($file_length - $hole_offset))
> +	fi
> +
> +	# locations to store hexdumps must not be in the filesystem
> +	# or it will skew the results.  When we measure used
> +	# available blocks. Also, there may not be enough
> +	# room to store them in the fs during ENOSPC tests
> +	# So store the dumps in the cwd by stripping the path
> +	expected=`echo $file_name.hexdump.expected | sed 's/.*\///'`
> +	result=`echo $file_name.hexdump.result | sed 's/.*\///'`

This is why you shoul dbe using the scratch device and using the
test device to store the results. No hoops to jump through, and the
result is s simpler test.

Oh, and all you do is run diff on the hexdump output of the files.
diff can check binary files just fine - why do you need the hexdump
output? i.e. create files with zeros where the holes will be on the
testdev, create new ones on the scratch dev, punch holes in them,
diff them. No need for hexdumps, and the diff output can be put
directly into the golden output. If we then dump the fiemap output
into the output file (appropriately filtered) no further validation
checks are needed to determine that the hole was punched in the
correct place....

Indeed, I've seen plenty of cases where same test case operating on
an existing file gives different results to operating on a newly
created file....

> +
> +	#calculate the end points of the hole in blocks
> +	local block_size=`stat -f $TEST_DEV | grep "Block size" | cut -d " " -f3`
> +	local hole_first_blk=$(( $hole_offset / $block_size ))
> +	if [ $(($hole_offset % $block_size)) != 0 ]
> +	then
> +		local hole_first_blk=$(( $hole_first_blk + 1 ))
> +	fi
> +
> +	local hole_last_blk=$(( ($hole_offset + $hole_length) / $block_size ))

That's making a big assumption about the granularity of hole
punching. It's invalid for certain XFS configurations - when using
per inode preferred allocation alignment or the real time device,
and hole punching follows those alignments.

....

I think maybe this test is trying to be too smart and do too much,
and the verbosity is hurting my eyes. I'm giving up here because I
think it overlaps greatly with test 252, and I can't see what
addition failures this test would actually detect that fsx and 252
wouldn't. If there are corner cases that 252 isn't covering that
this test does, then I think they should be added to 252....


-- 
Dave Chinner
david@fromorbit.com
