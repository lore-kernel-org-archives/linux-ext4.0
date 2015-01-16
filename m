From: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
Subject: RE: + ext2-get-rid-of-most-mentions-of-xip-in-ext2.patch added to
 -mm tree
Date: Fri, 16 Jan 2015 21:09:03 +0000
Message-ID: <100D68C7BA14664A8938383216E40DE04085342E@FMSMSX114.amr.corp.intel.com>
References: <54b4548f.X6zUbiROuSfruGuT%akpm@linux-foundation.org>
 <20150115103036.GE12739@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"Dilger, Andreas" <andreas.dilger@intel.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"boaz@plexistor.com" <boaz@plexistor.com>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"hch@lst.de" <hch@lst.de>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>,
	"rdunlap@infradead.org" <rdunlap@infradead.org>,
	"ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:43549 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189AbbAPVJG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Jan 2015 16:09:06 -0500
In-Reply-To: <20150115103036.GE12739@quack.suse.cz>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ugh ... this works better from my linux.intel.com address ...

-----Original Message-----
From: Jan Kara [mailto:jack@suse.cz] 
Sent: Thursday, January 15, 2015 2:31 AM
To: Wilcox, Matthew R
Cc: akpm@linux-foundation.org; Dilger, Andreas; axboe@kernel.dk; boaz@plexistor.com; david@fromorbit.com; hch@lst.de; jack@suse.cz; kirill.shutemov@linux.intel.com; mathieu.desnoyers@efficios.com; rdunlap@infradead.org; ross.zwisler@linux.intel.com; tytso@mit.edu; mm-commits@vger.kernel.org; linux-ext4@vger.kernel.org
Subject: Re: + ext2-get-rid-of-most-mentions-of-xip-in-ext2.patch added to -mm tree

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

That's copied from the original XIP code.  I think the intent is to make the XIP/DAX code disappear from the module, rather than being dead code cluttering up the object file.

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

Yeah, I thought that was the best migration path; somebody might have a script that's checking for 'xip' in /proc/mounts.
