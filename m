From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: Convert uninitialized extent to initialized
	extent in case of file system full
Date: Tue, 04 Mar 2008 16:47:15 -0800
Message-ID: <1204678035.3605.9.camel@localhost.localdomain>
References: <1204634630-16713-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35527 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764041AbYCEArq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Mar 2008 19:47:46 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m250lkmL007371
	for <linux-ext4@vger.kernel.org>; Tue, 4 Mar 2008 19:47:46 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m250lkRT215092
	for <linux-ext4@vger.kernel.org>; Tue, 4 Mar 2008 19:47:46 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m250ljun021329
	for <linux-ext4@vger.kernel.org>; Tue, 4 Mar 2008 19:47:46 -0500
In-Reply-To: <1204634630-16713-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2008-03-04 at 18:13 +0530, Aneesh Kumar K.V wrote:
> A write to prealloc area cause the split of unititalized extent
> into a initialized and uninitialized extent. If we don't have
> space to add new extent information instead of returning error
> convert the existing uninitialized extent to initialized one. We
> need to zero out the blocks corresponding to the extent to prevent
> wrong data reaching userspace.
> 

Looks good!

Added to patch queue. I modified the summary slightly.

Mingming
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/extents.c |  106 +++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 files changed, 99 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index d315cc1..839caf2 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2136,6 +2136,80 @@ void ext4_ext_release(struct super_block *sb)
>  #endif
>  }
> 
> +static void bi_complete(struct bio *bio, int error)
> +{
> +	complete((struct completion *)bio->bi_private);
> +}
> +
> +/* FIXME!! we need to try to merge to left or right after zerout  */
> +static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
> +{
> +	int ret = -EIO;
> +	struct bio *bio;
> +	int blkbits, blocksize;
> +	sector_t ee_pblock;
> +	struct completion event;
> +	unsigned int ee_len, len, done, offset;
> +
> +
> +	blkbits   = inode->i_blkbits;
> +	blocksize = inode->i_sb->s_blocksize;
> +	ee_len    = ext4_ext_get_actual_len(ex);
> +	ee_pblock = ext_pblock(ex);
> +
> +	/* convert ee_pblock in 512 byte sector */
> +	ee_pblock = ee_pblock << (blkbits >> 9);
> +
> +
> +	while (ee_len > 0) {
> +
> +		if (ee_len > BIO_MAX_PAGES)
> +			len = BIO_MAX_PAGES;
> +		else
> +			len = ee_len;
> +
> +		bio = bio_alloc(GFP_NOIO, len);
> +		if (!bio)
> +			return -ENOMEM;
> +		bio->bi_sector = ee_pblock;
> +		bio->bi_bdev   = inode->i_sb->s_bdev;
> +
> +		done = 0;
> +		offset = 0;
> +		while (done < len) {
> +			ret = bio_add_page(bio, ZERO_PAGE(0),
> +							blocksize, offset);
> +			if (ret != blocksize) {
> +				/* We can't add any more page because of
> +				 * hardware limitation. Start a new bio
> +				 */
> +				break;
> +			}
> +			done++;
> +			offset += blocksize;
> +			if (offset >= PAGE_CACHE_SIZE)
> +				offset = 0;
> +		}
> +
> +		init_completion(&event);
> +		bio->bi_private = &event;
> +		bio->bi_end_io = bi_complete;
> +		submit_bio(WRITE, bio);
> +		wait_for_completion(&event);
> +
> +		if (test_bit(BIO_UPTODATE, &bio->bi_flags))
> +			ret = 0;
> +		else {
> +			ret = -EIO;
> +			break;
> +		}
> +		bio_put(bio);
> +		ee_len    -= done;
> +		ee_pblock += done  << (blkbits - 9);
> +	}
> +	return ret;
> +}
> +
>  /*
>   * This function is called by ext4_ext_get_blocks() if someone tries to write
>   * to an uninitialized extent. It may result in splitting the uninitialized
> @@ -2202,14 +2276,19 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  		ex3->ee_len = cpu_to_le16(allocated - max_blocks);
>  		ext4_ext_mark_uninitialized(ex3);
>  		err = ext4_ext_insert_extent(handle, inode, path, ex3);
> -		if (err) {
> +		if (err == -ENOSPC) {
> +			err =  ext4_ext_zeroout(inode, &orig_ex);
> +			if (err)
> +				goto fix_extent_len;
> +			/* update the extent length and mark as initialized */
>  			ex->ee_block = orig_ex.ee_block;
>  			ex->ee_len   = orig_ex.ee_len;
>  			ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
> -			ext4_ext_mark_uninitialized(ex);
>  			ext4_ext_dirty(handle, inode, path + depth);
> -			goto out;
> -		}
> +			return le16_to_cpu(ex->ee_len);
> +
> +		} else if (err)
> +			goto fix_extent_len;
>  		/*
>  		 * The depth, and hence eh & ex might change
>  		 * as part of the insert above.
> @@ -2295,15 +2374,28 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  	goto out;
>  insert:
>  	err = ext4_ext_insert_extent(handle, inode, path, &newex);
> -	if (err) {
> +	if (err == -ENOSPC) {
> +		err =  ext4_ext_zeroout(inode, &orig_ex);
> +		if (err)
> +			goto fix_extent_len;
> +		/* update the extent length and mark as initialized */
>  		ex->ee_block = orig_ex.ee_block;
>  		ex->ee_len   = orig_ex.ee_len;
>  		ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
> -		ext4_ext_mark_uninitialized(ex);
>  		ext4_ext_dirty(handle, inode, path + depth);
> -	}
> +		return le16_to_cpu(ex->ee_len);
> +	} else if (err)
> +		goto fix_extent_len;
>  out:
>  	return err ? err : allocated;
> +
> +fix_extent_len:
> +	ex->ee_block = orig_ex.ee_block;
> +	ex->ee_len   = orig_ex.ee_len;
> +	ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
> +	ext4_ext_mark_uninitialized(ex);
> +	ext4_ext_dirty(handle, inode, path + depth);
> +	return err;
>  }
> 
>  /*

