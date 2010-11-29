From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 4/4] ext4: Coordinate data-only flush requests sent by fsync
Date: Mon, 29 Nov 2010 14:06:05 -0800
Message-ID: <20101129220605.12401.89668.stgit@elm3b57.beaverton.ibm.com>
References: <20101129220536.12401.16581.stgit@elm3b57.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-raid@vger.kernel.org, Keith Mannthey <kmannth@us.ibm.com>,
	dm-devel@redhat.com, Mingming Cao <cmm@us.ibm.com>,
	Tejun Heo <tj@kernel.org>, linux-ext4@vger.kernel.org,
	Ric Wheeler <rwheeler@redhat.com>,
	Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@redhat.com>
To: Jens Axboe <axboe@kernel.dk>, "Theodore Ts'o" <tytso@mit.edu>,
	Neil Brown <neilb@suse.de>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Alasdair G Kergon <agk@redhat.com>,
	"Darrick J.
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101129220536.12401.16581.stgit@elm3b57.beaverton.ibm.com>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On certain types of hardware, issuing a write cache flush takes a considerable
amount of time.  Typically, these are simple storage systems with write cache
enabled and no battery to save that cache after a power failure.  When we
encounter a system with many I/O threads that write data and then call fsync
after more transactions accumulate, ext4_sync_file performs a data-only flush,
the performance of which is suboptimal because each of those threads issues its
own flush command to the drive instead of trying to coordinate the flush,
thereby wasting execution time.

Instead of each fsync call initiating its own flush, there's now a flag to
indicate if (0) no flushes are ongoing, (1) we're delaying a short time to
collect other fsync threads, or (2) we're actually in-progress on a flush.

So, if someone calls ext4_sync_file and no flushes are in progress, the flag
shifts from 0->1 and the thread delays for a short time to see if there are any
other threads that are close behind in ext4_sync_file.  After that wait, the
state transitions to 2 and the flush is issued.  Once that's done, the state
goes back to 0 and a completion is signalled.

Those close-behind threads see the flag is already 1, and go to sleep until the
completion is signalled.  Instead of issuing a flush themselves, they simply
wait for that first thread to do it for them.  If they see that the flag is 2,
they wait for the current flush to finish, and start over.

However, there are a couple of exceptions to this rule.  First, there exist
high-end storage arrays with battery-backed write caches for which flush
commands take very little time (< 2ms); on these systems, performing the
coordination actually lowers performance.  Given the earlier patch to the block
layer to report low-level device flush times, we can detect this situation and
have all threads issue flushes without coordinating, as we did before.  The
second case is when there's a single thread issuing flushes, in which case it
can skip the coordination.

This author of this patch is aware that jbd2 has a similar flush coordination
scheme for journal commits.  An earlier version of this patch simply created a
new empty journal transaction and committed it, but that approach was shown to
increase the amount of write traffic heading towards the disk, which in turn
lowered performance considerably, especially in the case where directio was in
use.  Therefore, this patch adds the coordination code directly to ext4.

Should the user need to override the definition of a "fast" flush from the
default 2ms, the fast_flush_ns mount option is provided to do this.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/ext4.h  |   18 +++++++++++++
 fs/ext4/fsync.c |   79 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ext4/super.c |   23 ++++++++++++++++
 3 files changed, 119 insertions(+), 1 deletions(-)


diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 6a5edea..8c111e3 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -38,6 +38,17 @@
  */
 
 /*
+ * Flushes under 2ms should disable flush coordination
+ */
+#define DEFAULT_FAST_FLUSH	2000000
+
+enum ext4_flush_state {
+	EXT4_FLUSH_IDLE = 0,	/* no flushes going on */
+	EXT4_FLUSH_WAITING,	/* coordinating w/ other threads */
+	EXT4_FLUSH_RUNNING,	/* flush submitted */
+};
+
+/*
  * Define EXT4FS_DEBUG to produce debug messages
  */
 #undef EXT4FS_DEBUG
