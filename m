From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [RFC PATCH v7] ext4: Coordinate data-only flush requests sent by
	fsync
Date: Tue, 4 Jan 2011 08:27:31 -0800
Message-ID: <20110104162731.GA27381@tux1.beaverton.ibm.com>
References: <20101129220536.12401.16581.stgit@elm3b57.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>, Tejun Heo <tj@kernel.org>,
	linux-ext4@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>,
	Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@redhat.com>
To: Jens Axboe <axboe@kernel.dk>, "Theodore Ts'o" <tytso@mit.edu>,
	Neil Brown <neilb@suse.de>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:39558 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab1ADQ1j (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Jan 2011 11:27:39 -0500
Content-Disposition: inline
In-Reply-To: <20101129220536.12401.16581.stgit@elm3b57.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On certain types of hardware, issuing a write cache flush takes a considerable
amount of time.  Typically, these are simple storage systems with write cache
enabled and no battery to save that cache after a power failure.  When we
encounter a system with many I/O threads that write data and then call fsync
after more transactions accumulate, ext4_sync_file performs a data-only flush,
the performance of which is suboptimal because each of those threads issues its
own flush command to the drive instead of trying to coordinate the flush,
thereby wasting execution time.

Instead of each fsync call initiating its own flush, we now try to detect the
situation where multiple threads are issuing flush requests.  The first thread
to enter ext4_sync_file becomes the owner of the flush, and any threads that
enter ext4_sync_file before the flush finishes are queued up to wait for the
next flush.  When that first flush finishes, one of those sleeping threads is
woken up to perform the next flush and wake up the other threads that are
merely asleep waiting for the second flush to finish.

In the single-threaded case, the thread will simply issue the flush and exit.
There is no delay factor as in previous versions of this patch.

This patch probably belongs in the block layer, but now that I've made a
working proof-of-concept in ext4 I thought it expedient to push it out to
lkml/linux-ext4 for comments while I work on moving it to the block layer.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 fs/ext4/ext4.h  |   15 ++++++++
 fs/ext4/fsync.c |  100 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ext4/super.c |   10 ++++++
 3 files changed, 124 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 94ce3d7..2ea4fe6 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -36,6 +36,16 @@
 /*
  * The fourth extended filesystem constants/structures
  */
+struct flush_completion_t {
+	struct completion ready;
+	struct completion finish;
+	int ret;
+	atomic_t waiters;
+	struct kref ref;
+};
+
+extern struct flush_completion_t *alloc_flush_completion(void);
+extern void free_flush_completion(struct kref *ref);
 
 /*
  * Define EXT4FS_DEBUG to produce debug messages
@@ -1199,6 +1209,11 @@ struct ext4_sb_info {
 	struct ext4_li_request *s_li_request;
 	/* Wait multiplier for lazy initialization thread */
 	unsigned int s_li_wait_mult;
+
+	/* fsync flush coordination */
+	spinlock_t flush_flag_lock;
+	int in_flush;
+	struct flush_completion_t *next_flush;
 };
 
 static inline struct ext4_sb_info *EXT4_SB(struct super_block *sb)
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index c1a7bc9..7572ac2 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -140,6 +140,104 @@ static void ext4_sync_parent(struct inode *inode)
 	}
 }
 
