From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] [PATCH] ext4: Add inode to the orphan list during
	block allocation failure
Date: Tue, 31 Mar 2009 11:34:47 +0200
Message-ID: <20090331093447.GC11808@duck.suse.cz>
References: <20090331044544.GB5979@skywalker> <1238491766-13182-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:47169 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbZCaJex (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Mar 2009 05:34:53 -0400
Content-Disposition: inline
In-Reply-To: <1238491766-13182-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 31-03-09 14:59:25, Aneesh Kumar K.V wrote:
> We should add inode to the orphan list in the same transaction
> as block allocation. This ensures that if we crash after a failed
> block allocation and before we do a vmtruncate we don't leak block
> (ie block marked as used in bitmap but not claimed by the inode).
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> CC:  Jan Kara <jack@suse.cz>
  Looks fine.

  Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c |   15 +++++++++++++--
>  1 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 2231a65..074185f 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1424,7 +1424,7 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
>  				struct page **pagep, void **fsdata)
>  {
>  	struct inode *inode = mapping->host;
> -	int ret, needed_blocks = ext4_writepage_trans_blocks(inode);
> +	int ret, needed_blocks;
>  	handle_t *handle;
>  	int retries = 0;
>  	struct page *page;
> @@ -1435,6 +1435,11 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
>  		   "dev %s ino %lu pos %llu len %u flags %u",
>  		   inode->i_sb->s_id, inode->i_ino,
>  		   (unsigned long long) pos, len, flags);
> +	/*
> +	 * Reserve one block more for addition to orphan list in case
> +	 * we allocate blocks but write fails for some reason
> +	 */
> +	needed_blocks = ext4_writepage_trans_blocks(inode) + 1;
>   	index = pos >> PAGE_CACHE_SHIFT;
>  	from = pos & (PAGE_CACHE_SIZE - 1);
>  	to = from + len;
> @@ -1468,14 +1473,20 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
>  
>  	if (ret) {
>  		unlock_page(page);
> -		ext4_journal_stop(handle);
>  		page_cache_release(page);
>  		/*
>  		 * block_write_begin may have instantiated a few blocks
>  		 * outside i_size.  Trim these off again. Don't need
>  		 * i_size_read because we hold i_mutex.
> +		 *
> +		 * Add inode to orphan list in case we crash before
> +		 * truncate finishes
>  		 */
>  		if (pos + len > inode->i_size)
> +			ext4_orphan_add(handle, inode);
> +
> +		ext4_journal_stop(handle);
> +		if (pos + len > inode->i_size)
>  			vmtruncate(inode, inode->i_size);
>  	}
>  
> -- 
> 1.6.2.1.404.gb0085.dirty
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
