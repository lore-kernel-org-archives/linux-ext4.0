From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Add XIP functionality
Date: Mon, 2 Dec 2013 09:34:59 +0100
Message-ID: <20131202083459.GA2305@quack.suse.cz>
References: <1384811492-37040-1-git-send-email-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: andreas.dilger@intel.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57996 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199Ab3LBIfC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Dec 2013 03:35:02 -0500
Content-Disposition: inline
In-Reply-To: <1384811492-37040-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Mon 18-11-13 14:51:32, Ross Zwisler wrote:
> This is a port of the XIP functionality found in the current version =
of
> ext2.  This patch set is intended to achieve feature parity with XIP =
in
> ext2 rather than non-XIP in ext4.=A0 In particular, it lacks support =
for
> splice and AIO.=A0 We'll be submitting patches in the future to add t=
hat
> functionality, but we think this is a good start.
>=20
> There are also a couple of bugs that also appear in ext2 around handl=
ing
> of the xip mount option; we're currently investigating and will submi=
t
> patches to fix both in ext2 and ext4, but didn't want to delay gettin=
g
> this patch out for comment.
>=20
> The motivation behind this work is that we believe that the XIP featu=
re
> will begin to find new uses as various persistent memory devices and
> technologies come on to the market.  Having direct, byte-addressable
> access to persistent memory without having an additional copy in the
> page cache can be a win in terms of I/O latency and overall memory
> usage.
  Yes, I believe implementing XIP in ext4 is desirable. It is the only
ext2 feature I'm aware of that is missing from ext4.

> This patch applies cleanly to v3.12, and was tested using brd as our
> block driver.
>=20
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
> ---
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index e274e9c..dea66bb 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
=2E..
> @@ -4645,11 +4673,19 @@ int ext4_setattr(struct dentry *dentry, struc=
t iattr *attr)
>  			} else
>  				ext4_wait_for_tail_page_commit(inode);
>  		}
> -		/*
> -		 * Truncate pagecache after we've waited for commit
> -		 * in data=3Djournal mode to make pages freeable.
> -		 */
> +
> +		if (mapping_is_xip(inode->i_mapping)) {
> +			error =3D xip_truncate_page(inode->i_mapping,
> +						  inode->i_size);
> +			if (error)
> +				goto err_out;
> +		} else {
> +			/*
> +			 * Truncate pagecache after we've waited for commit
> +			 * in data=3Djournal mode to make pages freeable.
> +			 */
>  			truncate_pagecache(inode, inode->i_size);
> +		}
>  	}
>  	/*
>  	 * We want to call ext4_truncate() even if attr->ia_size =3D=3D
  Umm, much more logical place for this would be in ext4_truncate() at =
the
place where we do ext4_block_truncate_page(). Because xip_truncate_page=
()
does what ext4_block_truncate_page() does.

Also thinking about it for a while you must call truncate_pagecache() i=
n
XIP mode as well to unmap PTEs removed by truncate. In ext2 this is hid=
den
in truncate_setsize() call...

Also you seem to be missing any hole punching support at all. For that
you'd need to modify xip_truncate_page() to accept not only offset but =
also
length of the truncate area (a separate patch please). And then you wil=
l
need to use that function from ext4_punch_hole() at the place where
ext4_zero_partial_blocks() is used.

=46inally, as Matthew Wilcox pointed out
(http://www.spinics.net/lists/linux-fsdevel/msg70582.html) there's a ra=
ce
between truncate and mmap in xip support because xip is missing
serialization on page locks. So I believe we should solve that when we =
are
growing XIP support in another filesystem... Probably using mmap_sem fo=
r
that might be viable but I have to try.

> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 2c2e6cb..18e70d2 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
=2E..
> @@ -3525,11 +3532,19 @@ static int ext4_fill_super(struct super_block=
 *sb, void *data, int silent)
>  		}
>  		if (test_opt(sb, DELALLOC))
>  			clear_opt(sb, DELALLOC);
> +		if (test_opt(sb, XIP)) {
> +			ext4_msg(sb, KERN_ERR, "can't mount with "
> +				 "both data=3Djournal and xip");
> +			goto failed_mount;
> +		}
>  	}
> =20
>  	sb->s_flags =3D (sb->s_flags & ~MS_POSIXACL) |
>  		(test_opt(sb, POSIX_ACL) ? MS_POSIXACL : 0);
> =20
> +	ext4_xip_verify_sb(sb); /* see if bdev supports xip, unset
> +				    EXT4_MOUNT_XIP if not */
> +
  I don't like clearing the flag inside this function. Just opencode th=
e
function here please (I don't think the other call site at ext4_remount=
()
makes sense at all).

