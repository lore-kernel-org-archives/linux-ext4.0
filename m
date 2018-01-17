From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [RFC PATCH 4/8] ext4: decrypt all boundary blocks when doing
 buffered write
Date: Tue, 16 Jan 2018 18:22:16 -0800
Message-ID: <20180117022216.GD4477@zzz.localdomain>
References: <20180112141129.27507-1-chandan@linux.vnet.ibm.com>
 <20180112141129.27507-5-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:38976 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbeAQCWT (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Jan 2018 21:22:19 -0500
Content-Disposition: inline
In-Reply-To: <20180112141129.27507-5-chandan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 12, 2018 at 07:41:25PM +0530, Chandan Rajendra wrote:
> With block size < page size, ext4_block_write_begin() may have two
> blocks to decrypt. Hence this commit invokes fscrypt_decrypt_page() for
> those blocks.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>  fs/ext4/inode.c | 29 +++++++++++++++++++++--------
>  1 file changed, 21 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 6f6589e..d3baa15 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1158,12 +1158,13 @@ static int ext4_block_write_begin(struct page *page, loff_t pos, unsigned len,
>  	unsigned to = from + len;
>  	struct inode *inode = page->mapping->host;
>  	unsigned block_start, block_end;
> -	sector_t block;
> +	sector_t block, page_blk_nr;
>  	int err = 0;
>  	unsigned blocksize = inode->i_sb->s_blocksize;
>  	unsigned bbits;
>  	struct buffer_head *bh, *head, *wait[2], **wait_bh = wait;
>  	bool decrypt = false;
> +	int i;
>  
>  	BUG_ON(!PageLocked(page));
>  	BUG_ON(from > PAGE_SIZE);
> @@ -1224,16 +1225,28 @@ static int ext4_block_write_begin(struct page *page, loff_t pos, unsigned len,
>  	/*
>  	 * If we issued read requests, let them complete.
>  	 */
> -	while (wait_bh > wait) {
> -		wait_on_buffer(*--wait_bh);
> -		if (!buffer_uptodate(*wait_bh))
> +	for (i = 0; (wait + i) < wait_bh; i++) {
> +		wait_on_buffer(wait[i]);
> +		if (!buffer_uptodate(wait[i]))
>  			err = -EIO;
>  	}
> -	if (unlikely(err))
> +	if (unlikely(err)) {
>  		page_zero_new_buffers(page, from, to);
> -	else if (decrypt)
> -		err = fscrypt_decrypt_page(page->mapping->host, page,
> -				PAGE_SIZE, 0, page->index);
> +	} else if (decrypt) {
> +		page_blk_nr = (sector_t)page->index << (PAGE_SHIFT - bbits);
> +
> +		while (wait_bh > wait) {
> +			--wait_bh;
> +			block = page_blk_nr + (bh_offset(*wait_bh) >> bbits);
> +			err = fscrypt_decrypt_page(page->mapping->host, page,
> +						(*wait_bh)->b_size,
> +						bh_offset(*wait_bh),
> +						block);
> +			if (err)
> +				break;
> +		}
> +	}
> +
>  	return err;

Iterating through the 'wait' array once by index and once by pointer is
confusing.  Why not do it just by index?  e.g.

        int nr_wait = 0;
        int i;

        ...
                wait[nr_wait++] = bh;

        ...
        for (i = 0; i < nr_wait; i++) {
                wait_on_buffer(wait[i]);
                ...
        }

        for (i = 0; i < nr_wait; i++) {
                ...
                fscrypt_decrypt_block(...)
                ...
        }

Also, you are leaving the buffers uptodate() if the decryption fails, which is
wrong.  It is an existing bug even in the block_size == PAGE_SIZE case, but it
should be fixed if possible.

Eric
