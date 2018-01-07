From: "Tobin C. Harding" <me@tobin.cc>
Subject: [PATCH] jbd2: fix sphinx kerel-doc build warnings for journal_s
Date: Sun,  7 Jan 2018 11:46:14 +1100
Message-ID: <1515285974-29373-1-git-send-email-me@tobin.cc>
Cc: "Tobin C. Harding" <me@tobin.cc>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Sphinx emits various warnings when building make target 'htmldocs'.

Currently struct journal_s definition contains duplicate documentation,
some as kernel-docs and some as standard c89 comments.  We can reduce
duplication while cleaning up the kernel-docs. 

Move all kernel-docs to right above each struct member.  Use the set of
all existing comments (kernel-doc and c89).

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---

This patch only fixes 6 of the 24 warnings. If this work is deemed useful I
can do the rest. If there is a way to fix the warnings that is cleaner
than this please say so.

thanks,
Tobin.

 include/linux/jbd2.h | 401 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 269 insertions(+), 132 deletions(-)

diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 296d1e0ea87b..fb9cd4fcc0e0 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -729,228 +729,281 @@ jbd2_time_diff(unsigned long start, unsigned long end)
 /**
  * struct journal_s - The journal_s type is the concrete type associated with
  *     journal_t.
- * @j_flags:  General journaling state flags
- * @j_errno:  Is there an outstanding uncleared error on the journal (from a
- *     prior abort)?
- * @j_sb_buffer: First part of superblock buffer
- * @j_superblock: Second part of superblock buffer
- * @j_format_version: Version of the superblock format
- * @j_state_lock: Protect the various scalars in the journal
- * @j_barrier_count:  Number of processes waiting to create a barrier lock
- * @j_barrier: The barrier lock itself
- * @j_running_transaction: The current running transaction..
- * @j_committing_transaction: the transaction we are pushing to disk
- * @j_checkpoint_transactions: a linked circular list of all transactions
- *  waiting for checkpointing
- * @j_wait_transaction_locked: Wait queue for waiting for a locked transaction
- *  to start committing, or for a barrier lock to be released
- * @j_wait_done_commit: Wait queue for waiting for commit to complete
- * @j_wait_commit: Wait queue to trigger commit
- * @j_wait_updates: Wait queue to wait for updates to complete
- * @j_wait_reserved: Wait queue to wait for reserved buffer credits to drop
- * @j_checkpoint_mutex: Mutex for locking against concurrent checkpoints
- * @j_head: Journal head - identifies the first unused block in the journal
- * @j_tail: Journal tail - identifies the oldest still-used block in the
- *  journal.
- * @j_free: Journal free - how many free blocks are there in the journal?
- * @j_first: The block number of the first usable block
- * @j_last: The block number one beyond the last usable block
- * @j_dev: Device where we store the journal
- * @j_blocksize: blocksize for the location where we store the journal.
- * @j_blk_offset: starting block offset for into the device where we store the
- *     journal
- * @j_fs_dev: Device which holds the client fs.  For internal journal this will
- *     be equal to j_dev
- * @j_reserved_credits: Number of buffers reserved from the running transaction
- * @j_maxlen: Total maximum capacity of the journal region on disk.
- * @j_list_lock: Protects the buffer lists and internal buffer state.
- * @j_inode: Optional inode where we store the journal.  If present, all journal
- *     block numbers are mapped into this inode via bmap().
- * @j_tail_sequence:  Sequence number of the oldest transaction in the log
- * @j_transaction_sequence: Sequence number of the next transaction to grant
- * @j_commit_sequence: Sequence number of the most recently committed
- *  transaction
- * @j_commit_request: Sequence number of the most recent transaction wanting
- *     commit
- * @j_uuid: Uuid of client object.
- * @j_task: Pointer to the current commit thread for this journal
- * @j_max_transaction_buffers:  Maximum number of metadata buffers to allow in a
- *     single compound commit transaction
- * @j_commit_interval: What is the maximum transaction lifetime before we begin
- *  a commit?
- * @j_commit_timer:  The timer used to wakeup the commit thread
- * @j_revoke_lock: Protect the revoke table
- * @j_revoke: The revoke table - maintains the list of revoked blocks in the
- *     current transaction.
- * @j_revoke_table: alternate revoke tables for j_revoke
- * @j_wbuf: array of buffer_heads for jbd2_journal_commit_transaction
- * @j_wbufsize: maximum number of buffer_heads allowed in j_wbuf, the
- *	number that will fit in j_blocksize
- * @j_last_sync_writer: most recent pid which did a synchronous write
- * @j_history_lock: Protect the transactions statistics history
- * @j_proc_entry: procfs entry for the jbd statistics directory
- * @j_stats: Overall statistics
- * @j_private: An opaque pointer to fs-private information.
- * @j_trans_commit_map: Lockdep entity to track transaction commit dependencies
  */
