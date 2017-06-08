From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] ext4: change sequential discard handling on commit
 complete phase into parallel manner
Date: Thu, 8 Jun 2017 10:19:37 +0200
Message-ID: <20170608081937.GA31632@quack2.suse.cz>
References: <CGME20170608014457epcas1p2c2f6af76eee8ab0c20f8f9d8fbcae563@epcas1p2.samsung.com>
 <1496886288-6290-1-git-send-email-daeho.jeong@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.com, tytso@mit.edu, hch@infradead.org,
        linux-ext4@vger.kernel.org
To: Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42940 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751734AbdFHITk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 8 Jun 2017 04:19:40 -0400
Content-Disposition: inline
In-Reply-To: <1496886288-6290-1-git-send-email-daeho.jeong@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 08-06-17 10:44:48, Daeho Jeong wrote:
> Now, when we mount ext4 filesystem with '-o discard' option, we have to
> issue all the discard commands for the blocks to be deallocated and
> wait for the completion of the commands on the commit complete phase.
> Because this procedure might involve a lot of sequential combinations of
> issuing discard commands and waiting for that, the delay of this
> procedure might be too much long, even to half a minute in our test,
> and it results in long commit delay and fsync() performance degradation.
> 
> When we converted this sequential discard handling on commit complete
> phase into a parallel manner like XFS filesystem, we could enhance the
> discard command handling performance. The result was such that 17.0s
> delay of a single commit in the worst case has been enhanced to 4.8s.

Hmm, here you speak about 17s, in the above paragraph about half a minute
so what was it? Just curious...

> Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
> Tested-by: Hobin Woo <hobin.woo@samsung.com>
> Tested-by: Kitae Lee <kitae87.lee@samsung.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Actually, I didn't give my 'Reviewed-by' tag yet... But the patch looks
generally good, some smaller comments below.

