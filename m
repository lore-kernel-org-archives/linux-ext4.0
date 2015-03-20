From: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
Subject: Re: max_dir_size_kb option list
Date: Fri, 20 Mar 2015 17:42:23 +0300
Message-ID: <550C31CF.1080803@oracle.com>
References: <548988D2.3030100@oracle.com> <20141212005517.GK24183@dastard> <548F070F.2050808@oracle.com> <20141215215147.GV24183@dastard> <549052ED.6070405@oracle.com> <54995AC8.6070707@oracle.com> <20141224003449.GK4521@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20141224003449.GK4521@dastard>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello Dave,

On 12/24/2014 03:34 AM, Dave Chinner wrote:
> On Tue, Dec 23, 2014 at 03:06:32PM +0300, Alexander Tsvetkov wrote:
>> Hello Dave,
>>
>> Attached updated version of the test.
> [snip entire quoted previous emails]
>
> Closer, but still not quite all there.
>
> A couple of things about posting patches, first. please don't top
> post and when sending a new version of a patch, please send it with
> an appropriate subject such as:
>
> [PATCH v4] ext4: Add new test for max_dir_size_kb mount option
>
> So it's clear that there's a new version of the patch been sent.
> Also, the patch should be in-line, not an attachment.
>
>>  From 6f90894347d579e6cc6be9af159eb5d4a12c059e Mon Sep 17 00:00:00 2001
>> From: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
>> Date: Tue, 23 Dec 2014 14:58:13 +0300
>> Subject: [PATCH] added test for max_dir_size_kb mount option
>>
>> ---
> The commit message should not be blank - it needs to explain why the
> new test is needed.
>
> Also, the change history of the patch (what's changed between each
> version posted)  should be documented here below the first "---"
> delimiter so people who have already commented on previous versions
> know what you have and haven't changed.
>
> Fo more information, please go and read
> Documentation/SubmittingPatches from your local kernel source tree.
I've added history with corrected and updated commit message
>
>>   tests/ext4/005     | 137 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   tests/ext4/005.out |   2 +
>>   tests/ext4/group   |   1 +
>>   3 files changed, 140 insertions(+)
>>   create mode 100755 tests/ext4/005
>>   create mode 100644 tests/ext4/005.out
>>
>> diff --git a/tests/ext4/005 b/tests/ext4/005
>> new file mode 100755
>> index 0000000..4cfcb25
>> --- /dev/null
>> +++ b/tests/ext4/005
>> @@ -0,0 +1,137 @@
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
>> +seq=$(basename $0)
>> +seqres=$RESULT_DIR/$seq
>> +tmp=/tmp/$$
>> +
>> +testdir=$SCRATCH_MNT/dir1.$seq
>> +testdir2=$testdir/dir2.$seq
>> +testfile=$SCRATCH_MNT/testfile
> I think I've already pointed out that "testdir" should not be used
> as a local variable to point to something on the scratch device.
> It's too easily confused with TEST_DIR. Please rename them to
> something less confusing e.g. dir1, dir2, and fsimg_file.
>
I've renamed local variables 'testdir', 'testdir2' to 'dir1','dir2'
>> +
>> +echo "QA output created by $seq"
>> +echo "Silence is golden"
>> +rm -f $seqres.full
>> +
>> +status=1 # failure is the default!
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup()
>> +{
>> +	cd /
>> +	rm -rf $tmp.*
>> +}
>> +
>> +# filter expected output with ENOSPC error
>> +filter_enospc()
>> +{
>> +	sed -e "/^.*No space left on device$/d"
>> +}
>> +
>> +# $1 - expected limit after filling
>> +# $2 - where to create
>> +create_items()
>> +{
>> +	limit=$1
>> +	dir=${2:-$testdir}
> Just pass the variable at the call site.
I've added second parameter directory to create_items() function
>> +	sync
>> +	echo 3 > /proc/sys/vm/drop_caches
> Why is this necessary given there's always a remount just before
> this is called?
You are right, I've remove these lines
>> +	MAX_INUM=$((limit * 1024 * 3 / 24))
>> +	for i in $(seq 0 $MAX_INUM); do
>> +		touch $dir/$i 2>&1 1>/dev/null | filter_enospc
> touch is silent when it succeeds, so there's no need to redirect
> anything to /dev/null.
I've removed stdout redirection to dev/null of 'touch'
>> +		if [ ${PIPESTATUS[0]} -ne 0 ]; then
>> +			break
>> +		fi
>> +	done
>> +	size=$(stat -c %s $dir)
>> +	size=$((size / 1024))
>> +	if [ $size -gt $limit ]; then
>> +		echo "FAIL! expected dir size: $limit, actually: $size"
>> +	fi
>> +}
>> +
>> +# $1 - low directory limit value
>> +# $2 - high directory limit value
>> +# $3 - mkfs options
>> +run_test()
>> +{
>> +	LIMIT1=$1
>> +	LIMIT2=$2
>> +	MKFS_OPT=$3
>> +
>> +	_scratch_mkfs $MKFS_OPT >>$seqres.full 2>&1
>> +	_scratch_mount -o max_dir_size_kb=$LIMIT1
>> +	mkdir $testdir
>> +
>> +	# Exceed with low limit
>> +	create_items $LIMIT1
>> +
>> +	# Exceed with the same limit after remount
>> +	_scratch_mount "-o remount,max_dir_size_kb=$LIMIT1"
> Urk. We have _scratch_remount, so this is kinda confusing as to
> be using _scratch_mount to do remounts. You need to document why
> this is a safe thing to do.
_scratch_remout doesn't get mount options for _scratch_mount
called, so I used _scratch_mount with "-o remount" because
I want to pass new limit value and remount
>> +	create_items $LIMIT1
> And. well, after a remount, running sync and dropping caches is
> unnecessary...
>
>> +	# Exceed with high limit after remount
>> +	_scratch_mount "-o remount,max_dir_size_kb=$LIMIT2"
>> +	create_items $LIMIT2
>> +
>> +	# Exceed with low limit after remount
>> +	_scratch_mount "-o remount,max_dir_size_kb=$LIMIT1"
>> +	create_items $LIMIT2
>> +
>> +	# Exceed limits of two test dirs resided on different fs,
>> +	# second fs is mounted on nested test dir of the first fs
>> +	rm -fr $testdir/*
>> +	rmdir $testdir
>> +	mkdir -p $testdir2
>> +	touch $testfile
>> +	$MKFS_EXT4_PROG -F $MKFS_OPT $testfile 4m >> $seqres.full 2>&1
> _mkfs_dev $testfile 4m ?
replaced $MKFS_EXT4_PROG to _mkfs_dev
>
>> +	_mount -o loop,max_dir_size_kb=$LIMIT2 $testfile $testdir2
>> +	create_items $LIMIT1
>> +	create_items $LIMIT2 $testdir2
>> +	_scratch_mount "-o remount,max_dir_size_kb=$LIMIT2"
>> +	_mount -o remount,max_dir_size_kb=$LIMIT1 $testfile $testdir2
>> +	create_items $LIMIT2
>> +	create_items $LIMIT2 $testdir2
>> +
>> +	umount -d $testdir2
>> +	_scratch_unmount >/dev/null 2>&1
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
>> +_require_loop
> Put these at the top after the _cleanup function.
moved these parts at the top
>
> Cheers,
>
> Dave.
Thanks,
Alexander Tsvetkov

 From a95727e4639890df85de49bdd982e9dfbf4bbc49 Mon Sep 17 00:00:00 2001
From: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
Date: Fri, 20 Mar 2015 17:03:02 +0300
Subject: [PATCH v4] ext4: Add new test for max_dir_size_kb mount option
     Test max_dir_size_kb option for different limits is intended to verify
     that this option limits the size of the directories, created three
     set of test runs: with enabled/disabled dir_index feature and
     also additional one with filesystem of 1Kb block size as per
     max_dir_size_kb resolution

     Signed-off-by: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
---
v1-v2: moved test cases in the function run_test() parametrized with 
limits and mkfs options
        and defined the addition test runs one with disabled dir_index, 
another with 1024 block size,
        replaced _make_ext4fs/_make_loopfs functions on 
$MKFS_EXT4_PROG/_scratch_mkfs common functions,
        rewritten enospc error handling and removed _filter_error() 
function,
        removed redundant test cases to verify limits on symlinks, hard 
links and FIFOs,
        corrected cleanup and function names
v2-v3: replaced the function to create items 'mktemp' on 'touch',
        simplified messages before each test case run and replaced them 
on comments,
        removed redundant test case to verify limit on subdirectories,
        simplified robustness test case on loop device and removed 
function remove_files,
        restored _filter_error() to filter enospc errors only without 
checking of occurence
v3-v4: renamed local variables 'testdir', 'testdir2' to 'dir1','dir2',
        added second parameter directory to create_items() function,
        removed unnecessary drop caches,
        removed stdout redirection to dev/null of 'touch',
        replaced $MKFS_EXT4_PROG to _mkfs_dev,
        moved initilization function calls at the top after the _cleanup 
function
  tests/ext4/005     | 137 
+++++++++++++++++++++++++++++++++++++++++++++++++++++
  tests/ext4/005.out |   2 +
  2 files changed, 139 insertions(+)
  create mode 100755 tests/ext4/005
  create mode 100644 tests/ext4/005.out

diff --git a/tests/ext4/005 b/tests/ext4/005
new file mode 100755
index 0000000..1ca046f
--- /dev/null
+++ b/tests/ext4/005
@@ -0,0 +1,137 @@
+#! /bin/bash
+# FS QA Test
+#
+# Test for mount option max_dir_size_kb
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Oracle and/or its affiliates.  All Rights Reserved.
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
+dir1=$SCRATCH_MNT/dir1.$seq
+dir2=$dir1/dir2.$seq
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
+
+# filter expected output with ENOSPC error
+filter_enospc()
+{
+    sed -e "/^.*No space left on device$/d"
+}
+
+# $1 - expected limit after filling
+# $2 - where to create
+create_items()
+{
+    limit=$1
+    dir=$2
+    MAX_INUM=$((limit * 1024 * 3 / 24))
+    for i in $(seq 0 $MAX_INUM); do
+        touch $dir/$i 2>&1 | filter_enospc
+        if [ ${PIPESTATUS[0]} -ne 0 ]; then
+            break
+        fi
+    done
+    size=$(stat -c %s $dir)
+    size=$((size / 1024))
+    if [ $size -gt $limit ]; then
+        echo "FAIL! expected dir size: $limit, actually: $size"
+    fi
+}
+
+# $1 - low directory limit value
+# $2 - high directory limit value
+# $3 - mkfs options
+run_test()
+{
+    LIMIT1=$1
+    LIMIT2=$2
+    MKFS_OPT=$3
+
+    _scratch_mkfs $MKFS_OPT >>$seqres.full 2>&1
+    _scratch_mount -o max_dir_size_kb=$LIMIT1
+    mkdir $dir1
+
+    # Exceed with low limit
+    create_items $LIMIT1 $dir1
+
+    # Exceed with the same limit after remount
+    _scratch_mount "-o remount,max_dir_size_kb=$LIMIT1"
+    create_items $LIMIT1 $dir1
+
+    # Exceed with high limit after remount
+    _scratch_mount "-o remount,max_dir_size_kb=$LIMIT2"
+    create_items $LIMIT2 $dir1
+
+    # Exceed with low limit after remount
+    _scratch_mount "-o remount,max_dir_size_kb=$LIMIT1"
+    create_items $LIMIT2 $dir1
+
+    # Exceed limits of two test dirs resided on different fs,
+    # second fs is mounted on nested test dir of the first fs
+    rm -fr $dir1/*
+    rmdir $dir1
+    mkdir -p $dir2
+    touch $testfile
+    MKFS_OPTIONS="-F $MKFS_OPT"
+    _mkfs_dev $testfile 4m
+    _mount -o loop,max_dir_size_kb=$LIMIT2 $testfile $dir2
+    create_items $LIMIT1 $dir1
+    create_items $LIMIT2 $dir2
+    _scratch_mount "-o remount,max_dir_size_kb=$LIMIT2"
+    _mount -o remount,max_dir_size_kb=$LIMIT1 $testfile $dir2
+    create_items $LIMIT2 $dir1
+    create_items $LIMIT2 $dir2
+
+    umount -d $dir2
+    _scratch_unmount >/dev/null 2>&1
+
+}
+
+run_test 8 16
+run_test 4 32 "-O ^dir_index"
+run_test 5 11 "-b 1024"
+
+# success, all done
+status=0
+exit
diff --git a/tests/ext4/005.out b/tests/ext4/005.out
new file mode 100644
index 0000000..a5027f1
--- /dev/null
+++ b/tests/ext4/005.out
@@ -0,0 +1,2 @@
+QA output created by 005
+Silence is golden
-- 
1.9.3
