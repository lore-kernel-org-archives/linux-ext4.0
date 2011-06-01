From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] xfstests: add support for ext4dev FSTYP
Date: Tue, 31 May 2011 23:37:18 -0500
Message-ID: <4DE5C1FE.8080006@redhat.com>
References: <BANLkTimBnAgiXZnvS56eAzEdJ=kw1zVGsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: XFS <xfs@oss.sgi.com>, Sergey Ivanov <sergey57@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <BANLkTimBnAgiXZnvS56eAzEdJ=kw1zVGsg@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 5/31/11 10:13 PM, Amir Goldstein wrote:
> From: Amir Goldstein <amir73il@users.sf.net>
> 
> blkid knows to identify the ext4dev FSTYP of a partition that was
> formatted with mkfs.ext4dev.
> quota tools and various util-linux utils are also aware of ext4dev,
> so ext4dev shares the same capabilities as ext4.
> 
> While testing on Fedora 15, we encoutered a buggy fsck utility, which
> invokes fsck.ext4, even though it was called with -t ext4dev argument.
> In our setup fsck.ext4dev knows about new fs features that fsck.ext4
> doesn't know, so the generic_fs_check fails.
> Since we have no real use of the extra capabilities provided by fsck util,
> we decided to invoke fsck.$FSTYP directly to avoid this issue.

Adding ext4dev to every case seems harmless enough.  TBH I thought I had
it there already but I guess not.

I'm less certain of the change from fsck -t $FSTYP to fsck.$FSTYP

What issue are you avoiding?  wouldn't fsck -t ext4dev invoke fsck.ext4dev anyway?

It seems like it should be harmless, but I don't understand how it helps you.

Thanks,
-Eric

> Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
> Tested-by: Sergey Ivanov <sergey57@gmail.com>
> ---
> ext4dev is used to test experimental ext4 code in mutual existance
> with production ext4 code on the same system.
> 
> Specifically, ext4 snapshots code is available for testing as a
> stand-alone ext4dev module for Fedora 15 and Ubuntu 11.4
> (see http://next3.sf.net).
> 
>  common.defrag |    2 +-
>  common.quota  |    4 ++--
>  common.rc     |   12 ++++++------
>  3 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/common.defrag b/common.defrag
> index 1bcf01d..4850803 100644
> --- a/common.defrag
> +++ b/common.defrag
> @@ -26,7 +26,7 @@ _require_defrag()
>      xfs)
>          DEFRAG_PROG=/usr/sbin/xfs_fsr
>  	;;
> -    ext4)
> +    ext4|ext4dev)
>          DEFRAG_PROG=/usr/bin/e4defrag
>  	;;
>      *)
> diff --git a/common.quota b/common.quota
> index 3c87ce1..9eac19d 100644
> --- a/common.quota
> +++ b/common.quota
> @@ -29,7 +29,7 @@ _require_quota()
>      [ -n $QUOTA_PROG ] || _notrun "Quota user tools not installed"
> 
>      case $FSTYP in
> -    ext2|ext3|ext4|reiserfs)
> +    ext2|ext3|ext4|ext4dev|reiserfs)
>  	if [ ! -d /proc/sys/fs/quota ]; then
>  	    _notrun "Installed kernel does not support quotas"
>  	fi
> @@ -237,7 +237,7 @@ _check_quota_usage()
>  	# Sync to get delalloc to disk
>  	sync
>  	VFS_QUOTA=0
> -	if [ $FSTYP = "ext2" -o $FSTYP = "ext3" -o $FSTYP = "ext4" -o $FSTYP
> = "reiserfs" ]; then
> +	if [ $FSTYP = "ext2" -o $FSTYP = "ext3" -o $FSTYP = "ext4" -o $FSTYP
> = "ext4dev" -o $FSTYP = "reiserfs" ]; then
>  		VFS_QUOTA=1
>  		quotaon -f -u -g $SCRATCH_MNT 2>/dev/null
>  	fi
> diff --git a/common.rc b/common.rc
> index e634fbb..e71fe9c 100644
> --- a/common.rc
> +++ b/common.rc
> @@ -65,7 +65,7 @@ _mount_opts()
>      nfs)
>  	export MOUNT_OPTIONS=$NFS_MOUNT_OPTIONS
>  	;;
> -    ext2|ext3|ext4)
> +    ext2|ext3|ext4|ext4dev)
>  	# acls & xattrs aren't turned on by default on ext$FOO
>  	export MOUNT_OPTIONS="-o acl,user_xattr $EXT_MOUNT_OPTIONS"
>  	;;
> @@ -110,7 +110,7 @@ _mkfs_opts()
>  _fsck_opts()
>  {
>      case $FSTYP in
> -    ext2|ext3|ext4)
> +    ext2|ext3|ext4|ext4dev)
>  	export FSCK_OPTIONS="-nf"
>  	;;
>      reiserfs)
> @@ -326,10 +326,10 @@ _scratch_mkfs_sized()
>      xfs)
>  	_scratch_mkfs_xfs -d size=$fssize -b size=$blocksize
>  	;;
> -    ext2|ext3|ext4)
> +    ext2|ext3|ext4|ext4dev)
>  	/sbin/mkfs.$FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
>  	;;
> -     btrfs)
> +    btrfs)
>  	/sbin/mkfs.$FSTYP $MKFS_OPTIONS $SCRATCH_DEV -b $fssize
>  	;;
>      *)
> @@ -354,7 +354,7 @@ _scratch_mkfs_geom()
>      xfs)
>  	MKFS_OPTIONS+=" -b size=$blocksize, -d su=$sunit_bytes,sw=$swidth_mult"
>  	;;
> -    ext4)
> +    ext4|ext4dev)
>  	MKFS_OPTIONS+=" -b $blocksize -E
> stride=$sunit_blocks,stripe_width=$swidth_blocks"
>  	;;
>      *)
> @@ -1026,7 +1026,7 @@ _check_generic_filesystem()
>          mountpoint=`_umount_or_remount_ro $device`
>      fi
> 
> -    fsck -t $FSTYP $FSCK_OPTIONS $device >$tmp.fsck 2>&1
> +    fsck.$FSTYP $FSCK_OPTIONS $device >$tmp.fsck 2>&1
>      if [ $? -ne 0 ]
>      then
>          echo "_check_generic_filesystem: filesystem on $device is
> inconsistent (see $seq.full)"

