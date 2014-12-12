From: Dave Chinner <david@fromorbit.com>
Subject: Re: max_dir_size_kb option list
Date: Fri, 12 Dec 2014 11:55:17 +1100
Message-ID: <20141212005517.GK24183@dastard>
References: <548988D2.3030100@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:44716 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759218AbaLLAzd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Dec 2014 19:55:33 -0500
Content-Disposition: inline
In-Reply-To: <548988D2.3030100@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 11, 2014 at 03:06:42PM +0300, Alexander Tsvetkov wrote:
> Hello,
> 
> I've prepared test for xfstests suite that runs some checks for ext4
> mount option max_dir_size_kb introduced in Linux Kernel 3.7, could
> someone please look on it?
> 
> Thanks,
> Alexander Tsvetkov

> From 21b1da618d0fcb4cd4666d10c41583274ed4eeed Mon Sep 17 00:00:00 2001
> From: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
> Date: Wed, 10 Dec 2014 15:31:02 +0300
> Subject: [PATCH] added test for max_dir_size_kb mount option
> 
> ---
>  tests/ext4/309     | 213 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/ext4/309.out |   2 +
>  tests/ext4/group   |   3 +-
>  3 files changed, 217 insertions(+), 1 deletion(-)
>  create mode 100755 tests/ext4/309
>  create mode 100755 tests/ext4/309.out
> 
> diff --git a/tests/ext4/309 b/tests/ext4/309
> new file mode 100755
> index 0000000..e2f4e43
> --- /dev/null
> +++ b/tests/ext4/309
> @@ -0,0 +1,213 @@
> +#! /bin/bash
> +# FS QA Test
> +#
> +# Test for mount option max_dir_size_kb
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2014 Oracle and/or its affiliates.  All Rights Reserved.
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
> +tmp=/tmp/$$
> +
> +testdir=$SCRATCH_MNT/testdir
> +testfile=$SCRATCH_MNT/testfile

Do not call a file on the scratch device "testdir". That name has
specific meaning: it's the mount point for the test device. Using
the same variable name that differs only different syntax for
somethingon the scratch device is not a good idea.


> +sdir=`dirname $0`
> +sdir=`cd "$sdir"; pwd`

$here is already set to the current xfstests run location. 

> +echo "QA output created by $seq"
> +echo "Silence is golden"
> +rm -f $seqres.full
> +
> +status=1 # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup() {
> +   if [ ! -z SCRATCH_MNT ]; then
> +      rm -fr $SCRATCH_MNT/test*
> +      _scratch_unmount
> +   fi
> +}

No. The harness will unmount the scratch device if it was mounted.
Unless you need to do specific cleanup fo rthe test, do not modify
the standard cleanup function. At minimum, it still needs to remove
all the $tmp files created during the test run.


> +
> +_filter_error() {
> +   sed -n -e "s/.*\($1\).*/\"\1\"/p"
> +}

"_" prefix is reserved for library functions.

Comments are generally required to explain the intent of regexs that
look like line noise.

8 space tabs.

> +
> +_clear_testdir() {
> +   dirs="$testdir *$"
> +   for i in $dirs; do
> +      rm -fr $i/*
> +   done
> +}

I thought this was going to clean up the TEST_DIR, but as per above,
it's actually doing stuff to the scratch device. "remove_files()"
is good enough....

> +
> +# $1 - device
> +# $2 - options
> +_make_ext4fs() {
> +   device=$1
> +   opts=$2
> +   umount $device 1>/dev/null 2>&1
> +   mkfs.ext4 $opts $device 1>/dev/null 2>&1
> +}

_mkfs_dev

> +# $1 - options
> +# $2 - mount point
> +_make_loopfs() {
> +   lpf=$testfile
> +   dd if=/dev/zero of=$lpf bs=4k count=256 1>/dev/null 2>&1
> +   loopdev=$(losetup -f)
> +   losetup $loopdev $lpf
> +   mkfs.ext4 -O ^dir_index,^has_journal $loopdev 1>/dev/null 2>&1
> +   mount -t ext4 $1 $loopdev $2
> +}

no need to create a loop device. mount -o loop will do what you
want. Also, $MKFS_EXT4_PROG (or whatever the var is) shoul dbe used.
As should _mount. And 8 space tabs.


> +
> +# $1 - expected limit after items creation
> +# $2 - command to create item
> +# $3 - where to create (testdir by default)
> +_create_items() {
> +    limit=$1
> +    create_cmd=$2
> +    dir=${3:-$testdir}
> +    sync
> +    echo 3 > /proc/sys/vm/drop_caches
> +    MAX_INUM=$(((limit*1024*2)/24))
> +    for i in $(seq 0 $MAX_INUM); do
> +       tmp_name=`mktemp -u`

We use $tmp as the location for temporary files in tests

> +       item=`basename $tmp_name`
> +       if [ -e $dir/$item ]; then
> +          continue
> +       fi 

Why?

> +       create_cmd="$2 $dir/$item 2>$tmp.out 1>/dev/null"
> +       eval "$create_cmd"
> +       res=$?
> +       if [ $res -ne 0 ]; then
> +          _filter_error "No space left on device" < $tmp.out > $tmp.out2
> +          if [ -s $tmp.out2 ]; then
> +             cat $tmp.out2 | tr -d '\n' >> $seqres.full
> +          else
> +             echo "FAIL! expected ENOSPC" | tee -a $seqres.full

_fail?

> +          fi
> +          break
> +      fi

This all seems rather convoluted. You're creating a tmp file to
capture the error, then if you get an ENOSPC error you dump it to
the debug file, otherwise you dump an error message to main output
to cause the test to eventually fail? 

> +   done
> +   size=$(stat -c %s $dir)
> +   size=$((size/1024))
> +   if [ $size -gt $limit ]; then
> +      echo "FAIL! expected dir size: $limit, actually: $size" | tee -a $seqres.full
> +   fi
> +   rm -f $tmp*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +
> +# real QA test starts here
> +
> +_supported_fs ext4
> +_supported_os Linux
> +_require_scratch

_require_loop

> +
> +LIMIT1=8
> +LIMIT2=16
> +
> +_make_ext4fs $SCRATCH_DEV "-O ^dir_index,^filetype"

_scratch_mkfs -O ^dir_index,^filetype


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
