From: Hung-Ching Chang <hcchang@vt.edu>
Subject: [PATCH 1/1] ext4/jbd2: Force copy-outs during metadata commiting
Date: Tue, 21 Apr 2015 12:03:49 -0400
Message-ID: <1429632229-9723-1-git-send-email-hcchang@vt.edu>
Cc: linux-ext4@vger.kernel.org, Hung-Ching Chang <hcchang@vt.edu>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from outbound.smtp.vt.edu ([198.82.183.121]:34629 "EHLO
	omr2.cc.vt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753428AbbDUWTy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Apr 2015 18:19:54 -0400
Received: from mr5.cc.vt.edu (mr5.cc.ipv6.vt.edu [IPv6:2001:468:c80:2105:0:2b8:b328:9234])
	by omr2.cc.vt.edu (8.14.4/8.14.4) with ESMTP id t3LMBKc5022608
	for <linux-ext4@vger.kernel.org>; Tue, 21 Apr 2015 18:11:20 -0400
Received: from mail-qc0-f176.google.com (mail-qc0-f176.google.com [209.85.216.176])
	by mr5.cc.vt.edu (8.14.4/8.14.4) with ESMTP id t3LMBEaf023963
	for <linux-ext4@vger.kernel.org>; Tue, 21 Apr 2015 18:11:20 -0400
Received: by qcpm10 with SMTP id m10so83907904qcp.3
        for <linux-ext4@vger.kernel.org>; Tue, 21 Apr 2015 15:11:14 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The do_get_write_access()(fs/jbd2/transaction.c) may have to wait on the buffer that is being flushed out by the committing transaction and has not yet made the copy-out by the current transaction. When such condition is true, do_get_write_access() has to wait until BH_Shadow is cleared, which could take a very long time because of waiting on IO. In our research*, we observed that this situation become worse on parallel-transactional workloads (Filbebench** OLTP and IOzone*** write tests) to the ext4 filesystem. This patch forces copy-out to enable, and can be configured on the fly via /sys/fs/ext4/<device>/force_copyout. Our experimental results*, with force copy-out, showed ~25% speedup on Filebench OLTP and ~3X speedup on IOzone.

*Hung-Ching Chang, Bo Li, Godmar Back, Ali R. Butt, Kirk W. Cameron, "LUC: Limiting the Unintended Consequences of Power Scaling on Parallel Transaction-oriented Workloads," accepted by in proceedings of 29th IEEE International Parallel & Distributed Processing Symposium (IPDPS), Hyderabad, INDIA, 2015.

**http://filebench.sourceforge.net/
***http://www.iozone.org

Signed-off-by: Hung-Ching Chang <hcchang@vt.edu>
---
 Documentation/filesystems/ext4.txt |   11 +++++++++++
 fs/ext4/ext4.h                     |    6 ++++++
 fs/ext4/super.c                    |   26 ++++++++++++++++++++++++++
 fs/jbd2/journal.c                  |    2 ++
 include/linux/jbd2.h               |    7 +++++++
 5 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index 6c0108e..8282959 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -510,6 +510,17 @@ Files in /sys/fs/ext4/<devname>
                               in the file system. If there is not enough space
                               for the reserved space when mounting the file
                               mount will _not_ fail.
+
+ force_copyout=<0|1(*)>       This enables/disables the force copyout in the
+                              jbd code. force_copyout=0 disables,
+                              force_copyout=1 enables. When enabled, the
+                              committing transaction makes copy-outs for the
+                              metadata for IO submission. This removes
+                              potential locks when the current transaction
+                              attempts to modify the metadata, which are also
+                              owned by the committing transaction and are
+                              being flushed out to non-volatile storage, but
+                              copy-outs have not yet made for these metadata.
 ..............................................................................
 
 Ioctls
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f63c3d5..585836f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1247,6 +1247,7 @@ struct ext4_sb_info {
 	unsigned long s_commit_interval;
 	u32 s_max_batch_time;
 	u32 s_min_batch_time;
+	u32 s_force_copyout;
 	struct block_device *journal_bdev;
 #ifdef CONFIG_QUOTA
 	char *s_qf_names[EXT4_MAXQUOTAS];	/* Names of quota files with journalled quota */
@@ -1620,6 +1621,11 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 #define EXT4_DEF_MAX_BATCH_TIME	15000 /* 15ms */
 
 /*
+ * Default force copyout is set to enable
+ */
+#define EXT4_DEF_FORCE_COPYOUT 1
+
+/*
  * Minimum number of groups in a flexgroup before we separate out
  * directories into the first block group of a flexgroup
  */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e061e66..e09f7d2 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2508,6 +2508,27 @@ static ssize_t inode_readahead_blks_store(struct ext4_attr *a,
 	return count;
 }
 
+static ssize_t force_copyout_store(struct ext4_attr *a,
+				   struct ext4_sb_info *sbi,
+				   const char *buf, size_t count)
+{
+	journal_t *journal = sbi->s_journal;
+	unsigned long t;
+	int ret;
+
+	ret = kstrtoul(skip_spaces(buf), 0, &t);
+	if (ret)
+		return ret;
+
+	if (t >= 2)
+		return -EINVAL;
+
+	sbi->s_force_copyout = t;
+	if (journal)
+		journal->j_force_copyout = sbi->s_force_copyout;
+	return count;
+}
+
 static ssize_t sbi_ui_show(struct ext4_attr *a,
 			   struct ext4_sb_info *sbi, char *buf)
 {
@@ -2652,6 +2673,8 @@ EXT4_RW_ATTR_SBI_UI(msg_ratelimit_burst, s_msg_ratelimit_state.burst);
 EXT4_RO_ATTR_ES_UI(errors_count, s_error_count);
 EXT4_RO_ATTR_ES_UI(first_error_time, s_first_error_time);
 EXT4_RO_ATTR_ES_UI(last_error_time, s_last_error_time);
+EXT4_ATTR_OFFSET(force_copyout, 0644, sbi_ui_show,
+		 force_copyout_store, s_force_copyout);
 
 static struct attribute *ext4_attrs[] = {
 	ATTR_LIST(delayed_allocation_blocks),
@@ -2678,6 +2701,7 @@ static struct attribute *ext4_attrs[] = {
 	ATTR_LIST(errors_count),
 	ATTR_LIST(first_error_time),
 	ATTR_LIST(last_error_time),
+	ATTR_LIST(force_copyout),
 	NULL,
 };
 
@@ -3444,6 +3468,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_fs_info = sbi;
 	sbi->s_sb = sb;
 	sbi->s_inode_readahead_blks = EXT4_DEF_INODE_READAHEAD_BLKS;
+	sbi->s_force_copyout = EXT4_DEF_FORCE_COPYOUT;
 	sbi->s_sb_block = sb_block;
 	if (sb->s_bdev->bd_part)
 		sbi->s_sectors_written_start =
@@ -4321,6 +4346,7 @@ static void ext4_init_journal_params(struct super_block *sb, journal_t *journal)
 	journal->j_commit_interval = sbi->s_commit_interval;
 	journal->j_min_batch_time = sbi->s_min_batch_time;
 	journal->j_max_batch_time = sbi->s_max_batch_time;
+	journal->j_force_copyout = sbi->s_force_copyout;
 
 	write_lock(&journal->j_state_lock);
 	if (test_opt(sb, BARRIER))
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index b96bd80..2637234 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -396,6 +396,8 @@ repeat:
 		new_page = virt_to_page(jh_in->b_frozen_data);
 		new_offset = offset_in_page(jh_in->b_frozen_data);
 	} else {
+		if (journal->j_force_copyout == 1)
+			need_copy_out = 1;  /* pessimistically copy data out */
 		new_page = jh2bh(jh_in)->b_page;
 		new_offset = offset_in_page(jh2bh(jh_in)->b_data);
 	}
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 20e7f78..eb72346 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -968,6 +968,13 @@ struct journal_s
 	u32			j_min_batch_time;
 	u32			j_max_batch_time;
 
+	/*
+	 * when force_copyout is set to enable(1), the committing
+	 * transaction makes copy-outs for the metadata and uses the copied
+	 * buffers for IO submission.
+	 */
+	u32                     j_force_copyout;
+
 	/* This function is called when a transaction is closed */
 	void			(*j_commit_callback)(journal_t *,
 						     transaction_t *);
-- 
1.7.1

