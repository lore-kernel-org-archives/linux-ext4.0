From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 4/7] VFS: Rename and refactor
 writeback_inodes_sb_if_idle
Date: Fri, 6 Jan 2012 01:33:39 +0100
Message-ID: <20120106003339.GB3790@quack.suse.cz>
References: <1323367477-21685-1-git-send-email-kamal@canonical.com>
 <1323367477-21685-5-git-send-email-kamal@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Matthew Wilcox <matthew@wil.cx>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Theodore Tso <tytso@mit.edu>, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Surbhi Palande <csurbhi@gmail.com>,
	Valerie Aurora <val@vaaconsulting.com>,
	Christopher Chaltain <christopher.chaltain@canonical.com>,
	"Peter M. Petrakis" <peter.petrakis@canonical.com>,
	Mikulas Patocka <mpatocka@redhat.com>
To: Kamal Mostafa <kamal@canonical.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41830 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758249Ab2AFAdl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Jan 2012 19:33:41 -0500
Content-Disposition: inline
In-Reply-To: <1323367477-21685-5-git-send-email-kamal@canonical.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 08-12-11 10:04:34, Kamal Mostafa wrote:
> Rename writeback_inodes_sb{_nr}_if_idle to try_to_writeback_inodes_sb{_nr}
> and refactor to avoid duplicating logic.
  Looks good to me. You can add:
Acked-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Signed-off-by: Kamal Mostafa <kamal@canonical.com>
> ---
>  fs/btrfs/extent-tree.c    |    2 +-
>  fs/ext4/inode.c           |    2 +-
>  fs/fs-writeback.c         |   25 +++++++++++--------------
>  include/linux/writeback.h |    4 ++--
>  4 files changed, 15 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index f0d5718..6f6fe2b 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3416,7 +3416,7 @@ static int shrink_delalloc(struct btrfs_root *root, u64 to_reclaim,
>  		smp_mb();
>  		nr_pages = min_t(unsigned long, nr_pages,
>  		       root->fs_info->delalloc_bytes >> PAGE_CACHE_SHIFT);
> -		writeback_inodes_sb_nr_if_idle(root->fs_info->sb, nr_pages,
> +		try_to_writeback_inodes_sb_nr(root->fs_info->sb, nr_pages,
>  						WB_REASON_FS_FREE_SPACE);
>  
>  		spin_lock(&space_info->lock);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 848f436..0da75cd 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2373,7 +2373,7 @@ static int ext4_nonda_switch(struct super_block *sb)
>  	 * start pushing delalloc when 1/2 of free blocks are dirty.
>  	 */
>  	if (free_blocks < 2 * dirty_blocks)
> -		writeback_inodes_sb_if_idle(sb, WB_REASON_FS_FREE_SPACE);
> +		try_to_writeback_inodes_sb(sb, WB_REASON_FS_FREE_SPACE);
>  
>  	return 0;
>  }
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index eee01cd..ea89b3f 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -1271,45 +1271,42 @@ void writeback_inodes_sb(struct super_block *sb, enum wb_reason reason)
>  EXPORT_SYMBOL(writeback_inodes_sb);
>  
>  /**
> - * writeback_inodes_sb_if_idle	-	start writeback if none underway
> + * try_to_writeback_inodes_sb	-	start writeback if none underway
>   * @sb: the superblock
>   *
>   * Invoke writeback_inodes_sb if no writeback is currently underway.
>   * Returns 1 if writeback was started, 0 if not.
>   */
> -int writeback_inodes_sb_if_idle(struct super_block *sb, enum wb_reason reason)
> +int try_to_writeback_inodes_sb(struct super_block *sb, enum wb_reason reason)
>  {
> -	if (!writeback_in_progress(sb->s_bdi)) {
> -		down_read(&sb->s_umount);
> -		writeback_inodes_sb(sb, reason);
> -		up_read(&sb->s_umount);
> -		return 1;
> -	} else
> -		return 0;
> +	return try_to_writeback_inodes_sb_nr(sb, 0, reason);
>  }
> -EXPORT_SYMBOL(writeback_inodes_sb_if_idle);
> +EXPORT_SYMBOL(try_to_writeback_inodes_sb);
>  
>  /**
> - * writeback_inodes_sb_if_idle	-	start writeback if none underway
> + * try_to_writeback_inodes_sb_nr	-	start writeback if none underway
>   * @sb: the superblock
>   * @nr: the number of pages to write
>   *
>   * Invoke writeback_inodes_sb if no writeback is currently underway.
>   * Returns 1 if writeback was started, 0 if not.
>   */
> -int writeback_inodes_sb_nr_if_idle(struct super_block *sb,
> +int try_to_writeback_inodes_sb_nr(struct super_block *sb,
>  				   unsigned long nr,
>  				   enum wb_reason reason)
>  {
>  	if (!writeback_in_progress(sb->s_bdi)) {
>  		down_read(&sb->s_umount);
> -		writeback_inodes_sb_nr(sb, nr, reason);
> +		if (nr == 0)
> +			writeback_inodes_sb(sb, reason);
> +		else
> +			writeback_inodes_sb_nr(sb, nr, reason);
>  		up_read(&sb->s_umount);
>  		return 1;
>  	} else
>  		return 0;
>  }
> -EXPORT_SYMBOL(writeback_inodes_sb_nr_if_idle);
> +EXPORT_SYMBOL(try_to_writeback_inodes_sb_nr);
>  
>  /**
>   * sync_inodes_sb	-	sync sb inode pages
> diff --git a/include/linux/writeback.h b/include/linux/writeback.h
> index a378c29..e824225 100644
> --- a/include/linux/writeback.h
> +++ b/include/linux/writeback.h
> @@ -89,8 +89,8 @@ int inode_wait(void *);
>  void writeback_inodes_sb(struct super_block *, enum wb_reason reason);
>  void writeback_inodes_sb_nr(struct super_block *, unsigned long nr,
>  							enum wb_reason reason);
> -int writeback_inodes_sb_if_idle(struct super_block *, enum wb_reason reason);
> -int writeback_inodes_sb_nr_if_idle(struct super_block *, unsigned long nr,
> +int try_to_writeback_inodes_sb(struct super_block *, enum wb_reason reason);
> +int try_to_writeback_inodes_sb_nr(struct super_block *, unsigned long nr,
>  							enum wb_reason reason);
>  void sync_inodes_sb(struct super_block *);
>  long writeback_inodes_wb(struct bdi_writeback *wb, long nr_pages,
> -- 
> 1.7.5.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
