From: Jan Kara <jack@suse.cz>
Subject: Re: + ext2-get-rid-of-most-mentions-of-xip-in-ext2.patch added to
 -mm tree
Date: Thu, 15 Jan 2015 11:30:36 +0100
Message-ID: <20150115103036.GE12739@quack.suse.cz>
References: <54b4548f.X6zUbiROuSfruGuT%akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, andreas.dilger@intel.com,
	axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com,
	hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com,
	mathieu.desnoyers@efficios.com, rdunlap@infradead.org,
	ross.zwisler@linux.intel.com, tytso@mit.edu,
	mm-commits@vger.kernel.org, linux-ext4@vger.kernel.org
To: matthew.r.wilcox@intel.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47408 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbbAOKan (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Jan 2015 05:30:43 -0500
Content-Disposition: inline
In-Reply-To: <54b4548f.X6zUbiROuSfruGuT%akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 12-01-15 15:11:11, Andrew Morton wrote:
...
> diff -puN fs/ext2/ext2.h~ext2-get-rid-of-most-mentions-of-xip-in-ext2 fs/ext2/ext2.h
> --- a/fs/ext2/ext2.h~ext2-get-rid-of-most-mentions-of-xip-in-ext2
> +++ a/fs/ext2/ext2.h
> @@ -380,14 +380,15 @@ struct ext2_inode {
>  #define EXT2_MOUNT_NO_UID32		0x000200  /* Disable 32-bit UIDs */
>  #define EXT2_MOUNT_XATTR_USER		0x004000  /* Extended user attributes */
>  #define EXT2_MOUNT_POSIX_ACL		0x008000  /* POSIX Access Control Lists */
> -#ifdef CONFIG_FS_DAX
> -#define EXT2_MOUNT_XIP			0x010000  /* Execute in place */
> -#else
> -#define EXT2_MOUNT_XIP			0
> -#endif
> +#define EXT2_MOUNT_XIP			0x010000  /* Obsolete, use DAX */
>  #define EXT2_MOUNT_USRQUOTA		0x020000  /* user quota */
>  #define EXT2_MOUNT_GRPQUOTA		0x040000  /* group quota */
>  #define EXT2_MOUNT_RESERVATION		0x080000  /* Preallocation */
> +#ifdef CONFIG_FS_DAX
> +#define EXT2_MOUNT_DAX			0x100000  /* Direct Access */
> +#else
> +#define EXT2_MOUNT_DAX			0
> +#endif
  Why do you define EXT2_MOUNT_DAX differently depending on CONFIG_FS_DAX?
  That seems unnecessary...

...
> diff -puN fs/ext2/super.c~ext2-get-rid-of-most-mentions-of-xip-in-ext2 fs/ext2/super.c
> --- a/fs/ext2/super.c~ext2-get-rid-of-most-mentions-of-xip-in-ext2
> +++ a/fs/ext2/super.c
> @@ -294,6 +294,8 @@ static int ext2_show_options(struct seq_
>  #ifdef CONFIG_FS_DAX
>  	if (sbi->s_mount_opt & EXT2_MOUNT_XIP)
>  		seq_puts(seq, ",xip");
> +	if (sbi->s_mount_opt & EXT2_MOUNT_DAX)
> +		seq_puts(seq, ",dax");
>  #endif
>  
>  	if (!test_opt(sb, RESERVATION))
  So if someone mounts filesystem with -o xip, /proc/mounts will show both
'xip' and 'dax'. OK, probably makes sense.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