>  	if (le32_to_cpu(es->s_rev_level) =3D=3D EXT4_GOOD_OLD_REV &&
>  	    (EXT4_HAS_COMPAT_FEATURE(sb, ~0U) ||
>  	     EXT4_HAS_RO_COMPAT_FEATURE(sb, ~0U) ||
> @@ -3576,6 +3591,13 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
>  		goto failed_mount;
>  	}
> =20
> +	if (ext4_use_xip(sb) && blocksize !=3D PAGE_SIZE) {
> +		if (!silent)
> +			ext4_msg(sb, KERN_ERR,
> +				"error: unsupported blocksize for xip");
> +		goto failed_mount;
> +	}
> +
>  	if (sb->s_blocksize !=3D blocksize) {
>  		/* Validate the filesystem blocksize */
>  		if (!sb_set_blocksize(sb, blocksize)) {
> @@ -4707,6 +4729,7 @@ static int ext4_remount(struct super_block *sb,=
 int *flags, char *data)
>  	struct ext4_super_block *es;
>  	struct ext4_sb_info *sbi =3D EXT4_SB(sb);
>  	unsigned long old_sb_flags;
> +	unsigned long old_mount_opt =3D sbi->s_mount_opt;
>  	struct ext4_mount_options old_opts;
>  	int enable_quota =3D 0;
>  	ext4_group_t g;
> @@ -4773,7 +4796,23 @@ static int ext4_remount(struct super_block *sb=
, int *flags, char *data)
>  	sb->s_flags =3D (sb->s_flags & ~MS_POSIXACL) |
>  		(test_opt(sb, POSIX_ACL) ? MS_POSIXACL : 0);
> =20
> +	ext4_xip_verify_sb(sb); /* see if bdev supports xip, unset
> +				    EXT4_MOUNT_XIP if not */
> +
> +	if (ext4_use_xip(sb) && sb->s_blocksize !=3D PAGE_SIZE) {
> +		ext4_msg(sb, KERN_WARNING,
> +			"warning: unsupported blocksize for xip");
> +		err =3D -EINVAL;
> +		goto restore_opts;
> +	}
> +
>  	es =3D sbi->s_es;
> +	if ((sbi->s_mount_opt ^ old_mount_opt) & EXT4_MOUNT_XIP) {
> +		ext4_msg(sb, KERN_WARNING, "warning: refusing change of "
> +			 "xip flag with busy inodes while remounting");
> +		sbi->s_mount_opt &=3D ~EXT4_MOUNT_XIP;
> +		sbi->s_mount_opt |=3D old_mount_opt & EXT4_MOUNT_XIP;
> +	}
  So why do you bother with ext4_xip_verify_sb() and other stuff when y=
ou
disallow remount to change xip flag anyway (which I think makes sense)?

>  	if (sbi->s_journal) {
>  		ext4_init_journal_params(sb, sbi->s_journal);
> diff --git a/fs/ext4/xip.c b/fs/ext4/xip.c
> new file mode 100644
> index 0000000..e0a430a
> --- /dev/null
> +++ b/fs/ext4/xip.c
> @@ -0,0 +1,91 @@
> +/*
> + *  linux/fs/ext4/xip.c
> + *
> + * Copyright (C) 2005 IBM Corporation
> + * Author: Carsten Otte (cotte@de.ibm.com)
> + */
> +
> +#include <linux/mm.h>
> +#include <linux/fs.h>
> +#include <linux/genhd.h>
> +#include <linux/buffer_head.h>
> +#include <linux/blkdev.h>
> +#include "ext4.h"
> +#include "xip.h"
> +
> +static inline int
> +__inode_direct_access(struct inode *inode, sector_t block,
> +		      void **kaddr, unsigned long *pfn)
> +{
> +	struct block_device *bdev =3D inode->i_sb->s_bdev;
> +	const struct block_device_operations *ops =3D bdev->bd_disk->fops;
> +	sector_t sector;
> +
> +	sector =3D block * (PAGE_SIZE / 512); /* ext4 block to bdev sector =
*/
> +
> +	BUG_ON(!ops->direct_access);
> +	return ops->direct_access(bdev, sector, kaddr, pfn);
> +}
> +
> +static inline int
> +__ext4_get_block(struct inode *inode, pgoff_t pgoff, int create,
> +		   sector_t *result)
> +{
> +	struct buffer_head tmp;
> +	int rc;
> +
> +	memset(&tmp, 0, sizeof(struct buffer_head));
> +	tmp.b_size =3D inode->i_sb->s_blocksize;
> +	rc =3D ext4_get_block(inode, pgoff, &tmp, create);
> +	*result =3D tmp.b_blocknr;
  Please use ext4_map_blocks() directly. There's no need to go via
ext4_get_block() with its suboptimal buffer_head interface...

> +	/* did we get a sparse block (hole in the file)? */
> +	if (!tmp.b_blocknr && !rc) {
> +		BUG_ON(create);
> +		rc =3D -ENODATA;
> +	}
> +
> +	return rc;
> +}
> +

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
