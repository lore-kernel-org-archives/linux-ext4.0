From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] libext2fs: Always swab MMP block on BE machines
Date: Fri, 30 Sep 2011 15:09:53 -0600
Message-ID: <322E8AB3-3078-4854-8D8B-38ABA988B089@dilger.ca>
References: <20110930194126.GU12086@tux1.beaverton.ibm.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:39719 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab1I3VJy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Sep 2011 17:09:54 -0400
In-Reply-To: <20110930194126.GU12086@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-09-30, at 1:41 PM, Darrick J. Wong wrote:
> The MMP code in libext2fs tries to gate MMP block swab'ing with this test:
> 
> #ifdef EXT2FS_ENABLE_SWAPFS
> if (fs->super->s_magic == ext2fs_swab16(EXT2_SUPER_MAGIC))

We've never run Lustre on big-endian servers (clients generally work),
so it's possible this has been in our patch for years.

Thanks for the catch.

> However, EXT2FS_ENABLE_SWAPFS never seems to be defined anywhere (all possible
> #define's were cleaned out of e2fsprogs ages ago), and even if any still
> existed, the field fs->super->s_magic is always in host byteorder, so the test
> always fails.  So, we can change the #ifdef to WORDS_BIGENDIAN (which is
> conditionally defined on BE platforms) and get rid of the broken if test.
> 
> (This fix came up while testing the metadata checksumming patchset)
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
> lib/ext2fs/mmp.c |   15 ++++++---------
> 1 files changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/lib/ext2fs/mmp.c b/lib/ext2fs/mmp.c
> index ed6ee42..91f4fb2 100644
> --- a/lib/ext2fs/mmp.c
> +++ b/lib/ext2fs/mmp.c
> @@ -91,9 +91,8 @@ errcode_t ext2fs_mmp_read(ext2_filsys fs, blk64_t mmp_blk, void *buf)
> 	}
> 
> 	mmp_cmp = fs->mmp_cmp;
> -#ifdef EXT2FS_ENABLE_SWAPFS
> -	if (fs->flags & EXT2_FLAG_SWAP_BYTES)
> -		ext2fs_swap_mmp(mmp_cmp);
> +#ifdef WORDS_BIGENDIAN
> +	ext2fs_swap_mmp(mmp_cmp);
> #endif
> 
> 	if (buf != NULL && buf != fs->mmp_cmp)
> @@ -122,18 +121,16 @@ errcode_t ext2fs_mmp_write(ext2_filsys fs, blk64_t mmp_blk, void *buf)
> 	    fs->super->s_mmp_block > ext2fs_blocks_count(fs->super))
> 		return EXT2_ET_MMP_BAD_BLOCK;
> 
> -#ifdef EXT2FS_ENABLE_SWAPFS
> -	if (fs->super->s_magic == ext2fs_swab16(EXT2_SUPER_MAGIC))
> -		ext2fs_swap_mmp(mmp_s);
> +#ifdef WORDS_BIGENDIAN
> +	ext2fs_swap_mmp(mmp_s);
> #endif
> 
> 	/* I was tempted to make this use O_DIRECT and the mmp_fd, but
> 	 * this caused no end of grief, while leaving it as-is works. */
> 	retval = io_channel_write_blk64(fs->io, mmp_blk, -fs->blocksize, buf);
> 
> -#ifdef EXT2FS_ENABLE_SWAPFS
> -	if (fs->super->s_magic == ext2fs_swab16(EXT2_SUPER_MAGIC))
> -		ext2fs_swap_mmp(mmp_s);
> +#ifdef WORDS_BIGENDIAN
> +	ext2fs_swap_mmp(mmp_s);
> #endif
> 
> 	/* Make sure the block gets to disk quickly */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





