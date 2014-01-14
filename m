From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH 2/2] ext4: track extent status tree shrinker delay
 statictics
Date: Tue, 14 Jan 2014 14:24:00 +0100
Message-ID: <20140114132400.GF21327@quack.suse.cz>
References: <1389686801-11367-1-git-send-email-wenqing.lz@taobao.com>
 <1389686801-11367-3-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54364 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbaANNYE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Jan 2014 08:24:04 -0500
Content-Disposition: inline
In-Reply-To: <1389686801-11367-3-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 14-01-14 16:06:41, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> This commit adds some statictics in extent status tree shrinker.  The
> purpose to add these is that we want to collect more details when we
> encounter a stall caused by extent status tree shrinker.  Here we count
> the following statictics:
>   stats:
>     the number of all objects on all extent status trees
>     the number of reclaimable objects on lru list
>     the last sorted interval
>     the number of inodes on lru list
>   average:
>     scan time for shrinking some objects
>     the number of shrunk objects
>   maximum:
>     the inode that has max nr. of objects on lru list
> 
> The output looks like below:
>   $ cat /proc/fs/ext4/sda1/es_shrinker_info
>   stats:
>     28228 objects
>     6341 reclaimable objects
>     586ms last sorted interval
>     250 inodes on lru list
>   average:
>     153us scan time
>     128 shrunk objects
>   maximum:
>     255 inode (255 objects, 198 reclaimable)
> 
> If the lru list has never been sorted, the following line will not be
> printed:
>     586ms last sorted interval
> If there is an empty lru list, the following lines also will not be
> printed:
>     250 inodes on lru list
>   ...
>   maximum:
>     255 inode (255 objects, 198 reclaimable)
> 
> Meanwhile in this commit a new trace point is defined to print some
> details in __ext4_es_shrink().
  The patch looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  fs/ext4/ext4.h              |    4 +-
