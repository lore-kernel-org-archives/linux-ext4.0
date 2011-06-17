From: stufever@gmail.com
Subject: [PATCH] ext4: Set file system to read-only by I/O error threshold
Date: Fri, 17 Jun 2011 20:08:36 +0800
Message-ID: <1308312516-14252-1-git-send-email-wangshaoyan.pt@taobao.com>
Cc: Wang Shaoyan <wangshaoyan.pt@taobao.com>, Ted Tso <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51971 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757823Ab1FQMFR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Jun 2011 08:05:17 -0400
Received: by iyb12 with SMTP id 12so132260iyb.19
        for <linux-ext4@vger.kernel.org>; Fri, 17 Jun 2011 05:05:16 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Wang Shaoyan <wangshaoyan.pt@taobao.com>

Some version of Hadoop uses access(2) to check whether the data chunk harddisk is online, if access(2) returns error, hadoop marks the disk which it called access(2) as offline. This method works for Ext3/4 with journal, because when jbd/jbd2 encounters I/O error, the file system will be set as read-only. For Ext4 no-journal mode, there is no jdb2 to set the file system as read-only when I/O error happens, the access(2) from Hadoop is not able to reliably detect hard disk offline condition.

This patch tries to fix the above problem from kernel side. People can set I/O error threshold, in 2 conditions Ext4 file system without journal will be set as read-only:
1) inside the sampling interval, I/O errors come more then pre-set threshold happens
2) I/O errors always happen in continous sampling intervals, the sum of errors exceeds pre-set threshold

Then the application can find the file system is set as read-only, and call its own failure tolerance procedures.

There are 2 interface exported to user space via sysfs:
/sys/fs/ext4/sd[?]/eio_threshold --- I/O error threshold to set file system as read-only
/sys/fs/ext4/sd[?]/eio_interval  --- sampling interval in second

If echo 0 into file eio_threshold, I/O error threshold will be infinite, no file system read-only will be triggered.

Cc: Ted Tso <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>
Reviewed-by: Coly Li <bosong.ly@taobao.com>
Reviewed-by: Liu Yuan <tailai.ly@taobao.com>
Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>

---
 fs/ext4/ext4.h  |    5 +++++
 fs/ext4/super.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1921392..8f445a8 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1108,6 +1108,11 @@ struct ext4_sb_info {
 	int s_first_ino;
 	unsigned int s_inode_readahead_blks;
 	unsigned int s_inode_goal;
+	spinlock_t s_eio_lock;
+	unsigned int s_eio_threshold;
+	unsigned int s_eio_interval;
+	unsigned int s_eio_counter;
+	unsigned long s_eio_last_jiffies;
 	spinlock_t s_next_gen_lock;
 	u32 s_next_generation;
 	u32 s_hash_seed[4];
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index cc5c157..f85ddcd 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -384,6 +384,23 @@ static void save_error_info(struct super_block *sb, const char *func,
 	ext4_commit_super(sb, 1);
 }
 
+static inline void check_error_number(struct super_block *sb)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+
+	if (time_after(sbi->s_eio_last_jiffies + sbi->s_eio_interval * HZ, jiffies)) {
+		sbi->s_eio_counter++;
+	} else {
+		sbi->s_eio_counter = 1;
+	}
+
+	sbi->s_eio_last_jiffies = jiffies;
+	ext4_msg(sb, KERN_CRIT, "count total: %d", sbi->s_eio_counter);
+	
+	if (sbi->s_eio_counter > sbi->s_eio_threshold) { 
+		ext4_abort(sb, "Two many io error, abort it");
+	}
+}
 
 /* Deal with the reporting of failure conditions on a filesystem such as
  * inconsistencies detected or read IO failures.
@@ -402,9 +419,17 @@ static void save_error_info(struct super_block *sb, const char *func,
 
 static void ext4_handle_error(struct super_block *sb)
 {
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+
 	if (sb->s_flags & MS_RDONLY)
 		return;
 
+	if (sbi->s_eio_threshold && !sbi->s_journal) {
+		spin_lock(&sbi->s_eio_lock);
+		check_error_number(sb);
+		spin_unlock(&sbi->s_eio_lock);
+	}
+
 	if (!test_opt(sb, ERRORS_CONT)) {
 		journal_t *journal = EXT4_SB(sb)->s_journal;
 
@@ -2471,6 +2496,22 @@ static ssize_t inode_readahead_blks_store(struct ext4_attr *a,
 	return count;
 }
 
+static ssize_t eio_interval_store(struct ext4_attr *a,
+					  struct ext4_sb_info *sbi,
+					  const char *buf, size_t count)
+{
+	unsigned long t;
+
+	if (parse_strtoul(buf, 0xffffffff, &t))
+		return -EINVAL;
+
+	if (t <= 0)
+		return -EINVAL;
+
+	sbi->s_eio_interval = t;
+	return count;
+}
+
 static ssize_t sbi_ui_show(struct ext4_attr *a,
 			   struct ext4_sb_info *sbi, char *buf)
 {
@@ -2524,6 +2565,9 @@ EXT4_RW_ATTR_SBI_UI(mb_order2_req, s_mb_order2_reqs);
 EXT4_RW_ATTR_SBI_UI(mb_stream_req, s_mb_stream_request);
 EXT4_RW_ATTR_SBI_UI(mb_group_prealloc, s_mb_group_prealloc);
 EXT4_RW_ATTR_SBI_UI(max_writeback_mb_bump, s_max_writeback_mb_bump);
+EXT4_RW_ATTR_SBI_UI(eio_threshold, s_eio_threshold);
+EXT4_ATTR_OFFSET(eio_interval, 0644, sbi_ui_show,
+		 eio_interval_store, s_eio_interval);
 
 static struct attribute *ext4_attrs[] = {
 	ATTR_LIST(delayed_allocation_blocks),
@@ -2540,6 +2584,8 @@ static struct attribute *ext4_attrs[] = {
 	ATTR_LIST(mb_stream_req),
 	ATTR_LIST(mb_group_prealloc),
 	ATTR_LIST(max_writeback_mb_bump),
+	ATTR_LIST(eio_threshold),
+	ATTR_LIST(eio_interval),
 	NULL,
 };
 
@@ -3464,6 +3510,11 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->s_stripe = ext4_get_stripe_size(sbi);
 	sbi->s_max_writeback_mb_bump = 128;
 
+	spin_lock_init(&sbi->s_eio_lock);
+	sbi->s_eio_threshold = 10;
+	sbi->s_eio_interval = 5;
+	sbi->s_eio_counter = 0;
+
 	/*
 	 * set up enough so that it can read an inode
 	 */
-- 
1.7.4.1

