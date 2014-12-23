From: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
Subject: Re: max_dir_size_kb option list
Date: Tue, 23 Dec 2014 15:06:32 +0300
Message-ID: <54995AC8.6070707@oracle.com>
References: <548988D2.3030100@oracle.com> <20141212005517.GK24183@dastard> <548F070F.2050808@oracle.com> <20141215215147.GV24183@dastard> <549052ED.6070405@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030601080702040501050505"
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <549052ED.6070405@oracle.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------030601080702040501050505
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

Hello Dave,

Attached updated version of the test.

On 12/16/2014 06:42 PM, Alexander Tsvetkov wrote:
>
> On 12/16/2014 12:51 AM, Dave Chinner wrote:
>> On Mon, Dec 15, 2014 at 07:06:39PM +0300, Alexander Tsvetkov wrote:
>>> Hello Dave,
>>>
>>> Thank you for the review, I've updated test according to your comments
>> ....
>>
>>>  From e30cd49f5ab84c029c0b376e702caeac42f59f49 Mon Sep 17 00:00:00 2001
>>> From: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
>>> Date: Mon, 15 Dec 2014 18:49:42 +0300
>>> Subject: [PATCH] added test for max_dir_size_kb mount option
>>>
>>> ---
>>>   tests/ext4/309     | 178 
>>> +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>   tests/ext4/309.out |   2 +
>>>   tests/ext4/group   |   1 +
>>>   3 files changed, 181 insertions(+)
>>>   create mode 100755 tests/ext4/309
>>>   create mode 100755 tests/ext4/309.out
>> This is missing a commit message describing the change, as well as a
>> change log telling me what changed from v1 to v2. Hence I don't know
>> exactly what you changed and what you ignored.
> ok, it seems patch was not correctly collected
>>> diff --git a/tests/ext4/309 b/tests/ext4/309
>> Just use the next unused number in the ext4 directory.
> do you mean 004?
>>
>>> +remove_files()
>>> +{
>>> +   dirs="$testdir $*"
>>> +   for i in $dirs; do
>>> +      rm -fr $i/*
>>> +   done
>> Still whitespace damaged. Please use 8 space tabs.
> ok
>>> +}
>>> +
>>> +# $1 - expected limit after items creation
>>> +# $2 - command to create item
>>> +# $3 - where to create (testdir by default)
>>> +_create_items()
>> Still got a "_ prefix"
> ok
>>> +{
>>> +    limit=$1
>>> +    dir=${2:-$testdir}
>>> +    MKTEMP_OPT=""
>>> +    [ "$3" = "mkdir" ] && MKTEMP_OPT="-d"
>>> +    sync
>>> +    echo 3 > /proc/sys/vm/drop_caches
>>> +    MAX_INUM=$((limit * 1024 * 2 / 24))
>>> +    for i in $(seq 0 $MAX_INUM); do
>>> +       error=$(mktemp $MKTEMP_OPT --tmpdir=$dir 2>&1 >/dev/null)
>> Still using mktemp, only now in a much more convoluted manner.
>
>> If you just want to create a file, "touch $dir/$i" is all you need
>> to do.
> I use mktemp to create items of fixed size that allows
> to define the maximum dir items number corresponding to specified limit
> which is calculated MAX_INUM=$((limit * 1024 * 2 / 24)): file name 
> "tmp.XXXXXXXXXX"
> of 14 bytes +8 bytes of ext4_dir_entry control data+2 bytes for 
> padding = 24 bytes.
> It is multiplied on 2 so in case of failed max_dir_size_kb, i.e. 
> overlimit, the size
> of test directory will be greater on one block.
>
>>> +       res=$?
>>> +       if [ $res -ne 0 ]; then
>>> +          echo $error >> $seqres.full
>>> +          [[ ! $error =~ ^.*'No space left on device'$ ]] && echo 
>>> "FAIL! expected ENOSPC" | tee -a $seqres.full
>>> +          break
>>> +      fi
>> You didn't answer any of the questions I asked about this, nor
>> address the comments I made.
> Sorry, I thought your comments were about convolution only.
>
>> Just filter the error to sanitse it down to "No space left on
>> device" and break. The golden output match will fail the test if
>> there's any other type of error. i.e:
>>
>>     for i in $(seq 0 $MAX_INUM); do
>>         touch $dir/$i 2>&1 | _filter_scratch
>>         if [ $? -ne 0 ]; then
>>             break;
>>         fi
>>     done
>>
>> will test everything the above loop do (except the obvious touch vs
>> mkdir difference).
>>
> The error output style is the same as the similar one in this function:
>
> +   if [ $size -gt $limit ]; then
> +      echo "FAIL! expected dir size: $limit, actually: $size" | tee 
> -a $seqres.full
> +   fi
>
> The idea is to provide more descriptive error messages in output for 
> both checks, what was
> expected and what's happened actually helping more quickly understand 
> the type of failure.
>
>>> +   done
>>> +   size=$(stat -c %s $dir)
>>> +   size=$((size / 1024))
>>> +   if [ $size -gt $limit ]; then
>>> +      echo "FAIL! expected dir size: $limit, actually: $size" | tee 
>>> -a $seqres.full
>>> +   fi
>>> +}
>>> +
>>> +run_test()
>>> +{
>>> +   LIMIT1=$1
>>> +   LIMIT2=$2
>>> +   MKFS_OPT=$3
>>> +
>>> +   _scratch_unmount >/dev/null 2>&1
>>> +   _scratch_mkfs $MKFS_OPT >>$seqres.full 2>&1
>> _scratch_mkfs unmounts the SCRATCH_DEV.
> ok
>>> +   _scratch_mount -o max_dir_size_kb=$LIMIT1
>>> +   mkdir $testdir
>>> +
>>> +   echo -e "\nExceed $LIMIT1 Kb limit with new files in testdir/: " 
>>> >> $seqres.full
>>> +   _create_items $LIMIT1
>> I don't see much point in all these echos to $seqres.full.
> These test descriptions are used to differ test case from others in 
> the test and in logs, helping
> the finding of test case failure or it's source code when reading the 
> test. Otherwise it's unclear
> which test case failed when getting some error in test out file.
>>> +
>>> +   echo -e "\nRemount with $LIMIT1 Kb limit,\nnew item in testdir/ 
>>> should result to ENOSPC: " >>$seqres.full
>>> +   _scratch_mount "-o remount,max_dir_size_kb=$LIMIT1"
>>> +   _create_items $LIMIT1
>>> +
>>> +   echo -e "\nExceed $LIMIT2 Kb limit with new files in testdir/: " 
>>> >> $seqres.full
>>> +   _scratch_mount "-o remount,max_dir_size_kb=$LIMIT2"
>>> +   _create_items $LIMIT2
>>> +
>>> +   echo -e "\nExceed $LIMIT2 Kb limit with new files in testdir2/: 
>>> " >> $seqres.full
>>> +   mkdir $SCRATCH_MNT/testdir2 2>/dev/null
>>> +   _create_items $LIMIT2 "$SCRATCH_MNT/testdir2"
>>> +
>>> +   echo -e "\nRemount with $LIMIT1 Kb limit,\nnew item in testdir/ 
>>> should result to ENOSPC: " >> $seqres.full
>>> +   _scratch_mount "-o remount,max_dir_size_kb=$LIMIT1"
>>> +   _create_items $LIMIT2
>>> +   echo -e "\nnew item in testdir2/ should result to ENOSPC: " >> 
>>> $seqres.full
>>> +   _create_items $LIMIT2 "$SCRATCH_MNT/testdir2"
>>> +   remove_files "$SCRATCH_MNT/testdir2"
>>> +   rmdir $testdir
>>> +   mkdir $testdir
>>> +   dd if=/dev/urandom of=$testfile bs=1 seek=4096 count=4096 > 
>>> /dev/null 2>&1
>> Use xfs_io to write data to files, not dd.
> ok, will be applied
>>> +
>>> +   echo -e "\nExceed $LIMIT1 Kb directory limit with new 
>>> subdirectories: " >> $seqres.full
>>> +   _create_items $LIMIT1 $testdir "mkdir"
>>> +   remove_files
>>> +
>>> +   echo -e "\nCreate ext4 fs on testdir/subdir with $LIMIT2 Kb 
>>> limit," >> $seqres.full
>>> +   mkdir $testdir/subdir 2>/dev/null
>>> +   umount $TEST_DEV 1>/dev/null 2>&1
>>> +   _mkfs_dev $TEST_DEV $MKFS_OPT >>$seqres.full 2>&1
>> You are not allowed to mkfs the test device during any test. You
>> should not even be unmounting it.
> I didn't know about this restriction, will rewrite these parts.
>
>> You need to use loop devices
>> if you want to do this, though I don't see why you need to use a
>> second nested filesystem mount just to test a different limit,
> This is robustness testing when test conditions are special cases,
> to test filling of directories up to different limits which, for 
> example, are nested
> and mounted on different filesystems, when another filesystem
> on loop etc. to cover possibly more paths in the filesystem code.
>
> The loop devices test case was also separated as particular because I 
> had some
> xfstests failures in other tests reproduced on loop devices only. Just 
> to be sure
> that it is also covered here.
>> especially as:
>>
>>> +   $MKFS_EXT4_PROG -F $MKFS_OPT $testfile 2m >> $seqres.full 2>&1
>>> +   _mount -o loop,max_dir_size_kb=$LIMIT1 $testfile $testdir/subdir
>>> +
>>> +   echo "exceed $LIMIT1 Kb limit of testdir/subdir with a set of 
>>> files:" >> $seqres.full
>>> +   _create_items $LIMIT1 "$testdir/subdir"
>>> +
>>> +   echo -e "\nexceed $LIMIT2 Kb limit of testdir/ with a set of 
>>> files:" >> $seqres.full
>>> +   _create_items $LIMIT2
>>> +
>>> +   umount -d $testdir/subdir
>> You test loop devices here....
>>
>> Cheers,
>>
>> Dave.
> Thanks,
> Alexander Tsvetkov

Thanks,
Alexander Tsvetkov


--------------030601080702040501050505
Content-Type: text/x-patch;
 name="max_dir_size_kb.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="max_dir_size_kb.patch"

>From 6f90894347d579e6cc6be9af159eb5d4a12c059e Mon Sep 17 00:00:00 2001
From: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
Date: Tue, 23 Dec 2014 14:58:13 +0300
Subject: [PATCH] added test for max_dir_size_kb mount option

---
 tests/ext4/005     | 137 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/005.out |   2 +
 tests/ext4/group   |   1 +
 3 files changed, 140 insertions(+)
 create mode 100755 tests/ext4/005
 create mode 100644 tests/ext4/005.out

diff --git a/tests/ext4/005 b/tests/ext4/005
new file mode 100755
index 0000000..4cfcb25
--- /dev/null
+++ b/tests/ext4/005
@@ -0,0 +1,137 @@
+#! /bin/bash
+# FS QA Test
+#
+# Test for mount option max_dir_size_kb
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Oracle and/or its affiliates.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+#
+
+seq=$(basename $0)
+seqres=$RESULT_DIR/$seq
+tmp=/tmp/$$
+
+testdir=$SCRATCH_MNT/dir1.$seq
+testdir2=$testdir/dir2.$seq
+testfile=$SCRATCH_MNT/testfile
+
+echo "QA output created by $seq"
+echo "Silence is golden"
+rm -f $seqres.full
+
+status=1 # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# filter expected output with ENOSPC error
+filter_enospc()
+{
+	sed -e "/^.*No space left on device$/d"
+}
+
+# $1 - expected limit after filling
+# $2 - where to create
+create_items() 
+{
+	limit=$1
+	dir=${2:-$testdir}
+	sync
+	echo 3 > /proc/sys/vm/drop_caches
+	MAX_INUM=$((limit * 1024 * 3 / 24))
+	for i in $(seq 0 $MAX_INUM); do
+		touch $dir/$i 2>&1 1>/dev/null | filter_enospc
+		if [ ${PIPESTATUS[0]} -ne 0 ]; then
+			break
+		fi
+	done
+	size=$(stat -c %s $dir)
+	size=$((size / 1024))
+	if [ $size -gt $limit ]; then
+		echo "FAIL! expected dir size: $limit, actually: $size"
+	fi
+}
+
+# $1 - low directory limit value
+# $2 - high directory limit value 
+# $3 - mkfs options
+run_test()
+{
+	LIMIT1=$1
+	LIMIT2=$2
+	MKFS_OPT=$3
+
+	_scratch_mkfs $MKFS_OPT >>$seqres.full 2>&1
+	_scratch_mount -o max_dir_size_kb=$LIMIT1
+	mkdir $testdir
+
+	# Exceed with low limit
+	create_items $LIMIT1
+
+	# Exceed with the same limit after remount
+	_scratch_mount "-o remount,max_dir_size_kb=$LIMIT1"
+	create_items $LIMIT1
+
+	# Exceed with high limit after remount 
+	_scratch_mount "-o remount,max_dir_size_kb=$LIMIT2"
+	create_items $LIMIT2
+
+	# Exceed with low limit after remount 
+	_scratch_mount "-o remount,max_dir_size_kb=$LIMIT1"
+	create_items $LIMIT2
+
+	# Exceed limits of two test dirs resided on different fs, 
+	# second fs is mounted on nested test dir of the first fs
+	rm -fr $testdir/*
+	rmdir $testdir
+	mkdir -p $testdir2
+	touch $testfile
+	$MKFS_EXT4_PROG -F $MKFS_OPT $testfile 4m >> $seqres.full 2>&1
+	_mount -o loop,max_dir_size_kb=$LIMIT2 $testfile $testdir2
+	create_items $LIMIT1
+	create_items $LIMIT2 $testdir2
+	_scratch_mount "-o remount,max_dir_size_kb=$LIMIT2"
+	_mount -o remount,max_dir_size_kb=$LIMIT1 $testfile $testdir2
+	create_items $LIMIT2
+	create_items $LIMIT2 $testdir2
+
+	umount -d $testdir2
+	_scratch_unmount >/dev/null 2>&1
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+
+# real QA test starts here
+
+_supported_fs ext4
+_supported_os Linux
+_require_scratch
+_require_loop
+
+run_test 8 16
+run_test 4 32 "-O ^dir_index"
+run_test 5 11 "-b 1024" 
+
+# success, all done
+status=0
+exit
+
diff --git a/tests/ext4/005.out b/tests/ext4/005.out
new file mode 100644
index 0000000..a5027f1
--- /dev/null
+++ b/tests/ext4/005.out
@@ -0,0 +1,2 @@
+QA output created by 005
+Silence is golden
diff --git a/tests/ext4/group b/tests/ext4/group
index e7f1f2a..f02d221 100644
--- a/tests/ext4/group
+++ b/tests/ext4/group
@@ -7,6 +7,7 @@
 002 auto quick prealloc
 003 auto quick
 004 auto dump
+005 auto
 271 auto rw quick
 301 aio dangerous ioctl rw stress
 302 aio dangerous ioctl rw stress
-- 
1.9.3


--------------030601080702040501050505--
