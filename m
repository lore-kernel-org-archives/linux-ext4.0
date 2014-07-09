From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/4] lib: add EXT2_ prefix for SUPERBLOCK_{OFFSET,SIZE}
Date: Wed, 9 Jul 2014 12:58:44 -0700
Message-ID: <20140709195844.GD10417@birch.djwong.org>
References: <1404935478-8242-1-git-send-email-a3at.mail@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger@dilger.ca, tytso@mit.edu
To: Azat Khuzhin <a3at.mail@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41384 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649AbaGIT6w (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jul 2014 15:58:52 -0400
Content-Disposition: inline
In-Reply-To: <1404935478-8242-1-git-send-email-a3at.mail@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 09, 2014 at 11:51:18PM +0400, Azat Khuzhin wrote:
> Since mostly all macros have this prefix, and to avoid potential name
> clashes.
> 
> Proposed-by: Andreas Dilger <adilger@dilger.ca>
> Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>
> ---
>  e2fsck/journal.c           |  2 +-
>  e2fsck/super.c             |  4 ++--
>  e2fsck/util.c              |  4 ++--
>  lib/blkid/probe.h          |  2 +-
>  lib/ext2fs/closefs.c       | 18 +++++++++---------
>  lib/ext2fs/dupfs.c         |  8 ++++----
>  lib/ext2fs/ext2fs.h        | 10 ++++++++--
>  lib/ext2fs/imager.c        |  4 ++--
>  lib/ext2fs/initialize.c    |  4 ++--
>  lib/ext2fs/mkjournal.c     |  6 +++---
>  lib/ext2fs/openfs.c        | 12 ++++++------
>  lib/ext2fs/tst_badblocks.c |  4 ++--
>  lib/ext2fs/undo_io.c       |  4 ++--
>  misc/e2undo.c              |  4 ++--
>  misc/mke2fs.c              |  4 ++--
>  misc/tune2fs.c             | 12 ++++++------
>  16 files changed, 54 insertions(+), 48 deletions(-)
> 
> diff --git a/e2fsck/journal.c b/e2fsck/journal.c
> index 6df0165..785d283 100644
> --- a/e2fsck/journal.c
> +++ b/e2fsck/journal.c
> @@ -454,7 +454,7 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
>  			brelse(bh);
>  			goto errout;
>  		}
> -		memcpy(&jsuper, start ? bh->b_data :  bh->b_data + SUPERBLOCK_OFFSET,
> +		memcpy(&jsuper, start ? bh->b_data :  bh->b_data + EXT2_SUPERBLOCK_OFFSET,
>  		       sizeof(jsuper));
>  		brelse(bh);
>  #ifdef WORDS_BIGENDIAN
> diff --git a/e2fsck/super.c b/e2fsck/super.c
> index c8669f8..d58a789 100644
> --- a/e2fsck/super.c
> +++ b/e2fsck/super.c
> @@ -921,7 +921,7 @@ int check_backup_super_block(e2fsck_t ctx)
>  	dgrp_t		g;
>  	blk64_t		sb;
>  	int		ret = 0;
> -	char		buf[SUPERBLOCK_SIZE];
> +	char		buf[EXT2_SUPERBLOCK_SIZE];
>  	struct ext2_super_block	*backup_sb;
>  
>  	/*
> @@ -944,7 +944,7 @@ int check_backup_super_block(e2fsck_t ctx)
>  
>  		sb = ext2fs_group_first_block2(fs, g);
>  
> -		retval = io_channel_read_blk(fs->io, sb, -SUPERBLOCK_SIZE,
> +		retval = io_channel_read_blk(fs->io, sb, -EXT2_SUPERBLOCK_SIZE,
>  					     buf);
>  		if (retval)
>  			continue;
> diff --git a/e2fsck/util.c b/e2fsck/util.c
> index fec6179..75e11de 100644
> --- a/e2fsck/util.c
> +++ b/e2fsck/util.c
> @@ -540,7 +540,7 @@ blk64_t get_backup_sb(e2fsck_t ctx, ext2_filsys fs, const char *name,
>  	if (manager->open(name, 0, &io) != 0)
>  		goto cleanup;
>  
> -	if (ext2fs_get_mem(SUPERBLOCK_SIZE, &buf))
> +	if (ext2fs_get_mem(EXT2_SUPERBLOCK_SIZE, &buf))
>  		goto cleanup;
>  	sb = (struct ext2_super_block *) buf;
>  
> @@ -551,7 +551,7 @@ blk64_t get_backup_sb(e2fsck_t ctx, ext2_filsys fs, const char *name,
>  			superblock++;
>  		io_channel_set_blksize(io, blocksize);
>  		if (io_channel_read_blk64(io, superblock,
> -					-SUPERBLOCK_SIZE, buf))
> +					-EXT2_SUPERBLOCK_SIZE, buf))
>  			continue;
>  #ifdef WORDS_BIGENDIAN
>  		if (sb->s_magic == ext2fs_swab16(EXT2_SUPER_MAGIC))
> diff --git a/lib/blkid/probe.h b/lib/blkid/probe.h
> index d6809e1..06141ea 100644
> --- a/lib/blkid/probe.h
> +++ b/lib/blkid/probe.h
> @@ -403,7 +403,7 @@ struct iso_volume_descriptor {
>  /* Common gfs/gfs2 constants: */
>  #define GFS_MAGIC               0x01161970
>  #define GFS_DEFAULT_BSIZE       4096
> -#define GFS_SUPERBLOCK_OFFSET	(0x10 * GFS_DEFAULT_BSIZE)
> +#define GFS_EXT2_SUPERBLOCK_OFFSET	(0x10 * GFS_DEFAULT_BSIZE)

I doubt the e2fsprogs blkid does much these days, but .... huh???

The rest looks ok to me.

--D
