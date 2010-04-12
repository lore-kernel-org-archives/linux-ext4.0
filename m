From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext4: init statistics after journal recovery v2
Date: Mon, 12 Apr 2010 21:37:29 +0200
Message-ID: <20100412193728.GP3404@quack.suse.cz>
References: <1271099576-7507-1-git-send-email-dmonakhov@openvz.org>
 <1271099576-7507-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55196 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778Ab0DLThV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Apr 2010 15:37:21 -0400
Content-Disposition: inline
In-Reply-To: <1271099576-7507-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 12-04-10 23:12:56, Dmitry Monakhov wrote:
> Currently block/inode/dir counters initialized before journal was
> recovered. In fact after journal recovery this info will probably
> change. And freeblocks it critical for correct delalloc mode
> accounting.
> BUG:#15768
  This patch looks fine. Acked-by: Jan Kara <jack@suse.cz>

								Honza
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/super.c |   44 ++++++++++++++++++++++----------------------
>  1 files changed, 22 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 29c6875..04a30ef 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2793,24 +2793,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	get_random_bytes(&sbi->s_next_generation, sizeof(u32));
>  	spin_lock_init(&sbi->s_next_gen_lock);
>  
> -	err = percpu_counter_init(&sbi->s_freeblocks_counter,
> -			ext4_count_free_blocks(sb));
> -	if (!err) {
> -		err = percpu_counter_init(&sbi->s_freeinodes_counter,
> -				ext4_count_free_inodes(sb));
> -	}
> -	if (!err) {
> -		err = percpu_counter_init(&sbi->s_dirs_counter,
> -				ext4_count_dirs(sb));
> -	}
> -	if (!err) {
> -		err = percpu_counter_init(&sbi->s_dirtyblocks_counter, 0);
> -	}
> -	if (err) {
> -		ext4_msg(sb, KERN_ERR, "insufficient memory");
> -		goto failed_mount3;
> -	}
> -
>  	sbi->s_stripe = ext4_get_stripe_size(sbi);
>  	sbi->s_max_writeback_mb_bump = 128;
>  
> @@ -2910,6 +2892,24 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	set_task_ioprio(sbi->s_journal->j_task, journal_ioprio);
>  
>  no_journal:
> +	err = percpu_counter_init(&sbi->s_freeblocks_counter,
> +			ext4_count_free_blocks(sb));
> +	if (!err) {
> +		err = percpu_counter_init(&sbi->s_freeinodes_counter,
> +				ext4_count_free_inodes(sb));
> +	}
> +	if (!err) {
> +		err = percpu_counter_init(&sbi->s_dirs_counter,
> +				ext4_count_dirs(sb));
> +	}
> +	if (!err) {
> +		err = percpu_counter_init(&sbi->s_dirtyblocks_counter, 0);
> +	}
> +	if (err) {
> +		ext4_msg(sb, KERN_ERR, "insufficient memory");
> +		goto failed_mount_wq;
> +	}
> +
>  	if (test_opt(sb, NOBH)) {
>  		if (!(test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_WRITEBACK_DATA)) {
>  			ext4_msg(sb, KERN_WARNING, "Ignoring nobh option - "
> @@ -3059,6 +3059,10 @@ failed_mount_wq:
>  		jbd2_journal_destroy(sbi->s_journal);
>  		sbi->s_journal = NULL;
>  	}
> +	percpu_counter_destroy(&sbi->s_freeblocks_counter);
> +	percpu_counter_destroy(&sbi->s_freeinodes_counter);
> +	percpu_counter_destroy(&sbi->s_dirs_counter);
> +	percpu_counter_destroy(&sbi->s_dirtyblocks_counter);
>  failed_mount3:
>  	if (sbi->s_flex_groups) {
>  		if (is_vmalloc_addr(sbi->s_flex_groups))
> @@ -3066,10 +3070,6 @@ failed_mount3:
>  		else
>  			kfree(sbi->s_flex_groups);
>  	}
> -	percpu_counter_destroy(&sbi->s_freeblocks_counter);
> -	percpu_counter_destroy(&sbi->s_freeinodes_counter);
> -	percpu_counter_destroy(&sbi->s_dirs_counter);
> -	percpu_counter_destroy(&sbi->s_dirtyblocks_counter);
>  failed_mount2:
>  	for (i = 0; i < db_count; i++)
>  		brelse(sbi->s_group_desc[i]);
> -- 
> 1.6.6.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
