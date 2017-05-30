From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: change sequential discard handling on commit
 complete phase into parallel manner
Date: Tue, 30 May 2017 11:16:26 +0200
Message-ID: <20170530091626.GA3284@quack2.suse.cz>
References: <CGME20170530030551epcas5p327c9acbabf266842887bcc86cac43cba@epcas5p3.samsung.com>
 <1496113566-18899-1-git-send-email-daeho.jeong@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.com, hch@infradead.org, tytso@mit.edu,
        linux-ext4@vger.kernel.org
To: Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52438 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750896AbdE3JQ3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 30 May 2017 05:16:29 -0400
Content-Disposition: inline
In-Reply-To: <1496113566-18899-1-git-send-email-daeho.jeong@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Daeho!

On Tue 30-05-17 12:06:06, Daeho Jeong wrote:
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
> 
> Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
> Tested-by: Hobin Woo <hobin.woo@samsung.com>
> Tested-by: Kitae Lee <kitae87.lee@samsung.com>

Thanks for the patch. The design looks good now! Some comments below.

> @@ -2810,18 +2812,6 @@ static void ext4_free_data_callback(struct super_block *sb,
>  	mb_debug(1, "gonna free %u blocks in group %u (0x%p):",
>  		 entry->efd_count, entry->efd_group, entry);
>  
> -	if (test_opt(sb, DISCARD)) {
> -		err = ext4_issue_discard(sb, entry->efd_group,
> -					 entry->efd_start_cluster,
> -					 entry->efd_count);
> -		if (err && err != -EOPNOTSUPP)
> -			ext4_msg(sb, KERN_WARNING, "discard request in"
> -				 " group:%d block:%d count:%d failed"
> -				 " with %d", entry->efd_group,
> -				 entry->efd_start_cluster,
> -				 entry->efd_count, err);
> -	}
> -
>  	err = ext4_mb_load_buddy(sb, entry->efd_group, &e4b);
>  	/* we expect to find existing buddy because it's pinned */
>  	BUG_ON(err != 0);
> @@ -2862,6 +2852,67 @@ static void ext4_free_data_callback(struct super_block *sb,
>  	mb_debug(1, "freed %u blocks in %u structures\n", count, count2);
>  }
>  
> +/*
> + * This function is called by the jbd2 layer once the commit has finished,
> + * so we know we can free the blocks that were released with that commit.
> + */
> +static void ext4_free_data_callback(struct super_block *sb,
> +				    struct ext4_journal_cb_entry *jce,
> +				    int rc, struct list_head *post_cb_list)
> +{
> +	struct ext4_free_data *entry = (struct ext4_free_data *)jce;
> +
> +	ext4_free_data_in_buddy(sb, entry);
> +}
> +
> +static void ext4_bio_wait_endio(struct bio *bio)
> +{
> +	struct completion *wait = (struct completion *)bio->bi_private;
> +
> +	complete(wait);
> +}
> +
> +static void ext4_free_after_discard_callback(struct super_block *sb,
> +				    struct ext4_journal_cb_entry *jce,
> +				    int rc, struct list_head *post_cb_list)
> +{
> +	struct ext4_free_data *entry = (struct ext4_free_data *)jce;
> +
> +	wait_for_completion_io(&entry->efd_bio_wait);
> +	ext4_free_data_in_buddy(sb, entry);
> +}
> +
> +static void ext4_discard_callback(struct super_block *sb,
> +				    struct ext4_journal_cb_entry *jce,
> +				    int rc, struct list_head *post_cb_list)
> +{
> +	struct ext4_free_data *entry = (struct ext4_free_data *)jce;
> +	int err;
> +
> +	err = ext4_issue_discard(sb, entry->efd_group,
> +				 entry->efd_start_cluster,
> +				 entry->efd_count,
> +				 &entry->efd_discard_bio);
> +	if (err && err != -EOPNOTSUPP) {
> +		ext4_msg(sb, KERN_WARNING, "discard request in"
> +			 " group:%d block:%d count:%d failed"
> +			 " with %d", entry->efd_group,
> +			 entry->efd_start_cluster,
> +			 entry->efd_count, err);
> +	}
> +
> +	if (entry->efd_discard_bio) {
> +		init_completion(&entry->efd_bio_wait);
> +		entry->efd_discard_bio->bi_end_io = ext4_bio_wait_endio;
> +		entry->efd_discard_bio->bi_private = &entry->efd_bio_wait;
> +		submit_bio(entry->efd_discard_bio);
> +		jce->jce_func = ext4_free_after_discard_callback;
> +	} else
> +		jce->jce_func = ext4_free_data_callback;
> +
> +	list_add_tail(&jce->jce_list, post_cb_list);
> +}

Hum, these games with several callbacks, lists, etc. look awkward and
unnecessary. It think they mostly come from the fact that we call separate
freeing callback for each extent to free which doesn't fit the needs of
async discard well.

So instead of adding post_cb_list and several callback functions, it would
seem easier to have just one callback structure instead of one for every
extent. Then the structure would contain a list of extents that need to be
freed freed. So something like:

struct ext4_free_data {
	struct ext4_journal_cb_entry efd_jce;
	struct list_head efd_extents;
}

struct ext4_freed_extent {
	struct list_head efe_list;
	struct rb_node efe_node;
	ext4_group_t efe_group;
	ext4_grpblk_t efe_start_cluster;
	ext4_grpblk_t efe_count;
	tid_t efe_tid;
}

When commit happens, we can just walk the efd_extents list while efe_tid is
equal tid of the transaction for which the callback was called and submit all
discard requests. You can use bio chaining implemented in
__blkdev_issue_discard() which XFS already uses and so the result of all
the discards you submit will be just one bio. Then you walk the list of
extents again and free them in the buddy bitmaps. And finally, you wait for
the bio to complete. All will be then happening in one function and it will
be much easier to understand.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
