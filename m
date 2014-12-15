From: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
Subject: Re: max_dir_size_kb option list
Date: Mon, 15 Dec 2014 19:06:39 +0300
Message-ID: <548F070F.2050808@oracle.com>
References: <548988D2.3030100@oracle.com> <20141212005517.GK24183@dastard>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080409060609090700060305"
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50588 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaLOQHH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Dec 2014 11:07:07 -0500
In-Reply-To: <20141212005517.GK24183@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080409060609090700060305
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

Hello Dave,

Thank you for the review, I've updated test according to your comments

On 12/12/2014 03:55 AM, Dave Chinner wrote:
> On Thu, Dec 11, 2014 at 03:06:42PM +0300, Alexander Tsvetkov wrote:
>> Hello,
>>
>> I've prepared test for xfstests suite that runs some checks for ext4
>> mount option max_dir_size_kb introduced in Linux Kernel 3.7, could
>> someone please look on it?
>>
>> Thanks,
>> Alexander Tsvetkov
>>  From 21b1da618d0fcb4cd4666d10c41583274ed4eeed Mon Sep 17 00:00:00 2001
>> From: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
>> Date: Wed, 10 Dec 2014 15:31:02 +0300
>> Subject: [PATCH] added test for max_dir_size_kb mount option
>>
>> ---
>>   tests/ext4/309     | 213 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   tests/ext4/309.out |   2 +
>>   tests/ext4/group   |   3 +-
>>   3 files changed, 217 insertions(+), 1 deletion(-)
>>   create mode 100755 tests/ext4/309
>>   create mode 100755 tests/ext4/309.out
>>
>> diff --git a/tests/ext4/309 b/tests/ext4/309
>> new file mode 100755
>> index 0000000..e2f4e43
>> --- /dev/null
>> +++ b/tests/ext4/309
>> @@ -0,0 +1,213 @@
>> +#! /bin/bash
>> +# FS QA Test
>> +#
>> +# Test for mount option max_dir_size_kb
>> +#
>> +#-----------------------------------------------------------------------
>> +# Copyright (c) 2014 Oracle and/or its affiliates.  All Rights Reserved.
>> +#
>> +# This program is free software; you can redistribute it and/or
>> +# modify it under the terms of the GNU General Public License as
>> +# published by the Free Software Foundation.
>> +#
>> +# This program is distributed in the hope that it would be useful,
>> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> +# GNU General Public License for more details.
>> +#
>> +# You should have received a copy of the GNU General Public License
>> +# along with this program; if not, write the Free Software Foundation,
>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>> +#-----------------------------------------------------------------------
>> +#
>> +
>> +seq=`basename $0`
>> +seqres=$RESULT_DIR/$seq
>> +tmp=/tmp/$$
>> +
>> +testdir=$SCRATCH_MNT/testdir
>> +testfile=$SCRATCH_MNT/testfile
> Do not call a file on the scratch device "testdir". That name has
> specific meaning: it's the mount point for the test device. Using
> the same variable name that differs only different syntax for
> somethingon the scratch device is not a good idea.
>
>
>> +sdir=`dirname $0`
>> +sdir=`cd "$sdir"; pwd`
> $here is already set to the current xfstests run location.
>
>> +echo "QA output created by $seq"
>> +echo "Silence is golden"
>> +rm -f $seqres.full
>> +
>> +status=1 # failure is the default!
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup() {
>> +   if [ ! -z SCRATCH_MNT ]; then
>> +      rm -fr $SCRATCH_MNT/test*
>> +      _scratch_unmount
>> +   fi
>> +}
> No. The harness will unmount the scratch device if it was mounted.
> Unless you need to do specific cleanup fo rthe test, do not modify
> the standard cleanup function. At minimum, it still needs to remove
> all the $tmp files created during the test run.
>
>
>> +
>> +_filter_error() {
>> +   sed -n -e "s/.*\($1\).*/\"\1\"/p"
>> +}
> "_" prefix is reserved for library functions.
>
> Comments are generally required to explain the intent of regexs that
> look like line noise.
>
> 8 space tabs.
>
>> +
>> +_clear_testdir() {
>> +   dirs="$testdir *$"
>> +   for i in $dirs; do
>> +      rm -fr $i/*
>> +   done
>> +}
> I thought this was going to clean up the TEST_DIR, but as per above,
> it's actually doing stuff to the scratch device. "remove_files()"
> is good enough....
>
>> +
>> +# $1 - device
>> +# $2 - options
>> +_make_ext4fs() {
>> +   device=$1
>> +   opts=$2
>> +   umount $device 1>/dev/null 2>&1
>> +   mkfs.ext4 $opts $device 1>/dev/null 2>&1
>> +}
> _mkfs_dev
>
>> +# $1 - options
>> +# $2 - mount point
>> +_make_loopfs() {
>> +   lpf=$testfile
>> +   dd if=/dev/zero of=$lpf bs=4k count=256 1>/dev/null 2>&1
>> +   loopdev=$(losetup -f)
>> +   losetup $loopdev $lpf
>> +   mkfs.ext4 -O ^dir_index,^has_journal $loopdev 1>/dev/null 2>&1
>> +   mount -t ext4 $1 $loopdev $2
>> +}
> no need to create a loop device. mount -o loop will do what you
> want. Also, $MKFS_EXT4_PROG (or whatever the var is) shoul dbe used.
> As should _mount. And 8 space tabs.
>
>
>> +
>> +# $1 - expected limit after items creation
>> +# $2 - command to create item
>> +# $3 - where to create (testdir by default)
>> +_create_items() {
>> +    limit=$1
>> +    create_cmd=$2
>> +    dir=${3:-$testdir}
>> +    sync
>> +    echo 3 > /proc/sys/vm/drop_caches
>> +    MAX_INUM=$(((limit*1024*2)/24))
>> +    for i in $(seq 0 $MAX_INUM); do
>> +       tmp_name=`mktemp -u`
applied
> We use $tmp as the location for temporary files in tests
mktemp is used to fill test directory up to limit
>
>> +       item=`basename $tmp_name`
>> +       if [ -e $dir/$item ]; then
>> +          continue
>> +       fi
> Why?
removed
>> +       create_cmd="$2 $dir/$item 2>$tmp.out 1>/dev/null"
>> +       eval "$create_cmd"
>> +       res=$?
>> +       if [ $res -ne 0 ]; then
>> +          _filter_error "No space left on device" < $tmp.out > $tmp.out2
>> +          if [ -s $tmp.out2 ]; then
>> +             cat $tmp.out2 | tr -d '\n' >> $seqres.full
>> +          else
>> +             echo "FAIL! expected ENOSPC" | tee -a $seqres.full
> _fail?
this output is supposed to make a test failure, but as I see _fail is rather
for test setup errors
>
>> +          fi
>> +          break
>> +      fi
> This all seems rather convoluted. You're creating a tmp file to
> capture the error, then if you get an ENOSPC error you dump it to
> the debug file, otherwise you dump an error message to main output
> to cause the test to eventually fail?
agree, I've simplified this part
>> +   done
>> +   size=$(stat -c %s $dir)
>> +   size=$((size/1024))
>> +   if [ $size -gt $limit ]; then
>> +      echo "FAIL! expected dir size: $limit, actually: $size" | tee -a $seqres.full
>> +   fi
>> +   rm -f $tmp*
>> +}
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +
>> +# real QA test starts here
>> +
>> +_supported_fs ext4
>> +_supported_os Linux
>> +_require_scratch
> _require_loop
>
>> +
>> +LIMIT1=8
>> +LIMIT2=16
>> +
>> +_make_ext4fs $SCRATCH_DEV "-O ^dir_index,^filetype"
> _scratch_mkfs -O ^dir_index,^filetype
>
applied
> Cheers,
>
> Dave.
Thanks,
Alexander Tsvetkov

--------------080409060609090700060305
Content-Type: text/x-patch;
 name="max_dir_size_kb.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="max_dir_size_kb.patch"

>From e30cd49f5ab84c029c0b376e702caeac42f59f49 Mon Sep 17 00:00:00 2001
From: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
Date: Mon, 15 Dec 2014 18:49:42 +0300
Subject: [PATCH] added test for max_dir_size_kb mount option

---
 tests/ext4/309     | 178 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/309.out |   2 +
 tests/ext4/group   |   1 +
 3 files changed, 181 insertions(+)
 create mode 100755 tests/ext4/309
 create mode 100755 tests/ext4/309.out

diff --git a/tests/ext4/309 b/tests/ext4/309
new file mode 100755
index 0000000..34ceb2b
--- /dev/null
+++ b/tests/ext4/309
@@ -0,0 +1,178 @@
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
+testdir=$SCRATCH_MNT/dir.$seq
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
+    cd /
+    rm -rf $tmp.*
+}
+
+remove_files() 
+{
+   dirs="$testdir $*"
+   for i in $dirs; do
+      rm -fr $i/*
+   done
+}
+
+# $1 - expected limit after items creation
+# $2 - command to create item
+# $3 - where to create (testdir by default)
+_create_items() 
+{
+    limit=$1
+    dir=${2:-$testdir}
+    MKTEMP_OPT=""
+    [ "$3" = "mkdir" ] && MKTEMP_OPT="-d"
+    sync
+    echo 3 > /proc/sys/vm/drop_caches
+    MAX_INUM=$((limit * 1024 * 2 / 24))
+    for i in $(seq 0 $MAX_INUM); do
+       error=$(mktemp $MKTEMP_OPT --tmpdir=$dir 2>&1 >/dev/null)
+       res=$?
+       if [ $res -ne 0 ]; then
+          echo $error >> $seqres.full  
+          [[ ! $error =~ ^.*'No space left on device'$ ]] && echo "FAIL! expected ENOSPC" | tee -a $seqres.full
+          break
+      fi
+   done
+   size=$(stat -c %s $dir)
+   size=$((size / 1024))
+   if [ $size -gt $limit ]; then
+      echo "FAIL! expected dir size: $limit, actually: $size" | tee -a $seqres.full
+   fi
+}
+
+run_test()
+{
+   LIMIT1=$1
+   LIMIT2=$2
+   MKFS_OPT=$3
+
+   _scratch_unmount >/dev/null 2>&1
+   _scratch_mkfs $MKFS_OPT >>$seqres.full 2>&1
+   _scratch_mount -o max_dir_size_kb=$LIMIT1
+   mkdir $testdir
+
+   echo -e "\nExceed $LIMIT1 Kb limit with new files in testdir/: " >> $seqres.full
+   _create_items $LIMIT1
+
+   echo -e "\nRemount with $LIMIT1 Kb limit,\nnew item in testdir/ should result to ENOSPC: " >>$seqres.full
+   _scratch_mount "-o remount,max_dir_size_kb=$LIMIT1"
+   _create_items $LIMIT1
+
+   echo -e "\nExceed $LIMIT2 Kb limit with new files in testdir/: " >> $seqres.full
+   _scratch_mount "-o remount,max_dir_size_kb=$LIMIT2"
+   _create_items $LIMIT2
+
+   echo -e "\nExceed $LIMIT2 Kb limit with new files in testdir2/: " >> $seqres.full
+   mkdir $SCRATCH_MNT/testdir2 2>/dev/null
+   _create_items $LIMIT2 "$SCRATCH_MNT/testdir2"
+
+   echo -e "\nRemount with $LIMIT1 Kb limit,\nnew item in testdir/ should result to ENOSPC: " >> $seqres.full
+   _scratch_mount "-o remount,max_dir_size_kb=$LIMIT1"
+   _create_items $LIMIT2
+   echo -e "\nnew item in testdir2/ should result to ENOSPC: " >> $seqres.full
+   _create_items $LIMIT2 "$SCRATCH_MNT/testdir2"
+   remove_files "$SCRATCH_MNT/testdir2"
+   rmdir $testdir
+   mkdir $testdir
+   dd if=/dev/urandom of=$testfile bs=1 seek=4096 count=4096 > /dev/null 2>&1
+
+   echo -e "\nExceed $LIMIT1 Kb directory limit with new subdirectories: " >> $seqres.full
+   _create_items $LIMIT1 $testdir "mkdir"
+   remove_files
+
+   echo -e "\nCreate ext4 fs on testdir/subdir with $LIMIT2 Kb limit," >> $seqres.full
+   mkdir $testdir/subdir 2>/dev/null
+   umount $TEST_DEV 1>/dev/null 2>&1
+   _mkfs_dev $TEST_DEV $MKFS_OPT >>$seqres.full 2>&1
+   _mount -o max_dir_size_kb=$LIMIT2 $TEST_DEV $testdir/subdir
+
+   echo "exceed $LIMIT1 Kb limit of testdir/:" >> $seqres.full
+   _create_items $LIMIT1
+
+   echo -e "\nexceed $LIMIT2 Kb limit of testdir/subdir:" >> $seqres.full
+   _create_items $LIMIT2 "$testdir/subdir"
+
+   echo -e "\ntestdir/ limit $LIMIT2 Kb, testdir/subdir limit $LIMIT1 Kb," >> $seqres.full
+   umount $TEST_DEV 1>/dev/null 2>&1
+   _scratch_mount "-o remount,max_dir_size_kb=$LIMIT2"
+   _mount -o max_dir_size_kb=$LIMIT1 $TEST_DEV $testdir/subdir
+
+   echo "exceed new $LIMIT2 Kb limit of testdir/ with a set of files:" >> $seqres.full
+   _create_items $LIMIT2
+   echo -e "\nnew item in testdir/subdir should result to ENOSPC: " >> $seqres.full
+   _create_items $LIMIT2 "$testdir/subdir"
+
+   umount $TEST_DEV 1>/dev/null 2>&1
+   remove_files
+
+   echo -e "\nTestdir/ limit $LIMIT2 Kb, loop fs: testdir/subdir limit $LIMIT1 Kb," >> $seqres.full
+   mkdir $testdir/subdir
+
+   $MKFS_EXT4_PROG -F $MKFS_OPT $testfile 2m >> $seqres.full 2>&1
+   _mount -o loop,max_dir_size_kb=$LIMIT1 $testfile $testdir/subdir
+
+   echo "exceed $LIMIT1 Kb limit of testdir/subdir with a set of files:" >> $seqres.full
+   _create_items $LIMIT1 "$testdir/subdir"
+
+   echo -e "\nexceed $LIMIT2 Kb limit of testdir/ with a set of files:" >> $seqres.full
+   _create_items $LIMIT2
+
+   umount -d $testdir/subdir
+   remove_files
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
+exit 0
+
diff --git a/tests/ext4/309.out b/tests/ext4/309.out
new file mode 100755
index 0000000..56330d6
--- /dev/null
+++ b/tests/ext4/309.out
@@ -0,0 +1,2 @@
+QA output created by 309
+Silence is golden
diff --git a/tests/ext4/group b/tests/ext4/group
index e7f1f2a..78d643b 100644
--- a/tests/ext4/group
+++ b/tests/ext4/group
@@ -16,3 +16,4 @@
 306 auto rw resize quick
 307 auto ioctl rw
 308 auto ioctl rw prealloc quick
+309 auto
-- 
1.9.3


--------------080409060609090700060305--
