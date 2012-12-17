From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/4] mm: Only enforce stable page writes if the backing
 device requires it
Date: Mon, 17 Dec 2012 10:16:46 +0100
Message-ID: <20121217091646.GF5133@quack.suse.cz>
References: <20121213080740.23360.16346.stgit@blackbox.djwong.org>
 <20121213080755.23360.31463.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
	viro@zeniv.linux.org.uk, rminnich@sandia.gov, tytso@mit.edu,
	martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	linux-kernel@vger.kernel.org, hch@infradead.org,
	linux-fsdevel@vger.kernel.org, adilger.kernel@dilger.ca,
	bharrosh@panasas.com, jlayton@samba.org,
	v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44417 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242Ab2LQJQ7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Dec 2012 04:16:59 -0500
Content-Disposition: inline
In-Reply-To: <20121213080755.23360.31463.stgit@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 13-12-12 00:07:55, Darrick J. Wong wrote:
> Create a helper function to check if a backing device requires stable page
> writes and, if so, performs the necessary wait.  Then, make it so that all
> points in the memory manager that handle making pages writable use the helper
> function.  This should provide stable page write support to most filesystems,
> while eliminating unnecessary waiting for devices that don't require the
> feature.
  There are two more places that would seem to need conversion from
wait_on_page_writeback() to wait_for_stable_page():
  gfs2_page_mkwrite()
  nilfs_page_mkwrite()

Otherwise the patch looks OK.

								Honza


> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/buffer.c             |    2 +-
>  fs/ext4/inode.c         |    2 +-
>  include/linux/pagemap.h |    1 +
>  mm/filemap.c            |    3 ++-
>  mm/page-writeback.c     |   20 ++++++++++++++++++++
>  5 files changed, 25 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index ec0aca8..c562136 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -2363,7 +2363,7 @@ int __block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
>  	if (unlikely(ret < 0))
>  		goto out_unlock;
>  	set_page_dirty(page);
> -	wait_on_page_writeback(page);
> +	wait_for_stable_page(page);
>  	return 0;
>  out_unlock:
>  	unlock_page(page);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index b3c243b..1bfc79f 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4814,7 +4814,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  		if (!walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
>  					ext4_bh_unmapped)) {
>  			/* Wait so that we don't change page under IO */
> -			wait_on_page_writeback(page);
> +			wait_for_stable_page(page);
>  			ret = VM_FAULT_LOCKED;
>  			goto out;
>  		}
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index e42c762..ea631ee 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -398,6 +398,7 @@ static inline void wait_on_page_writeback(struct page *page)
>  }
>  
>  extern void end_page_writeback(struct page *page);
> +void wait_for_stable_page(struct page *page);
>  
>  /*
>   * Add an arbitrary waiter to a page's wait queue
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 83efee7..5577dc8 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1728,6 +1728,7 @@ int filemap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	 * see the dirty page and writeprotect it again.
>  	 */
>  	set_page_dirty(page);
> +	wait_for_stable_page(page);
>  out:
>  	sb_end_pagefault(inode->i_sb);
>  	return ret;
> @@ -2274,7 +2275,7 @@ repeat:
>  		return NULL;
>  	}
>  found:
> -	wait_on_page_writeback(page);
> +	wait_for_stable_page(page);
>  	return page;
>  }
>  EXPORT_SYMBOL(grab_cache_page_write_begin);
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 830893b..3e4a8cc 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2275,3 +2275,23 @@ int mapping_tagged(struct address_space *mapping, int tag)
>  	return radix_tree_tagged(&mapping->page_tree, tag);
>  }
>  EXPORT_SYMBOL(mapping_tagged);
> +
> +/**
> + * wait_for_stable_page() - wait for writeback to finish, if necessary.
> + * @page:	The page to wait on.
> + *
> + * This function determines if the given page is related to a backing device
> + * that requires page contents to be held stable during writeback.  If so, then
> + * it will wait for any pending writeback to complete.
> + */
> +void wait_for_stable_page(struct page *page)
> +{
> +	struct address_space *mapping = page_mapping(page);
> +	struct backing_dev_info *bdi = mapping->backing_dev_info;
> +
> +	if (!bdi_cap_stable_pages_required(bdi))
> +		return;
> +
> +	wait_on_page_writeback(page);
> +}
> +EXPORT_SYMBOL_GPL(wait_for_stable_page);
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
