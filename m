From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [RFC PATCH 7/8] ext4: decrypt blocks whose size is less than
 page size
Date: Tue, 16 Jan 2018 18:39:25 -0800
Message-ID: <20180117023925.GG4477@zzz.localdomain>
References: <20180112141129.27507-1-chandan@linux.vnet.ibm.com>
 <20180112141129.27507-8-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:42313 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750830AbeAQCj2 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Jan 2018 21:39:28 -0500
Content-Disposition: inline
In-Reply-To: <20180112141129.27507-8-chandan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 12, 2018 at 07:41:28PM +0530, Chandan Rajendra wrote:
> This commit adds code to decrypt all file blocks mapped by page.
> 
[...]
> diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
> index 0be590b..e494e2d 100644
> --- a/fs/ext4/readpage.c
> +++ b/fs/ext4/readpage.c
> @@ -62,6 +62,143 @@ static inline bool ext4_bio_encrypted(struct bio *bio)
>  #endif
>  }
>  
> +static void ext4_complete_block(struct work_struct *work)
> +{
> +	struct fscrypt_ctx *ctx =
> +		container_of(work, struct fscrypt_ctx, r.work);
> +	struct buffer_head *first, *bh, *tmp;
> +	struct bio *bio;
> +	struct bio_vec *bv;
> +	struct page *page;
> +	struct inode *inode;
> +	u64 blk_nr;
> +	unsigned long flags;
> +	int page_uptodate = 1;
> +	int ret;
> +
> +	bio = ctx->r.bio;
> +	BUG_ON(bio->bi_vcnt != 1);
> +
> +	bv = bio->bi_io_vec;
> +	page = bv->bv_page;
> +	inode = page->mapping->host;
> +
> +	BUG_ON(bv->bv_len != i_blocksize(inode));
> +
> +	blk_nr = page->index << (PAGE_SHIFT - inode->i_blkbits);
> +	blk_nr += bv->bv_offset >> inode->i_blkbits;
> +
> +	bh = ctx->r.bh;
> +
> +	ret = fscrypt_decrypt_page(inode, page, bv->bv_len,
> +				bv->bv_offset, blk_nr);
> +	if (ret) {
> +		WARN_ON_ONCE(1);
> +		SetPageError(page);
> +	} else {
> +		set_buffer_uptodate(bh);
> +	}
> +
> +	fscrypt_release_ctx(ctx);
> +	bio_put(bio);
> +
> +	first = page_buffers(page);
> +	local_irq_save(flags);
> +	bit_spin_lock(BH_Uptodate_Lock, &first->b_state);
> +
> +	clear_buffer_async_read(bh);
> +	unlock_buffer(bh);
> +	tmp = bh;
> +	do {
> +		if (!buffer_uptodate(tmp))
> +			page_uptodate = 0;
> +		if (buffer_async_read(tmp)) {
> +			BUG_ON(!buffer_locked(tmp));
> +			goto still_busy;
> +		}
> +		tmp = tmp->b_this_page;
> +	} while (tmp != bh);
> +
> +	bit_spin_unlock(BH_Uptodate_Lock, &first->b_state);
> +	local_irq_restore(flags);
> +
> +	if (page_uptodate && !PageError(page))
> +		SetPageUptodate(page);
> +	unlock_page(page);
> +	return;
> +
> +still_busy:
> +	bit_spin_unlock(BH_Uptodate_Lock, &first->b_state);
> +	local_irq_restore(flags);
> +	return;
> +}

First, see my comments on Patch 2 regarding whether we should really be
copy+pasting all this code from fs/buffer.c into ext4.

If nevertheless we really do have to have this, why can't we call
end_buffer_async_read() from ext4_complete_block() and from block_end_io(),
rather than duplicating it?

> +
> +static void block_end_io(struct bio *bio)
> +{
[...]
>  
> +int ext4_block_read_full_page(struct page *page)
> +{
> +	struct inode *inode = page->mapping->host;
> +	struct fscrypt_ctx *ctx;
> +	struct bio *bio;
> +	sector_t iblock, lblock;
> +	struct buffer_head *bh, *head, *arr[MAX_BUF_PER_PAGE];
> +	unsigned int blocksize, bbits;
> +	int nr, i;
> +	int fully_mapped = 1;
> +	int ret;
> +
> +	head = create_page_buffers(page, inode, 0);
> +	blocksize = head->b_size;
> +	bbits = block_size_bits(blocksize);
> +
> +	iblock = (sector_t)page->index << (PAGE_SHIFT - bbits);
> +	lblock = (i_size_read(inode)+blocksize-1) >> bbits;
> +	bh = head;
> +	nr = 0;
> +	i = 0;
> +
> +	do {
> +		if (buffer_uptodate(bh))
> +			continue;
> +
> +		if (!buffer_mapped(bh)) {
> +			int err = 0;
> +
> +			fully_mapped = 0;
> +			if (iblock < lblock) {
> +				WARN_ON(bh->b_size != blocksize);
> +				err = ext4_get_block(inode, iblock, bh, 0);
> +				if (err)
> +					SetPageError(page);
> +			}
> +			if (!buffer_mapped(bh)) {
> +				zero_user(page, i << bbits, blocksize);
> +				if (!err)
> +					set_buffer_uptodate(bh);
> +				continue;
> +			}
> +			/*
> +			 * get_block() might have updated the buffer
> +			 * synchronously
> +			 */
> +			if (buffer_uptodate(bh))
> +				continue;
> +		}
> +		arr[nr++] = bh;
> +	} while (i++, iblock++, (bh = bh->b_this_page) != head);
> +
> +	if (fully_mapped)
> +		SetPageMappedToDisk(page);
> +
> +	if (!nr) {
> +		/*
> +		 * All buffers are uptodate - we can set the page uptodate
> +		 * as well. But not if ext4_get_block() returned an error.
> +		 */
> +		if (!PageError(page))
> +			SetPageUptodate(page);
> +		unlock_page(page);
> +		return 0;
> +	}
> +
> +	/* Stage two: lock the buffers */
> +	for (i = 0; i < nr; i++) {
> +		bh = arr[i];
> +		lock_buffer(bh);
> +		set_buffer_async_read(bh);
> +	}
> +
> +	/*
> +	 * Stage 3: start the IO.  Check for uptodateness
> +	 * inside the buffer lock in case another process reading
> +	 * the underlying blockdev brought it uptodate (the sct fix).
> +	 */
> +	for (i = 0; i < nr; i++) {
> +		ctx = NULL;
> +		bh = arr[i];
> +
> +		if (buffer_uptodate(bh)) {
> +			end_buffer_async_read(bh, 1);
> +			continue;
> +		}
> +
> +		if (ext4_encrypted_inode(inode)
> +			&& S_ISREG(inode->i_mode)) {
> +			ctx = fscrypt_get_ctx(inode, GFP_NOFS);
> +			if (IS_ERR(ctx)) {
> +			set_page_error:
> +				SetPageError(page);
> +				zero_user_segment(page, bh_offset(bh), blocksize);
> +				continue;

This isn't cleaning up properly; the buffer_head is being left locked and with
BH_Async_Read set, and that means the page will never be unlocked either.
'end_buffer_async_read(bh, 0)' should do it.


> +			}
> +			ctx->r.bh = bh;
> +		}
> +
> +		bio = bio_alloc(GFP_KERNEL, 1);

GFP_NOIO

Eric
