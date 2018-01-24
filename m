From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v4] ext4: Ext4 online resize with bigalloc tests.
Date: Wed, 24 Jan 2018 14:37:48 +0800
Message-ID: <20180124063748.GA16904@eguan.usersys.redhat.com>
References: <20180111070740.GE5123@eguan.usersys.redhat.com>
 <20180123215357.261381-1-harshads@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: harshads <harshads@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59556 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752206AbeAXGhu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 24 Jan 2018 01:37:50 -0500
Content-Disposition: inline
In-Reply-To: <20180123215357.261381-1-harshads@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 23, 2018 at 01:53:57PM -0800, harshads wrote:
> Add tests to verify Ext4 online resizing feature with bigalloc feature
> enabled. We test various resizing scenarios with different cluster
> sizes.
> 
> Signed-off-by: Harshad Shirwadkar <harshads@google.com>

Looks good to me, thanks! Just two minor issues inline.

> ---
>  tests/ext4/030     | 174 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/ext4/030.out | 172 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/ext4/group   |   1 +
>  3 files changed, 347 insertions(+)
>  create mode 100755 tests/ext4/030
>  create mode 100644 tests/ext4/030.out
> 
> diff --git a/tests/ext4/030 b/tests/ext4/030
> new file mode 100755
> index 00000000..9e91b96a
> --- /dev/null
> +++ b/tests/ext4/030
> @@ -0,0 +1,174 @@
> +#! /bin/bash
> +# FS QA Test ext4/030
> +#
> +# Ext4 online resize tests of small and crucial resizes with bigalloc
> +# feature.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2017 Google, Inc.  All Rights Reserved.
> +#
> +# Author: Harshad Shirwadkar <harshads@google.com>
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,	 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#-----------------------------------------------------------------------
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
> +BLK_SIZ=4096
> +CLUSTER_SIZ=4096
> +
> +IMG_FILE=$SCRATCH_DIR/$seq.fs
> +IMG_MNT=$SCRATCH_DIR/$seq.mnt
> +
> +## Num clusters to blocks.
> +c2b()
> +{
> +	local clusters=$1
> +	echo $(($clusters * $CLUSTER_SIZ / $BLK_SIZ))
> +}
> +
> +_ext4_online_resize()
> +{
> +	## sizes are in number of blocks.
> +	local original_size=$1
> +	local final_size=$2
> +
> +	## Start with a clean image file.
> +	echo "" > ${IMG_FILE}
> +	echo "+++ truncate image file to $final_size" | \
> +		tee -a $seqres.full
> +	$XFS_IO_PROG -f -c "truncate $(($final_size * $BLK_SIZ))" ${IMG_FILE}
> +	LOOP_DEVICE=`_create_loop_device $IMG_FILE || _fail "losetup failed"`
> +
> +	echo "+++ create fs on image file $original_size" | \
> +		tee -a $seqres.full
> +
> +	${MKFS_PROG}.${FSTYP} -F -O bigalloc,resize_inode -C $CLUSTER_SIZ \
> +		-b $BLK_SIZ ${LOOP_DEVICE} $original_size >> \
> +		$seqres.full 2>&1 || _fail "mkfs failed"
> +
> +	echo "+++ mount image file" | tee -a $seqres.full
> +	$MOUNT_PROG -t ${FSTYP} ${LOOP_DEVICE} ${IMG_MNT} > \
> +		/dev/null 2>&1 || _fail "mount failed"
> +
> +	echo "+++ resize fs to $final_size" | tee -a $seqres.full
> +
> +	resize2fs -f ${LOOP_DEVICE} $final_size >> \
> +		  $seqres.full 2>&1 || return 1
> +
> +	echo "+++ umount fs" | tee -a $seqres.full
> +	$UMOUNT_PROG ${IMG_MNT}
> +
> +	echo "+++ check fs" | tee -a $seqres.full
> +	_check_generic_filesystem $LOOP_DEVICE >> $seqres.full 2>&1 || \
> +		_fail "fsck should not fail"
> +	_destroy_loop_device $LOOP_DEVICE && LOOP_DEVICE=
> +}
> +
> +_cleanup()
> +{
> +	cd /
> +	[ -n "$LOOP_DEVICE" ] && _destroy_loop_device $LOOP_DEVICE > /dev/null 2>&1
> +	rm -f $tmp.*
> +	$UMOUNT_PROG ${IMG_MNT} > /dev/null 2>&1
> +	rm -f ${IMG_FILE} > /dev/null 2>&1
> +}
> +
> +# get standard environment and checks
> +. ./common/rc
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs ext4
> +_supported_os Linux
> +
> +_require_loop
> +_require_scratch
> +# We use resize_inode to make sure that block group descriptor table
> +# can be extended.
> +_require_scratch_ext4_feature "bigalloc,resize_inode,metadata_csum"

What about metadata_csum? Seems it's not used in the actual resize test.
Meant to delete it?

> +
> +_scratch_mkfs >>$seqres.full 2>&1
> +_scratch_mount
> +
> +rm -f $seqres.full
> +
> +mkdir -p $IMG_MNT || _fail "cannot create loopback mount point"
> +
> +# Check if online resizing with bigalloc is supported by the kernel
> +_ext4_online_resize 4096 8192 || \
> +	_notrun "Kernel doesn't support online resizing with bigalloc"

Hmm, how do we tell if it's a test failure or lack of kernel support?
How about adding an extra argument to ext4_online_resize to indicate
that this is a test run, so it checks resize2fs output to see if the
failure is really due to lacking support in kernel. Otherwise we treat
all resize2fs failures as bugs.

e.g. resize2fs prints:
"resize2fs: Operation not supported While checking for on-line resizing support"

Thanks,
Eryu
