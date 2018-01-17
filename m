From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [RFC PATCH 3/8] ext4: decrypt all contiguous blocks in a page
Date: Tue, 16 Jan 2018 18:18:17 -0800
Message-ID: <20180117021817.GC4477@zzz.localdomain>
References: <20180112141129.27507-1-chandan@linux.vnet.ibm.com>
 <20180112141129.27507-4-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:41700 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750811AbeAQCSU (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Jan 2018 21:18:20 -0500
Content-Disposition: inline
In-Reply-To: <20180112141129.27507-4-chandan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Chandan,

On Fri, Jan 12, 2018 at 07:41:24PM +0530, Chandan Rajendra wrote:
> With blocksize < pagesize, a page can contain more than one block. Hence
> this commit changes completion_pages() to invoke fscrypt_decrypt_page()
> in order to decrypt all the contiguous blocks mapped by the page.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>  fs/crypto/bio.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/crypto/bio.c b/fs/crypto/bio.c
> index 0d5e6a5..eb6e06a 100644
> --- a/fs/crypto/bio.c
> +++ b/fs/crypto/bio.c
> @@ -40,8 +40,23 @@ static void completion_pages(struct work_struct *work)
>  
>  	bio_for_each_segment_all(bv, bio, i) {
>  		struct page *page = bv->bv_page;
> -		int ret = fscrypt_decrypt_page(page->mapping->host, page,
> -				PAGE_SIZE, 0, page->index);
> +		struct inode *inode = page->mapping->host;
> +		const unsigned long blocksize = inode->i_sb->s_blocksize;
> +		const unsigned blkbits = inode->i_blkbits;
> +		int page_blk = page->index << (PAGE_SHIFT - blkbits);
> +		int blk = page_blk + (bv->bv_offset >> blkbits);

Use 'u64' for the block number:

	u64 page_blk = (u64)page->index << (PAGE_SHIFT - blkbits);
	u64 blk = page_blk + (bv->bv_offset >> blkbits);

> +		int nr_blks = bv->bv_len >> blkbits;
> +		int ret = 0;
> +		int j;
> +
> +		for (j = 0; j < nr_blks; j++, blk++) {
> +			ret = fscrypt_decrypt_page(page->mapping->host,
> +						page, blocksize,
> +						bv->bv_offset + (j << blkbits),
> +						blk);
> +			if (ret)
> +				break;
> +		}
>  
>  		if (ret) {
>  			WARN_ON_ONCE(1);

Since that we'll now actually be operating on blocks rather than pages, some
renaming seems to be in order, otherwise things will get very confusing.  e.g.:

	fscrypt_decrypt_page() -> fscrypt_decrypt_block()
	fscrypt_encrypt_page() -> fscrypt_encrypt_block()
	completion_pages() -> completion_blocks()
	fscrypt_decrypt_bio_pages() -> fscrypt_decrypt_bio_blocks()

Please also update the comment for completion_pages() / completion_blocks() to
clarify that it is decrypting *blocks*, not *pages*.

(Yes, we should have named all these functions as *_block() originally.  But
this is a good time to fix it!)

Eric
