From: Jan Kara <jack@suse.cz>
Subject: [PATCH] jbd: Journal block numbers can ever be only 32-bit use unsigned int for them
Date: Mon,  3 Aug 2009 23:06:56 +0200
Message-ID: <1249333616-23442-3-git-send-email-jack@suse.cz>
References: <1249333616-23442-1-git-send-email-jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:59672 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932131AbZHCVG5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Aug 2009 17:06:57 -0400
In-Reply-To: <1249333616-23442-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It does not make sence to store block number for journal as unsigned long
since they can be only 32-bit (because of on-disk format limitation). So
change in-memory structures and variables to use unsigned int instead.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd/checkpoint.c |    2 +-
 fs/jbd/commit.c     |    2 +-
 fs/jbd/journal.c    |   22 +++++++++++-----------
 fs/jbd/recovery.c   |   12 ++++++------
 fs/jbd/revoke.c     |   14 +++++++-------
 include/linux/jbd.h |   26 +++++++++++++-------------
 6 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/fs/jbd/checkpoint.c b/fs/jbd/checkpoint.c
index 61f32f3..95e898a 100644
--- a/fs/jbd/checkpoint.c
+++ b/fs/jbd/checkpoint.c
@@ -456,7 +456,7 @@ int cleanup_journal_tail(journal_t *journal)
 {
 	transaction_t * transaction;
 	tid_t		first_tid;
-	unsigned long	blocknr, freed;
+	unsigned int	blocknr, freed;
 
 	if (is_journal_aborted(journal))
 		return 1;
diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 618e21c..4bd8825 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -308,7 +308,7 @@ void journal_commit_transaction(journal_t *journal)
 	int bufs;
 	int flags;
 	int err;
-	unsigned long blocknr;
+	unsigned int blocknr;
 	ktime_t start_time;
 	u64 commit_time;
 	char *tagp = NULL;
diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index f96f850..24cdd6b 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -276,7 +276,7 @@ static void journal_kill_thread(journal_t *journal)
 int journal_write_metadata_buffer(transaction_t *transaction,
 				  struct journal_head  *jh_in,
 				  struct journal_head **jh_out,
-				  unsigned long blocknr)
+				  unsigned int blocknr)
 {
 	int need_copy_out = 0;
 	int done_copy_out = 0;
@@ -567,9 +567,9 @@ int log_wait_commit(journal_t *journal, tid_t tid)
  * Log buffer allocation routines:
  */
 
-int journal_next_log_block(journal_t *journal, unsigned long *retp)
+int journal_next_log_block(journal_t *journal, unsigned int *retp)
 {
-	unsigned long blocknr;
+	unsigned int blocknr;
 
 	spin_lock(&journal->j_state_lock);
 	J_ASSERT(journal->j_free > 1);
@@ -590,11 +590,11 @@ int journal_next_log_block(journal_t *journal, unsigned long *retp)
  * this is a no-op.  If needed, we can use j_blk_offset - everything is
  * ready.
  */
-int journal_bmap(journal_t *journal, unsigned long blocknr,
-		 unsigned long *retp)
+int journal_bmap(journal_t *journal, unsigned int blocknr,
+		 unsigned int *retp)
 {
 	int err = 0;
-	unsigned long ret;
+	unsigned int ret;
 
 	if (journal->j_inode) {
 		ret = bmap(journal->j_inode, blocknr);
@@ -630,7 +630,7 @@ int journal_bmap(journal_t *journal, unsigned long blocknr,
 struct journal_head *journal_get_descriptor_buffer(journal_t *journal)
 {
 	struct buffer_head *bh;
-	unsigned long blocknr;
+	unsigned int blocknr;
 	int err;
 
 	err = journal_next_log_block(journal, &blocknr);
@@ -774,7 +774,7 @@ journal_t * journal_init_inode (struct inode *inode)
 	journal_t *journal = journal_init_common();
 	int err;
 	int n;
-	unsigned long blocknr;
+	unsigned int blocknr;
 
 	if (!journal)
 		return NULL;
@@ -846,7 +846,7 @@ static void journal_fail_superblock (journal_t *journal)
 static int journal_reset(journal_t *journal)
 {
 	journal_superblock_t *sb = journal->j_superblock;
-	unsigned long first, last;
+	unsigned int first, last;
 
 	first = be32_to_cpu(sb->s_first);
 	last = be32_to_cpu(sb->s_maxlen);
@@ -885,7 +885,7 @@ static int journal_reset(journal_t *journal)
  **/
 int journal_create(journal_t *journal)
 {
-	unsigned long blocknr;
+	unsigned int blocknr;
 	struct buffer_head *bh;
 	journal_superblock_t *sb;
 	int i, err;
@@ -1371,7 +1371,7 @@ int journal_flush(journal_t *journal)
 {
 	int err = 0;
 	transaction_t *transaction = NULL;
-	unsigned long old_tail;
+	unsigned int old_tail;
 
 	spin_lock(&journal->j_state_lock);
 
diff --git a/fs/jbd/recovery.c b/fs/jbd/recovery.c
index db5e982..9284620 100644
--- a/fs/jbd/recovery.c
+++ b/fs/jbd/recovery.c
@@ -70,7 +70,7 @@ static int do_readahead(journal_t *journal, unsigned int start)
 {
 	int err;
 	unsigned int max, nbufs, next;
-	unsigned long blocknr;
+	unsigned int blocknr;
 	struct buffer_head *bh;
 
 	struct buffer_head * bufs[MAXBUF];
@@ -132,7 +132,7 @@ static int jread(struct buffer_head **bhp, journal_t *journal,
 		 unsigned int offset)
 {
 	int err;
-	unsigned long blocknr;
+	unsigned int blocknr;
 	struct buffer_head *bh;
 
 	*bhp = NULL;
@@ -314,7 +314,7 @@ static int do_one_pass(journal_t *journal,
 			struct recovery_info *info, enum passtype pass)
 {
 	unsigned int		first_commit_ID, next_commit_ID;
-	unsigned long		next_log_block;
+	unsigned int		next_log_block;
 	int			err, success = 0;
 	journal_superblock_t *	sb;
 	journal_header_t *	tmp;
@@ -429,7 +429,7 @@ static int do_one_pass(journal_t *journal,
 			tagp = &bh->b_data[sizeof(journal_header_t)];
 			while ((tagp - bh->b_data +sizeof(journal_block_tag_t))
 			       <= journal->j_blocksize) {
-				unsigned long io_block;
+				unsigned int io_block;
 
 				tag = (journal_block_tag_t *) tagp;
 				flags = be32_to_cpu(tag->t_flags);
@@ -446,7 +446,7 @@ static int do_one_pass(journal_t *journal,
 						"block %ld in log\n",
 						err, io_block);
 				} else {
-					unsigned long blocknr;
+					unsigned int blocknr;
 
 					J_ASSERT(obh != NULL);
 					blocknr = be32_to_cpu(tag->t_blocknr);
@@ -581,7 +581,7 @@ static int scan_revoke_records(journal_t *journal, struct buffer_head *bh,
 	max = be32_to_cpu(header->r_count);
 
 	while (offset < max) {
-		unsigned long blocknr;
+		unsigned int blocknr;
 		int err;
 
 		blocknr = be32_to_cpu(* ((__be32 *) (bh->b_data+offset)));
diff --git a/fs/jbd/revoke.c b/fs/jbd/revoke.c
index da6cd9b..65b34ea 100644
--- a/fs/jbd/revoke.c
+++ b/fs/jbd/revoke.c
@@ -101,7 +101,7 @@ struct jbd_revoke_record_s
 {
 	struct list_head  hash;
 	tid_t		  sequence;	/* Used for recovery only */
-	unsigned long	  blocknr;
+	unsigned int	  blocknr;
 };
 
 
@@ -126,7 +126,7 @@ static void flush_descriptor(journal_t *, struct journal_head *, int, int);
 /* Utility functions to maintain the revoke table */
 
 /* Borrowed from buffer.c: this is a tried and tested block hash function */
-static inline int hash(journal_t *journal, unsigned long block)
+static inline int hash(journal_t *journal, unsigned int block)
 {
 	struct jbd_revoke_table_s *table = journal->j_revoke;
 	int hash_shift = table->hash_shift;
@@ -136,7 +136,7 @@ static inline int hash(journal_t *journal, unsigned long block)
 		(block << (hash_shift - 12))) & (table->hash_size - 1);
 }
 
-static int insert_revoke_hash(journal_t *journal, unsigned long blocknr,
+static int insert_revoke_hash(journal_t *journal, unsigned int blocknr,
 			      tid_t seq)
 {
 	struct list_head *hash_list;
@@ -166,7 +166,7 @@ oom:
 /* Find a revoke record in the journal's hash table. */
 
 static struct jbd_revoke_record_s *find_revoke_record(journal_t *journal,
-						      unsigned long blocknr)
+						      unsigned int blocknr)
 {
 	struct list_head *hash_list;
 	struct jbd_revoke_record_s *record;
@@ -332,7 +332,7 @@ void journal_destroy_revoke(journal_t *journal)
  * by one.
  */
 
-int journal_revoke(handle_t *handle, unsigned long blocknr,
+int journal_revoke(handle_t *handle, unsigned int blocknr,
 		   struct buffer_head *bh_in)
 {
 	struct buffer_head *bh = NULL;
@@ -644,7 +644,7 @@ static void flush_descriptor(journal_t *journal,
  */
 
 int journal_set_revoke(journal_t *journal,
-		       unsigned long blocknr,
+		       unsigned int blocknr,
 		       tid_t sequence)
 {
 	struct jbd_revoke_record_s *record;
@@ -668,7 +668,7 @@ int journal_set_revoke(journal_t *journal,
  */
 
 int journal_test_revoke(journal_t *journal,
-			unsigned long blocknr,
+			unsigned int blocknr,
 			tid_t sequence)
 {
 	struct jbd_revoke_record_s *record;
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index c2049a0..a1187a0 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -446,7 +446,7 @@ struct transaction_s
 	/*
 	 * Where in the log does this transaction's commit start? [no locking]
 	 */
-	unsigned long		t_log_start;
+	unsigned int		t_log_start;
 
 	/* Number of buffers on the t_buffers list [j_list_lock] */
 	int			t_nr_buffers;
@@ -701,26 +701,26 @@ struct journal_s
 	 * Journal head: identifies the first unused block in the journal.
 	 * [j_state_lock]
 	 */
-	unsigned long		j_head;
+	unsigned int		j_head;
 
 	/*
 	 * Journal tail: identifies the oldest still-used block in the journal.
 	 * [j_state_lock]
 	 */
-	unsigned long		j_tail;
+	unsigned int		j_tail;
 
 	/*
 	 * Journal free: how many free blocks are there in the journal?
 	 * [j_state_lock]
 	 */
-	unsigned long		j_free;
+	unsigned int		j_free;
 
 	/*
 	 * Journal start and end: the block numbers of the first usable block
 	 * and one beyond the last usable block in the journal. [j_state_lock]
 	 */
-	unsigned long		j_first;
-	unsigned long		j_last;
+	unsigned int		j_first;
+	unsigned int		j_last;
 
 	/*
 	 * Device, blocksize and starting block offset for the location where we
@@ -728,7 +728,7 @@ struct journal_s
 	 */
 	struct block_device	*j_dev;
 	int			j_blocksize;
-	unsigned long		j_blk_offset;
+	unsigned int		j_blk_offset;
 
 	/*
 	 * Device which holds the client fs.  For internal journal this will be
@@ -859,7 +859,7 @@ extern void __journal_clean_data_list(transaction_t *transaction);
 
 /* Log buffer allocation */
 extern struct journal_head * journal_get_descriptor_buffer(journal_t *);
-int journal_next_log_block(journal_t *, unsigned long *);
+int journal_next_log_block(journal_t *, unsigned int *);
 
 /* Commit management */
 extern void journal_commit_transaction(journal_t *);
@@ -874,7 +874,7 @@ extern int
 journal_write_metadata_buffer(transaction_t	  *transaction,
 			      struct journal_head  *jh_in,
 			      struct journal_head **jh_out,
-			      unsigned long	   blocknr);
+			      unsigned int blocknr);
 
 /* Transaction locking */
 extern void		__wait_on_journal (journal_t *);
@@ -942,7 +942,7 @@ extern void	   journal_abort      (journal_t *, int);
 extern int	   journal_errno      (journal_t *);
 extern void	   journal_ack_err    (journal_t *);
 extern int	   journal_clear_err  (journal_t *);
-extern int	   journal_bmap(journal_t *, unsigned long, unsigned long *);
+extern int	   journal_bmap(journal_t *, unsigned int, unsigned int *);
 extern int	   journal_force_commit(journal_t *);
 
 /*
@@ -976,14 +976,14 @@ extern int	   journal_init_revoke_caches(void);
 
 extern void	   journal_destroy_revoke(journal_t *);
 extern int	   journal_revoke (handle_t *,
-				unsigned long, struct buffer_head *);
+				unsigned int, struct buffer_head *);
 extern int	   journal_cancel_revoke(handle_t *, struct journal_head *);
 extern void	   journal_write_revoke_records(journal_t *,
 						transaction_t *, int);
 
 /* Recovery revoke support */
-extern int	journal_set_revoke(journal_t *, unsigned long, tid_t);
-extern int	journal_test_revoke(journal_t *, unsigned long, tid_t);
+extern int	journal_set_revoke(journal_t *, unsigned int, tid_t);
+extern int	journal_test_revoke(journal_t *, unsigned int, tid_t);
 extern void	journal_clear_revoke(journal_t *);
 extern void	journal_switch_revoke_table(journal_t *journal);
 
-- 
1.6.0.2

