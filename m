From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: directory inode reservation (V1) to mke2fs
Date: Mon, 29 Oct 2007 18:44:07 -0400
Message-ID: <20071029224407.GI21133@thunk.org>
References: <4726126A.3060303@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Coly Li <coyli@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:39361 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbXJ2Wom (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Oct 2007 18:44:42 -0400
Content-Disposition: inline
In-Reply-To: <4726126A.3060303@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Oct 30, 2007 at 01:03:38AM +0800, Coly Li wrote:
> This patch adds directory inode reservation supporting to mke2fs. Ask for review.

So I had completely erased this from my memory, and had to do some
google searching and some mail archive searching before I found this:

http://lkml.org/lkml/2007/3/26/180

... and some initial kernel patches which no one ever really looked at
because your mailer had converted all tab characters into a single
space, making the patch compltely unreadable and unusuable to use as a
patch.

>  /*
> + * Macro-instructions used to reserve inodes for directories
> + */
> +#define EXT4_DIR_IRESERVE_LOW		16
> +#define EXT4_DIR_IRESERVE_NORMAL	64
> +#define EXT4_DIR_IRESERVE_HIGH		128

Macro-instructions?  These are constants.  And exactly what do they
signify, anyway.  I'll note that this patch only uses
EEXT4_DIR_IRESERVE_NORMAL, and not IRESERVE_LOW or IRESERVE_HIGH.

> +/*
>   * ACL structures
>   */
>  struct ext2_acl_header	/* Header of Access Control Lists */
> @@ -167,7 +174,7 @@ struct ext4_group_desc
>  	__u16	bg_free_blocks_count_hi;/* Free blocks count MSB */
>  	__u16	bg_free_inodes_count_hi;/* Free inodes count MSB */
>  	__u16	bg_used_dirs_count_hi;	/* Directories count MSB */
> -	__u16   bg_pad;
> +	__u16	bg_itable_unused_hi;	/* Unused inodes count MSB */
>  	__u32	bg_reserved2[3];
>  };

This patch hunk has nothing to do with your patch.... 

Note that for 4k block filesystems, the maximum number of inodes we
can have is 32768, so it would be highly unsusual and unreasonable for
us to need more than 64k inodes per block group.  It only might make
come up in real life for filesystems that are using, say, 64k block
filesystems, and which needed a huge number of inodes.

If we are triggering this, then mayne we should fix the ununitialized
block group patches so that instead of enumerating the number of
inodes, that it is denotes the number of unused inode table *blocks*.
After all, if we are going to be initializing a new inode table block,
it only makes sense to initialize all of the inodes in that block at
once.

> @@ -100,7 +101,8 @@ static void usage(void)
>  	"\t[-N number-of-inodes] [-m reserved-blocks-percentage] "
>  	"[-o creator-os]\n\t[-g blocks-per-group] [-L volume-label] "
>  	"[-M last-mounted-directory]\n\t[-O feature[,...]] "
> -	"[-r fs-revision] [-R options] [-qvSV]\n\tdevice [blocks-count]\n"),
> +	"[-r fs-revision] [-E extended-option[,...]] [-qvSV]\n"
> +	"\tdevice [blocks-count]\n"),
>  		program_name);
>  	exit(1);
>  }

This patch has nothing to do with your patch, and in fact is already
in e2fsprogs.  How are you generating your patch?


> @@ -575,6 +577,16 @@ static void reserve_inodes(ext2_filsys fs)
>  	ext2fs_mark_ib_dirty(fs);
>  }
> 
> +static void setup_itable_unused(ext2_filsys fs)
> +{
> +	dgrp_t	i;
> +	int inodes_pgroup = fs->super->s_inodes_per_group;
> +	fs->group_desc[0].bg_itable_unused =
> +		inodes_pgroup - EXT4_DIR_IRESERVE_NORMAL;
> +	for (i = 1; i < fs->group_desc_count; i++)
> +		fs->group_desc[i].bg_itable_unused = inodes_pgroup;
> +}
> +
>  #define BSD_DISKMAGIC   (0x82564557UL)  /* The disk magic number */
>  #define BSD_MAGICDISK   (0x57455682UL)  /* The disk magic number reversed */
>  #define BSD_LABEL_OFFSET        64

Ok, so this is bad in many, many ways.  First of all, this shouldn't
be in mke2fs.c, but in lib/ext2fs/initialize.c

Secondly, we really need to talk about the on-disk format.  This needs
to be integrated with the uninit blockgroup patch, and even there,
there needs to be some filesytem feature flag marker so we know we're
doing this wierd thing.  Why it makes sense to set the bg_table_unused
field to the number of block groups minus 64 makes no sense to me (you
need to explain the on-disk format very clearly, and the only
explanation I've seen back in March never talked about using
bg_itable_unused).  

More importantly, it's doing this unconditionally without any feature
flag indicating whether or not the uninit blockgroup feature is even
enabled, and if it is enabled, that EXT4_DIR_IRESERVE_NORMAL blocks
have been initialized.  What the heck is going on here?

> @@ -761,7 +773,7 @@ static void parse_extended_opts(struct ext2_super_block *param,
>  	int	r_usage = 0;
> 
>  	len = strlen(opts);
> -	buf = malloc(len+1);
> +	buf = (char *)malloc(len+1);
>  	if (!buf) {
>  		fprintf(stderr,
>  			_("Couldn't allocate memory to parse options!\n"));

Unnecessary cast.  Why did you add it?

						- Ted
