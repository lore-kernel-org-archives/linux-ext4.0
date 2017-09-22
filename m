From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] generic: Add nocheck shutdown stress test
Date: Fri, 22 Sep 2017 16:05:02 +0800
Message-ID: <20170922080502.GD8034@eguan.usersys.redhat.com>
References: <20170921213443.41654-1-khazhy@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, tytso@mit.edu
To: Khazhismel Kumykov <khazhy@google.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170921213443.41654-1-khazhy@google.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 21, 2017 at 02:34:43PM -0700, Khazhismel Kumykov wrote:
> Most shutdown tests only run on filesystems with metadata journaling, so
> we lose coverage. Add a shutdown stress test that doesn't check for
> consistency, so does not require journaling.
> 
> Signed-off-by: Khazhismel Kumykov <khazhy@google.com>

Test looks reasonable to me, some minor issues inline.

> ---
>  tests/generic/999     | 84 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/999.out |  2 ++
>  tests/generic/group   |  1 +
>  3 files changed, 87 insertions(+)
>  create mode 100755 tests/generic/999
>  create mode 100644 tests/generic/999.out
> 
> diff --git a/tests/generic/999 b/tests/generic/999
> new file mode 100755
> index 00000000..71b9aa4c
> --- /dev/null
> +++ b/tests/generic/999
> @@ -0,0 +1,84 @@
> +#!/bin/bash
> +# FS QA Test No. 999
> +#
> +# Shutdown stress test - exercise shutdown codepath with fsstress,
> +# make sure we don't BUG/WARN. Coverage for all fs with shutdown.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2013 Red Hat, Inc.  All Rights Reserved.
> +# Copyright (c) 2017 Google, Inc.  All Rights Reserved.

Why Red Hat copyright? Is this based on a RH test?

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
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +_cleanup()
> +{
> +	cd /
> +	_scratch_unmount 2>/dev/null
> +	rm -f $tmp.*
> +}
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +
> +_require_scratch_nocheck
> +_require_scratch_shutdown
> +_require_command "$KILLALL_PROG" killall
> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs > $seqres.full 2>&1
> +_scratch_mount
> +
> +SLEEP_TIME=$((10 * $TIME_FACTOR))
> +PROCS=$((4 * LOAD_FACTOR))
> +
> +load_dir=$SCRATCH_MNT/test
> +
> +$XFS_FSR_PROG -v $load_dir >> $seqres.full 2>&1

$load_dir is not created yet, xfs_fsr always fails with ENOENT. But even
with $load_dir created, it seems xfs_fsr only accepts a block device
name or a file name or the XFS mount point. And this only works for XFS.

Further more, I don't think we need to do defrag here, it's a newly
created filesystem and xfs_fsr (or e4defrag) exits quickly, as there's
nothing to defrag.

> +$FSSTRESS_PROG $FSSTRESS_AVOID -n10000000 -p $PROCS -d $load_dir >> $seqres.full 2>&1 &
> +sleep $SLEEP_TIME
> +sync
> +
> +# now shutdown and unmount
> +sleep 5
> +$here/src/godown $load_dir
> +$KILLALL_PROG -q $FSSTRESS_PROG
> +wait
> +
> +# for some reason fsstress processes manage to live on beyond the wait?
> +sleep 5
> +
> +_scratch_unmount
> +
> +echo "No output is good. Failures are loud."

Better to be consistent with other tests here :)

echo "Silence is golden"

Thanks,
Eryu

> +
> +status=0
> +exit
> diff --git a/tests/generic/999.out b/tests/generic/999.out
> new file mode 100644
> index 00000000..68a51fe7
> --- /dev/null
> +++ b/tests/generic/999.out
> @@ -0,0 +1,2 @@
> +QA output created by 999
> +No output is good. Failures are loud.
> diff --git a/tests/generic/group b/tests/generic/group
> index f922b496..891386ac 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -463,3 +463,4 @@
>  458 auto quick clone
>  459 auto dangerous
>  460 auto quick rw
> +999 auto shutdown stress
> -- 
> 2.14.1.821.g8fa685d3b7-goog
> 
