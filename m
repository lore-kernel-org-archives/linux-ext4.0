From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/7] ext2: tell DAX the size of allocation holes
Date: Tue, 16 Aug 2016 11:10:25 +0200
Message-ID: <20160816091025.GA27284@quack2.suse.cz>
References: <20160815190918.20672-1-ross.zwisler@linux.intel.com>
 <20160815190918.20672-2-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-nvdimm@lists.01.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20160815190918.20672-2-ross.zwisler@linux.intel.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Mon 15-08-16 13:09:12, Ross Zwisler wrote:
> When DAX calls ext2_get_block() and the file offset points to a hole we
> currently don't set bh_result->b_size.  When we re-enable PMD faults DAX
> will need bh_result->b_size to tell it the size of the hole so it can
> decide whether to fault in a 4 KiB zero page or a 2 MiB zero page.
> 
> For ext2 we always want DAX to use 4 KiB zero pages, so we just tell DAX
> that all holes are 4 KiB in size.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  fs/ext2/inode.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index d5c7d09..c6d9763 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -773,6 +773,12 @@ int ext2_get_block(struct inode *inode, sector_t iblock, struct buffer_head *bh_
>  	if (ret > 0) {
>  		bh_result->b_size = (ret << inode->i_blkbits);
>  		ret = 0;
> +	} else if (ret == 0 && IS_DAX(inode)) {

I'd just drop the IS_DAX() check and set

	bh_result->b_size = 1 << inode->i_blkbits;

IMO it's better to have things consistent between DAX & !DAX whenever
possible.

								Honza

> +		/*
> +		 * We have hit a hole.  Tell DAX it is 4k in size so that it
> +		 * uses PTE faults.
> +		 */
> +		bh_result->b_size = PAGE_SIZE;
>  	}
>  	return ret;
>  
> -- 
> 2.9.0
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
