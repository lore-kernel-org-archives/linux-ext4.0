From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] generic/017: skip tests with mkfs failures
Date: Tue, 7 Oct 2014 10:21:14 +1100
Message-ID: <20141006232114.GK2301@dastard>
References: <1412619830-23088-1-git-send-email-paul.paulson@seagate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Paul Paulson <paul.paulson@seagate.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:15338 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750859AbaJFXeK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Oct 2014 19:34:10 -0400
Content-Disposition: inline
In-Reply-To: <1412619830-23088-1-git-send-email-paul.paulson@seagate.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 06, 2014 at 01:23:50PM -0500, Paul Paulson wrote:
> The mkfs command fails to create ext4 filesystems on partition sizes
> greater than 1998080 MiB when using 1024 byte blocks and the default
> calculation for the number of inodes reserved for the filesystem.

This is what the MKFS_OPTIONS field is for. We don't usually try to
work around specific perculiarities of specific filesystem configs
in individual tests.

> The following error message is produced when the maximum number of
> inodes is exceeded:
> 
>     "Cannot create filesystem with requested number of inodes while
>      setting up superblock"
> 
> The generic/017 test was modified to skip the 1K block size test
> for partitions with an inode count that exceeds the maximum.

Oh, I thought we got rid of the multiple block size loop in that
test.

Hmm - maybe I missed picking up that patch from Lucas after we
discussed it. I'll go back and pick it up, and then you won't have
this problem when testing default filesystem configs.

> diff --git a/tests/generic/017 b/tests/generic/017
> index 13b7254..eb38d4d 100755
> --- a/tests/generic/017
> +++ b/tests/generic/017
> @@ -49,8 +49,16 @@ _do_die_on_error=y
>  testfile=$SCRATCH_MNT/$seq.$$
>  BLOCKS=10240
>  
> -for (( BSIZE = 1024; BSIZE <= 4096; BSIZE *= 2 )); do
> +MAX_INODE_COUNT_1K=127877120
> +inode_count=`$TUNE2FS_PROG -l $SCRATCH_DEV | awk '/Inode count:/ { print $3 }'`
> +initial_bsize=$(($inode_count <= $MAX_INODE_COUNT_1K ? 1024 : 2048))

FWIW, that'll break every filesystem type other than ext4.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
