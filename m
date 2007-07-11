From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [EXT4 set 6][PATCH 1/1]Export jbd stats through procfs
Date: Tue, 10 Jul 2007 19:31:17 -0700
Message-ID: <20070710193117.a4ef6298.akpm@linux-foundation.org>
References: <1183275490.4010.134.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48858 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750989AbXGKCb4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jul 2007 22:31:56 -0400
In-Reply-To: <1183275490.4010.134.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 01 Jul 2007 03:38:10 -0400 Mingming Cao <cmm@us.ibm.com> wrote:

> [PATCH] jbd2 stats through procfs
> 
> The patch below updates the jbd stats patch to 2.6.20/jbd2.
> The initial patch was posted by Alex Tomas in December 2005
> (http://marc.info/?l=linux-ext4&m=113538565128617&w=2).
> It provides statistics via procfs such as transaction lifetime and size.
> 
> [ This probably should be rewritten to use debugfs?   -- Ted]
> 

I suppose that given that we're creating a spot in debugfs for the jbd2
debug code, yes, this also should be moved over.

But the jbd2 debug debugfs entries were kernel-wide whereas this is
per-superblock.  I think.

That email from Alex contains pretty important information.  I suggest that
it be added to the changelog after accuracy-checking.  Addition to
Documentation/filesystems/ext4.txt would be good.

> --
> 
> Index: linux-2.6.22-rc4/include/linux/jbd2.h
> ===================================================================
> --- linux-2.6.22-rc4.orig/include/linux/jbd2.h	2007-06-11 17:28:17.000000000 -0700
> +++ linux-2.6.22-rc4/include/linux/jbd2.h	2007-06-13 10:45:21.000000000 -0700
> @@ -408,6 +408,16 @@
>  };
>  
>  
> +/*
> + * Some stats for checkpoint phase
> + */
> +struct transaction_chp_stats_s {
> +	unsigned long		cs_chp_time;
> +	unsigned long		cs_forced_to_close;
> +	unsigned long		cs_written;
> +	unsigned long		cs_dropped;
> +};

It would be nice to document what units all these fields are in.  Jiffies,
I assume.

>  /* The transaction_t type is the guts of the journaling mechanism.  It
>   * tracks a compound transaction through its various states:
>   *
> @@ -543,6 +553,21 @@
>  	spinlock_t		t_handle_lock;
>  
>  	/*
> +	 * Longest time some handle had to wait for running transaction
> +	 */
> +	unsigned long		t_max_wait;
> +
> +	/*
> +	 * When transaction started
> +	 */
> +	unsigned long		t_start;
> +
> +	/*
> +	 * Checkpointing stats [j_checkpoint_sem]
> +	 */
> +	struct transaction_chp_stats_s t_chp_stats;
> +
> +	/*
>  	 * Number of outstanding updates running on this transaction
>  	 * [t_handle_lock]
>  	 */
> @@ -573,6 +598,57 @@
>  
>  };
>  
> +struct transaction_run_stats_s {
> +	unsigned long		rs_wait;
> +	unsigned long		rs_running;
> +	unsigned long		rs_locked;
> +	unsigned long		rs_flushing;
> +	unsigned long		rs_logging;
> +
> +	unsigned long		rs_handle_count;
> +	unsigned long		rs_blocks;
> +	unsigned long		rs_blocks_logged;
> +};
> +
> +struct transaction_stats_s
> +{
> +	int 			ts_type;
> +	unsigned long		ts_tid;
> +	union {
> +		struct transaction_run_stats_s run;
> +		struct transaction_chp_stats_s chp;
> +	} u;
> +};
> +
> +#define JBD2_STATS_RUN		1
> +#define JBD2_STATS_CHECKPOINT	2
> +
> +#define ts_wait			u.run.rs_wait
> +#define ts_running		u.run.rs_running
> +#define ts_locked		u.run.rs_locked
> +#define ts_flushing		u.run.rs_flushing
> +#define ts_logging		u.run.rs_logging
> +#define ts_handle_count		u.run.rs_handle_count
> +#define ts_blocks		u.run.rs_blocks
> +#define ts_blocks_logged	u.run.rs_blocks_logged
> +
> +#define ts_chp_time		u.chp.cs_chp_time
> +#define ts_forced_to_close	u.chp.cs_forced_to_close
> +#define ts_written		u.chp.cs_written
> +#define ts_dropped		u.chp.cs_dropped

