From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 07/15] ext4: Take i_mutex before punching hole
Date: Sun, 19 Aug 2012 22:45:08 -0700 (PDT)
Message-ID: <alpine.LSU.2.00.1208192224390.2390@eggly.anvils>
References: <1343376074-28034-1-git-send-email-lczerner@redhat.com> <1343376074-28034-8-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	tytso@mit.edu, linux-mmc@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1343376074-28034-8-git-send-email-lczerner@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 27 Jul 2012, Lukas Czerner wrote:

> Currently the allocation might happen in the punched range after the
> truncation and before the releasing the space of the range. This would
> lead to blocks being unallocated under the mapped buffer heads resulting
> in nasty bugs.
> 
> With this commit we take i_mutex before going to do anything in the
> ext4_ext_punch_hole() preventing any write to happen while the hole
> punching is in progress. This will also allow us to ditch the writeout
> of dirty pages withing the range.
> 
> This commit was based on code provided by Zheng Liu, thanks!

I'm glad you have found that i_mutex really is needed here: it had
worried me that it was not taken, but I could only raise a concern,
didn't really know one way or the other.

> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/ext4/extents.c |   26 ++++++++++----------------
>  1 files changed, 10 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 91341ec..2d6a216 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4755,9 +4755,11 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
>  	loff_t first_page_offset, last_page_offset;
>  	int credits, err = 0;
>  
> +	mutex_lock(&inode->i_mutex);
> +
>  	/* No need to punch hole beyond i_size */
>  	if (offset >= inode->i_size)
> -		return 0;
> +		goto out1;

Note that this is wrong, but there is no reason why it should be you
to fix it in this patchset.  Blocks may have been fallocated beyond
i_size, and they should be removed when a hole is punched there.

It's on the ext4 TODO list to be fixed, so don't worry about it:
unless your changes happen to make it trivial to fix at the same time.

>  
>  	/*
>  	 * If the hole extends beyond i_size, set the hole
> @@ -4775,18 +4777,6 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
>  	first_page_offset = first_page << PAGE_CACHE_SHIFT;
>  	last_page_offset = last_page << PAGE_CACHE_SHIFT;
>  
> -	/*
> -	 * Write out all dirty pages to avoid race conditions
> -	 * Then release them.
> -	 */
> -	if (mapping->nrpages && mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
> -		err = filemap_write_and_wait_range(mapping,
> -			offset, offset + length - 1);
> -
> -		if (err)
> -			return err;
> -	}
> -

It's not clear to me why that's now safe to remove: a little more comment
in the commit would be good; but so long as it's clear to ext4 developers,
don't try to make it clear to me - that would take far too long!

Hugh

>  	/* Now release the pages */
>  	if (last_page_offset > first_page_offset) {
>  		truncate_pagecache_range(inode, first_page_offset,
> @@ -4798,12 +4788,14 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
>  
>  	credits = ext4_writepage_trans_blocks(inode);
>  	handle = ext4_journal_start(inode, credits);
> -	if (IS_ERR(handle))
> -		return PTR_ERR(handle);
> +	if (IS_ERR(handle)) {
> +		err = PTR_ERR(handle);
> +		goto out1;
> +	}
>  
>  	err = ext4_orphan_add(handle, inode);
>  	if (err)
> -		goto out;
> +		goto out1;
>  
>  	/*
>  	 * Now we need to zero out the non-page-aligned data in the
> @@ -4893,6 +4885,8 @@ out:
>  	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
>  	ext4_mark_inode_dirty(handle, inode);
>  	ext4_journal_stop(handle);
> +out1:
> +	mutex_unlock(&inode->i_mutex);
>  	return err;
>  }
>  int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> -- 
> 1.7.7.6