-
 struct journal_s
 {
-	/* General journaling state flags [j_state_lock] */
+	/**
+	 * @j_flags:
+	 *
+	 * General journaling state flags [j_state_lock]
+	 */
 	unsigned long		j_flags;
 
-	/*
+	/**
+	 * @j_errno:
+	 *
 	 * Is there an outstanding uncleared error on the journal (from a prior
 	 * abort)? [j_state_lock]
 	 */
 	int			j_errno;
 
-	/* The superblock buffer */
+	/**
+	 * @j_sb_buffer:
+	 *
+	 * The first part of the superblock buffer.
+	 */
 	struct buffer_head	*j_sb_buffer;
+
+	/**
+	 * @j_superblock:
+	 *
+	 * The second part of the superblock buffer.
+	 */
 	journal_superblock_t	*j_superblock;
 
-	/* Version of the superblock format */
+	/**
+	 * @j_format_version:
+	 *
+	 * Version of the superblock format.
+	 */
 	int			j_format_version;
 
-	/*
-	 * Protect the various scalars in the journal
+	/**
+	 * @j_state_lock:
+	 *
+	 * Protect the various scalars in the journal.
 	 */
 	rwlock_t		j_state_lock;
 
-	/*
+	/**
+	 * @j_barrier_count:
+	 *
 	 * Number of processes waiting to create a barrier lock [j_state_lock]
 	 */
 	int			j_barrier_count;
 
-	/* The barrier lock itself */
+	/**
+	 * @j_barrier:
+	 *
+	 * The barrier lock itself.
+	 */
 	struct mutex		j_barrier;
 
-	/*
+	/**
+	 * @j_running_transaction:
+	 *
 	 * Transactions: The current running transaction...
 	 * [j_state_lock] [caller holding open handle]
 	 */
 	transaction_t		*j_running_transaction;
 
-	/*
+	/**
+	 * @j_committing_transaction:
+	 *
 	 * the transaction we are pushing to disk
 	 * [j_state_lock] [caller holding open handle]
 	 */
 	transaction_t		*j_committing_transaction;
 
-	/*
+	/**
+	 * @j_checkpoint_transactions:
+	 *
 	 * ... and a linked circular list of all transactions waiting for
 	 * checkpointing. [j_list_lock]
 	 */
 	transaction_t		*j_checkpoint_transactions;
 
-	/*
+	/**
+	 * @j_wait_transaction_locked:
+	 *
 	 * Wait queue for waiting for a locked transaction to start committing,
-	 * or for a barrier lock to be released
+	 * or for a barrier lock to be released.
 	 */
 	wait_queue_head_t	j_wait_transaction_locked;
 
-	/* Wait queue for waiting for commit to complete */
+	/**
+	 * @j_wait_done_commit:
+	 *
+	 * Wait queue for waiting for commit to complete.
+	 */
 	wait_queue_head_t	j_wait_done_commit;
 
-	/* Wait queue to trigger commit */
+	/**
+	 * @j_wait_commit:
+	 *
+	 * Wait queue to trigger commit.
+	 */
 	wait_queue_head_t	j_wait_commit;
 
-	/* Wait queue to wait for updates to complete */
+	/**
+	 * @j_wait_updates:
+	 *
+	 * Wait queue to wait for updates to complete.
+	 */
 	wait_queue_head_t	j_wait_updates;
 
-	/* Wait queue to wait for reserved buffer credits to drop */
+	/**
+	 * @j_wait_reserved:
+	 *
+	 * Wait queue to wait for reserved buffer credits to drop.
+	 */
 	wait_queue_head_t	j_wait_reserved;
 
-	/* Semaphore for locking against concurrent checkpoints */
+	/**
+	 * @j_checkpoint_mutex:
+	 *
+	 * Semaphore for locking against concurrent checkpoints.
+	 */
 	struct mutex		j_checkpoint_mutex;
 
-	/*
+	/**
+	 * @j_chkpt_bhs:
+	 *
 	 * List of buffer heads used by the checkpoint routine.  This
 	 * was moved from jbd2_log_do_checkpoint() to reduce stack
 	 * usage.  Access to this array is controlled by the
-	 * j_checkpoint_mutex.  [j_checkpoint_mutex]
+	 * @j_checkpoint_mutex.  [j_checkpoint_mutex]
 	 */
 	struct buffer_head	*j_chkpt_bhs[JBD2_NR_BATCH];
-	
-	/*
+
+	/**
+	 * @j_head:
+	 *
 	 * Journal head: identifies the first unused block in the journal.
 	 * [j_state_lock]
 	 */
 	unsigned long		j_head;
 
-	/*
+	/**
+	 * @j_tail:
+	 *
 	 * Journal tail: identifies the oldest still-used block in the journal.
 	 * [j_state_lock]
 	 */
 	unsigned long		j_tail;
 
-	/*
+	/**
+	 * @j_free:
+	 *
 	 * Journal free: how many free blocks are there in the journal?
 	 * [j_state_lock]
 	 */
 	unsigned long		j_free;
 
-	/*
-	 * Journal start and end: the block numbers of the first usable block
-	 * and one beyond the last usable block in the journal. [j_state_lock]
+	/**
+	 * @j_first:
+	 *
+	 * The block number of the first usable block in the journal
+	 * [j_state_lock].
 	 */
 	unsigned long		j_first;
+
+	/**
+	 * @j_last:
+	 *
+	 * The block number one beyond the last usable block in the
+	 * journal [j_state_lock].
+	 */
 	unsigned long		j_last;
 
-	/*
-	 * Device, blocksize and starting block offset for the location where we
-	 * store the journal.
+	/**
+	 * @j_dev:
+	 *
+	 * Device where we store the journal.
 	 */
 	struct block_device	*j_dev;
+
+	/**
+	 * @j_blocksize:
+	 *
+	 * Block size for the location where we store the journal.
+	 */
 	int			j_blocksize;
+
+	/**
+	 * @j_blk_offset:
+	 *
+	 * Starting block offset into the device where we store the journal.
+	 */
 	unsigned long long	j_blk_offset;
+
+	/**
+	 * @j_devname:
+	 *
+	 * Journal device name.
+	 */
 	char			j_devname[BDEVNAME_SIZE+24];
 
-	/*
+	/**
+	 * @j_fs_dev:
+	 *
 	 * Device which holds the client fs.  For internal journal this will be
 	 * equal to j_dev.
 	 */
 	struct block_device	*j_fs_dev;
 
-	/* Total maximum capacity of the journal region on disk. */
+	/**
+	 * @j_maxlen:
+	 *
+	 * Total maximum capacity of the journal region on disk.
+	 */
 	unsigned int		j_maxlen;
 
-	/* Number of buffers reserved from the running transaction */
+	/**
+	 * @j_reserved_credits:
+	 *
+	 * Number of buffers reserved from the running transaction.
+	 */
 	atomic_t		j_reserved_credits;
 
-	/*
+	/**
+	 * @j_list_lock:
+	 *
 	 * Protects the buffer lists and internal buffer state.
 	 */
 	spinlock_t		j_list_lock;
 
-	/* Optional inode where we store the journal.  If present, all */
-	/* journal block numbers are mapped into this inode via */
-	/* bmap(). */
+	/**
+	 * @j_inode:
+	 *
+	 * Optional inode where we store the journal.  If present, all
+	 * journal block numbers are mapped into this inode via bmap().
+	 */
 	struct inode		*j_inode;
 
-	/*
+	/**
+	 * @j_tail_sequence:
+	 *
 	 * Sequence number of the oldest transaction in the log [j_state_lock]
 	 */
 	tid_t			j_tail_sequence;
 
-	/*
+	/**
+	 * @j_transaction_sequence:
+	 *
 	 * Sequence number of the next transaction to grant [j_state_lock]
 	 */
 	tid_t			j_transaction_sequence;
 
-	/*
+	/**
+	 * @j_commit_sequence:
+	 *
 	 * Sequence number of the most recently committed transaction
 	 * [j_state_lock].
 	 */
 	tid_t			j_commit_sequence;
 
-	/*
+	/**
+	 * @j_commit_request:
+	 *
 	 * Sequence number of the most recent transaction wanting commit
 	 * [j_state_lock]
 	 */
 	tid_t			j_commit_request;
 
-	/*
+	/**
+	 * @j_uuid:
+	 *
 	 * Journal uuid: identifies the object (filesystem, LVM volume etc)
 	 * backed by this journal.  This will eventually be replaced by an array
 	 * of uuids, allowing us to index multiple devices within a single
@@ -958,85 +1011,169 @@ struct journal_s
 	 */
 	__u8			j_uuid[16];
 
-	/* Pointer to the current commit thread for this journal */
+	/**
+	 * @j_task:
+	 *
+	 * Pointer to the current commit thread for this journal.
+	 */
 	struct task_struct	*j_task;
 
-	/*
+	/**
+	 * @j_max_transaction_buffers:
+	 *
 	 * Maximum number of metadata buffers to allow in a single compound
-	 * commit transaction
+	 * commit transaction.
 	 */
 	int			j_max_transaction_buffers;
 
-	/*
+	/**
+	 * @j_commit_interval:
+	 *
 	 * What is the maximum transaction lifetime before we begin a commit?
 	 */
 	unsigned long		j_commit_interval;
 
-	/* The timer used to wakeup the commit thread: */
+	/**
+	 * @j_commit_timer:
+	 *
+	 * The timer used to wakeup the commit thread.
+	 */
 	struct timer_list	j_commit_timer;
 
-	/*
-	 * The revoke table: maintains the list of revoked blocks in the
-	 * current transaction.  [j_revoke_lock]
+	/**
+	 * @j_revoke_lock:
+	 *
+	 * Protect the revoke table.
 	 */
 	spinlock_t		j_revoke_lock;
+
+	/**
+	 * @j_revoke:
+	 *
+	 * The revoke table - maintains the list of revoked blocks in the
+	 * current transaction.
+	 */
 	struct jbd2_revoke_table_s *j_revoke;
+
+	/**
+	 * @j_revoke_table:
+	 *
+	 * Alternate revoke tables for j_revoke.
+	 */
 	struct jbd2_revoke_table_s *j_revoke_table[2];
 
-	/*
-	 * array of bhs for jbd2_journal_commit_transaction
+	/**
+	 * @j_wbuf:
+	 *
+	 * Array of bhs for jbd2_journal_commit_transaction.
 	 */
 	struct buffer_head	**j_wbuf;
+
+	/**
+	 * @j_wbufsize:
+	 *
+	 * Size of @j_wbuf array.
+	 */
 	int			j_wbufsize;
 
-	/*
-	 * this is the pid of hte last person to run a synchronous operation
-	 * through the journal
+	/**
+	 * @j_last_sync_writer:
+	 *
+	 * The pid of the last person to run a synchronous operation
+	 * through the journal.
 	 */
 	pid_t			j_last_sync_writer;
 
-	/*
-	 * the average amount of time in nanoseconds it takes to commit a
+	/**
+	 * @j_average_commit_time:
+	 *
+	 * The average amount of time in nanoseconds it takes to commit a
 	 * transaction to disk. [j_state_lock]
 	 */
 	u64			j_average_commit_time;
 
-	/*
-	 * minimum and maximum times that we should wait for
-	 * additional filesystem operations to get batched into a
-	 * synchronous handle in microseconds
+	/**
+	 * @j_min_batch_time:
+	 *
+	 * Minimum time that we should wait for additional filesystem operations
+	 * to get batched into a synchronous handle in microseconds.
 	 */
 	u32			j_min_batch_time;
+
+	/**
+	 * @j_max_batch_time:
+	 *
+	 * Maximum time that we should wait for additional filesystem operations
+	 * to get batched into a synchronous handle in microseconds.
+	 */
 	u32			j_max_batch_time;
 
-	/* This function is called when a transaction is closed */
+	/**
+	 * @j_commit_callback:
+	 *
+	 * This function is called when a transaction is closed.
+	 */
 	void			(*j_commit_callback)(journal_t *,
 						     transaction_t *);
 
 	/*
 	 * Journal statistics
 	 */
+
+	/**
+	 * @j_history_lock:
+	 *
+	 * Protect the transactions statistics history.
+	 */
 	spinlock_t		j_history_lock;
+
+	/**
+	 * @j_proc_entry:
+	 *
+	 * procfs entry for the jbd statistics directory.
+	 */
 	struct proc_dir_entry	*j_proc_entry;
+
+	/**
+	 * @j_stats:
+	 *
+	 * Overall statistics.
+	 */
 	struct transaction_stats_s j_stats;
 
-	/* Failed journal commit ID */
+	/**
+	 * @j_failed_commit:
+	 *
+	 * Failed journal commit ID.
+	 */
 	unsigned int		j_failed_commit;
 
-	/*
+	/**
+	 * @j_private:
+	 *
 	 * An opaque pointer to fs-private information.  ext3 puts its
-	 * superblock pointer here
+	 * superblock pointer here.
 	 */
 	void *j_private;
 
-	/* Reference to checksum algorithm driver via cryptoapi */
+	/**
+	 * @j_chksum_driver:
+	 *
+	 * Reference to checksum algorithm driver via cryptoapi.
+	 */
 	struct crypto_shash *j_chksum_driver;
 
-	/* Precomputed journal UUID checksum for seeding other checksums */
+	/**
+	 * @j_csum_seed:
+	 *
+	 * Precomputed journal UUID checksum for seeding other checksums.
+	 */
 	__u32 j_csum_seed;
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-	/*
+	/**
+	 * @j_trans_commit_map:
+	 *
 	 * Lockdep entity to track transaction commit dependencies. Handles
 	 * hold this "lock" for read, when we wait for commit, we acquire the
 	 * "lock" for writing. This matches the properties of jbd2 journalling
-- 
2.7.4
