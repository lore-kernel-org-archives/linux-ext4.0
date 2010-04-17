From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 2/2] ext4: fix inode bitmaps manipulation in free_inode
Date: Sat, 17 Apr 2010 14:57:22 +0400
Message-ID: <8739yu73e5.fsf@openvz.org>
References: <87pr2246y4.fsf@openvz.org>
	<1271244184-8693-1-git-send-email-dmonakhov@openvz.org>
	<1271244184-8693-2-git-send-email-dmonakhov@openvz.org>
	<20100415001242.GE19959@thunk.org> <20100416010649.GA31409@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:45222 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649Ab0DQK52 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 17 Apr 2010 06:57:28 -0400
Received: by bwz25 with SMTP id 25so3933187bwz.28
        for <linux-ext4@vger.kernel.org>; Sat, 17 Apr 2010 03:57:26 -0700 (PDT)
In-Reply-To: <20100416010649.GA31409@thunk.org> (tytso@mit.edu's message of
	"Thu, 15 Apr 2010 21:06:50 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu writes:

> Here's my -V3 respin of this patch, which further cleans up the code
> and removes some duplicated code by only calling ext4_clear_bit() from
> one call site.
>
> I think I'm about done for this, so if you agree with my improvements
> as improvements, it might be useful to port this back to ext3 version
> of this patch.
Ok, agree that's looks better.
>
> 						- Ted
>
> ext4: clean up inode bitmaps manipulation in ext4_free_inode
>
> From: Dmitry Monakhov <dmonakhov@openvz.org>
>
> - Reorganize locking scheme to batch two atomic operation in to one.
>   This also allow us to state what healthy group must obey following rule
>   ext4_free_inodes_count(sb, gdp) == ext4_count_free(inode_bitmap, NUM);
> - Fix possible undefined pointer dereference.
> - Even if group descriptor stats aren't accessible we have to update
>   inode bitmaps.
> - Move non-group members update out of group_lock.
>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/ialloc.c |   81 ++++++++++++++++++++++++-----------------------------
>  1 files changed, 37 insertions(+), 44 deletions(-)
>
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 57f6eef..52618d5 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -240,56 +240,49 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
>  	if (fatal)
>  		goto error_return;
>  
> -	/* Ok, now we can actually update the inode bitmaps.. */
> -	cleared = ext4_clear_bit_atomic(ext4_group_lock_ptr(sb, block_group),
> -					bit, bitmap_bh->b_data);
> -	if (!cleared)
> -		ext4_error(sb, "bit already cleared for inode %lu", ino);
> -	else {
> -		gdp = ext4_get_group_desc(sb, block_group, &bh2);
> -
> +	fatal = -ESRCH;
> +	gdp = ext4_get_group_desc(sb, block_group, &bh2);
> +	if (gdp) {
>  		BUFFER_TRACE(bh2, "get_write_access");
>  		fatal = ext4_journal_get_write_access(handle, bh2);
> -		if (fatal) goto error_return;
> -
> -		if (gdp) {
> -			ext4_lock_group(sb, block_group);
> -			count = ext4_free_inodes_count(sb, gdp) + 1;
> -			ext4_free_inodes_set(sb, gdp, count);
> -			if (is_directory) {
> -				count = ext4_used_dirs_count(sb, gdp) - 1;
> -				ext4_used_dirs_set(sb, gdp, count);
> -				if (sbi->s_log_groups_per_flex) {
> -					ext4_group_t f;
> -
> -					f = ext4_flex_group(sbi, block_group);
> -					atomic_dec(&sbi->s_flex_groups[f].used_dirs);
> -				}
> +	}
> +	ext4_lock_group(sb, block_group);
> +	cleared = ext4_clear_bit(bit, bitmap_bh->b_data);
> +	if (fatal || !cleared) {
> +		ext4_unlock_group(sb, block_group);
> +		goto out;
> +	}
>  
> -			}
> -			gdp->bg_checksum = ext4_group_desc_csum(sbi,
> -							block_group, gdp);
> -			ext4_unlock_group(sb, block_group);
> -			percpu_counter_inc(&sbi->s_freeinodes_counter);
> -			if (is_directory)
> -				percpu_counter_dec(&sbi->s_dirs_counter);
> -
> -			if (sbi->s_log_groups_per_flex) {
> -				ext4_group_t f;
> -
> -				f = ext4_flex_group(sbi, block_group);
> -				atomic_inc(&sbi->s_flex_groups[f].free_inodes);
> -			}
> -		}
> -		BUFFER_TRACE(bh2, "call ext4_handle_dirty_metadata");
> -		err = ext4_handle_dirty_metadata(handle, NULL, bh2);
> -		if (!fatal) fatal = err;
> +	count = ext4_free_inodes_count(sb, gdp) + 1;
> +	ext4_free_inodes_set(sb, gdp, count);
> +	if (is_directory) {
> +		count = ext4_used_dirs_count(sb, gdp) - 1;
> +		ext4_used_dirs_set(sb, gdp, count);
> +		percpu_counter_dec(&sbi->s_dirs_counter);
>  	}
> -	BUFFER_TRACE(bitmap_bh, "call ext4_handle_dirty_metadata");
> -	err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
> -	if (!fatal)
> -		fatal = err;
> -	sb->s_dirt = 1;
> +	gdp->bg_checksum = ext4_group_desc_csum(sbi, block_group, gdp);
> +	ext4_unlock_group(sb, block_group);
> +
> +	percpu_counter_inc(&sbi->s_freeinodes_counter);
> +	if (sbi->s_log_groups_per_flex) {
> +		ext4_group_t f = ext4_flex_group(sbi, block_group);
> +
> +		atomic_inc(&sbi->s_flex_groups[f].free_inodes);
> +		if (is_directory)
> +			atomic_dec(&sbi->s_flex_groups[f].used_dirs);
> +	}
> +	BUFFER_TRACE(bh2, "call ext4_handle_dirty_metadata");
> +	fatal = ext4_handle_dirty_metadata(handle, NULL, bh2);
> +out:
> +	if (cleared) {
> +		BUFFER_TRACE(bitmap_bh, "call ext4_handle_dirty_metadata");
> +		err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
> +		if (!fatal)
> +			fatal = err;
> +		sb->s_dirt = 1;
> +	} else
> +		ext4_error(sb, "bit already cleared for inode %lu", ino);
> +
>  error_return:
>  	brelse(bitmap_bh);
>  	ext4_std_error(sb, fatal);