That's a bit sleazy.  We can drop the "u" from 'struct transaction_stats_s'
and make it an anonymous union, then open-code foo.run.rs_wait everywhere.

But that's a bit sleazy too, because the reader of the code would not know
that a write to foo.run.rs_wait will stomp on the value of
foo.chp.cs_chp_time.

So to minimize reader confusion it would be best I think to just open-code
the full u.run.rs_wait at all code-sites.

The macros above are the worst possible choice: they hide information from
the code-reader just to save the code-writer a bit of typing.  But we very
much want to optimise for code-readers, not for code-writers.

> +#define CURRENT_MSECS		(jiffies_to_msecs(jiffies))

hm, that isn't something which should be in an ext4 header file.  And it
shouldn't be in UPPER CASE and it shouldn't pretend to be a constant (or a
global scalar).

IOW: yuk.

How's about raising a separate, standalone patch which creates a new
kernel-wide coded-in-C function such as

unsigned long jiffies_in_msecs(void);

?  (That's assuming we don't already have one.  Most likely we have seven
of them hiding in various dark corners).

> +static inline unsigned int
> +jbd2_time_diff(unsigned int start, unsigned int end)
> +{
> +	if (unlikely(start > end))
> +		end = end + (~0UL - start);
> +	else
> +		end -= start;
> +	return end;
> +}

I don't know what this does and I am disinclined to reverse-engineer its
uncommentedness.  But it looks like something which should be in some
kernel-wide header file?

>  /**
>   * struct journal_s - The journal_s type is the concrete type associated with
>   *     journal_t.
> @@ -634,6 +710,12 @@
>   * @j_wbufsize: maximum number of buffer_heads allowed in j_wbuf, the
>   *	number that will fit in j_blocksize
>   * @j_last_sync_writer: most recent pid which did a synchronous write
> + * @j_history: Buffer storing the transactions statistics history
> + * @j_history_max: Maximum number of transactions in the statistics history
> + * @j_history_cur: Current number of transactions in the statistics history
> + * @j_history_lock: Protect the transactions statistics history
> + * @j_proc_entry: procfs entry for the jbd statistics directory
> + * @j_stats: Overall statistics
>   * @j_private: An opaque pointer to fs-private information.
>   */
>  
> @@ -826,6 +908,16 @@
>  	pid_t			j_last_sync_writer;
>  
>  	/*
> +	 * Journal statistics
> +	 */
> +	struct transaction_stats_s *j_history;
> +	int			j_history_max;
> +	int			j_history_cur;
> +	spinlock_t		j_history_lock;
> +	struct proc_dir_entry	*j_proc_entry;
> +	struct transaction_stats_s j_stats;

hm, we seem to be documenting the struct journal_s fields at two different
places, possibly with duplication.

Documenting the fields at the top in kernedoc-style drives me wild,
frankly.  We really really do want to be able to see the description of
each field (which is vital information for understanding the code!) right
there at the definition site.

But at least it's documented somewhere.

> +	/*
>  	 * An opaque pointer to fs-private information.  ext3 puts its
>  	 * superblock pointer here
>  	 */
> Index: linux-2.6.22-rc4/fs/jbd2/transaction.c
> ===================================================================
> --- linux-2.6.22-rc4.orig/fs/jbd2/transaction.c	2007-06-11 17:22:14.000000000 -0700
> +++ linux-2.6.22-rc4/fs/jbd2/transaction.c	2007-06-13 10:47:56.000000000 -0700
> @@ -59,6 +59,8 @@
>  
>  	J_ASSERT(journal->j_running_transaction == NULL);
>  	journal->j_running_transaction = transaction;
> +	transaction->t_max_wait = 0;
> +	transaction->t_start = CURRENT_MSECS;

