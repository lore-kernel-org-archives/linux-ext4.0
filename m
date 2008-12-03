From: <gregkh@suse.de>
Subject: patch jbd2-fix-proc-setup-for-devices-that-contain-in-their-names.patch added to 2.6.27-stable tree
Date: Wed, 03 Dec 2008 10:56:07 -0800
Message-ID: <20081203185936.9D71749052@coco.kroah.org>
References: <1226851540-8032-4-git-send-email-tytso@mit.edu>
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: tytso@mit.edu, gregkh@suse.de, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:60978 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752481AbYLCS7h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 13:59:37 -0500
In-Reply-To: <1226851540-8032-4-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: jbd2: fix /proc setup for devices that contain '/' in their names

to the 2.6.27-stable tree.  Its filename is

    jbd2-fix-proc-setup-for-devices-that-contain-in-their-names.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From tytso@mit.edu  Wed Dec  3 09:56:53 2008
From: "Theodore Ts'o" <tytso@mit.edu>
Date: Sun, 16 Nov 2008 11:05:23 -0500
Subject: jbd2: fix /proc setup for devices that contain '/' in their names
To: stable@kernel.org
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>
Message-ID: <1226851540-8032-4-git-send-email-tytso@mit.edu>

From: "Theodore Ts'o" <tytso@mit.edu>

trimed down version of commit 05496769e5da83ce22ed97345afd9c7b71d6bd24 upstream.

Some devices such as "cciss/c0d0p9" will cause jbd2 setup and teardown
failures when /proc filenames are created with embedded slashes.  This
is a slimmed down version of commit 05496769, with the stack reduction
aspects of the patch omitted to meet the -stable criteria.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/jbd2/journal.c    |   22 ++++++++++++++--------
 include/linux/jbd2.h |    3 ++-
 2 files changed, 16 insertions(+), 9 deletions(-)

--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -901,10 +901,7 @@ static struct proc_dir_entry *proc_jbd2_
 
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
@@ -915,12 +912,9 @@ static void jbd2_stats_proc_init(journal
 
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
@@ -1018,6 +1012,7 @@ journal_t * jbd2_journal_init_dev(struct
 {
 	journal_t *journal = journal_init_common();
 	struct buffer_head *bh;
+	char *p;
 	int n;
 
 	if (!journal)
@@ -1039,6 +1034,10 @@ journal_t * jbd2_journal_init_dev(struct
 	journal->j_fs_dev = fs_dev;
 	journal->j_blk_offset = start;
 	journal->j_maxlen = len;
+	bdevname(journal->j_dev, journal->j_devname);
+	p = journal->j_devname;
+	while ((p = strchr(p, '/')))
+		*p = '!';
 	jbd2_stats_proc_init(journal);
 
 	bh = __getblk(journal->j_dev, start, journal->j_blocksize);
@@ -1061,6 +1060,7 @@ journal_t * jbd2_journal_init_inode (str
 {
 	struct buffer_head *bh;
 	journal_t *journal = journal_init_common();
+	char *p;
 	int err;
 	int n;
 	unsigned long long blocknr;
@@ -1070,6 +1070,12 @@ journal_t * jbd2_journal_init_inode (str
 
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


Patches currently in stable-queue which might be from tytso@mit.edu are

queue-2.6.27/ext4-update-flex_bg-free-blocks-and-free-inodes-counters-when-resizing.patch
queue-2.6.27/ext4-fix-11321-create-proc-ext4-stats-more-carefully.patch
queue-2.6.27/jbd2-fix-proc-setup-for-devices-that-contain-in-their-names.patch
queue-2.6.27/ext4-add-missing-unlock-in-ext4_check_descriptors-on-error-path.patch
queue-2.6.27/ext4-elevate-write-count-for-migrate-ioctl.patch
queue-2.6.27/ext4-renumber-ext4_ioc_migrate.patch
queue-2.6.27/ext4-jbd2-avoid-warn-messages-when-failing-to-write-to-the-superblock.patch
queue-2.6.27/ext4-fix-initialization-of-uninit-bitmap-blocks.patch
queue-2.6.27/jbd2-abort-instead-of-waiting-for-nonexistent-transaction.patch
queue-2.6.27/jbd2-fix-buffer-head-leak-when-writing-the-commit-block.patch
queue-2.6.27/ext4-fix-xattr-deadlock.patch
queue-2.6.27/ext4-free-ext4_prealloc_space-using-kmem_cache_free.patch
queue-2.6.27/ext4-do-mballoc-init-before-doing-filesystem-recovery.patch
queue-2.6.27/ext4-fix-duplicate-entries-returned-from-getdents-system-call.patch
queue-2.6.27/jbd2-don-t-give-up-looking-for-space-so-easily-in-__jbd2_log_wait_for_space.patch
queue-2.6.27/ext4-convert-to-host-order-before-using-the-values.patch
queue-2.6.27/ext4-wait-on-all-pending-commits-in-ext4_sync_fs.patch
queue-2.6.27/ext4-calculate-journal-credits-correctly.patch
queue-2.6.27/ext4-mark-the-buffer_heads-as-dirty-and-uptodate-after-prepare_write.patch
queue-2.6.27/ext4-add-checksum-calculation-when-clearing-uninit-flag-in-ext4_new_inode.patch
queue-2.6.27/ext3-fix-ext3_dx_readdir-hash-collision-handling.patch
queue-2.6.27/ext3-fix-duplicate-entries-returned-from-getdents-system-call.patch
queue-2.6.27/ext2-fix-ext2-block-reservation-early-enospc-issue.patch
queue-2.6.27/ext3-fix-ext3-block-reservation-early-enospc-issue.patch
