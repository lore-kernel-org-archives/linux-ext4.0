From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: ext34_free_inode's mess
Date: Wed, 14 Apr 2010 15:35:14 +0400
Message-ID: <87ljcq468d.fsf@openvz.org>
References: <87pr2246y4.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:31026 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004Ab0DNLfV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Apr 2010 07:35:21 -0400
In-Reply-To: <87pr2246y4.fsf@openvz.org> (Dmitry Monakhov's message of "Wed,
	14 Apr 2010 15:19:47 +0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dmitry Monakhov <dmonakhov@openvz.org> writes:

> I've finally automated my favorite testcase (see attachment), 
> before i've run it by hand.
> And sometimes i've saw following complain from fsck:
BTW sometimes i've saw other corruption
e2fsck -fn /dev/sdb2
e2fsck 1.41.9 (22-Aug-2009)
Pass 1: Checking inodes, blocks, and sizes
Inode 69, i_blocks is 439472, should be 439480.  Fix? no
...

By unknown reason node extent's block wasn't accounted 
in to i_blocks. Now I'm digging in to that issue.
Currently I'm suspecting uninit=>init codepath
> fsck.ext4 -f -n /dev/sdb2
> ...
> Pass 5: Checking group summary information
> Inode bitmap differences:  -93582
> Fix? no
>
> Free inodes count wrong for group #12 (4634, counted=4633).
> Fix? no
>
> Free inodes count wrong (35610, counted=35609).
> Fix? no
> ...
>
> I've started to look an inode bitmap manipulation code paths
> and found strange logic in ext{3,4}_free_inode functions
>
> 1) Group lock acquired twice for bitmap and for group_desc.
>    There are not any advantage from this double locking, only
>    error path(where the bit is already cleared) takes an
>    advantage from this locking schema.
>    It is reasonable to batch it in to one locking block.
> 2) if we failed to read gdp then bh2 is undefined so
>    may result in oops due to undefince pointer dereferance.
> 3) if we failed to get write_access to gdp we skip
>    handle_dirty_metadata for inode_bitmap which is also a bug.
>
> I've redesigned free_inode logic(see later two emails) and
> currently i'm not able to reproduce the bug, but i can not
> guarantee it is goes away.
>
> From 1857fc6c7349a67cf930e73b802427a138e43456 Mon Sep 17 00:00:00 2001
> From: Dmitry Monakhov <dmonakhov@openvz.org>
> Date: Wed, 14 Apr 2010 14:53:47 +0400
> Subject: [PATCH] xfstests-dev: add one more stress test
>
> During stress testing we want to cover most of code paths.
> fsstress is very good for this purpose. But it has expandable
> nature (disk usage almost continually grow). So once we
> goes it no ENOSPC condition we will be where till the end.
>
> But by running 'dd' in parallel we can regularly trigger
> ENOSPC but only for a limited periods of time.
>
> This is my favorite stress test-case configuration.
> ---
>  227     |  105 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  227.out |    5 +++
>  group   |    1 +
>  3 files changed, 111 insertions(+), 0 deletions(-)
>  create mode 100755 227
>  create mode 100644 227.out
>
> diff --git a/227 b/227
> new file mode 100755
> index 0000000..d2b0c7d
> --- /dev/null
> +++ b/227
> @@ -0,0 +1,105 @@
> +#! /bin/bash
> +# FS QA Test No. 227
> +#
> +# Perform fsstress test with parallel dd
> +# This proven to be a good stress test
> +# * Continuous dd retult in ENOSPC condition but only for a limited periods
> +#   of time.
> +# * Fsstress test cover many code paths
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2010 Dmitry Monakhov.  All Rights Reserved.
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
> +#
> +#-----------------------------------------------------------------------
> +#
> +# creator
> +owner=dmonakhov@openvz.org
> +
> +seq=`basename $0`
> +echo "QA output created by $seq"
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +
> +_cleanup()
> +{
> +    rm -f $tmp.*
> +}
> +
> +workout()
> +{
> +    # Disable bash job controll, to prevent message about killed task.
> +    set +m
> +
> +    #Timing parameters
> +    nr_iterations=5
> +    kill_tries=20
> +    echo Running fsstress. | tee -a $seq.full
> +
> +####################################################
> +##    -f unresvsp=0 -f allocsp=0 -f freesp=0 \
> +##    -f setxattr=0 -f attr_remove=0 -f attr_set=0 \
> +## 
> +######################################################
> +    mkdir -p $SCRATCH_MNT/fsstress
> +    # It is reasonable to disable sync, otherwise most of tasks will simply
> +    # stuck in that sync() call.
> +    $FSSTRESS_PROG \
> +	-d $SCRATCH_MNT/fsstress \
> +	-p 100 -f sync=0  -n 9999999 > /dev/null 2>&1 &
> +
> +    echo Running ENOSPC hitters. | tee -a $seq.full
> +    for ((i = 0; i < $nr_iterations; i++))
> +    do
> +	#Open with O_TRUNC and then write until error
> +	#hit ENOSPC each time.
> +	dd if=/dev/zero of=$SCRATCH_MNT/BIG_FILE bs=1M 2> /dev/null
> +    done
> +
> +    for ((i = 0; i < $kill_tries; i++))
> +    do
> +	killall -r -q -TERM fsstress 2> /dev/null
> +	sleep 1
> +    done
> +}
> +
> +trap "_cleanup ; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.filter
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +_require_scratch
> +
> +rm -f $seq.full
> +
> +umount $TEST_DEV >/dev/null 2>&1
> +umount $SCRATCH_DEV >/dev/null 2>&1
> +echo "*** MKFS ***"                         >>$seq.full
> +echo ""                                     >>$seq.full
> +_scratch_mkfs    >/dev/null 2>&1 || _fail "mkfs failed"
> +_scratch_mount   >/dev/null 2>&1 || _fail "mount failed"
> +
> +workout
> +umount $SCRATCH_MNT
> +echo 
> +echo Checking filesystem
> +_check_scratch_fs
> +status=$?
> +exit
> diff --git a/227.out b/227.out
> new file mode 100644
> index 0000000..6a7342d
> --- /dev/null
> +++ b/227.out
> @@ -0,0 +1,5 @@
> +QA output created by 227
> +Running fsstress.
> +Running ENOSPC hitters.
> +
> +Checking filesystem
> diff --git a/group b/group
> index 8d4a83a..81a2aa4 100644
> --- a/group
> +++ b/group
> @@ -339,3 +339,4 @@ deprecated
>  223 auto quick
>  224 auto
>  225 auto quick
> +227 rw auto prealloc enospc
> \ No newline at end of file
