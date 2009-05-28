From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Add WARN_ON on unmapped dirty buffer_heads in
	writepage
Date: Thu, 28 May 2009 12:06:58 +0200
Message-ID: <20090528100657.GI29199@duck.suse.cz>
References: <1243499264-29629-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com, jack@suse.cz,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50268 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbZE1KG6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 May 2009 06:06:58 -0400
Content-Disposition: inline
In-Reply-To: <1243499264-29629-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 28-05-09 13:57:44, Aneesh Kumar K.V wrote:
> Now we have block_lock_hole_extend clearing the dirty flag of
> buffer_heads outside i_size we should not find buffer_heads
> which are unmapped and dirty in writepage. If we find do a WARN_ON.
> We can still continue because block_write_full page look at the mapped
> flag only.
> 
> Following sequence of events would result in the above condition.
> 1) truncate(f, 1024)
> 2) mmap(f, 0, 4096)
> 3) a[0] = 'a'
> 4) truncate(f, 4096)
> 5) writepage(...)
> 
> After step 3 we would have unmapped buffer_heads outside i_size.
> After step 4 we would have unmapped buffer_heads within i_size.
> 
> Now that truncate is calling block_lock_hole_extend which in turn
> is clearing the dirty flag, we can safely assume that we won't
> find unmapped dirty buffer_heads in write page. If we did find one
> we should find out why.
  Thanks. Apart from one coding-style nitpick, you can add:
Acked-by: Jan Kara <jack@suse.cz>

									Honza

> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/inode.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index f6f2202..ca26bdd 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2509,6 +2509,11 @@ static int __ext4_journalled_writepage(struct page *page,
>  	return ret;
>  }
>  
> +static int ext4_bh_unmapped_and_dirty(handle_t *handle, struct buffer_head *bh)
> +{
> +	return (!buffer_mapped(bh)) && buffer_dirty(bh);
               ^                  ^
                looks a bit strange
> +}
> +
>  /*
>   * Note that we don't need to start a transaction unless we're journaling data
>   * because we should have holes filled from ext4_page_mkwrite(). We even don't
> @@ -2622,6 +2627,14 @@ static int ext4_writepage(struct page *page,
>  		/* now mark the buffer_heads as dirty and uptodate */
>  		block_commit_write(page, 0, len);
>  	}
> +	/*
> +	 * There should not be any unmapped and dirty
> +	 * buffer_heads at this point. Look at block_lock_hole_extend
> +	 * for more info. If we find one print more info
> +	 */
> +	 WARN(walk_page_buffers(NULL, page_bufs, 0, len, NULL,
> +				 ext4_bh_unmapped_and_dirty),
> +		 "Unmapped dirty buffer_heads found in %s\n", __func__);
>  
>  	if (PageChecked(page) && ext4_should_journal_data(inode)) {
>  		/*
> -- 
> 1.6.3.1.145.gb74d77
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
