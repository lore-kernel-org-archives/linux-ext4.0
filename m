From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] ext4: remove while loop in
 mpage_map_and_submit_extent()
Date: Fri, 21 Jun 2013 18:32:36 +0200
Message-ID: <20130621163236.GN13932@quack.suse.cz>
References: <1371477488-17722-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53171 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423252Ab3FUQci (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Jun 2013 12:32:38 -0400
Content-Disposition: inline
In-Reply-To: <1371477488-17722-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 17-06-13 09:58:07, Ted Tso wrote:
> The while loop in mpage_map_and_submit_extent() is pointless; this
> function is only called if mpd.map.m_len is non-zero, and at the end
> of the while loop, mpage_map_and_submit_buffers sets mpd.map.m_len to
> be zero on success.  (And on a failure, we return out of the while
> loop anyway.)
  This is not true. In case blocksize < pagesize and we were not able to
map a full page, mpage_map_and_submit_buffers() changes mpd->map to point
to the next extent inside the page that needs mapping. In that case we can
take several iterations of the loop. Maybe this fact deserves a comment
before the loop but there's a comment before the callsite of
mpage_map_and_submit_buffers() which mentions that it will get us next
extent to map and also the documentation of mpage_map_and_submit_buffers()
explicitely tells that it can update mpd->map.

								Honza

> Hence, the body of the while loop is guaranteed to execute once and
> exactly once.  This also fixes a gcc warning complaining that err
> might be left uninitialized.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/inode.c | 66 ++++++++++++++++++++++++++++-----------------------------
>  1 file changed, 32 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 2644679..0e61543 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2157,44 +2157,42 @@ static int mpage_map_and_submit_extent(handle_t *handle,
>  
>  	mpd->io_submit.io_end->offset =
>  				((loff_t)map->m_lblk) << inode->i_blkbits;
> -	while (map->m_len) {
> -		err = mpage_map_one_extent(handle, mpd);
> -		if (err < 0) {
> -			struct super_block *sb = inode->i_sb;
> +	err = mpage_map_one_extent(handle, mpd);
> +	if (err < 0) {
> +		struct super_block *sb = inode->i_sb;
>  
> -			/*
> -			 * Need to commit transaction to free blocks. Let upper
> -			 * layers sort it out.
> -			 */
> -			if (err == -ENOSPC && ext4_count_free_clusters(sb))
> -				return -ENOSPC;
> -
> -			if (!(EXT4_SB(sb)->s_mount_flags & EXT4_MF_FS_ABORTED)) {
> -				ext4_msg(sb, KERN_CRIT,
> -					 "Delayed block allocation failed for "
> -					 "inode %lu at logical offset %llu with"
> -					 " max blocks %u with error %d",
> -					 inode->i_ino,
> -					 (unsigned long long)map->m_lblk,
> -					 (unsigned)map->m_len, err);
> -				ext4_msg(sb, KERN_CRIT,
> -					 "This should not happen!! Data will "
> -					 "be lost\n");
> -				if (err == -ENOSPC)
> -					ext4_print_free_blocks(inode);
> -			}
> -			/* invalidate all the pages */
> -			mpage_release_unused_pages(mpd, true);
> -			return err;
> -		}
>  		/*
> -		 * Update buffer state, submit mapped pages, and get us new
> -		 * extent to map
> +		 * Need to commit transaction to free blocks. Let upper
> +		 * layers sort it out.
>  		 */
> -		err = mpage_map_and_submit_buffers(mpd);
> -		if (err < 0)
> -			return err;
> +		if (err == -ENOSPC && ext4_count_free_clusters(sb))
> +			return -ENOSPC;
> +
> +		if (!(EXT4_SB(sb)->s_mount_flags & EXT4_MF_FS_ABORTED)) {
> +			ext4_msg(sb, KERN_CRIT,
> +				 "Delayed block allocation failed for "
> +				 "inode %lu at logical offset %llu with"
> +				 " max blocks %u with error %d",
> +				 inode->i_ino,
> +				 (unsigned long long)map->m_lblk,
> +				 (unsigned)map->m_len, err);
> +			ext4_msg(sb, KERN_CRIT,
> +				 "This should not happen!! Data will "
> +				 "be lost\n");
> +			if (err == -ENOSPC)
> +				ext4_print_free_blocks(inode);
> +		}
> +		/* invalidate all the pages */
> +		mpage_release_unused_pages(mpd, true);
> +		return err;
>  	}
> +	/*
> +	 * Update buffer state, submit mapped pages, and get us new
> +	 * extent to map
> +	 */
> +	err = mpage_map_and_submit_buffers(mpd);
> +	if (err < 0)
> +		return err;
>  
>  	/* Update on-disk size after IO is submitted */
>  	disksize = ((loff_t)mpd->first_page) << PAGE_CACHE_SHIFT;
> -- 
> 1.7.12.rc0.22.gcdd159b
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