> @@ -2862,6 +2850,62 @@ static void ext4_free_data_callback(struct super_block *sb,
>  	mb_debug(1, "freed %u blocks in %u structures\n", count, count2);
>  }
>  
> +/*
> + * This function is called by the jbd2 layer once the commit has finished,
> + * so we know we can free the blocks that were released with that commit.
> + */
> +void ext4_process_freed_data(struct super_block *sb, tid_t commit_tid)
> +{
> +	struct ext4_sb_info *sbi = EXT4_SB(sb);
> +	struct ext4_free_data *entry;
> +	struct bio *discard_bio = NULL;
> +	struct list_head freed_data_list;
> +	struct list_head *cur;
> +	struct list_head *tmp;
> +	int err;
> +
> +	INIT_LIST_HEAD(&freed_data_list);
> +
> +	spin_lock(&sbi->s_md_lock);
> +	list_for_each_safe(cur, tmp, &sbi->s_freed_data_list) {
> +		entry = list_entry(cur, struct ext4_free_data, efd_list);

Use list_for_each_entry_safe() instead of explicit list_entry() call.

> +		if (entry->efd_tid != commit_tid)
> +			break;
> +		entry->efd_freed = true;
> +		list_del(&entry->efd_list);
> +		list_add_tail(&entry->efd_list, &freed_data_list);
> +	}
> +	spin_unlock(&sbi->s_md_lock);

Just find the right entry in the above loop and then use
list_cut_position() to split the list as needed. That saves us having to
remove and add each entry. Also you don't have to use _safe() list entry
iteration in that case.

> +
> +	if (test_opt(sb, DISCARD)) {
> +		list_for_each(cur, &freed_data_list) {
> +			entry = list_entry(cur, struct ext4_free_data,
> +					   efd_list);

Again use list_for_each_entry().

> +
> +			err = ext4_issue_discard(sb, entry->efd_group,
> +						 entry->efd_start_cluster,
> +						 entry->efd_count,
> +						 &discard_bio);
> +			if (err && err != -EOPNOTSUPP) {
> +				ext4_msg(sb, KERN_WARNING, "discard request in"
> +					 " group:%d block:%d count:%d failed"
> +					 " with %d", entry->efd_group,
> +					 entry->efd_start_cluster,
> +					 entry->efd_count, err);
> +			} else if (err == -EOPNOTSUPP)
> +				break;
> +		}
> +
> +		if (discard_bio)
> +			submit_bio_wait(discard_bio);
> +	}
> +
> +	list_for_each_safe(cur, tmp, &freed_data_list) {
> +		entry = list_entry(cur, struct ext4_free_data, efd_list);

And here use list_for_each_entry_safe().

> +		ext4_free_data_in_buddy(sb, entry);
> +	}
> +}
> +
>  int __init ext4_init_mballoc(void)
>  {
>  	ext4_pspace_cachep = KMEM_CACHE(ext4_prealloc_space,
> @@ -4588,6 +4632,21 @@ static int can_merge(struct ext4_free_data *entry1,
>  	return 0;
>  }
>  
> +static inline bool ext4_freed_data_try_del(struct ext4_sb_info *sbi,
> +					   struct ext4_free_data *entry)
> +{
> +	bool deleted = false;
> +
> +	spin_lock(&sbi->s_md_lock);
> +	if (!entry->efd_freed) {
> +		entry->efd_freed = true;
> +		list_del(&entry->efd_list);
> +		deleted = true;
> +	}
> +	spin_unlock(&sbi->s_md_lock);
> +	return deleted;
> +}

efd_freed can never be true here - see my explanation at the end. So you
can simplify the code by implementing something like:

void ext4_try_merge_freed_extent(struct ext4_sb_info *sbi,
				 struct ext4_free_data *entry,
				 struct ext4_free_data *new_entry)
{
	if ((entry->efd_tid != new_entry->efd_tid) ||
            (entry->efd_group != new_entry->efd_group))
		return;
	if (entry->efd_start_cluster + entry->efd_count ==
	    new_entry->efd_start_cluster) {
		new_entry->efd_start_cluster = entry->efd_start_cluster;
		new_entry->efd_count += entry->efd_count;
	} else if (new_entry->efd_start_cluster + new_entry->efd_count ==
		   entry->efd_start_cluster) {
		new_entry->efd_count += entry->efd_count;
	}
	spin_lock(&sbi->s_md_lock);
	list_del(&entry->efd_list);
	spin_unlock(&sbi->s_md_lock);
	rb_erase(entry->efd_node, &(db->bb_free_root));
	kmem_cache_free(ext4_free_data_cachep, entry);
}

which should handle all that is needed in one place.

> +
>  static noinline_for_stack int
>  ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
>  		      struct ext4_free_data *new_entry)
> @@ -4642,7 +4701,7 @@ static int can_merge(struct ext4_free_data *entry1,
>  	if (node) {
>  		entry = rb_entry(node, struct ext4_free_data, efd_node);
>  		if (can_merge(entry, new_entry) &&
> -		    ext4_journal_callback_try_del(handle, &entry->efd_jce)) {
> +		    ext4_freed_data_try_del(sbi, entry)) {
>  			new_entry->efd_start_cluster = entry->efd_start_cluster;
>  			new_entry->efd_count += entry->efd_count;
>  			rb_erase(node, &(db->bb_free_root));
> @@ -4654,16 +4713,15 @@ static int can_merge(struct ext4_free_data *entry1,
>  	if (node) {
>  		entry = rb_entry(node, struct ext4_free_data, efd_node);
>  		if (can_merge(new_entry, entry) &&
> -		    ext4_journal_callback_try_del(handle, &entry->efd_jce)) {
> +		    ext4_freed_data_try_del(sbi, entry)) {
>  			new_entry->efd_count += entry->efd_count;
>  			rb_erase(node, &(db->bb_free_root));
>  			kmem_cache_free(ext4_free_data_cachep, entry);
>  		}
>  	}
> -	/* Add the extent to transaction's private list */
> -	new_entry->efd_jce.jce_func = ext4_free_data_callback;
> +
>  	spin_lock(&sbi->s_md_lock);
> -	_ext4_journal_callback_add(handle, &new_entry->efd_jce);
> +	list_add_tail(&new_entry->efd_list, &sbi->s_freed_data_list);
>  	sbi->s_mb_free_pending += clusters;
>  	spin_unlock(&sbi->s_md_lock);
>  	return 0;
> @@ -4856,6 +4914,7 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
>  		new_entry->efd_group = block_group;
>  		new_entry->efd_count = count_clusters;
>  		new_entry->efd_tid = handle->h_transaction->t_tid;
> +		new_entry->efd_freed = false;
>  
>  		ext4_lock_group(sb, block_group);
>  		mb_clear_bits(bitmap_bh->b_data, bit, count_clusters);
> @@ -4866,7 +4925,8 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
>  		 * them with group lock_held
>  		 */
>  		if (test_opt(sb, DISCARD)) {
> -			err = ext4_issue_discard(sb, block_group, bit, count);
> +			err = ext4_issue_discard(sb, block_group, bit, count,
> +						 NULL);
>  			if (err && err != -EOPNOTSUPP)
>  				ext4_msg(sb, KERN_WARNING, "discard request in"
>  					 " group:%d block:%d count:%lu failed"
> @@ -5089,7 +5149,7 @@ static int ext4_trim_extent(struct super_block *sb, int start, int count,
>  	 */
>  	mb_mark_used(e4b, &ex);
>  	ext4_unlock_group(sb, group);
> -	ret = ext4_issue_discard(sb, group, start, count);
> +	ret = ext4_issue_discard(sb, group, start, count, NULL);
>  	ext4_lock_group(sb, group);
>  	mb_free_blocks(NULL, e4b, start, ex.fe_len);
>  	return ret;
> diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
> index 1aba469..f762509 100644
> --- a/fs/ext4/mballoc.h
> +++ b/fs/ext4/mballoc.h
> @@ -78,10 +78,8 @@
>  
>  
>  struct ext4_free_data {
> -	/* MUST be the first member */
> -	struct ext4_journal_cb_entry	efd_jce;
> -
> -	/* ext4_free_data private data starts from here */
> +	/* this links the free block information from sb_info */
> +	struct list_head		efd_list;
>  
>  	/* this links the free block information from group_info */
>  	struct rb_node			efd_node;
> @@ -95,6 +93,9 @@ struct ext4_free_data {
>  
>  	/* transaction which freed this extent */
>  	tid_t				efd_tid;
> +
> +	/* indicate whether this is already handled */
> +	bool				efd_freed;
>  };

Two comments here:

a) 'bool' type in structures is discouraged in kernel as it can lead to
strange alignment issues etc. Just use int or bitfields.

b) efd_freed seems in fact unnecessary. You use it only in
ext4_freed_data_try_del() which is called only if merge succeeded which
means tids match and thus we currently have handle open against the
transaction with that pid and so that transaction cannot commit... So all
in all efd_freed can never be set in the places where you call
ext4_freed_data_try_del().

Thanks for working on this!

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
