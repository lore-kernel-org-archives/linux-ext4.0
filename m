From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] ext4/004: Add new resize2fs functional test
Date: Fri, 12 Dec 2014 11:21:21 +1100
Message-ID: <20141212002121.GJ24183@dastard>
References: <1418153247-17435-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1418153247-17435-1-git-send-email-dmonakhov@openvz.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Dec 09, 2014 at 11:27:26PM +0400, Dmitry Monakhov wrote:
> Perform online fs-resize(from 1T to 15T) and check that fs is usable
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  tests/ext4/004     | 100 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/ext4/004.out |  16 +++++++++
>  tests/ext4/group   |   1 +
>  3 files changed, 117 insertions(+)
>  create mode 100755 tests/ext4/004
>  create mode 100644 tests/ext4/004.out
> 
> diff --git a/tests/ext4/004 b/tests/ext4/004
> new file mode 100755
> index 0000000..0c54ade
> --- /dev/null
> +++ b/tests/ext4/004
> @@ -0,0 +1,100 @@
> +#! /bin/bash
> +# FS QA Test No. 004
> +#
> +# Online resize2fs functional test
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2014 Dmitry Monakhov.  All Rights Reserved.
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
> +
> +_cleanup()
> +{
> +    _scratch_unmount
> +}

Why the custom cleanup function? It needs to cleanup $tmp, the test
harness will unmount the scratch device.


> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +E2FSCK_PROG="`set_prog_path e2fsck`"
> +RESIZE2FS_PROG="`set_prog_path resize2fs`"
> +_supported_fs ext4
> +_supported_os Linux
> +_require_command $MKFS_EXT4_PROG mkfs.ext4
> +_require_command $E2FSCK_PROG e2fsck
> +_require_command $RESIZE2FS_PROG resize2fs
> +_require_scratch
> +
> +# real QA test starts here
> +_scratch_mkfs  >> $seqres.full 2>&1
> +_scratch_mount
> +mkdir $SCRATCH_MNT/mnt
> +touch $SCRATCH_MNT/img

LOOP_DEV=$SCRATCH_MNT/img
LOOP_MNT=$SCRATCH_MNT/mnt

and use those everywhere.

> +truncate --size 1G $SCRATCH_MNT/img || _fail "Can not grow $SCRATCH_MNT/img"

$XFS_IO_PROG -c "truncate 1g" ....

> +$MKFS_EXT4_PROG -F -b 4096 -i $((1024*1024*64)) $MKFS_OPTIONS -O 64bit $SCRATCH_MNT/img \
> +    >> $seqres.full 2>&1 || _fail "$MKFS_EXT4_PROG failed see $seqres.full"

Indents are 8 space tabs. i.e.

$MKFS_EXT4_PROG -F -b 4096 -i $((1024*1024*64)) \
	$MKFS_OPTIONS -O 64bit $SCRATCH_MNT/img >> $seqres.full 2>&1 || \
	 _fail "$MKFS_EXT4_PROG failed see $seqres.full"

> +
> +for ((size = 1; size < 16; size++))
> +do
> +    truncate --size ${size}T $SCRATCH_MNT/img || _fail "Can not grow $SCRATCH_MNT/img file"
> +    loop=`_create_loop_device $SCRATCH_MNT/img`
> +    _mount -t $FSTYP $MOUNT_OPTIONS $loop $SCRATCH_MNT/mnt
> +
> +    echo "Resize to ${size}T"
> +    $RESIZE2FS_PROG $loop  >> $seqres.full 2>&1 || \
> +	_fail "Could not resize FS to $size Tb"

8 space tabs.

> +    du -sch $SCRATCH_MNT/img >> $seqres.full
> +    # Create space-holders
> +    for ((i=0 ; i < 1000;i++))
> +    do
> +	fallocate -l 1001M $SCRATCH_MNT/mnt/space-$size-$i

$XFS_IO_PROG -c "falloc ...

Also 8 space tabs...

> +    done
> +
> +    # Consume all space remaining
> +    fallocate -l 1T $SCRATCH_MNT/mnt/space-$size-last 2> /dev/null && \
> +	_fail "Too may space consumed"

Same.

> +    # Cut 1Mb for eash space-holders in order to create very fragmented fs
> +    for ((i=0 ; i < 1000;i++))
> +    do
> +	truncate --size 1000M $SCRATCH_MNT/mnt/space-$size-$i

$XFS_IO_PROG -c "truncate 1000m" ....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