>  fs/ext4/extents_status.c    |  171 ++++++++++++++++++++++++++++++++++++++++---
>  fs/ext4/extents_status.h    |   10 ++-
>  fs/ext4/super.c             |   17 ++---
>  include/trace/events/ext4.h |   31 ++++++++
>  5 files changed, 210 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index ece5556..23ce6b7 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -885,6 +885,7 @@ struct ext4_inode_info {
>  	struct ext4_es_tree i_es_tree;
>  	rwlock_t i_es_lock;
>  	struct list_head i_es_lru;
> +	unsigned int i_es_all_nr;	/* protected by i_es_lock */
>  	unsigned int i_es_lru_nr;	/* protected by i_es_lock */
>  	unsigned long i_touch_when;	/* jiffies of last accessing */
>  
> @@ -1322,8 +1323,7 @@ struct ext4_sb_info {
>  	/* Reclaim extents from extent status tree */
>  	struct shrinker s_es_shrinker;
>  	struct list_head s_es_lru;
> -	unsigned long s_es_last_sorted;
> -	struct percpu_counter s_extent_cache_cnt;
> +	struct ext4_es_stats s_es_stats;
>  	spinlock_t s_es_lru_lock ____cacheline_aligned_in_smp;
>  
>  	/* Ratelimit ext4 messages. */
> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index eb7ae61..5cb25c5 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@ -11,6 +11,8 @@
>   */
>  #include <linux/rbtree.h>
>  #include <linux/list_sort.h>
> +#include <linux/proc_fs.h>
> +#include <linux/seq_file.h>
>  #include "ext4.h"
>  #include "extents_status.h"
>  
> @@ -313,19 +315,27 @@ ext4_es_alloc_extent(struct inode *inode, ext4_lblk_t lblk, ext4_lblk_t len,
>  	 */
>  	if (!ext4_es_is_delayed(es)) {
>  		EXT4_I(inode)->i_es_lru_nr++;
> -		percpu_counter_inc(&EXT4_SB(inode->i_sb)->s_extent_cache_cnt);
> +		percpu_counter_inc(&EXT4_SB(inode->i_sb)->
> +					s_es_stats.es_stats_lru_cnt);
>  	}
>  
> +	EXT4_I(inode)->i_es_all_nr++;
> +	percpu_counter_inc(&EXT4_SB(inode->i_sb)->s_es_stats.es_stats_all_cnt);
> +
>  	return es;
>  }
>  
>  static void ext4_es_free_extent(struct inode *inode, struct extent_status *es)
>  {
> +	EXT4_I(inode)->i_es_all_nr--;
> +	percpu_counter_dec(&EXT4_SB(inode->i_sb)->s_es_stats.es_stats_all_cnt);
> +
>  	/* Decrease the lru counter when this es is not delayed */
>  	if (!ext4_es_is_delayed(es)) {
>  		BUG_ON(EXT4_I(inode)->i_es_lru_nr == 0);
>  		EXT4_I(inode)->i_es_lru_nr--;
> -		percpu_counter_dec(&EXT4_SB(inode->i_sb)->s_extent_cache_cnt);
> +		percpu_counter_dec(&EXT4_SB(inode->i_sb)->
> +					s_es_stats.es_stats_lru_cnt);
>  	}
>  
>  	kmem_cache_free(ext4_es_cachep, es);
> @@ -929,11 +939,16 @@ static int __ext4_es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
>  			    struct ext4_inode_info *locked_ei)
>  {
>  	struct ext4_inode_info *ei;
> +	struct ext4_es_stats *es_stats;
>  	struct list_head *cur, *tmp;
>  	LIST_HEAD(skipped);
> +	ktime_t start_time;
> +	u64 scan_time;
>  	int nr_shrunk = 0;
>  	int retried = 0, skip_precached = 1, nr_skipped = 0;
>  
> +	es_stats = &sbi->s_es_stats;
> +	start_time = ktime_get();
>  	spin_lock(&sbi->s_es_lru_lock);
>  
>  retry:
> @@ -944,7 +959,8 @@ retry:
>  		 * If we have already reclaimed all extents from extent
>  		 * status tree, just stop the loop immediately.
>  		 */
> -		if (percpu_counter_read_positive(&sbi->s_extent_cache_cnt) == 0)
> +		if (percpu_counter_read_positive(
> +				&es_stats->es_stats_lru_cnt) == 0)
>  			break;
>  
>  		ei = list_entry(cur, struct ext4_inode_info, i_es_lru);
> @@ -954,7 +970,7 @@ retry:
>  		 * time.  Normally we try hard to avoid shrinking
>  		 * precached inodes, but we will as a last resort.
>  		 */
> -		if ((sbi->s_es_last_sorted < ei->i_touch_when) ||
> +		if ((es_stats->es_stats_last_sorted < ei->i_touch_when) ||
>  		    (skip_precached && ext4_test_inode_state(&ei->vfs_inode,
>  						EXT4_STATE_EXT_PRECACHED))) {
>  			nr_skipped++;
> @@ -988,7 +1004,7 @@ retry:
>  	if ((nr_shrunk == 0) && nr_skipped && !retried) {
>  		retried++;
>  		list_sort(NULL, &sbi->s_es_lru, ext4_inode_touch_time_cmp);
> -		sbi->s_es_last_sorted = jiffies;
> +		es_stats->es_stats_last_sorted = jiffies;
>  		ei = list_first_entry(&sbi->s_es_lru, struct ext4_inode_info,
>  				      i_es_lru);
>  		/*
> @@ -1006,6 +1022,20 @@ retry:
>  	if (locked_ei && nr_shrunk == 0)
>  		nr_shrunk = __es_try_to_reclaim_extents(locked_ei, nr_to_scan);
>  
> +	scan_time = ktime_to_ns(ktime_sub(ktime_get(), start_time));
> +	if (likely(es_stats->es_stats_scan_time))
> +		es_stats->es_stats_scan_time = (scan_time +
> +				es_stats->es_stats_scan_time*3) / 4;
> +	else
> +		es_stats->es_stats_scan_time = scan_time;
> +	if (likely(es_stats->es_stats_shrunk))
> +		es_stats->es_stats_shrunk = (nr_shrunk +
> +				es_stats->es_stats_shrunk*3) / 4;
> +	else
> +		es_stats->es_stats_shrunk = nr_shrunk;
> +
> +	trace_ext4_es_shrink(sbi->s_sb, nr_shrunk, scan_time, skip_precached,
> +			     nr_skipped, retried);
>  	return nr_shrunk;
>  }
>  
> @@ -1016,7 +1046,7 @@ static unsigned long ext4_es_count(struct shrinker *shrink,
>  	struct ext4_sb_info *sbi;
>  
>  	sbi = container_of(shrink, struct ext4_sb_info, s_es_shrinker);
> -	nr = percpu_counter_read_positive(&sbi->s_extent_cache_cnt);
> +	nr = percpu_counter_read_positive(&sbi->s_es_stats.es_stats_lru_cnt);
>  	trace_ext4_es_shrink_count(sbi->s_sb, sc->nr_to_scan, nr);
>  	return nr;
>  }
> @@ -1029,7 +1059,7 @@ static unsigned long ext4_es_scan(struct shrinker *shrink,
>  	int nr_to_scan = sc->nr_to_scan;
>  	int ret, nr_shrunk;
>  
> -	ret = percpu_counter_read_positive(&sbi->s_extent_cache_cnt);
> +	ret = percpu_counter_read_positive(&sbi->s_es_stats.es_stats_lru_cnt);
>  	trace_ext4_es_shrink_scan_enter(sbi->s_sb, nr_to_scan, ret);
>  
>  	if (!nr_to_scan)
> @@ -1041,19 +1071,140 @@ static unsigned long ext4_es_scan(struct shrinker *shrink,
>  	return nr_shrunk;
>  }
>  
> -void ext4_es_register_shrinker(struct ext4_sb_info *sbi)
> +static void *ext4_es_seq_shrinker_info_start(struct seq_file *seq, loff_t *pos)
> +{
> +	return *pos ? NULL : SEQ_START_TOKEN;
> +}
> +
> +static void *
> +ext4_es_seq_shrinker_info_next(struct seq_file *seq, void *v, loff_t *pos)
> +{
> +	return NULL;
> +}
> +
> +static int ext4_es_seq_shrinker_info_show(struct seq_file *seq, void *v)
> +{
> +	struct ext4_sb_info *sbi = seq->private;
> +	struct ext4_es_stats *es_stats = &sbi->s_es_stats;
> +	struct ext4_inode_info *ei, *max = NULL;
> +	unsigned int inode_cnt = 0;
> +
> +	if (v != SEQ_START_TOKEN)
> +		return 0;
> +
> +	/* here we just find an inode that has the max nr. of objects */
> +	spin_lock(&sbi->s_es_lru_lock);
> +	list_for_each_entry(ei, &sbi->s_es_lru, i_es_lru) {
> +		inode_cnt++;
> +		if (max && max->i_es_all_nr < ei->i_es_all_nr)
> +			max = ei;
> +		else if (!max)
> +			max = ei;
> +	}
> +	spin_unlock(&sbi->s_es_lru_lock);
> +
> +	seq_printf(seq, "stats:\n  %lld objects\n  %lld reclaimable objects\n",
> +		   percpu_counter_sum_positive(&es_stats->es_stats_all_cnt),
> +		   percpu_counter_sum_positive(&es_stats->es_stats_lru_cnt));
> +	if (es_stats->es_stats_last_sorted != 0)
> +		seq_printf(seq, "  %ums last sorted interval\n",
> +			   jiffies_to_msecs(jiffies -
> +					    es_stats->es_stats_last_sorted));
> +	if (inode_cnt)
> +		seq_printf(seq, "  %d inodes on lru list\n", inode_cnt);
> +
> +	seq_printf(seq, "average:\n  %lluus scan time\n",
> +	    div_u64(es_stats->es_stats_scan_time, 1000));
> +	seq_printf(seq, "  %lu shrunk objects\n", es_stats->es_stats_shrunk);
> +	if (inode_cnt)
> +		seq_printf(seq,
> +		    "maximum:\n  %lu inode (%u objects, %u reclaimable)\n",
> +		    max->vfs_inode.i_ino, max->i_es_all_nr, max->i_es_lru_nr);
> +
> +	return 0;
> +}
> +
> +static void ext4_es_seq_shrinker_info_stop(struct seq_file *seq, void *v)
>  {
> +}
> +
> +static const struct seq_operations ext4_es_seq_shrinker_info_ops = {
> +	.start = ext4_es_seq_shrinker_info_start,
> +	.next  = ext4_es_seq_shrinker_info_next,
> +	.stop  = ext4_es_seq_shrinker_info_stop,
> +	.show  = ext4_es_seq_shrinker_info_show,
> +};
> +
> +static int
> +ext4_es_seq_shrinker_info_open(struct inode *inode, struct file *file)
> +{
> +	int ret;
> +
> +	ret = seq_open(file, &ext4_es_seq_shrinker_info_ops);
> +	if (!ret) {
> +		struct seq_file *m = file->private_data;
> +		m->private = PDE_DATA(inode);
> +	}
> +
> +	return ret;
> +}
> +
> +static int
> +ext4_es_seq_shrinker_info_release(struct inode *inode, struct file *file)
> +{
> +	return seq_release(inode, file);
> +}
> +
> +static const struct file_operations ext4_es_seq_shrinker_info_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= ext4_es_seq_shrinker_info_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= ext4_es_seq_shrinker_info_release,
> +};
> +
> +int ext4_es_register_shrinker(struct ext4_sb_info *sbi)
> +{
> +	int err;
> +
>  	INIT_LIST_HEAD(&sbi->s_es_lru);
>  	spin_lock_init(&sbi->s_es_lru_lock);
> -	sbi->s_es_last_sorted = 0;
> +	sbi->s_es_stats.es_stats_last_sorted = 0;
> +	sbi->s_es_stats.es_stats_shrunk = 0;
> +	sbi->s_es_stats.es_stats_scan_time = 0;
> +	err = percpu_counter_init(&sbi->s_es_stats.es_stats_all_cnt, 0);
> +	if (err)
> +		return err;
> +	err = percpu_counter_init(&sbi->s_es_stats.es_stats_lru_cnt, 0);
> +	if (err)
> +		goto err1;
> +
>  	sbi->s_es_shrinker.scan_objects = ext4_es_scan;
>  	sbi->s_es_shrinker.count_objects = ext4_es_count;
>  	sbi->s_es_shrinker.seeks = DEFAULT_SEEKS;
> -	register_shrinker(&sbi->s_es_shrinker);
> +	err = register_shrinker(&sbi->s_es_shrinker);
> +	if (err)
> +		goto err2;
> +
> +	if (sbi->s_proc)
> +		proc_create_data("es_shrinker_info", S_IRUGO, sbi->s_proc,
> +				 &ext4_es_seq_shrinker_info_fops, sbi);
> +
> +	return 0;
> +
> +err2:
> +	percpu_counter_destroy(&sbi->s_es_stats.es_stats_lru_cnt);
> +err1:
> +	percpu_counter_destroy(&sbi->s_es_stats.es_stats_all_cnt);
> +	return err;
>  }
>  
>  void ext4_es_unregister_shrinker(struct ext4_sb_info *sbi)
>  {
> +	if (sbi->s_proc)
> +		remove_proc_entry("es_shrinker_info", sbi->s_proc);
> +	percpu_counter_destroy(&sbi->s_es_stats.es_stats_all_cnt);
> +	percpu_counter_destroy(&sbi->s_es_stats.es_stats_lru_cnt);
>  	unregister_shrinker(&sbi->s_es_shrinker);
>  }
>  
> diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
> index 167f4ab8..37a4313 100644
> --- a/fs/ext4/extents_status.h
> +++ b/fs/ext4/extents_status.h
> @@ -64,6 +64,14 @@ struct ext4_es_tree {
>  	struct extent_status *cache_es;	/* recently accessed extent */
>  };
>  
> +struct ext4_es_stats {
> +	unsigned long es_stats_last_sorted;
> +	unsigned long es_stats_shrunk;
> +	u64 es_stats_scan_time;
> +	struct percpu_counter es_stats_all_cnt;
> +	struct percpu_counter es_stats_lru_cnt;
> +};
> +
>  extern int __init ext4_init_es(void);
>  extern void ext4_exit_es(void);
>  extern void ext4_es_init_tree(struct ext4_es_tree *tree);
> @@ -129,7 +137,7 @@ static inline void ext4_es_store_status(struct extent_status *es,
>  		       (es->es_pblk & ~ES_MASK));
>  }
>  
> -extern void ext4_es_register_shrinker(struct ext4_sb_info *sbi);
> +extern int ext4_es_register_shrinker(struct ext4_sb_info *sbi);
>  extern void ext4_es_unregister_shrinker(struct ext4_sb_info *sbi);
>  extern void ext4_es_lru_add(struct inode *inode);
>  extern void ext4_es_lru_del(struct inode *inode);
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 1f7784d..9c3a8bd 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -819,7 +819,6 @@ static void ext4_put_super(struct super_block *sb)
>  	percpu_counter_destroy(&sbi->s_freeinodes_counter);
>  	percpu_counter_destroy(&sbi->s_dirs_counter);
>  	percpu_counter_destroy(&sbi->s_dirtyclusters_counter);
> -	percpu_counter_destroy(&sbi->s_extent_cache_cnt);
>  	brelse(sbi->s_sbh);
>  #ifdef CONFIG_QUOTA
>  	for (i = 0; i < MAXQUOTAS; i++)
> @@ -879,6 +878,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
>  	ext4_es_init_tree(&ei->i_es_tree);
>  	rwlock_init(&ei->i_es_lock);
>  	INIT_LIST_HEAD(&ei->i_es_lru);
> +	ei->i_es_all_nr = 0;
>  	ei->i_es_lru_nr = 0;
>  	ei->i_touch_when = 0;
>  	ei->i_reserved_data_blocks = 0;
> @@ -3869,10 +3869,11 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	sbi->s_err_report.data = (unsigned long) sb;
>  
>  	/* Register extent status tree shrinker */
> -	ext4_es_register_shrinker(sbi);
> -
> -	err = percpu_counter_init(&sbi->s_freeclusters_counter,
> -			ext4_count_free_clusters(sb));
> +	err = ext4_es_register_shrinker(sbi);
> +	if (!err) {
> +		err = percpu_counter_init(&sbi->s_freeclusters_counter,
> +				ext4_count_free_clusters(sb));
> +	}
>  	if (!err) {
>  		err = percpu_counter_init(&sbi->s_freeinodes_counter,
>  				ext4_count_free_inodes(sb));
> @@ -3884,9 +3885,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	if (!err) {
>  		err = percpu_counter_init(&sbi->s_dirtyclusters_counter, 0);
>  	}
> -	if (!err) {
> -		err = percpu_counter_init(&sbi->s_extent_cache_cnt, 0);
> -	}
>  	if (err) {
>  		ext4_msg(sb, KERN_ERR, "insufficient memory");
>  		goto failed_mount3;
> @@ -4191,8 +4189,8 @@ failed_mount_wq:
>  		jbd2_journal_destroy(sbi->s_journal);
>  		sbi->s_journal = NULL;
>  	}
> -failed_mount3:
>  	ext4_es_unregister_shrinker(sbi);
> +failed_mount3:
>  	del_timer_sync(&sbi->s_err_report);
>  	if (sbi->s_flex_groups)
>  		ext4_kvfree(sbi->s_flex_groups);
> @@ -4200,7 +4198,6 @@ failed_mount3:
>  	percpu_counter_destroy(&sbi->s_freeinodes_counter);
>  	percpu_counter_destroy(&sbi->s_dirs_counter);
>  	percpu_counter_destroy(&sbi->s_dirtyclusters_counter);
> -	percpu_counter_destroy(&sbi->s_extent_cache_cnt);
>  	if (sbi->s_mmp_tsk)
>  		kthread_stop(sbi->s_mmp_tsk);
>  failed_mount2:
> diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
> index 35d28f8..a05a16d 100644
> --- a/include/trace/events/ext4.h
> +++ b/include/trace/events/ext4.h
> @@ -2422,6 +2422,37 @@ TRACE_EVENT(ext4_es_shrink_scan_exit,
>  		  __entry->nr_shrunk, __entry->cache_cnt)
>  );
>  
> +TRACE_EVENT(ext4_es_shrink,
> +	TP_PROTO(struct super_block *sb, int nr_shrunk, u64 scan_time,
> +		 int skip_precached, int nr_skipped, int retried),
> +
> +	TP_ARGS(sb, nr_shrunk, scan_time, skip_precached, nr_skipped, retried),
> +
> +	TP_STRUCT__entry(
> +		__field(	dev_t,		dev		)
> +		__field(	int,		nr_shrunk	)
> +		__field(	unsigned long long, scan_time	)
> +		__field(	int,		skip_precached	)
> +		__field(	int,		nr_skipped	)
> +		__field(	int,		retried		)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->dev		= sb->s_dev;
> +		__entry->nr_shrunk	= nr_shrunk;
> +		__entry->scan_time	= div_u64(scan_time, 1000);
> +		__entry->skip_precached = skip_precached;
> +		__entry->nr_skipped	= nr_skipped;
> +		__entry->retried	= retried;
> +	),
> +
> +	TP_printk("dev %d,%d nr_shrunk %d, scan_time %llu skip_precached %d "
> +		  "nr_skipped %d retried %d",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->nr_shrunk,
> +		  __entry->scan_time, __entry->skip_precached,
> +		  __entry->nr_skipped, __entry->retried)
> +);
> +
>  #endif /* _TRACE_EXT4_H */
>  
>  /* This part must be outside protection */
> -- 
> 1.7.9.7
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
