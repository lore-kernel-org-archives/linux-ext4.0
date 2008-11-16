From: Theodore Ts'o <tytso@mit.edu>
Subject: [FOR-STABLE 03/20] jbd2: fix /proc setup for devices that contain '/' in their names
Date: Sun, 16 Nov 2008 11:05:23 -0500
Message-ID: <1226851540-8032-4-git-send-email-tytso@mit.edu>
References: <1226851540-8032-1-git-send-email-tytso@mit.edu>
 <1226851540-8032-2-git-send-email-tytso@mit.edu>
 <1226851540-8032-3-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:36963 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752421AbYKPQfV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Nov 2008 11:35:21 -0500
In-Reply-To: <1226851540-8032-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Some devices such as "cciss/c0d0p9" will cause jbd2 setup and teardown
failures when /proc filenames are created with embedded slashes.  This
is a slimmed down version of commit 05496769, with the stack reduction
aspects of the patch omitted to meet the -stable criteria.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/jbd2/journal.c    |   22 ++++++++++++++--------
 include/linux/jbd2.h |    3 ++-
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 8207a01..ebe4940 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -901,10 +901,7 @@ static struct proc_dir_entry *proc_jbd2_stats;
 
 static void jbd2_stats_proc_init(journal_t *journal)
 {
-	char name[BDEVNAME_SIZE];
-
-	bdevname(journal->j_dev, name);
-	journal->j_proc_entry = proc_mkdir(name, proc_jbd2_stats);
+	journal->j_proc_entry = proc_mkdir(journal->j_devname, proc_jbd2_stats);
 	if (journal->j_proc_entry) {
 		proc_create_data("history", S_IRUGO, journal->j_proc_entry,
 				 &jbd2_seq_history_fops, journal);
@@ -915,12 +912,9 @@ static void jbd2_stats_proc_init(journal_t *journal)
 
 static void jbd2_stats_proc_exit(journal_t *journal)
 {
-	char name[BDEVNAME_SIZE];
-
-	bdevname(journal->j_dev, name);
 	remove_proc_entry("info", journal->j_proc_entry);
 	remove_proc_entry("history", journal->j_proc_entry);
-	remove_proc_entry(name, proc_jbd2_stats);
+	remove_proc_entry(journal->j_devname, proc_jbd2_stats);
 }
 
 static void journal_init_stats(journal_t *journal)
@@ -1018,6 +1012,7 @@ journal_t * jbd2_journal_init_dev(struct block_device *bdev,
 {
 	journal_t *journal = journal_init_common();
 	struct buffer_head *bh;
+	char *p;
 	int n;
 
 	if (!journal)
@@ -1039,6 +1034,10 @@ journal_t * jbd2_journal_init_dev(struct block_device *bdev,
 	journal->j_fs_dev = fs_dev;
 	journal->j_blk_offset = start;
 	journal->j_maxlen = len;
+	bdevname(journal->j_dev, journal->j_devname);
+	p = journal->j_devname;
+	while ((p = strchr(p, '/')))
+		*p = '!';
 	jbd2_stats_proc_init(journal);
 
 	bh = __getblk(journal->j_dev, start, journal->j_blocksize);
@@ -1061,6 +1060,7 @@ journal_t * jbd2_journal_init_inode (struct inode *inode)
 {
 	struct buffer_head *bh;
 	journal_t *journal = journal_init_common();
+	char *p;
 	int err;
 	int n;
 	unsigned long long blocknr;
@@ -1070,6 +1070,12 @@ journal_t * jbd2_journal_init_inode (struct inode *inode)
 
 	journal->j_dev = journal->j_fs_dev = inode->i_sb->s_bdev;
 	journal->j_inode = inode;
+	bdevname(journal->j_dev, journal->j_devname);
+	p = journal->j_devname;
+	while ((p = strchr(p, '/')))
+		*p = '!';
+	p = journal->j_devname + strlen(journal->j_devname);
+	sprintf(p, ":%lu", journal->j_inode->i_ino);
 	jbd_debug(1,
 		  "journal %p: inode %s/%ld, size %Ld, bits %d, blksize %ld\n",
 		  journal, inode->i_sb->s_id, inode->i_ino,
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 3dd2090..66c3499 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -850,7 +850,8 @@ struct journal_s
 	 */
 	struct block_device	*j_dev;
 	int			j_blocksize;
-	unsigned long long		j_blk_offset;
+	unsigned long long	j_blk_offset;
+	char			j_devname[BDEVNAME_SIZE+24];
 
 	/*
 	 * Device which holds the client fs.  For internal journal this will be
-- 
1.6.0.4.8.g36f27.dirty