Ah, it's in milliseconds!

Good, albeit somewhat inefficient.  Usually we'd accumulate jiffies and
convert to/from milliseconds at the user interface boundary.

> --- linux-2.6.22-rc4.orig/fs/jbd2/checkpoint.c	2007-06-11 17:22:14.000000000 -0700
> +++ linux-2.6.22-rc4/fs/jbd2/checkpoint.c	2007-06-13 10:48:44.000000000 -0700
> @@ -232,7 +232,8 @@
>   * Called under jbd_lock_bh_state(jh2bh(jh)), and drops it
>   */
>  static int __process_buffer(journal_t *journal, struct journal_head *jh,
> -			struct buffer_head **bhs, int *batch_count)
> +			struct buffer_head **bhs, int *batch_count,
> +			transaction_t *transaction)
>  {
>  	struct buffer_head *bh = jh2bh(jh);
>  	int ret = 0;
> @@ -250,6 +251,7 @@
>  		transaction_t *t = jh->b_transaction;
>  		tid_t tid = t->t_tid;
>  
> +		transaction->t_chp_stats.cs_forced_to_close++;
>  		spin_unlock(&journal->j_list_lock);
>  		jbd_unlock_bh_state(bh);
>  		jbd2_log_start_commit(journal, tid);
> @@ -279,6 +281,7 @@
>  		bhs[*batch_count] = bh;
>  		__buffer_relink_io(jh);
>  		jbd_unlock_bh_state(bh);
> +		transaction->t_chp_stats.cs_written++;
>  		(*batch_count)++;
>  		if (*batch_count == NR_BATCH) {
>  			spin_unlock(&journal->j_list_lock);
> @@ -322,6 +325,8 @@
>  	if (!journal->j_checkpoint_transactions)
>  		goto out;
>  	transaction = journal->j_checkpoint_transactions;
> +	if (transaction->t_chp_stats.cs_chp_time == 0)
> +		transaction->t_chp_stats.cs_chp_time = CURRENT_MSECS;

Oh dear, I have no clue what cs_chp_time represents.  Number of
milliseconds for this transaction, I guess.  In which case we must be
either a) triggering stats collection via some user interface of b)
averaging these on an ongoing basis or c) something else.

Let me read on...

>  	this_tid = transaction->t_tid;
>  restart:
>  	/*
> @@ -346,7 +351,8 @@
>  				retry = 1;
>  				break;
>  			}
> -			retry = __process_buffer(journal, jh, bhs,&batch_count);
> +			retry = __process_buffer(journal, jh, bhs, &batch_count,
> +						 transaction);
>  			if (!retry && lock_need_resched(&journal->j_list_lock)){
>  				spin_unlock(&journal->j_list_lock);
>  				retry = 1;
> @@ -668,6 +674,8 @@
>  
>  void __jbd2_journal_drop_transaction(journal_t *journal, transaction_t *transaction)
>  {
> +	struct transaction_stats_s stats;
> +
>  	assert_spin_locked(&journal->j_list_lock);
>  	if (transaction->t_cpnext) {
>  		transaction->t_cpnext->t_cpprev = transaction->t_cpprev;
> @@ -693,5 +701,26 @@
>  	J_ASSERT(journal->j_running_transaction != transaction);
>  
>  	jbd_debug(1, "Dropping transaction %d, all done\n", transaction->t_tid);
> +
> +	/*
> +	 * File the transaction for history
> +	 */
> +	if (transaction->t_chp_stats.cs_written != 0 ||
> +			transaction->t_chp_stats.cs_chp_time != 0) {
> +		stats.ts_type = JBD2_STATS_CHECKPOINT;
> +		stats.ts_tid = transaction->t_tid;
> +		stats.u.chp = transaction->t_chp_stats;
> +		if (stats.ts_chp_time)
> +			stats.ts_chp_time =
> +				jbd2_time_diff(stats.ts_chp_time,
> +						CURRENT_MSECS);
> +		spin_lock(&journal->j_history_lock);
> +		memcpy(journal->j_history + journal->j_history_cur, &stats,
> +				sizeof(stats));
> +		if (++journal->j_history_cur == journal->j_history_max)
> +			journal->j_history_cur = 0;
> +		spin_unlock(&journal->j_history_lock);
> +	}
> +

