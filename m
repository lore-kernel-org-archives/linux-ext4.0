From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH -v2] ext4: move ext4_update_i_disksize() into
 mpage_map_and_submit_extent()
Date: Tue, 15 Apr 2014 18:26:27 +0200
Message-ID: <20140415162627.GA10144@quack.suse.cz>
References: <1397226957-9581-1-git-send-email-tytso@mit.edu>
 <1397310327-18147-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	pfonseca@mpi-sws.org, stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1397310327-18147-1-git-send-email-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat 12-04-14 09:45:27, Ted Tso wrote:
> The function ext4_update_i_disksize() is used in only one place, in
> the function mpage_map_and_submit_extent().  Move there to simplify
> the code paths, and also move the call to ext4_mark_inode_dirty() into
> the i_data_sem's critical region, to be consistent with all of the
> other places where we update i_disksize.  That way, we also keep the
> raw_inode's i_disksize protected.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: stable@vger.kernel.org
  I agree that it makes sense to have all the places consistent and protect
raw disk inode i_disksize with i_data_sem. OTOH I don't see a way how this
can cause any real harm (but I guess you expect there might be something as
you CCed stable), so can you explain it please?

								Honza
> ---
> 
> Oops, the first version was missing the commit description
> 
>  fs/ext4/ext4.h  | 17 -----------------
>  fs/ext4/inode.c | 16 +++++++++++++---
>  2 files changed, 13 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index f1c65dc..66946aa 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2466,23 +2466,6 @@ static inline void ext4_update_i_disksize(struct inode *inode, loff_t newsize)
>  	up_write(&EXT4_I(inode)->i_data_sem);
>  }
>  
> -/*
> - * Update i_disksize after writeback has been started. Races with truncate
> - * are avoided by checking i_size under i_data_sem.
> - */
> -static inline void ext4_wb_update_i_disksize(struct inode *inode, loff_t newsize)
> -{
> -	loff_t i_size;
> -
> -	down_write(&EXT4_I(inode)->i_data_sem);
> -	i_size = i_size_read(inode);
> -	if (newsize > i_size)
> -		newsize = i_size;
> -	if (newsize > EXT4_I(inode)->i_disksize)
> -		EXT4_I(inode)->i_disksize = newsize;
> -	up_write(&EXT4_I(inode)->i_data_sem);
> -}
> -
>  struct ext4_group_info {
>  	unsigned long   bb_state;
>  	struct rb_root  bb_free_root;
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 7b93df9..f023f0c 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2247,13 +2247,23 @@ static int mpage_map_and_submit_extent(handle_t *handle,
>  			return err;
>  	} while (map->m_len);
>  
> -	/* Update on-disk size after IO is submitted */
> +	/*
> +	 * Update on-disk size after IO is submitted.  Races with
> +	 * truncate are avoided by checking i_size under i_data_sem.
> +	 */
>  	disksize = ((loff_t)mpd->first_page) << PAGE_CACHE_SHIFT;
>  	if (disksize > EXT4_I(inode)->i_disksize) {
>  		int err2;
> -
> -		ext4_wb_update_i_disksize(inode, disksize);
> +		loff_t i_size;
> +
> +		down_write(&EXT4_I(inode)->i_data_sem);
> +		i_size = i_size_read(inode);
> +		if (disksize > i_size)
> +			disksize = i_size;
> +		if (disksize > EXT4_I(inode)->i_disksize)
> +			EXT4_I(inode)->i_disksize = disksize;
>  		err2 = ext4_mark_inode_dirty(handle, inode);
> +		up_write(&EXT4_I(inode)->i_data_sem);
>  		if (err2)
>  			ext4_error(inode->i_sb,
>  				   "Failed to mark inode %lu dirty",
> -- 
> 1.9.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
