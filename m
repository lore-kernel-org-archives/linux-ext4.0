From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: mount other filesystems with selinux context
 as well
Date: Mon, 28 Nov 2011 06:02:28 -0500
Message-ID: <20111128110228.GC13766@infradead.org>
References: <4ECD3262.105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs-oss <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:51703
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752281Ab1K1LCa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Nov 2011 06:02:30 -0500
Content-Disposition: inline
In-Reply-To: <4ECD3262.105@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 23, 2011 at 11:50:26AM -0600, Eric Sandeen wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> For some reason, non-xfs filesystems aren't getting mounted with
> the selinux context; perhaps because none of the xattr tests used
> to work on anything but xfs?
> 
> Anyway, 062 fails for extN unless we mount with the fs-wide
> context.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> - ---
> 
> diff --git a/common.rc b/common.rc
> index cab0b64..5998ff2 100644
> - --- a/common.rc
> +++ b/common.rc
> @@ -86,14 +86,17 @@ _mount_opts()
>  	export MOUNT_OPTIONS=$NFS_MOUNT_OPTIONS
>  	;;
>      ext2|ext3|ext4|ext4dev)
> - -	# acls & xattrs aren't turned on by default on ext$FOO
> +	export SELINUX_MOUNT_OPTIONS
> +	# acls & xattrs aren't turned on by default on ext$FOO in old kernels
>  	export MOUNT_OPTIONS="-o acl,user_xattr $EXT_MOUNT_OPTIONS"
>  	;;
>      reiserfs)
> +	export SELINUX_MOUNT_OPTIONS
>  	# acls & xattrs aren't turned on by default on reiserfs
>  	export MOUNT_OPTIONS="-o acl,user_xattr $REISERFS_MOUNT_OPTIONS"
>  	;;
>      gfs2)
> +	export SELINUX_MOUNT_OPTIONS
>  	# acls aren't turned on by default on gfs2
>  	export MOUNT_OPTIONS="-o acl $GFS2_MOUNT_OPTIONS"
>  	;;

shouldn't the "export SELINUX_MOUNT_OPTIONS" simply move to common code?

