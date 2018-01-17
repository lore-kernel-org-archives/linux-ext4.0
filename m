From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [RFC PATCH 5/8] ext4: decrypt the block that needs to be
 partially zeroed
Date: Tue, 16 Jan 2018 18:23:02 -0800
Message-ID: <20180117022302.GE4477@zzz.localdomain>
References: <20180112141129.27507-1-chandan@linux.vnet.ibm.com>
 <20180112141129.27507-6-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180112141129.27507-6-chandan@linux.vnet.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jan 12, 2018 at 07:41:26PM +0530, Chandan Rajendra wrote:
> __ext4_block_zero_page_range decrypts the entire page. This commit
> decrypts the block to be partially zeroed instead of the whole page.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>  fs/ext4/inode.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index d3baa15..db47f6d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4030,9 +4030,8 @@ static int __ext4_block_zero_page_range(handle_t *handle,
>  		    ext4_encrypted_inode(inode)) {
>  			/* We expect the key to be set. */
>  			BUG_ON(!fscrypt_has_encryption_key(inode));
> -			BUG_ON(blocksize != PAGE_SIZE);
>  			WARN_ON_ONCE(fscrypt_decrypt_page(page->mapping->host,
> -						page, PAGE_SIZE, 0, page->index));
> +						page, blocksize, round_down(offset, blocksize), iblock));
>  		}

Please use proper line breaking here.

Eric