Ah, it's a per-journal ringbuffer.  Fair enough.

> +struct jbd2_stats_proc_session {
> +	journal_t *journal;
> +	struct transaction_stats_s *stats;
> +	int start;
> +	int max;
> +};
> +
> +static void *jbd2_history_skip_empty(struct jbd2_stats_proc_session *s,
> +					struct transaction_stats_s *ts,
> +					int first)
> +{
> +	if (ts == s->stats + s->max)
> +		ts = s->stats;
> +	if (!first && ts == s->stats + s->start)
> +		return NULL;
> +	while (ts->ts_type == 0) {
> +		ts++;
> +		if (ts == s->stats + s->max)
> +			ts = s->stats;
> +		if (ts == s->stats + s->start)
> +			return NULL;
> +	}
> +	return ts;
> +
> +}
> +
> +static void *jbd2_seq_history_start(struct seq_file *seq, loff_t *pos)
> +{
> +	struct jbd2_stats_proc_session *s = seq->private;
> +	struct transaction_stats_s *ts;
> +	int l = *pos;
> +
> +	if (l == 0)
> +		return SEQ_START_TOKEN;
> +	ts = jbd2_history_skip_empty(s, s->stats + s->start, 1);
> +	if (!ts)
> +		return NULL;
> +	l--;
> +	while (l) {
> +		ts = jbd2_history_skip_empty(s, ++ts, 0);
> +		if (!ts)
> +			break;
> +		l--;
> +	}
> +	return ts;
> +}
> +
> +static void *jbd2_seq_history_next(struct seq_file *seq, void *v, loff_t *pos)
> +{
> +	struct jbd2_stats_proc_session *s = seq->private;
> +	struct transaction_stats_s *ts = v;
> +
> +	++*pos;
> +	if (v == SEQ_START_TOKEN)
> +		return jbd2_history_skip_empty(s, s->stats + s->start, 1);
> +	else
> +		return jbd2_history_skip_empty(s, ++ts, 0);
> +}
> +
> +static int jbd2_seq_history_show(struct seq_file *seq, void *v)
> +{
> +	struct transaction_stats_s *ts = v;
> +	if (v == SEQ_START_TOKEN) {
> +		seq_printf(seq, "%-4s %-5s %-5s %-5s %-5s %-5s %-5s %-6s %-5s "
> +				"%-5s %-5s %-5s %-5s %-5s\n", "R/C", "tid",
> +				"wait", "run", "lock", "flush", "log", "hndls",
> +				"block", "inlog", "ctime", "write", "drop",
> +				"close");
> +		return 0;
> +	}
> +	if (ts->ts_type == JBD2_STATS_RUN)
> +		seq_printf(seq, "%-4s %-5lu %-5lu %-5lu %-5lu %-5lu %-5lu "
> +				"%-6lu %-5lu %-5lu\n", "R", ts->ts_tid,
> +				ts->ts_wait, ts->ts_running, ts->ts_locked,
> +				ts->ts_flushing, ts->ts_logging,
> +				ts->ts_handle_count, ts->ts_blocks,
> +				ts->ts_blocks_logged);
> +	else if (ts->ts_type == JBD2_STATS_CHECKPOINT)
> +		seq_printf(seq, "%-4s %-5lu %48s %-5lu %-5lu %-5lu %-5lu\n",
> +				"C", ts->ts_tid, " ", ts->ts_chp_time,
> +				ts->ts_written, ts->ts_dropped,
> +				ts->ts_forced_to_close);
> +	else
> +		J_ASSERT(0);
> +	return 0;
> +}
> +
> +static void jbd2_seq_history_stop(struct seq_file *seq, void *v)
> +{
> +}
> +
> +static struct seq_operations jbd2_seq_history_ops = {
> +	.start  = jbd2_seq_history_start,
> +	.next   = jbd2_seq_history_next,
> +	.stop   = jbd2_seq_history_stop,
> +	.show   = jbd2_seq_history_show,
> +};
> +
> +static int jbd2_seq_history_open(struct inode *inode, struct file *file)
> +{
> +	journal_t *journal = PDE(inode)->data;
> +	struct jbd2_stats_proc_session *s;
> +	int rc, size;
> +
> +	s = kmalloc(sizeof(*s), GFP_KERNEL);
> +	if (s == NULL)
> +		return -EIO;

ENOMEM.

> +	size = sizeof(struct transaction_stats_s) * journal->j_history_max;
> +	s->stats = kmalloc(size, GFP_KERNEL);
> +	if (s == NULL) {
> +		kfree(s);
> +		return -EIO;

ENOMEM.

> +	}
> +	spin_lock(&journal->j_history_lock);
> +	memcpy(s->stats, journal->j_history, size);
> +	s->max = journal->j_history_max;
> +	s->start = journal->j_history_cur % s->max;
> +	spin_unlock(&journal->j_history_lock);
> +
> +	rc = seq_open(file, &jbd2_seq_history_ops);
> +	if (rc == 0) {
> +		struct seq_file *m = (struct seq_file *)file->private_data;

unneeded cast of void*

> +		m->private = s;
> +	} else {
> +		kfree(s->stats);
> +		kfree(s);
> +	}
> +	return rc;
> +
> +}
> +
> +static int jbd2_seq_history_release(struct inode *inode, struct file *file)
> +{
> +	struct seq_file *seq = (struct seq_file *)file->private_data;

unneeded cast of void*

> +	struct jbd2_stats_proc_session *s = seq->private;
> +	kfree(s->stats);
> +	kfree(s);
> +	return seq_release(inode, file);
> +}
> +
>
> ...
>
> +static int jbd2_seq_info_open(struct inode *inode, struct file *file)
> +{
> +	journal_t *journal = PDE(inode)->data;
> +	struct jbd2_stats_proc_session *s;
> +	int rc, size;
> +
> +	s = kmalloc(sizeof(*s), GFP_KERNEL);
> +	if (s == NULL)
> +		return -EIO;

ENOMEM

> +	size = sizeof(struct transaction_stats_s);
> +	s->stats = kmalloc(size, GFP_KERNEL);
> +	if (s == NULL) {
> +		kfree(s);
> +		return -EIO;

ENOMEM

> +	}
> +	spin_lock(&journal->j_history_lock);
> +	memcpy(s->stats, &journal->j_stats, size);
> +	s->journal = journal;
> +	spin_unlock(&journal->j_history_lock);
> +
> +	rc = seq_open(file, &jbd2_seq_info_ops);
> +	if (rc == 0) {
> +		struct seq_file *m = (struct seq_file *)file->private_data;
> +		m->private = s;
> +	} else {
> +		kfree(s->stats);
> +		kfree(s);
> +	}
> +	return rc;
> +
> +}
> +
> +static int jbd2_seq_info_release(struct inode *inode, struct file *file)
> +{
> +	struct seq_file *seq = (struct seq_file *)file->private_data;

Unneeded cast

> +	struct jbd2_stats_proc_session *s = seq->private;
> +	kfree(s->stats);
> +	kfree(s);
> +	return seq_release(inode, file);
> +}