+struct flush_completion_t *alloc_flush_completion(void)
+{
+	struct flush_completion_t *t;
+
+	t = kzalloc(sizeof(*t), GFP_KERNEL);
+	if (!t)
+		return t;
+
+	init_completion(&t->ready);
+	init_completion(&t->finish);
+	kref_init(&t->ref);
+	INIT_COMPLETION(t->ready);
+	INIT_COMPLETION(t->finish);
+
+	return t;
+}
+
+void free_flush_completion(struct kref *ref)
+{
+	struct flush_completion_t *f;
+
+	f = container_of(ref, struct flush_completion_t, ref);
+	kfree(f);
+}
+
+/*
+ * Handle the case where a process wants to flush writes to disk but there is
+ * no accompanying journal commit (i.e. no metadata to be updated).  This can
+ * happen when a first thread writes data, some other threads issue and commit
+ * transactions for other filesystem activity, and then the first writer thread
+ * issues an fsync to flush its dirty data to disk.
+ */
+static int ext4_sync_dataonly(struct inode *inode)
+{
+	struct flush_completion_t *flush, *new_flush;
+	struct ext4_sb_info *sb = EXT4_SB(inode->i_sb);
+	int ret = 0;
+
+	new_flush = alloc_flush_completion();
+	if (!new_flush)
+		return -ENOMEM;
+
+again:
+	spin_lock(&sb->flush_flag_lock);
+	if (sb->in_flush) {
+		/* Flush in progress */
+		kref_get(&sb->next_flush->ref);
+		flush = sb->next_flush;
+		ret = atomic_read(&flush->waiters);
+		atomic_inc(&flush->waiters);
+		spin_unlock(&sb->flush_flag_lock);
+
+		/*
+		 * If there aren't any waiters, this thread will be woken
+		 * up to start the next flush.
+		 */
+		if (!ret) {
+			wait_for_completion(&flush->ready);
+			kref_put(&flush->ref, free_flush_completion);
+			goto again;
+		}
+
+		/* Otherwise, just wait for this flush to end. */
+		ret = wait_for_completion_killable(&flush->finish);
+		if (!ret)
+			ret = flush->ret;
+		kref_put(&flush->ref, free_flush_completion);
+		kref_put(&new_flush->ref, free_flush_completion);
+	} else {
+		/* no flush in progress */
+		flush = sb->next_flush;
+		sb->next_flush = new_flush;
+		sb->in_flush = 1;
+		spin_unlock(&sb->flush_flag_lock);
+
+		ret = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
+		flush->ret = ret;
+
+		/* Wake up the thread that starts the next flush. */
+		spin_lock(&sb->flush_flag_lock);
+		sb->in_flush = 0;
+		/*
+		 * This line must be between the zeroing of in_flush and the
+		 * spin_unlock because we don't want the next-flush thread to
+		 * start messing with pointers until we're safely out of this
+		 * section.  It must be the first complete_all, because on some
+		 * fast devices, the next flush finishes (and frees
+		 * next_flush!) before the second complete_all finishes!
+		 */
+		complete_all(&new_flush->ready);
+		spin_unlock(&sb->flush_flag_lock);
+
+		complete_all(&flush->finish);
+		kref_put(&flush->ref, free_flush_completion);
+	}
+	return ret;
+}
+
 /*
  * akpm: A new design for ext4_sync_file().
  *
@@ -214,6 +312,6 @@ int ext4_sync_file(struct file *file, int datasync)
 					NULL);
 		ret = jbd2_log_wait_commit(journal, commit_tid);
 	} else if (journal->j_flags & JBD2_BARRIER)
-		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
+		ret = ext4_sync_dataonly(inode);
 	return ret;
 }
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index fb15c9c..49ce7c2 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -787,6 +787,7 @@ static void ext4_put_super(struct super_block *sb)
 	kobject_put(&sbi->s_kobj);
 	wait_for_completion(&sbi->s_kobj_unregister);
 	kfree(sbi->s_blockgroup_lock);
+	kref_put(&sbi->next_flush->ref, free_flush_completion);
 	kfree(sbi);
 }
 
@@ -3011,11 +3012,20 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	int err;
 	unsigned int journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
 	ext4_group_t first_not_zeroed;
+	struct flush_completion_t *t;
+
+	t = alloc_flush_completion();
+	if (!t)
+		return -ENOMEM;
 
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
 		goto out_free_orig;
 
+	sbi->in_flush = 0;
+	spin_lock_init(&sbi->flush_flag_lock);
+	sbi->next_flush = t;
+
 	sbi->s_blockgroup_lock =
 		kzalloc(sizeof(struct blockgroup_lock), GFP_KERNEL);
 	if (!sbi->s_blockgroup_lock) {
