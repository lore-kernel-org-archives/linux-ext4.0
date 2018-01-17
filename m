From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [RFC PATCH 6/8] ext4: encrypt blocks whose size is less than
 page size
Date: Tue, 16 Jan 2018 18:33:05 -0800
Message-ID: <20180117023305.GF4477@zzz.localdomain>
References: <20180112141129.27507-1-chandan@linux.vnet.ibm.com>
 <20180112141129.27507-7-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:37794 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750846AbeAQCdI (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Jan 2018 21:33:08 -0500
Content-Disposition: inline
In-Reply-To: <20180112141129.27507-7-chandan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 12, 2018 at 07:41:27PM +0530, Chandan Rajendra wrote:
> This commit adds code to encrypt all file blocks mapped by page.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>  fs/crypto/crypto.c              | 80 ++++++++++++++++++++++++++---------------
>  fs/ext4/page-io.c               | 58 ++++++++++++++++++++----------
>  include/linux/fscrypt_notsupp.h | 15 ++++----
>  include/linux/fscrypt_supp.h    | 11 ++++--
>  4 files changed, 108 insertions(+), 56 deletions(-)
> 
> diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
> index 732a786..52ad5cf 100644
> --- a/fs/crypto/crypto.c
> +++ b/fs/crypto/crypto.c
> @@ -226,15 +226,16 @@ struct page *fscrypt_alloc_bounce_page(struct fscrypt_ctx *ctx,
>   * Return: A page with the encrypted content on success. Else, an
>   * error value or NULL.
>   */
> -struct page *fscrypt_encrypt_page(const struct inode *inode,
> -				struct page *page,
> -				unsigned int len,
> -				unsigned int offs,
> -				u64 lblk_num, gfp_t gfp_flags)
> -
> +int fscrypt_encrypt_page(const struct inode *inode,
> +			struct page *page,
> +			unsigned int len,
> +			unsigned int offs,
> +			u64 lblk_num,
> +			struct fscrypt_ctx **ctx,
> +			struct page **ciphertext_page,
> +			gfp_t gfp_flags)
>  {

Note that f2fs and ubifs have to be updated to use the new prototype too.

As noted earlier this should be renamed to fscrypt_encrypt_block().  Also the
function comment needs to be updated to match any changes.

But more importantly, the new calling convention is really confusing, especially
how it sometimes allocates resources but sometimes doesn't, and also in the
error path, it will free resources that were *not* allocated by that same
invocation of fscrypt_encrypt_page(), but rather by previous ones.  Can you
please switch it to a more standard convention?  Really there should be a
separate function which just allocates the fscrypt_ctx and bounce buffer, and
then fscrypt_encrypt_block() would just encrypt into that existing bounce
buffer.

>  
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index db75901..9828d77 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -415,7 +415,7 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
>  			struct writeback_control *wbc,
>  			bool keep_towrite)
>  {
> -	struct page *data_page = NULL;
> +	struct page *ciphertext_page = NULL;
>  	struct inode *inode = page->mapping->host;
>  	unsigned block_start;
>  	struct buffer_head *bh, *head;
> @@ -475,36 +475,56 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
>  		nr_to_submit++;
>  	} while ((bh = bh->b_this_page) != head);
>  
> -	bh = head = page_buffers(page);
>  
>  	if (ext4_encrypted_inode(inode) && S_ISREG(inode->i_mode) &&
>  	    nr_to_submit) {
> +		struct fscrypt_ctx *ctx;
> +		u64 blk_nr;
>  		gfp_t gfp_flags = GFP_NOFS;
>  
> -	retry_encrypt:
> -		data_page = fscrypt_encrypt_page(inode, page, PAGE_SIZE, 0,
> -						page->index, gfp_flags);
> -		if (IS_ERR(data_page)) {
> -			ret = PTR_ERR(data_page);
> -			if (ret == -ENOMEM && wbc->sync_mode == WB_SYNC_ALL) {
> -				if (io->io_bio) {
> -					ext4_io_submit(io);
> -					congestion_wait(BLK_RW_ASYNC, HZ/50);
> +		bh = head = page_buffers(page);
> +		blk_nr = page->index << (PAGE_SHIFT - inode->i_blkbits);
> +		ctx = NULL;
> +		ciphertext_page = NULL;
> +
> +		do {
> +			if (!buffer_async_write(bh))
> +				continue;
> +		retry_encrypt:
> +			ret = fscrypt_encrypt_page(inode, page, bh->b_size,
> +						bh_offset(bh),
> +						blk_nr, &ctx,
> +						&ciphertext_page,
> +						gfp_flags);
> +			if (ret) {
> +				if (ret == -ENOMEM
> +					&& wbc->sync_mode == WB_SYNC_ALL) {
> +					if (io->io_bio) {
> +						ext4_io_submit(io);
> +						congestion_wait(BLK_RW_ASYNC,
> +								HZ/50);
> +					}
> +					gfp_flags |= __GFP_NOFAIL;
> +					bh = head = page_buffers(page);
> +					blk_nr = page->index
> +						<< (PAGE_SHIFT - inode->i_blkbits);
> +					ctx = NULL;
> +					ciphertext_page = NULL;
> +					goto retry_encrypt;
>  				}
> -				gfp_flags |= __GFP_NOFAIL;
> -				goto retry_encrypt;
> +				ciphertext_page = NULL;
> +				goto out;
>  			}
> -			data_page = NULL;
> -			goto out;
> -		}
> +		} while (++blk_nr, (bh = bh->b_this_page) != head);

The error handling is broken in the block_size < PAGE_SIZE case, for a couple
reasons.

First, in the "non-retry" case where we do 'goto out', we have to clear the
BH_Async_Write flag from all the buffer_heads, since none have been submitted
yet.  But it will start at 'bh' which will not necessarily be the first one,
since the encryption loop is also using the 'bh' variable.

Second, in the "retry" case where we do 'goto retry_encrypt', your new code will
leak the 'ctx' and 'ciphertext' page, then try to start at the beginning of the
buffer_head list again.  But it doesn't check the BH_Async_Write flag, so it may
try to encrypt a block that doesn't actually need to be written.

Also, in the "retry" case, why not start at the same block again, rather than
discarding the encryptions that have been done and restarting at the first one?

In any case, now that you're adding more logic here, if possible can you please
refactor everything under the 'ext4_encrypted_inode(inode) &&
S_ISREG(inode->i_mode)' condition into its own function?  That should make it
easier to clean up some of the above bugs.

Eric
