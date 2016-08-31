From: Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH] jbd2: add jbd2_journal_init() helper
Date: Wed, 31 Aug 2016 20:23:03 +0800
Message-ID: <4f138dd04ef1dd370642c24f4a801370cc12ca54.1472644753.git.geliangtang@gmail.com>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

There are some repetitive code in jbd2_journal_init_dev() and
jbd2_journal_init_inode(). So this patch extracts the common code into
jbd2_journal_init() helper to simplify the code. And fix the coding
style warnings reported by checkpatch.pl by the way.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 fs/jbd2/journal.c | 130 +++++++++++++++++++++++++++---------------------------
 1 file changed, 66 insertions(+), 64 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 46261a6..c10f657 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1143,30 +1143,13 @@ static journal_t * journal_init_common (void)
  *
  */
 
-/**
- *  journal_t * jbd2_journal_init_dev() - creates and initialises a journal structure
- *  @bdev: Block device on which to create the journal
- *  @fs_dev: Device which hold journalled filesystem for this journal.
- *  @start: Block nr Start of journal.
- *  @len:  Length of the journal in blocks.
- *  @blocksize: blocksize of journalling device
- *
- *  Returns: a newly created journal_t *
- *
- *  jbd2_journal_init_dev creates a journal which maps a fixed contiguous
- *  range of blocks on an arbitrary block device.
- *
- */
-journal_t * jbd2_journal_init_dev(struct block_device *bdev,
-			struct block_device *fs_dev,
-			unsigned long long start, int len, int blocksize)
+static int jbd2_journal_init(journal_t *journal, struct block_device *bdev,
+			struct block_device *fs_dev, unsigned long long start,
+			int len, int blocksize, gfp_t gfp)
 {
-	journal_t *journal = journal_init_common();
 	struct buffer_head *bh;
 	int n;
-
-	if (!journal)
-		return NULL;
+	int err = 0;
 
 	/* journal descriptor can store up to n blocks -bzzz */
 	journal->j_blocksize = blocksize;
@@ -1183,94 +1166,113 @@ journal_t * jbd2_journal_init_dev(struct block_device *bdev,
 	if (!journal->j_wbuf) {
 		printk(KERN_ERR "%s: Can't allocate bhs for commit thread\n",
 			__func__);
+		err = -ENOMEM;
 		goto out_err;
 	}
 
-	bh = __getblk(journal->j_dev, start, journal->j_blocksize);
+	bh = __getblk_gfp(journal->j_dev, start, journal->j_blocksize, gfp);
 	if (!bh) {
 		printk(KERN_ERR
 		       "%s: Cannot get buffer for journal superblock\n",
 		       __func__);
+		err = -EIO;
 		goto out_err;
 	}
 	journal->j_sb_buffer = bh;
 	journal->j_superblock = (journal_superblock_t *)bh->b_data;
 
-	return journal;
+	return 0;
 out_err:
 	kfree(journal->j_wbuf);
 	jbd2_stats_proc_exit(journal);
+	return err;
+}
+
+/**
+ * journal_t *jbd2_journal_init_dev() - creates and initialises a journal
+ * structure.
+ * @bdev: Block device on which to create the journal
+ * @fs_dev: Device which hold journalled filesystem for this journal.
+ * @start: Block nr Start of journal.
+ * @len:  Length of the journal in blocks.
+ * @blocksize: blocksize of journalling device
+ *
+ * Returns: a newly created journal_t *
+ *
+ * jbd2_journal_init_dev creates a journal which maps a fixed contiguous
+ * range of blocks on an arbitrary block device.
+ */
+journal_t *jbd2_journal_init_dev(struct block_device *bdev,
+			struct block_device *fs_dev,
+			unsigned long long start, int len, int blocksize)
+{
+	journal_t *journal = journal_init_common();
+	int err;
+
+	if (!journal)
+		return NULL;
+
+	err = jbd2_journal_init(journal, bdev, fs_dev, start, len,
+				blocksize, __GFP_MOVABLE);
+	if (err) {
+		pr_err("%s: journal init error\n",
+		       __func__);
+		goto out_err;
+	}
+
+	return journal;
+
+out_err:
 	kfree(journal);
 	return NULL;
 }
 
 /**
- *  journal_t * jbd2_journal_init_inode () - creates a journal which maps to a inode.
- *  @inode: An inode to create the journal in
+ * journal_t *jbd2_journal_init_inode() - creates a journal which maps to a
+ * inode.
+ * @inode: An inode to create the journal in
+ *
+ * Returns: a newly created journal_t *
  *
  * jbd2_journal_init_inode creates a journal which maps an on-disk inode as
- * the journal.  The inode must exist already, must support bmap() and
- * must have all data blocks preallocated.
+ * the journal.  The inode must exist already, must support bmap() and must
+ * have all data blocks preallocated.
  */
-journal_t * jbd2_journal_init_inode (struct inode *inode)
+journal_t *jbd2_journal_init_inode(struct inode *inode)
 {
-	struct buffer_head *bh;
 	journal_t *journal = journal_init_common();
-	char *p;
-	int err;
-	int n;
 	unsigned long long blocknr;
+	int err;
 
 	if (!journal)
 		return NULL;
 
-	journal->j_dev = journal->j_fs_dev = inode->i_sb->s_bdev;
 	journal->j_inode = inode;
-	bdevname(journal->j_dev, journal->j_devname);
-	p = strreplace(journal->j_devname, '/', '!');
-	sprintf(p, "-%lu", journal->j_inode->i_ino);
-	jbd_debug(1,
-		  "journal %p: inode %s/%ld, size %Ld, bits %d, blksize %ld\n",
-		  journal, inode->i_sb->s_id, inode->i_ino,
-		  (long long) inode->i_size,
-		  inode->i_sb->s_blocksize_bits, inode->i_sb->s_blocksize);
-
-	journal->j_maxlen = inode->i_size >> inode->i_sb->s_blocksize_bits;
-	journal->j_blocksize = inode->i_sb->s_blocksize;
-	jbd2_stats_proc_init(journal);
-
-	/* journal descriptor can store up to n blocks -bzzz */
-	n = journal->j_blocksize / sizeof(journal_block_tag_t);
-	journal->j_wbufsize = n;
-	journal->j_wbuf = kmalloc(n * sizeof(struct buffer_head*), GFP_KERNEL);
-	if (!journal->j_wbuf) {
-		printk(KERN_ERR "%s: Can't allocate bhs for commit thread\n",
-			__func__);
-		goto out_err;
-	}
 
 	err = jbd2_journal_bmap(journal, 0, &blocknr);
 	/* If that failed, give up */
 	if (err) {
-		printk(KERN_ERR "%s: Cannot locate journal superblock\n",
+		pr_err("%s: Cannot locate journal superblock\n",
 		       __func__);
 		goto out_err;
 	}
 
-	bh = getblk_unmovable(journal->j_dev, blocknr, journal->j_blocksize);
-	if (!bh) {
-		printk(KERN_ERR
-		       "%s: Cannot get buffer for journal superblock\n",
+	err = jbd2_journal_init(journal, inode->i_sb->s_bdev,
+				inode->i_sb->s_bdev, blocknr,
+				inode->i_size >> inode->i_sb->s_blocksize_bits,
+				inode->i_sb->s_blocksize, 0);
+	if (err) {
+		pr_err("%s: journal init error\n",
 		       __func__);
 		goto out_err;
 	}
-	journal->j_sb_buffer = bh;
-	journal->j_superblock = (journal_superblock_t *)bh->b_data;
+
+	sprintf(journal->j_devname, "%s-%lu",
+		journal->j_devname, journal->j_inode->i_ino);
 
 	return journal;
+
 out_err:
-	kfree(journal->j_wbuf);
-	jbd2_stats_proc_exit(journal);
 	kfree(journal);
 	return NULL;
 }
-- 
2.7.4
