From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [RFC PATCH] fs: ext4: don't trap kswapd and allocating tasks on ext4 inode IO
Date: Mon, 15 May 2017 11:46:34 -0400
Message-ID: <20170515154634.19733-1-hannes@cmpxchg.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
To: Jan Kara <jack@suse.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

We have observed across several workloads situations where kswapd and
direct reclaimers get stuck in the inode shrinker of the ext4 / mount,
causing allocation latencies across tasks in the system, while there
are dozens of gigabytes of clean page cache covering multiple disks.

The stack traces of such an instance looks like this:

[<ffffffff812b3225>] jbd2_log_wait_commit+0x95/0x110
[<ffffffff812b4f29>] jbd2_complete_transaction+0x59/0x90
[<ffffffff812668da>] ext4_evict_inode+0x2da/0x480
[<ffffffff811f2230>] evict+0xc0/0x190
[<ffffffff811f2339>] dispose_list+0x39/0x50
[<ffffffff811f323b>] prune_icache_sb+0x4b/0x60
[<ffffffff811dba71>] super_cache_scan+0x141/0x190
[<ffffffff8116e755>] shrink_slab+0x235/0x440
[<ffffffff81172b48>] shrink_zone+0x268/0x2d0
[<ffffffff81172f04>] do_try_to_free_pages+0x164/0x410
[<ffffffff81173265>] try_to_free_pages+0xb5/0x160
[<ffffffff811656b6>] __alloc_pages_nodemask+0x636/0xb30
[<ffffffff811acac8>] alloc_pages_current+0x88/0x120
[<ffffffff816d4e46>] skb_page_frag_refill+0xc6/0xf0
[<ffffffff816d4e8d>] sk_page_frag_refill+0x1d/0x80
[<ffffffff8173f86b>] tcp_sendmsg+0x28b/0xb10
[<ffffffff81769727>] inet_sendmsg+0x67/0xa0
[<ffffffff816d0488>] sock_sendmsg+0x38/0x50
[<ffffffff816d0518>] sock_write_iter+0x78/0xd0
[<ffffffff811d774e>] do_iter_readv_writev+0x5e/0xa0
[<ffffffff811d8468>] do_readv_writev+0x178/0x210
[<ffffffff811d871c>] vfs_writev+0x3c/0x50
[<ffffffff811d8782>] do_writev+0x52/0xd0
[<ffffffff811d9810>] SyS_writev+0x10/0x20
[<ffffffff81002910>] do_syscall_64+0x50/0xa0
[<ffffffff817eed3c>] return_from_SYSCALL_64+0x0/0x6a
[<ffffffffffffffff>] 0xffffffffffffffff

The inode shrinker has provisions to skip any inodes that require
writeback, to avoid tarpitting the entire system behind a single
object when there are many other pools to recycle memory from. But
that logic doesn't cover the situation where an ext4 inode is clean
but journaled and tied to a commit that yet needs to hit the platter.

Add a superblock operation that lets the generic inode shrinker query
the filesystem whether evicting a given inode will require any IO; add
an ext4 implementation that checks whether the journal is caught up to
the commit id associated with the inode.

Fixes: 2d859db3e4a8 ("ext4: fix data corruption in inodes with journalled data")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 fs/ext4/ext4.h       |  1 +
 fs/ext4/inode.c      | 17 +++++++++++++++++
 fs/ext4/super.c      |  1 +
 fs/inode.c           |  7 +++++++
 fs/jbd2/journal.c    |  9 ++++++++-
 include/linux/fs.h   |  1 +
 include/linux/jbd2.h |  1 +
 7 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 8e8046104f4d..b552978fc31f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2463,6 +2463,7 @@ extern struct inode *ext4_iget_normal(struct super_block *, unsigned long);
 extern int  ext4_write_inode(struct inode *, struct writeback_control *);
 extern int  ext4_setattr(struct dentry *, struct iattr *);
 extern int  ext4_getattr(const struct path *, struct kstat *, u32, unsigned int);
+extern int ext4_evict_needs_io(struct inode *);
 extern void ext4_evict_inode(struct inode *);
 extern void ext4_clear_inode(struct inode *);
 extern int  ext4_file_getattr(const struct path *, struct kstat *, u32, unsigned int);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5834c4d76be8..4cb6cf932d9a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -182,6 +182,23 @@ int ext4_truncate_restart_trans(handle_t *handle, struct inode *inode,
 	return ret;
 }
 
