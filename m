From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 24/31] libext2fs: Use ext2fs_punch() to truncate quota
 file
Date: Thu, 10 Oct 2013 18:06:13 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1310101805540.1925@localhost.localdomain>
References: <20131001012642.28415.89353.stgit@birch.djwong.org> <20131001012915.28415.89982.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932072Ab3JJQGS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Oct 2013 12:06:18 -0400
In-Reply-To: <20131001012915.28415.89982.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 30 Sep 2013, Darrick J. Wong wrote:

> Date: Mon, 30 Sep 2013 18:29:15 -0700
> From: Darrick J. Wong <darrick.wong@oracle.com>
> To: tytso@mit.edu, darrick.wong@oracle.com
> Cc: linux-ext4@vger.kernel.org
> Subject: [PATCH 24/31] libext2fs: Use ext2fs_punch() to truncate quota file
> 
> Use the new ext2fs_punch() call to truncate the quota file.  This also
> eliminates the need to fix it to work with bigalloc.

Looks good.

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  lib/quota/quotaio.c |   19 +++----------------
>  1 file changed, 3 insertions(+), 16 deletions(-)
> 
> 
> diff --git a/lib/quota/quotaio.c b/lib/quota/quotaio.c
> index 8ddb92a..807fabd 100644
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
> +		err = ext2fs_punch(fs, ino, NULL, NULL, 0, ~0ULL);
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
> 