We would usually put a blanck line betwee end-of-locals and start-of-code.

> +static struct file_operations jbd2_seq_info_fops = {
> +	.owner		= THIS_MODULE,
> +	.open           = jbd2_seq_info_open,
> +	.read           = seq_read,
> +	.llseek         = seq_lseek,
> +	.release        = jbd2_seq_info_release,
> +};
> +
> +static struct proc_dir_entry *proc_jbd2_stats = NULL;

Unneeded (and wasteful) initialisation (checkpatch should catch this)

> +static void jbd2_stats_proc_init(journal_t *journal)
> +{
> +	char name[64];

This should have size BDEVNAME_SIZE.

> +	snprintf(name, sizeof(name) - 1, "%s", bdevname(journal->j_dev, name));
> +	journal->j_proc_entry = proc_mkdir(name, proc_jbd2_stats);
> +	if (journal->j_proc_entry) {
> +		struct proc_dir_entry *p;
> +		p = create_proc_entry("history", S_IRUGO,
> +				journal->j_proc_entry);
> +		if (p) {
> +			p->proc_fops = &jbd2_seq_history_fops;
> +			p->data = journal;
> +			p = create_proc_entry("info", S_IRUGO,
> +						journal->j_proc_entry);
> +			if (p) {
> +				p->proc_fops = &jbd2_seq_info_fops;
> +				p->data = journal;
> +			}
> +		}
> +	}
> +}
> +
> +static void jbd2_stats_proc_exit(journal_t *journal)
> +{
> +	char name[64];

ditto

> +	snprintf(name, sizeof(name) - 1, "%s", bdevname(journal->j_dev, name));
> +	remove_proc_entry("info", journal->j_proc_entry);
> +	remove_proc_entry("history", journal->j_proc_entry);
> +	remove_proc_entry(name, proc_jbd2_stats);
> +}
> +
> +static void journal_init_stats(journal_t *journal)
> +{
> +	int size;
> +
> +	if (proc_jbd2_stats == NULL)
> +		return;
> +
> +	journal->j_history_max = 100;
> +	size = sizeof(struct transaction_stats_s) * journal->j_history_max;
> +	journal->j_history = kmalloc(size, GFP_KERNEL);
> +	if (journal->j_history == NULL) {
> +		journal->j_history_max = 0;
> +		return;
> +	}
> +	memset(journal->j_history, 0, size);
> +	spin_lock_init(&journal->j_history_lock);
> +}

