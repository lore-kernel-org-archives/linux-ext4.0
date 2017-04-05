From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] fstests: generic: Check if cycle mount and sleep can
 affect fiemap result
Date: Wed, 5 Apr 2017 10:35:26 +0800
Message-ID: <20170405023526.GS22845@eguan.usersys.redhat.com>
References: <20170403070923.18518-1-quwenruo@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        linux-ext4@vger.kernel.org
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170403070923.18518-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Apr 03, 2017 at 03:09:23PM +0800, Qu Wenruo wrote:
> As long as we don't modify the on-disk data, fiemap result should always
> be constant.
> 
> Operation like cycle mount and sleep should not affect fiemap result.
> While unfortunately, btrfs doesn't follow that behavior.
> 
> Btrfs fiemap sometimes return merged result, while after cycle mount, it
> returns split result. Furthermore after a snap, btrfs returns merged
> result again.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Test fails with ext3/2 when driving with ext4 driver, fiemap changed
after umount/mount cycle, then changed back to original result after
sleeping some time. An ext4 bug? (cc'ed linux-ext4 list.)

=== Fiemap after dsync write and sleep ===
/vda6/file:
 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
   0: [0..127]:        12288..12415       128 0x1000
   1: [128..255]:      12160..12287       128 0x1000
   2: [256..511]:      16384..16639       256 0x1000
   3: [512..2047]:     16896..18431      1536 0x1000
   4: [2048..4095]:    19456..21503      2048 0x1001
=== Fiemap after cycle mount ===
/vda6/file:
 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
   0: [0..95]:         12288..12383        96 0x1000
   1: [96..127]:       12384..12415        32 0x1000

[0-127] was split to two extents

   2: [128..255]:      12160..12287       128 0x1000
   3: [256..511]:      16384..16639       256 0x1000
   4: [512..2047]:     16896..18431      1536 0x1000
   5: [2048..4095]:    19456..21503      2048 0x1001
=== Fiemap after cycle mount and sleep ===
/vda6/file:
 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
   0: [0..127]:        12288..12415       128 0x1000
   1: [128..255]:      12160..12287       128 0x1000
   2: [256..511]:      16384..16639       256 0x1000
   3: [512..2047]:     16896..18431      1536 0x1000
   4: [2048..4095]:    19456..21503      2048 0x1001

> ---
>  tests/generic/422     | 127 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/422.out |   2 +
>  tests/generic/group   |   1 +
>  3 files changed, 130 insertions(+)
>  create mode 100755 tests/generic/422
>  create mode 100644 tests/generic/422.out
> 
> diff --git a/tests/generic/422 b/tests/generic/422
> new file mode 100755
> index 0000000..4ca4476
> --- /dev/null
> +++ b/tests/generic/422
> @@ -0,0 +1,127 @@
> +#! /bin/bash
> +# FS QA Test 422
> +#
> +# Test if a file system returns constant fiemap result after remount and
> +# fiemap.
> +# Unfortunately, btrfs doesn't follow this behavior.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2017 Fujitsu.  All Rights Reserved.
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
> +_supported_os IRIX Linux
> +_require_scratch

Need _require_fiemap

> +
> +block_size=$((64 * 1024))
> +block_count=32
> +dst=$SCRATCH_MNT/file
> +sleeptime=3
> +
> +# It's almost 100% for btrfs to trigger inconstant fiemap result 

Trailing whitespace in above line.

> +# just in case
> +runtime=$((2 * $LOAD_FACTOR))

I don't think this loop is necessary, as the comments state, it's almost
100% reproducible for btrfs (and for ext2/3 in my testing).

> +
> +# record fiemap as checkpoint, and output the hash of fiemap result
> +# to stdout
> +fiemap_checkpoint()
> +{
> +	local number=$1
> +	local message=$2
> +
> +	echo "=== $message ===" >> $seqres.full
> +	$XFS_IO_PROG -c "fiemap -v" $dst > ${tmp}.cp$number
> +	cat ${tmp}.cp${number} >> $seqres.full
> +
> +	md5sum ${tmp}.cp${number} | cut -d ' ' -f 1
> +}
> +
> +do_test()
> +{
> +	local number=$1
> +
> +	# Use 16 times of file size to ensure we have enough space
> +	_scratch_mkfs_sized $((16 * $block_size * $block_count)) \

Use _require_fs_space for required space. Not all filesystems have
_scratch_mkfs_sized support so this could potentially reduce the
filesystem coverage.

> +		> /dev/null 2>&1
> +	_scratch_mount 

Trailing whitespace issue.

Thanks,
Eryu

> +
> +	echo "====== Loop $number ======" >> $seqres.full
> +	touch $dst
> +	# Xfsprogs 4.9.0 still has a bug that xfs_io "open" with O_SYNC command
> +	# doesn't work well with "pwrite", although it gets fixed in v4.10.0,
> +	# use dd here to avoid it won't hurt for non-xfs developers
> +	dd if=/dev/zero of=$dst bs=$block_size count=$block_count oflag=dsync \
> +		status=none 2>&1
> +
> +	hash1=$(fiemap_checkpoint 1 "Fiemap just after dsync write")
> +
> +	# Sleep should not modify fiemap result
> +	sleep $sleeptime
> +
> +	hash2=$(fiemap_checkpoint 2 "Fiemap after dsync write and sleep")
> +
> +	# cycle mount should not modify fiemap result
> +	_scratch_cycle_mount
> +
> +	hash3=$(fiemap_checkpoint 3 "Fiemap after cycle mount")
> +
> +	# Sleep should not modify fiemap result
> +	sleep $sleeptime
> +
> +	hash4=$(fiemap_checkpoint 4 "Fiemap after cycle mount and sleep")
> +
> +	_scratch_unmount
> +
> +	if [ $hash1 != $hash2 -o $hash2 != $hash3 -o $hash3 != $hash4 ]; then
> +		echo "Inconstant fiemap result detected"
> +	fi
> +	echo >> $seqres.full
> +}
> +
> +for i in $(seq 1 $runtime); do
> +	do_test $i
> +done
> +
> +echo "Silence is golden"
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/422.out b/tests/generic/422.out
> new file mode 100644
> index 0000000..f70693f
> --- /dev/null
> +++ b/tests/generic/422.out
> @@ -0,0 +1,2 @@
> +QA output created by 422
> +Silence is golden
> diff --git a/tests/generic/group b/tests/generic/group
> index 3c7c5e4..86d2325 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -424,3 +424,4 @@
>  419 auto quick encrypt
>  420 auto quick punch
>  421 auto quick encrypt dangerous
> +422 auto
> -- 
> 2.9.3
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
