From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2] generic: add testcase to test fallocate & f{data,}sync
Date: Wed, 15 Nov 2017 19:37:28 +0800
Message-ID: <20171115113728.GS17339@eguan.usersys.redhat.com>
References: <20171115085833.55207-1-yuchao0@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, jaegeuk@kernel.org, chao@kernel.org
To: Chao Yu <yuchao0@huawei.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37482 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757704AbdKOLhb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 15 Nov 2017 06:37:31 -0500
Content-Disposition: inline
In-Reply-To: <20171115085833.55207-1-yuchao0@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[adding ext4 list]

On Wed, Nov 15, 2017 at 04:58:33PM +0800, Chao Yu wrote:
> f2fs can skip isize updating in fsync(), since during mount, f2fs tries
> to recovery isize according to valid block address or preallocated flag
> in last fsynced dnode block.
> 
> However, fallocate() breaks our rule with setting FALLOC_FL_KEEP_SIZE
> flag, since it can preallocated block cross EOF, once the file is fsynced,
> in POR, we will recover isize incorrectly based on these fallocated
> blocks.
> 
> This patch adds a new testcase to test fallocate, in order to verify
> whether filesystem will do correct recovery on isize.
> 
> Signed-off-by: Chao Yu <yuchao0@huawei.com>

This test fails on ext4 as

 ==== falloc -k 1024 test with fdatasync ====
+Before:  "b: 8216 s: 4202496"
+After :  "b: 8208 s: 4202496"
 ==== falloc -k 4096 test with fdatasync ====
+Before:  "b: 8216 s: 4202496"
+After :  "b: 8208 s: 4202496"
 ==== falloc -k 104857600 test with fdatasync ====
+Before:  "b: 213008 s: 4202496"
+After :  "b: 8208 s: 4202496"

So the block counts are changed after fdatasync & fs shutdown in the
fallocate(2) KEEP_SIZE case. Looks like a real ext4 bug, fdatasync
failed to flush the preallocated blocks beyond EOF to disk, but I want
to confirm first with ext4 people. If it turns out to be a case issue,
we'd like to update test case accordingly before merging it.

> ---
> v2:
> - change copyright to Huawei Co.
> - refactor description of testcase.
> - set status correctly.
>  tests/generic/468     | 127 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/468.out |  13 ++++++
>  tests/generic/group   |   1 +
>  3 files changed, 141 insertions(+)
>  create mode 100755 tests/generic/468
>  create mode 100644 tests/generic/468.out
> 
> diff --git a/tests/generic/468 b/tests/generic/468
> new file mode 100755
> index 000000000000..242589a35e34
> --- /dev/null
> +++ b/tests/generic/468
> @@ -0,0 +1,127 @@
> +#! /bin/bash
> +# FS QA Test 468
> +#
> +# This testcase is a fallocate variant of generic/392, it expands to test
> +# block preallocation functionality of fallocate.
> +# In this case, we are trying to execute:
> +# 1. fallocate {,-k}
> +# 2. f{data,}sync
> +# 3. power-cuts
> +# 4. recovery filesystem during mount
> +# 5. check inode's metadata
> +#
> +# In the case of fsync, filesystem should recover all the inode metadata, while
> +# recovering i_blocks and i_size at least for fdatasync, so this testcase excepts
> +# that inode metadata will be unchanged after recovery.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2017 Huawei.  All Rights Reserved.
> +# Author: Chao Yu <yuchao0@huawei.com>
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#-----------------------------------------------------------------------
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_supported_os Linux
> +_require_test

I'd removed this _require_test call, as test device is not used. I'll
fix it on commit if we don't need v3 (due to the ext4 failure).

> +
> +_require_scratch
> +_require_scratch_shutdown
> +_require_xfs_io_command "falloc" "-k"
> +
> +_scratch_mkfs >/dev/null 2>&1
> +_require_metadata_journaling $SCRATCH_DEV
> +_scratch_mount
> +
> +testfile=$SCRATCH_MNT/testfile
> +
> +# check inode metadata after shutdown
> +check_inode_metadata()
> +{
> +	sync_mode=$1
> +
> +	# fsync or fdatasync
> +	if [ $sync_mode = "fsync" ]; then
> +		stat_opt='-c "b: %b s: %s a: %x m: %y c: %z"'
> +	else
> +		stat_opt='-c "b: %b s: %s"'
> +	fi
> +
> +	before=`stat "$stat_opt" $testfile`
> +
> +	$XFS_IO_PROG -c "$sync_mode" $testfile | _filter_xfs_io
> +	src/godown $SCRATCH_MNT | tee -a $seqres.full
> +	_scratch_cycle_mount
> +
> +	after=`stat "$stat_opt" $testfile`
> +
> +	if [ "$before" != "$after" ]; then
> +		echo "Before: $before"
> +		echo "After : $after"
> +		status=1;	# this is a failure!
> +	fi
> +	echo "Before: $before" >> $seqres.full
> +	echo "After : $after" >> $seqres.full
> +	rm $testfile
> +}
> +
> +# fallocate XX KB with f{data}sync, followed by power-cut
> +test_falloc()
> +{
> +	echo "==== falloc $2$3 test with $1 ====" | tee -a $seqres.full
> +	$XFS_IO_PROG -f -c "truncate 4202496"	\
> +			-c "pwrite 0 4202496"	\
> +			-c "fsync"		\
> +			-c "falloc $2 4202496 $3"\
> +			$testfile >/dev/null
> +	check_inode_metadata $1
> +}
> +
> +for i in fsync fdatasync; do
> +	test_falloc $i "" 1024
> +	test_falloc $i "" 4096
> +	test_falloc $i "" 104857600
> +	test_falloc $i "-k " 1024
> +	test_falloc $i "-k " 4096
> +	test_falloc $i "-k " 104857600
> +done
> +
> +status = 0

This is wrong in bash, should be "status=0", no spaces between "=" :)
I can fix it on commit too.

Thanks,
Eryu

> +exit
> diff --git a/tests/generic/468.out b/tests/generic/468.out
> new file mode 100644
> index 000000000000..b3a28d5ea07c
> --- /dev/null
> +++ b/tests/generic/468.out
> @@ -0,0 +1,13 @@
> +QA output created by 468
> +==== falloc 1024 test with fsync ====
> +==== falloc 4096 test with fsync ====
> +==== falloc 104857600 test with fsync ====
> +==== falloc -k 1024 test with fsync ====
> +==== falloc -k 4096 test with fsync ====
> +==== falloc -k 104857600 test with fsync ====
> +==== falloc 1024 test with fdatasync ====
> +==== falloc 4096 test with fdatasync ====
> +==== falloc 104857600 test with fdatasync ====
> +==== falloc -k 1024 test with fdatasync ====
> +==== falloc -k 4096 test with fdatasync ====
> +==== falloc -k 104857600 test with fdatasync ====
> diff --git a/tests/generic/group b/tests/generic/group
> index 9183950c8dfc..ea2dc04d931e 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -470,3 +470,4 @@
>  465 auto rw quick aio
>  466 auto quick rw
>  467 auto quick exportfs
> +468 shutdown auto quick metadata
> -- 
> 2.15.0.55.gc2ece9dc4de6
> 