So the "100" is not alterable at present although the code is pretty much
set up to do this (code which alters the size of the history buffer will
need to take j_history_lock).

> +	journal_init_stats(journal);

This is all a heck of a lot of new code.  Should we plan to make it
Kconfigurable?

> +#if defined(CONFIG_PROC_FS)

#ifdef CONFIG_PROC_FS

would be more typical

> +#define JBD2_STATS_PROC_NAME "fs/jbd2"

hm, now what's going one here.  Maybe I misiunderstood, and the stats are
not per-superblock at all.  That would be a shame.

> +static void __init jbd2_create_jbd_stats_proc_entry(void)
> +{
> +	proc_jbd2_stats = proc_mkdir(JBD2_STATS_PROC_NAME, NULL);
> +}
> +
> +static void __exit jbd2_remove_jbd_stats_proc_entry(void)
> +{
> +	if (proc_jbd2_stats)
> +		remove_proc_entry(JBD2_STATS_PROC_NAME, NULL);
> +}
> +
> +#else
> +
> +#define jbd2_create_jbd_stats_proc_entry() do {} while (0)
> +#define jbd2_remove_jbd_stats_proc_entry() do {} while (0)

These could be coded in C.  Remember: only use macros for things which
_cannot_ be coded in C.


> +#endif
> +
>  struct kmem_cache *jbd2_handle_cache;
>  
>  static int __init journal_init_handle_cache(void)
> @@ -2046,6 +2376,7 @@
>  	if (ret != 0)
>  		jbd2_journal_destroy_caches();
>  	jbd2_create_debugfs_entry();
> +	jbd2_create_jbd_stats_proc_entry();
>  	return ret;
>  }
>  
> @@ -2057,6 +2388,7 @@
>  		printk(KERN_EMERG "JBD: leaked %d journal_heads!\n", n);
>  #endif
>  	jbd2_remove_debugfs_entry();
> +	jbd2_remove_jbd_stats_proc_entry();
>  	jbd2_journal_destroy_caches();
>  }
