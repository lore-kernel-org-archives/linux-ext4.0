From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 4/6] ext4: change lru to round-robin in extent status
 tree shrinker
Date: Wed, 27 Aug 2014 17:01:21 +0200
Message-ID: <20140827150121.GC22211@quack.suse.cz>
References: <1407382553-24256-1-git-send-email-wenqing.lz@taobao.com>
 <1407382553-24256-5-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37896 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934344AbaH0PBZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Aug 2014 11:01:25 -0400
Content-Disposition: inline
In-Reply-To: <1407382553-24256-5-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 07-08-14 11:35:51, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> In this commit we discard the lru algorithm because it should take a
> long time to keep a lru list in extent status tree shrinker and the
> shrinker should take a long time to scan this lru list in order to
> reclaim some objects.
> 
> For reducing the latency, this commit does two works.  The first one
> is to replace lru with round-robin.  After that we never need to keep
> a lru list.  That means that the list shouldn't be sorted if the
> shrinker can not reclaim any objects in the first round.  The second
> one is to shrink the length of the list.  After using round-robin
> algorithm, the shrinker takes the first inode in the list and handle
> it.  If this inode is skipped, it will be moved into the tail of the
> list.  Otherwise it will be added back when it is touched again.
  I like this change. Some comments are below.

...
> @@ -685,8 +685,8 @@ int ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
>  		goto error;
>  retry:
>  	err = __es_insert_extent(inode, &newes);
> -	if (err == -ENOMEM && __ext4_es_shrink(EXT4_SB(inode->i_sb), 1,
> -					       EXT4_I(inode)))
> +	if (err == -ENOMEM && __es_shrink(EXT4_SB(inode->i_sb),
> +					  1, EXT4_I(inode)))
>  		goto retry;
>  	if (err == -ENOMEM && !ext4_es_is_delayed(&newes))
>  		err = 0;
  This comment is not directly related to this patch but looking into the
code made me think about it. It seems ugly to call __es_shrink() from
internals of ext4_es_insert_extent(). Also thinking about locking
implications makes me shudder a bit and finally this may make the pressure
on the extent cache artificially bigger because MM subsystem is not aware
of the shrinking you do here. I would prefer to leave shrinking on
the slab subsystem itself.

Now GFP_ATOMIC allocation we use for extent cache makes it hard for the
slab subsystem and actually we could fairly easily use GFP_NOFS. We can just
allocate the structure before grabbing i_es_lock with GFP_NOFS allocation and
in case we don't need the structure, we can just free it again. It may
introduce some overhead from unnecessary alloc/free but things get simpler
that way (no need for that locked_ei argument for __es_shrink(), no need
for internal calls to __es_shrink() from within the filesystem).

...
> +static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
> +		       struct ext4_inode_info *locked_ei)
>  {
>  	struct ext4_inode_info *ei;
>  	struct ext4_es_stats *es_stats;
> -	struct list_head *cur, *tmp;
> -	LIST_HEAD(skipped);
>  	ktime_t start_time;
>  	u64 scan_time;
> +	int nr_to_walk;
>  	int nr_shrunk = 0;
> -	int retried = 0, skip_precached = 1, nr_skipped = 0;
> +	int retried = 0, nr_skipped = 0;
>  
>  	es_stats = &sbi->s_es_stats;
>  	start_time = ktime_get();
> -	spin_lock(&sbi->s_es_lru_lock);
>  
>  retry:
> -	list_for_each_safe(cur, tmp, &sbi->s_es_lru) {
> +	spin_lock(&sbi->s_es_lock);
> +	nr_to_walk = sbi->s_es_nr_inode;
> +	while (!list_empty(&sbi->s_es_list) && nr_to_walk-- > 0) {
>  		int shrunk;
>  
> -		/*
> -		 * If we have already reclaimed all extents from extent
> -		 * status tree, just stop the loop immediately.
> -		 */
> -		if (percpu_counter_read_positive(
> -				&es_stats->es_stats_lru_cnt) == 0)
> -			break;
> +		ei = list_first_entry(&sbi->s_es_list, struct ext4_inode_info,
> +				      i_es_list);
>  
> -		ei = list_entry(cur, struct ext4_inode_info, i_es_lru);
> +		list_del_init(&ei->i_es_list);
> +		sbi->s_es_nr_inode--;
> +		spin_unlock(&sbi->s_es_lock);
  Nothing seems to prevent reclaim from freeing the inode after we drop
s_es_lock. So we could use freed memory. I don't think we want to pin the
inode here by grabbing a refcount since we don't want to deal with iput()
in the shrinker (that could mean having to delete the inode from shrinker
context). But what we could do it to grab ei->i_es_lock before dropping
s_es_lock. Since ext4_es_remove_extent() called from ext4_clear_inode()
always grabs i_es_lock, we are protected from inode being freed while we
hold that lock. But please add comments about this both to the
__es_shrink() and ext4_es_remove_extent().

>  
>  		/*
> -		 * Skip the inode that is newer than the last_sorted
> -		 * time.  Normally we try hard to avoid shrinking
> -		 * precached inodes, but we will as a last resort.
> +		 * Normally we try hard to avoid shrinking precached inodes,
> +		 * but we will as a last resort.
>  		 */
> -		if ((es_stats->es_stats_last_sorted < ei->i_touch_when) ||
> -		    (skip_precached && ext4_test_inode_state(&ei->vfs_inode,
> -						EXT4_STATE_EXT_PRECACHED))) {
> +		if (!retried && ext4_test_inode_state(&ei->vfs_inode,
> +						EXT4_STATE_EXT_PRECACHED)) {
>  			nr_skipped++;
> -			list_move_tail(cur, &skipped);
> +			spin_lock(&sbi->s_es_lock);
> +			__ext4_es_list_add(sbi, ei);
> +			continue;
> +		}
> +
> +		if (ei->i_es_shk_nr == 0) {
> +			spin_lock(&sbi->s_es_lock);
>  			continue;
>  		}
>  
> -		if (ei->i_es_lru_nr == 0 || ei == locked_ei ||
> -		    !write_trylock(&ei->i_es_lock))
> +		if (ei == locked_ei || !write_trylock(&ei->i_es_lock)) {
> +			nr_skipped++;
> +			spin_lock(&sbi->s_es_lock);
> +			__ext4_es_list_add(sbi, ei);
>  			continue;
> +		}
  These tests will need some reorg when we rely on ei->i_es_lock but it
should be easily doable.

>  
>  		shrunk = __es_try_to_reclaim_extents(ei, nr_to_scan);
> -		if (ei->i_es_lru_nr == 0)
> -			list_del_init(&ei->i_es_lru);
>  		write_unlock(&ei->i_es_lock);
>  
>  		nr_shrunk += shrunk;
>  		nr_to_scan -= shrunk;
> +
>  		if (nr_to_scan == 0)
> -			break;
> +			goto out;
> +		spin_lock(&sbi->s_es_lock);
>  	}
> -
> -	/* Move the newer inodes into the tail of the LRU list. */
> -	list_splice_tail(&skipped, &sbi->s_es_lru);
> -	INIT_LIST_HEAD(&skipped);
> +	spin_unlock(&sbi->s_es_lock);
>  
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
