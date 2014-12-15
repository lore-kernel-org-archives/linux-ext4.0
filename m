From: Dave Chinner <david@fromorbit.com>
Subject: Re: max_dir_size_kb option list
Date: Tue, 16 Dec 2014 08:51:47 +1100
Message-ID: <20141215215147.GV24183@dastard>
References: <548988D2.3030100@oracle.com>
 <20141212005517.GK24183@dastard>
 <548F070F.2050808@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <548F070F.2050808@oracle.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Dec 15, 2014 at 07:06:39PM +0300, Alexander Tsvetkov wrote:
> Hello Dave,
> 
> Thank you for the review, I've updated test according to your comments
....

> From e30cd49f5ab84c029c0b376e702caeac42f59f49 Mon Sep 17 00:00:00 2001
> From: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
> Date: Mon, 15 Dec 2014 18:49:42 +0300
> Subject: [PATCH] added test for max_dir_size_kb mount option
> 
> ---
>  tests/ext4/309     | 178 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/ext4/309.out |   2 +
>  tests/ext4/group   |   1 +
>  3 files changed, 181 insertions(+)
>  create mode 100755 tests/ext4/309
>  create mode 100755 tests/ext4/309.out

This is missing a commit message describing the change, as well as a
change log telling me what changed from v1 to v2. Hence I don't know
exactly what you changed and what you ignored.

> diff --git a/tests/ext4/309 b/tests/ext4/309

Just use the next unused number in the ext4 directory.

> +remove_files() 
> +{
> +   dirs="$testdir $*"
> +   for i in $dirs; do
> +      rm -fr $i/*
> +   done

Still whitespace damaged. Please use 8 space tabs.

> +}
> +
> +# $1 - expected limit after items creation
> +# $2 - command to create item
> +# $3 - where to create (testdir by default)
> +_create_items() 

Still got a "_ prefix"

> +{
> +    limit=$1
> +    dir=${2:-$testdir}
> +    MKTEMP_OPT=""
> +    [ "$3" = "mkdir" ] && MKTEMP_OPT="-d"
> +    sync
> +    echo 3 > /proc/sys/vm/drop_caches
> +    MAX_INUM=$((limit * 1024 * 2 / 24))
> +    for i in $(seq 0 $MAX_INUM); do
> +       error=$(mktemp $MKTEMP_OPT --tmpdir=$dir 2>&1 >/dev/null)

Still using mktemp, only now in a much more convoluted manner.
If you just want to create a file, "touch $dir/$i" is all you need
to do.

> +       res=$?
> +       if [ $res -ne 0 ]; then
> +          echo $error >> $seqres.full  
> +          [[ ! $error =~ ^.*'No space left on device'$ ]] && echo "FAIL! expected ENOSPC" | tee -a $seqres.full
> +          break
> +      fi

You didn't answer any of the questions I asked about this, nor
address the comments I made. Just filter the error to sanitse it down to "No space left on
device" and break. The golden output match will fail the test if
there's any other type of error. i.e:

	for i in $(seq 0 $MAX_INUM); do
		touch $dir/$i 2>&1 | _filter_scratch
		if [ $? -ne 0 ]; then
			break;
		fi
	done

will test everything the above loop do (except the obvious touch vs
mkdir difference).

> +   done
> +   size=$(stat -c %s $dir)
> +   size=$((size / 1024))
> +   if [ $size -gt $limit ]; then
> +      echo "FAIL! expected dir size: $limit, actually: $size" | tee -a $seqres.full
> +   fi
> +}
> +
> +run_test()
> +{
> +   LIMIT1=$1
> +   LIMIT2=$2
> +   MKFS_OPT=$3
> +
> +   _scratch_unmount >/dev/null 2>&1
> +   _scratch_mkfs $MKFS_OPT >>$seqres.full 2>&1

_scratch_mkfs unmounts the SCRATCH_DEV.

> +   _scratch_mount -o max_dir_size_kb=$LIMIT1
> +   mkdir $testdir
> +
> +   echo -e "\nExceed $LIMIT1 Kb limit with new files in testdir/: " >> $seqres.full
> +   _create_items $LIMIT1

I don't see much point in all these echos to $seqres.full.

> +
> +   echo -e "\nRemount with $LIMIT1 Kb limit,\nnew item in testdir/ should result to ENOSPC: " >>$seqres.full
> +   _scratch_mount "-o remount,max_dir_size_kb=$LIMIT1"
> +   _create_items $LIMIT1
> +
> +   echo -e "\nExceed $LIMIT2 Kb limit with new files in testdir/: " >> $seqres.full
> +   _scratch_mount "-o remount,max_dir_size_kb=$LIMIT2"
> +   _create_items $LIMIT2
> +
> +   echo -e "\nExceed $LIMIT2 Kb limit with new files in testdir2/: " >> $seqres.full
> +   mkdir $SCRATCH_MNT/testdir2 2>/dev/null
> +   _create_items $LIMIT2 "$SCRATCH_MNT/testdir2"
> +
> +   echo -e "\nRemount with $LIMIT1 Kb limit,\nnew item in testdir/ should result to ENOSPC: " >> $seqres.full
> +   _scratch_mount "-o remount,max_dir_size_kb=$LIMIT1"
> +   _create_items $LIMIT2
> +   echo -e "\nnew item in testdir2/ should result to ENOSPC: " >> $seqres.full
> +   _create_items $LIMIT2 "$SCRATCH_MNT/testdir2"
> +   remove_files "$SCRATCH_MNT/testdir2"
> +   rmdir $testdir
> +   mkdir $testdir
> +   dd if=/dev/urandom of=$testfile bs=1 seek=4096 count=4096 > /dev/null 2>&1

Use xfs_io to write data to files, not dd.

> +
> +   echo -e "\nExceed $LIMIT1 Kb directory limit with new subdirectories: " >> $seqres.full
> +   _create_items $LIMIT1 $testdir "mkdir"
> +   remove_files
> +
> +   echo -e "\nCreate ext4 fs on testdir/subdir with $LIMIT2 Kb limit," >> $seqres.full
> +   mkdir $testdir/subdir 2>/dev/null
> +   umount $TEST_DEV 1>/dev/null 2>&1
> +   _mkfs_dev $TEST_DEV $MKFS_OPT >>$seqres.full 2>&1

You are not allowed to mkfs the test device during any test. You
should not even be unmounting it. You need to use loop devices
if you want to do this, though I don't see why you need to use a
second nested filesystem mount just to test a different limit,
especially as:

> +   $MKFS_EXT4_PROG -F $MKFS_OPT $testfile 2m >> $seqres.full 2>&1
> +   _mount -o loop,max_dir_size_kb=$LIMIT1 $testfile $testdir/subdir
> +
> +   echo "exceed $LIMIT1 Kb limit of testdir/subdir with a set of files:" >> $seqres.full
> +   _create_items $LIMIT1 "$testdir/subdir"
> +
> +   echo -e "\nexceed $LIMIT2 Kb limit of testdir/ with a set of files:" >> $seqres.full
> +   _create_items $LIMIT2
> +
> +   umount -d $testdir/subdir

You test loop devices here....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
