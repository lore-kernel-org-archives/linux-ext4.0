From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: use atomic64_t for the per-flexbg free_clusters
 count
Date: Tue, 12 Mar 2013 16:09:54 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1303121605480.7128@dhcp-1-104.brq.redhat.com>
References: <1363059885-29942-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932569Ab3CLPJ7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Mar 2013 11:09:59 -0400
In-Reply-To: <1363059885-29942-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 11 Mar 2013, Theodore Ts'o wrote:

> Date: Mon, 11 Mar 2013 23:44:44 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Ext4 Developers List <linux-ext4@vger.kernel.org>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Subject: [PATCH] ext4: use atomic64_t for the per-flexbg free_clusters count
> 
> A user who was using a 8TB+ file system and with a very large flexbg
> size (> 65536) could cause the atomic_t used in the struct flex_groups
> to overflow.  This was detected by PaX security patchset:
> 
> http://forums.grsecurity.net/viewtopic.php?f=3&t=3289&p=12551#p12551
> 
> Fix this by using an atomic64_t for struct orlav_stats's
> free_clusters.

Looks ok. Thanks!

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/ext4.h    |  6 +++---
>  fs/ext4/ialloc.c  |  4 ++--
>  fs/ext4/mballoc.c | 12 ++++++------
>  fs/ext4/resize.c  |  4 ++--
>  fs/ext4/super.c   |  4 ++--
>  5 files changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 6ac9b9a..29bb0ac 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -335,9 +335,9 @@ struct ext4_group_desc
>   */
>  
>  struct flex_groups {
> -	atomic_t free_inodes;
> -	atomic_t free_clusters;
> -	atomic_t used_dirs;
> +	atomic64_t	free_clusters;
> +	atomic_t	free_inodes;
> +	atomic_t	used_dirs;
>  };
>  
>  #define EXT4_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not in use */
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 32fd2b9..6c5bb8d 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -324,8 +324,8 @@ error_return:
>  }
>  
>  struct orlov_stats {
> +	__u64 free_clusters;
>  	__u32 free_inodes;
> -	__u32 free_clusters;
>  	__u32 used_dirs;
>  };
>  
> @@ -342,7 +342,7 @@ static void get_orlov_stats(struct super_block *sb, ext4_group_t g,
>  
>  	if (flex_size > 1) {
>  		stats->free_inodes = atomic_read(&flex_group[g].free_inodes);
> -		stats->free_clusters = atomic_read(&flex_group[g].free_clusters);
> +		stats->free_clusters = atomic64_read(&flex_group[g].free_clusters);
>  		stats->used_dirs = atomic_read(&flex_group[g].used_dirs);
>  		return;
>  	}
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 8b2ea9f..ee6614b 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2804,8 +2804,8 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
>  	if (sbi->s_log_groups_per_flex) {
>  		ext4_group_t flex_group = ext4_flex_group(sbi,
>  							  ac->ac_b_ex.fe_group);
> -		atomic_sub(ac->ac_b_ex.fe_len,
> -			   &sbi->s_flex_groups[flex_group].free_clusters);
> +		atomic64_sub(ac->ac_b_ex.fe_len,
> +			     &sbi->s_flex_groups[flex_group].free_clusters);
>  	}
>  
>  	err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
> @@ -4661,8 +4661,8 @@ do_more:
>  
>  	if (sbi->s_log_groups_per_flex) {
>  		ext4_group_t flex_group = ext4_flex_group(sbi, block_group);
> -		atomic_add(count_clusters,
> -			   &sbi->s_flex_groups[flex_group].free_clusters);
> +		atomic64_add(count_clusters,
> +			     &sbi->s_flex_groups[flex_group].free_clusters);
>  	}
>  
>  	ext4_mb_unload_buddy(&e4b);
> @@ -4804,8 +4804,8 @@ int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
>  
>  	if (sbi->s_log_groups_per_flex) {
>  		ext4_group_t flex_group = ext4_flex_group(sbi, block_group);
> -		atomic_add(EXT4_NUM_B2C(sbi, blocks_freed),
> -			   &sbi->s_flex_groups[flex_group].free_clusters);
> +		atomic64_add(EXT4_NUM_B2C(sbi, blocks_freed),
> +			     &sbi->s_flex_groups[flex_group].free_clusters);
>  	}
>  
>  	ext4_mb_unload_buddy(&e4b);
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index b2c8ee5..c169477 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -1360,8 +1360,8 @@ static void ext4_update_super(struct super_block *sb,
>  	    sbi->s_log_groups_per_flex) {
>  		ext4_group_t flex_group;
>  		flex_group = ext4_flex_group(sbi, group_data[0].group);
> -		atomic_add(EXT4_NUM_B2C(sbi, free_blocks),
> -			   &sbi->s_flex_groups[flex_group].free_clusters);
> +		atomic64_add(EXT4_NUM_B2C(sbi, free_blocks),
> +			     &sbi->s_flex_groups[flex_group].free_clusters);
>  		atomic_add(EXT4_INODES_PER_GROUP(sb) * flex_gd->count,
>  			   &sbi->s_flex_groups[flex_group].free_inodes);
>  	}
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 9379b7f..d1ee6a8 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1923,8 +1923,8 @@ static int ext4_fill_flex_info(struct super_block *sb)
>  		flex_group = ext4_flex_group(sbi, i);
>  		atomic_add(ext4_free_inodes_count(sb, gdp),
>  			   &sbi->s_flex_groups[flex_group].free_inodes);
> -		atomic_add(ext4_free_group_clusters(sb, gdp),
> -			   &sbi->s_flex_groups[flex_group].free_clusters);
> +		atomic64_add(ext4_free_group_clusters(sb, gdp),
> +			     &sbi->s_flex_groups[flex_group].free_clusters);
>  		atomic_add(ext4_used_dirs_count(sb, gdp),
>  			   &sbi->s_flex_groups[flex_group].used_dirs);
>  	}
> 
