From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v2] xfstests: avoid ext4/306 failures caused by incompatible
 mount options
Date: Fri, 31 Jan 2014 13:24:32 -0600
Message-ID: <52EBF870.1000603@sandeen.net>
References: <20140131155332.GB2385@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>, xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45551 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932271AbaAaTYh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 31 Jan 2014 14:24:37 -0500
In-Reply-To: <20140131155332.GB2385@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/31/14, 9:53 AM, Eric Whitney wrote:
> ext4/306 will fail when mounting the ext3 file system it creates if an
> ext3-incompatible mount option is applied by _scratch_mount.  This can
> happen if EXT_MOUNT_OPTIONS is defined appropriately in the test
> environment.  For example, the block_validity option is commonly used
> to enhance ext4 testing, and it is not supported by ext3.
> 
> Fix this by instead creating an ext4 file system without extents as a
> functionally equivalent substitute.  This will also eliminate a
> dependency for ext3 support on the test system.

this seems like it should be fine, but a quick check[1] makes me think
that it's passing when it should not.  My flexible test boxes are tied up
right now; the fix hit v3.10 (dunno about stable) so we should make sure
this fails on v3.9 before & after your, I guess.

I can try to get to it, or if you do first, let me now :)

-Eric

[1] on an old RHEL5 box so that's a bit of a strange beast

> Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> ---
>  tests/ext4/306 | 21 +++++++--------------
>  1 file changed, 7 insertions(+), 14 deletions(-)
> 
> diff --git a/tests/ext4/306 b/tests/ext4/306
> index 398c4c0..9559cf2 100755
> --- a/tests/ext4/306
> +++ b/tests/ext4/306
> @@ -45,29 +45,22 @@ _supported_os Linux
>  
>  _require_scratch
>  
> -# This needs to mount ext3; might require ext3 driver, or ext4
> -# might handle it itself.  Find out if we have it one way or another.
> -modprobe ext3 > /dev/null 2>&1
> -grep -q ext3 /proc/filesystems || _notrun "This test requires ext3 support"
> -
>  rm -f $seqres.full
>  
> -# Make a small ext3 fs, (extents disabled) & mount it
> -yes | mkfs.ext3 $SCRATCH_DEV 512m >> $seqres.full 2>&1
> -_scratch_mount -t ext3 || _fail "couldn't mount fs as ext3"
> +# Make a small ext4 fs with extents disabled & mount it
> +yes | mkfs.ext4 -O ^extents $SCRATCH_DEV 512m >> $seqres.full 2>&1
> +_scratch_mount || _fail "couldn't mount fs"
> +
>  # Create a small non-extent-based file
>  echo "Create 1m testfile1"
>  $XFS_IO_PROG -f $SCRATCH_MNT/testfile1 -c "pwrite 0 1m" | _filter_xfs_io
> +
> +# Create a large non-extent-based file filling the fs; this will run out & fail
>  echo "Create testfile2 to fill the fs"
> -# A large non-extent-based file filling the fs; this will run out & fail
>  $XFS_IO_PROG -f $SCRATCH_MNT/testfile2 -c "pwrite 0 512m" | _filter_xfs_io
> -
> -# Remount as ext4
> -_scratch_unmount
> -_scratch_mount -t ext4 || _fail "couldn't remount fs as ext4"
>  df -h $SCRATCH_MNT >> $seqres.full
>  
> -# Grow it by 512m
> +# Grow fs by 512m
>  echo "Resize to 1g"
>  resize2fs $SCRATCH_DEV 1g >> $seqres.full 2>&1 || _fail "Could not resize to 1g"
>  df -h $SCRATCH_MNT >> $seqres.full
> 

