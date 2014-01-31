From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v2] xfstests: avoid ext4/306 failures caused by
	incompatible mount options
Date: Fri, 31 Jan 2014 14:42:01 -0600
Message-ID: <52EC0A99.8080702@sandeen.net>
References: <20140131155332.GB2385@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>, xfs@oss.sgi.com
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <20140131155332.GB2385@wallace>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

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
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Looks good, thanks for double checking the old kernel.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