@@ -1198,6 +1209,13 @@ struct ext4_sb_info {
 	struct ext4_li_request *s_li_request;
 	/* Wait multiplier for lazy initialization thread */
 	unsigned int s_li_wait_mult;
+
+	/* fsync flush coordination */
+	spinlock_t flush_flag_lock;
+	enum ext4_flush_state flush_state;
+	struct completion flush_finish;
+	pid_t last_flusher;
+	unsigned long fast_flush_ns;
 };
 
 static inline struct ext4_sb_info *EXT4_SB(struct super_block *sb)
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index c1a7bc9..e3e5a5f 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -141,6 +141,83 @@ static void ext4_sync_parent(struct inode *inode)
 }
 
 /*
+ * Handle the case where a process wants to flush writes to disk but there is
+ * no accompanying journal commit (i.e. no metadata to be updated).  This can
+ * happen when a first thread writes data, some other threads issue and commit
+ * transactions for other filesystem activity, and then the first writer thread
+ * issues an fsync to flush its dirty data to disk.
+ */
+static int ext4_sync_dataonly(struct inode *inode)
+{
+	struct ext4_sb_info *sb = EXT4_SB(inode->i_sb);
+	struct gendisk *disk;
+	ktime_t expires;
+	pid_t pid;
+	int ret = 0;
+
+	/*
+	 * Fast (< 2ms) flushes imply battery-backed write cache or a block
+	 * device that silently eat flushes (disk w/o any write cache), which
+	 * implies that flushes are no-ops.  We also check the calling process;
+	 * if it's the same as the previous caller, there's only one process,
+	 * and no need to coordinate.  Issue the flush instead of wasting time
+	 * coordinating no-ops.
+	 *
+	 * As this is a data-only flush (no metadata writes), we do the flush
+	 * coordination here instead of creating and committing an empty
+	 * journal transaction, because doing so creates more writes for the
+	 * empty journal records.
+	 */
+	pid = current->pid;
+	disk = inode->i_sb->s_bdev->bd_disk;
+	spin_lock(&sb->flush_flag_lock);
+	if ((!sb->flush_state && sb->last_flusher == pid) ||
+	    sb->fast_flush_ns > disk->avg_flush_time_ns) {
+		sb->last_flusher = pid;
+		spin_unlock(&sb->flush_flag_lock);
+		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL,
+				   NULL);
+		return 0;
+	}
+again:
+	switch (sb->flush_state) {
+	case EXT4_FLUSH_RUNNING:
+		spin_unlock(&sb->flush_flag_lock);
+		ret = wait_for_completion_interruptible(&sb->flush_finish);
+		spin_lock(&sb->flush_flag_lock);
+		goto again;
+	case EXT4_FLUSH_WAITING:
+		spin_unlock(&sb->flush_flag_lock);
+		ret = wait_for_completion_interruptible(&sb->flush_finish);
+		break;
+	case EXT4_FLUSH_IDLE:
+		sb->last_flusher = pid;
+		sb->flush_state = EXT4_FLUSH_WAITING;
+		INIT_COMPLETION(sb->flush_finish);
+		spin_unlock(&sb->flush_flag_lock);
+
+		expires = ktime_add_ns(ktime_get(), disk->avg_flush_time_ns);
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_hrtimeout(&expires, HRTIMER_MODE_ABS);
+
+		spin_lock(&sb->flush_flag_lock);
+		sb->flush_state = EXT4_FLUSH_RUNNING;
+		spin_unlock(&sb->flush_flag_lock);
+
+		ret = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
+
+		complete_all(&sb->flush_finish);
+
+		spin_lock(&sb->flush_flag_lock);
+		sb->flush_state = EXT4_FLUSH_IDLE;
+		spin_unlock(&sb->flush_flag_lock);
+		break;
+	}
+
+	return ret;
+}
+
+/*
  * akpm: A new design for ext4_sync_file().
  *
  * This is only called from sys_fsync(), sys_fdatasync() and sys_msync().
@@ -214,6 +291,6 @@ int ext4_sync_file(struct file *file, int datasync)
 					NULL);
 		ret = jbd2_log_wait_commit(journal, commit_tid);
 	} else if (journal->j_flags & JBD2_BARRIER)
-		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
+		ret = ext4_sync_dataonly(inode);
 	return ret;
 }
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e32195d..473721a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1026,6 +1026,10 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	    !(def_mount_opts & EXT4_DEFM_NODELALLOC))
 		seq_puts(seq, ",nodelalloc");
 
+	if (sbi->fast_flush_ns != DEFAULT_FAST_FLUSH)
+		seq_printf(seq, ",fast_flush_ns=%lu",
+			   sbi->fast_flush_ns);
+
 	if (sbi->s_stripe)
 		seq_printf(seq, ",stripe=%lu", sbi->s_stripe);
 	/*
@@ -1245,6 +1249,7 @@ enum {
 	Opt_dioread_nolock, Opt_dioread_lock,
 	Opt_discard, Opt_nodiscard,
 	Opt_init_inode_table, Opt_noinit_inode_table,
+	Opt_fast_flush_ns,
 };
 
 static const match_table_t tokens = {
@@ -1318,6 +1323,7 @@ static const match_table_t tokens = {
 	{Opt_init_inode_table, "init_itable=%u"},
 	{Opt_init_inode_table, "init_itable"},
 	{Opt_noinit_inode_table, "noinit_itable"},
+	{Opt_fast_flush_ns, "fast_flush_ns=%d"},
 	{Opt_err, NULL},
 };
 
@@ -1802,6 +1808,15 @@ set_qf_format:
 		case Opt_noinit_inode_table:
 			clear_opt(sbi->s_mount_opt, INIT_INODE_TABLE);
 			break;
+		case Opt_fast_flush_ns:
+			if (args[0].from) {
+				if (match_int(&args[0], &option))
+					return 0;
+			} else
+				return 0;
+
+			sbi->fast_flush_ns = option;
+			break;
 		default:
 			ext4_msg(sb, KERN_ERR,
 			       "Unrecognized mount option \"%s\" "
@@ -3120,6 +3135,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 			 "failed to parse options in superblock: %s",
 			 sbi->s_es->s_mount_opts);
 	}
+
+	EXT4_SB(sb)->fast_flush_ns = DEFAULT_FAST_FLUSH;
+
 	if (!parse_options((char *) data, sb, &journal_devnum,
 			   &journal_ioprio, NULL, 0))
 		goto failed_mount;
@@ -3617,6 +3635,11 @@ no_journal:
 	if (es->s_error_count)
 		mod_timer(&sbi->s_err_report, jiffies + 300*HZ); /* 5 minutes */
 
+	EXT4_SB(sb)->flush_state = EXT4_FLUSH_IDLE;
+	spin_lock_init(&EXT4_SB(sb)->flush_flag_lock);
+	init_completion(&EXT4_SB(sb)->flush_finish);
+	EXT4_SB(sb)->last_flusher = 0;
+
 	kfree(orig_data);
 	return 0;
 

