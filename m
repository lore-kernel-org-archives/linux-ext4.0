From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 13/25] libext2fs: use ext2fs_punch() to truncate quota
 file
Date: Mon, 25 Nov 2013 17:08:22 +0800
Message-ID: <20131125090822.GB13183@gmail.com>
References: <20131018044854.7339.48457.stgit@birch.djwong.org>
 <20131018045021.7339.83267.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:62581 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab3KYJFk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Nov 2013 04:05:40 -0500
Received: by mail-pb0-f41.google.com with SMTP id jt11so5315210pbb.28
        for <linux-ext4@vger.kernel.org>; Mon, 25 Nov 2013 01:05:35 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20131018045021.7339.83267.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 17, 2013 at 09:50:21PM -0700, Darrick J. Wong wrote:
> Use the new ext2fs_punch() call to truncate the quota file.  This also
> eliminates the need to fix it to work with bigalloc.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

                                                - Zheng

> ---
>  lib/quota/quotaio.c |   19 +++----------------
>  1 file changed, 3 insertions(+), 16 deletions(-)
> 
> 
> diff --git a/lib/quota/quotaio.c b/lib/quota/quotaio.c
> index 8ddb92a..1bdcba6 100644
> --- a/lib/quota/quotaio.c
> +++ b/lib/quota/quotaio.c
> @@ -98,19 +98,6 @@ void update_grace_times(struct dquot *q)
>  	}
>  }
>  
> -static int release_blocks_proc(ext2_filsys fs, blk64_t *blocknr,
> -			       e2_blkcnt_t blockcnt EXT2FS_ATTR((unused)),
> -			       blk64_t ref_block EXT2FS_ATTR((unused)),
> -			       int ref_offset EXT2FS_ATTR((unused)),
> -			       void *private EXT2FS_ATTR((unused)))
> -{
> -	blk64_t	block;
> -
> -	block = *blocknr;
> -	ext2fs_block_alloc_stats2(fs, block, -1);
> -	return 0;
> -}
> -
>  static int compute_num_blocks_proc(ext2_filsys fs, blk64_t *blocknr,
>  			       e2_blkcnt_t blockcnt EXT2FS_ATTR((unused)),
>  			       blk64_t ref_block EXT2FS_ATTR((unused)),
> @@ -135,9 +122,9 @@ errcode_t quota_inode_truncate(ext2_filsys fs, ext2_ino_t ino)
>  		inode.i_dtime = fs->now ? fs->now : time(0);
>  		if (!ext2fs_inode_has_valid_blocks2(fs, &inode))
>  			return 0;
> -
> -		ext2fs_block_iterate3(fs, ino, BLOCK_FLAG_READ_ONLY, NULL,
> -				      release_blocks_proc, NULL);
> +		err = ext2fs_punch(fs, ino, &inode, NULL, 0, ~0ULL);
> +		if (err)
> +			return err;
>  		fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
>  		memset(&inode, 0, sizeof(struct ext2_inode));
>  	} else {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