+int ext4_evict_needs_io(struct inode *inode)
+{
+	if (inode->i_nlink &&
+	    inode->i_ino != EXT4_JOURNAL_INO &&
+	    ext4_should_journal_data(inode) &&
+	    (S_ISLNK(inode->i_mode) || S_ISREG(inode->i_mode))) {
+		journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
+		tid_t commit_tid = EXT4_I(inode)->i_datasync_tid;
+		int err;
+
+		err = __jbd2_complete_transaction(journal, commit_tid, false);
+		if (err == -EAGAIN)
+			return 1;
+	}
+	return 0;
+}
+
 /*
  * Called at the last iput() if i_nlink is zero.
  */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index c90edf09b0c3..e0e7cff589eb 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1287,6 +1287,7 @@ static const struct super_operations ext4_sops = {
 	.write_inode	= ext4_write_inode,
 	.dirty_inode	= ext4_dirty_inode,
 	.drop_inode	= ext4_drop_inode,
+	.evict_needs_io	= ext4_evict_needs_io,
 	.evict_inode	= ext4_evict_inode,
 	.put_super	= ext4_put_super,
 	.sync_fs	= ext4_sync_fs,
diff --git a/fs/inode.c b/fs/inode.c
index db5914783a71..730d2034b8a1 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -703,6 +703,7 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 {
 	struct list_head *freeable = arg;
 	struct inode	*inode = container_of(item, struct inode, i_lru);
+	const struct super_operations *op = inode->i_sb->s_op;
 
 	/*
 	 * we are inverting the lru lock/inode->i_lock here, so use a trylock.
@@ -723,6 +724,12 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 		return LRU_REMOVED;
 	}
 
+	/* If eviction may block on IO, defer for now */
+	if (op->evict_needs_io && !op->evict_needs_io(inode)) {
+		spin_unlock(&inode->i_lock);
+		return LRU_ROTATE;
+	}
+
 	/* recently referenced inodes get one more pass */
 	if (inode->i_state & I_REFERENCED) {
 		inode->i_state &= ~I_REFERENCED;
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 5a0245e36240..e353f3a0abf5 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -745,7 +745,7 @@ int jbd2_log_wait_commit(journal_t *journal, tid_t tid)
  * the transaction id is stale, it is by definition already completed,
  * so just return SUCCESS.
  */
-int jbd2_complete_transaction(journal_t *journal, tid_t tid)
+int __jbd2_complete_transaction(journal_t *journal, tid_t tid, bool wait)
 {
 	int	need_to_wait = 1;
 
@@ -765,8 +765,15 @@ int jbd2_complete_transaction(journal_t *journal, tid_t tid)
 	if (!need_to_wait)
 		return 0;
 wait_commit:
+	if (!wait)
+		return -EAGAIN;
 	return jbd2_log_wait_commit(journal, tid);
 }
+
+int jbd2_complete_transaction(journal_t *journal, tid_t tid)
+{
+	return __jbd2_complete_transaction(journal, tid, true);
+}
 EXPORT_SYMBOL(jbd2_complete_transaction);
 
 /*
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 26488b419965..3a895f31afa7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1777,6 +1777,7 @@ struct super_operations {
    	void (*dirty_inode) (struct inode *, int flags);
 	int (*write_inode) (struct inode *, struct writeback_control *wbc);
 	int (*drop_inode) (struct inode *);
+	int (*evict_needs_io) (struct inode *);
 	void (*evict_inode) (struct inode *);
 	void (*put_super) (struct super_block *);
 	int (*sync_fs)(struct super_block *sb, int wait);
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 606b6bce3a5b..3b902bed6e8b 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1367,6 +1367,7 @@ int jbd2_log_start_commit(journal_t *journal, tid_t tid);
 int __jbd2_log_start_commit(journal_t *journal, tid_t tid);
 int jbd2_journal_start_commit(journal_t *journal, tid_t *tid);
 int jbd2_log_wait_commit(journal_t *journal, tid_t tid);
+int __jbd2_complete_transaction(journal_t *journal, tid_t tid, bool wait);
 int jbd2_complete_transaction(journal_t *journal, tid_t tid);
 int jbd2_log_do_checkpoint(journal_t *journal);
 int jbd2_trans_will_send_data_barrier(journal_t *journal, tid_t tid);
-- 
2.12.2
