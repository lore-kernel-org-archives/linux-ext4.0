From: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
Subject: Re: max_dir_size_kb option list
Date: Tue, 16 Dec 2014 18:42:37 +0300
Message-ID: <549052ED.6070405@oracle.com>
References: <548988D2.3030100@oracle.com> <20141212005517.GK24183@dastard> <548F070F.2050808@oracle.com> <20141215215147.GV24183@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42647 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaLPPnG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Dec 2014 10:43:06 -0500
In-Reply-To: <20141215215147.GV24183@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On 12/16/2014 12:51 AM, Dave Chinner wrote:
> On Mon, Dec 15, 2014 at 07:06:39PM +0300, Alexander Tsvetkov wrote:
>> Hello Dave,
>>
>> Thank you for the review, I've updated test according to your comments
> ....
>
>>  From e30cd49f5ab84c029c0b376e702caeac42f59f49 Mon Sep 17 00:00:00 2001
>> From: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
>> Date: Mon, 15 Dec 2014 18:49:42 +0300
>> Subject: [PATCH] added test for max_dir_size_kb mount option
>>
>> ---
>>   tests/ext4/309     | 178 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   tests/ext4/309.out |   2 +
>>   tests/ext4/group   |   1 +
>>   3 files changed, 181 insertions(+)
>>   create mode 100755 tests/ext4/309
>>   create mode 100755 tests/ext4/309.out
> This is missing a commit message describing the change, as well as a
> change log telling me what changed from v1 to v2. Hence I don't know
> exactly what you changed and what you ignored.
ok, it seems patch was not correctly collected
>> diff --git a/tests/ext4/309 b/tests/ext4/309
> Just use the next unused number in the ext4 directory.
do you mean 004?
>
>> +remove_files()
>> +{
>> +   dirs="$testdir $*"
>> +   for i in $dirs; do
>> +      rm -fr $i/*
>> +   done
> Still whitespace damaged. Please use 8 space tabs.
ok
>> +}
>> +
>> +# $1 - expected limit after items creation
>> +# $2 - command to create item
>> +# $3 - where to create (testdir by default)
>> +_create_items()
> Still got a "_ prefix"
ok
>> +{
>> +    limit=$1
>> +    dir=${2:-$testdir}
>> +    MKTEMP_OPT=""
>> +    [ "$3" = "mkdir" ] && MKTEMP_OPT="-d"
>> +    sync
>> +    echo 3 > /proc/sys/vm/drop_caches
>> +    MAX_INUM=$((limit * 1024 * 2 / 24))
>> +    for i in $(seq 0 $MAX_INUM); do
>> +       error=$(mktemp $MKTEMP_OPT --tmpdir=$dir 2>&1 >/dev/null)
> Still using mktemp, only now in a much more convoluted manner.

> If you just want to create a file, "touch $dir/$i" is all you need
> to do.
I use mktemp to create items of fixed size that allows
to define the maximum dir items number corresponding to specified limit
which is calculated MAX_INUM=$((limit * 1024 * 2 / 24)): file name 
"tmp.XXXXXXXXXX"
of 14 bytes +8 bytes of ext4_dir_entry control data+2 bytes for padding 
= 24 bytes.
It is multiplied on 2 so in case of failed max_dir_size_kb, i.e. 
overlimit, the size
of test directory will be greater on one block.

>> +       res=$?
>> +       if [ $res -ne 0 ]; then
>> +          echo $error >> $seqres.full
>> +          [[ ! $error =~ ^.*'No space left on device'$ ]] && echo "FAIL! expected ENOSPC" | tee -a $seqres.full
>> +          break
>> +      fi
> You didn't answer any of the questions I asked about this, nor
> address the comments I made.
Sorry, I thought your comments were about convolution only.

> Just filter the error to sanitse it down to "No space left on
> device" and break. The golden output match will fail the test if
> there's any other type of error. i.e:
>
> 	for i in $(seq 0 $MAX_INUM); do
> 		touch $dir/$i 2>&1 | _filter_scratch
> 		if [ $? -ne 0 ]; then
> 			break;
> 		fi
> 	done
>
> will test everything the above loop do (except the obvious touch vs
> mkdir difference).
>
The error output style is the same as the similar one in this function:

+   if [ $size -gt $limit ]; then
+      echo "FAIL! expected dir size: $limit, actually: $size" | tee -a 
$seqres.full
+   fi

The idea is to provide more descriptive error messages in output for 
both checks, what was
expected and what's happened actually helping more quickly understand 
the type of failure.

>> +   done
>> +   size=$(stat -c %s $dir)
>> +   size=$((size / 1024))
>> +   if [ $size -gt $limit ]; then
>> +      echo "FAIL! expected dir size: $limit, actually: $size" | tee -a $seqres.full
>> +   fi
>> +}
>> +
>> +run_test()
>> +{
>> +   LIMIT1=$1
>> +   LIMIT2=$2
>> +   MKFS_OPT=$3
>> +
>> +   _scratch_unmount >/dev/null 2>&1
>> +   _scratch_mkfs $MKFS_OPT >>$seqres.full 2>&1
> _scratch_mkfs unmounts the SCRATCH_DEV.
ok
>> +   _scratch_mount -o max_dir_size_kb=$LIMIT1
>> +   mkdir $testdir
>> +
>> +   echo -e "\nExceed $LIMIT1 Kb limit with new files in testdir/: " >> $seqres.full
>> +   _create_items $LIMIT1
> I don't see much point in all these echos to $seqres.full.
These test descriptions are used to differ test case from others in the 
test and in logs, helping
the finding of test case failure or it's source code when reading the 
test. Otherwise it's unclear
which test case failed when getting some error in test out file.
>> +
>> +   echo -e "\nRemount with $LIMIT1 Kb limit,\nnew item in testdir/ should result to ENOSPC: " >>$seqres.full
>> +   _scratch_mount "-o remount,max_dir_size_kb=$LIMIT1"
>> +   _create_items $LIMIT1
>> +
>> +   echo -e "\nExceed $LIMIT2 Kb limit with new files in testdir/: " >> $seqres.full
>> +   _scratch_mount "-o remount,max_dir_size_kb=$LIMIT2"
>> +   _create_items $LIMIT2
>> +
>> +   echo -e "\nExceed $LIMIT2 Kb limit with new files in testdir2/: " >> $seqres.full
>> +   mkdir $SCRATCH_MNT/testdir2 2>/dev/null
>> +   _create_items $LIMIT2 "$SCRATCH_MNT/testdir2"
>> +
>> +   echo -e "\nRemount with $LIMIT1 Kb limit,\nnew item in testdir/ should result to ENOSPC: " >> $seqres.full
>> +   _scratch_mount "-o remount,max_dir_size_kb=$LIMIT1"
>> +   _create_items $LIMIT2
>> +   echo -e "\nnew item in testdir2/ should result to ENOSPC: " >> $seqres.full
>> +   _create_items $LIMIT2 "$SCRATCH_MNT/testdir2"
>> +   remove_files "$SCRATCH_MNT/testdir2"
>> +   rmdir $testdir
>> +   mkdir $testdir
>> +   dd if=/dev/urandom of=$testfile bs=1 seek=4096 count=4096 > /dev/null 2>&1
> Use xfs_io to write data to files, not dd.
ok, will be applied
>> +
>> +   echo -e "\nExceed $LIMIT1 Kb directory limit with new subdirectories: " >> $seqres.full
>> +   _create_items $LIMIT1 $testdir "mkdir"
>> +   remove_files
>> +
>> +   echo -e "\nCreate ext4 fs on testdir/subdir with $LIMIT2 Kb limit," >> $seqres.full
>> +   mkdir $testdir/subdir 2>/dev/null
>> +   umount $TEST_DEV 1>/dev/null 2>&1
>> +   _mkfs_dev $TEST_DEV $MKFS_OPT >>$seqres.full 2>&1
> You are not allowed to mkfs the test device during any test. You
> should not even be unmounting it.
I didn't know about this restriction, will rewrite these parts.

> You need to use loop devices
> if you want to do this, though I don't see why you need to use a
> second nested filesystem mount just to test a different limit,
This is robustness testing when test conditions are special cases,
to test filling of directories up to different limits which, for 
example, are nested
and mounted on different filesystems, when another filesystem
on loop etc. to cover possibly more paths in the filesystem code.

The loop devices test case was also separated as particular because I 
had some
xfstests failures in other tests reproduced on loop devices only. Just 
to be sure
that it is also covered here.
> especially as:
>
>> +   $MKFS_EXT4_PROG -F $MKFS_OPT $testfile 2m >> $seqres.full 2>&1
>> +   _mount -o loop,max_dir_size_kb=$LIMIT1 $testfile $testdir/subdir
>> +
>> +   echo "exceed $LIMIT1 Kb limit of testdir/subdir with a set of files:" >> $seqres.full
>> +   _create_items $LIMIT1 "$testdir/subdir"
>> +
>> +   echo -e "\nexceed $LIMIT2 Kb limit of testdir/ with a set of files:" >> $seqres.full
>> +   _create_items $LIMIT2
>> +
>> +   umount -d $testdir/subdir
> You test loop devices here....
>
> Cheers,
>
> Dave.
Thanks,
Alexander Tsvetkov
