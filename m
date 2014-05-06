From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: add sysfs entry showing whether the fs contains errors
Date: Tue,  6 May 2014 15:19:17 +0200
Message-ID: <1399382357-12703-1-git-send-email-lczerner@redhat.com>
Cc: nikola.ciprich@linuxbox.cz, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbaEFNT2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 May 2014 09:19:28 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently there is no easy way to tell that the mounted file system
contains errors other than checking for log messages, or reading the
information directly from superblock.

This patch adds new sysfs entry "contains_errors" for each ext4 file
system so user can simply check

cat /sys/fs/ext4/sda/contains_errors

If the file system is not marked as containing errors then the file is
empty. Otherwise it would print the same information that could be found
in the log. For example:

error count: 1
EXT4-fs (sda): initial error at 1399305407: trigger_test_error:2630
EXT4-fs (sda): last error at 1399305407: trigger_test_error:2630

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/super.c | 100 ++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 68 insertions(+), 32 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6f9e6fa..61dc3d6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2502,6 +2502,59 @@ static ssize_t lifetime_write_kbytes_show(struct ext4_attr *a,
 			  EXT4_SB(sb)->s_sectors_written_start) >> 1)));
 }
 
+static ssize_t get_fs_errors(struct ext4_sb_info *sbi, char *buf, ssize_t size)
+{
+	struct super_block *sb = sbi->s_buddy_cache->i_sb;
+	struct ext4_super_block *es = sbi->s_es;
+	int len = 0;
+
+	if (es->s_error_count)
+		len = snprintf(buf + len, size - len,
+			       "error count: %u\n",
+			       le32_to_cpu(es->s_error_count));
+	if (es->s_first_error_time) {
+		len += snprintf(buf + len, size - len,
+				"EXT4-fs (%s): initial error at %u: %.*s:%d",
+				sb->s_id, le32_to_cpu(es->s_first_error_time),
+				(int) sizeof(es->s_first_error_func),
+				es->s_first_error_func,
+				le32_to_cpu(es->s_first_error_line));
+		if (es->s_first_error_ino)
+			len += snprintf(buf + len, size - len,
+					": inode %u",
+					le32_to_cpu(es->s_first_error_ino));
+		if (es->s_first_error_block)
+			len += snprintf(buf + len, size - len,
+					": block %llu", (unsigned long long)
+					le64_to_cpu(es->s_first_error_block));
+		len += snprintf(buf + len, size - len, "\n");
+	}
+	if (es->s_last_error_time) {
+		len += snprintf(buf + len, size - len,
+				"EXT4-fs (%s): last error at %u: %.*s:%d",
+				sb->s_id, le32_to_cpu(es->s_last_error_time),
+				(int) sizeof(es->s_last_error_func),
+				es->s_last_error_func,
+				le32_to_cpu(es->s_last_error_line));
+		if (es->s_last_error_ino)
+			len += snprintf(buf + len, size - len,
+					": inode %u",
+					le32_to_cpu(es->s_last_error_ino));
+		if (es->s_last_error_block)
+			len += snprintf(buf + len, size - len,
+					": block %llu", (unsigned long long)
+					le64_to_cpu(es->s_last_error_block));
+		len += snprintf(buf + len, size - len, "\n");
+	}
+	return len;
+}
+
+static ssize_t contains_errors_show(struct ext4_attr *a,
+				    struct ext4_sb_info *sbi, char *buf)
+{
+	return get_fs_errors(sbi, buf, PAGE_SIZE);
+}
+
 static ssize_t inode_readahead_blks_store(struct ext4_attr *a,
 					  struct ext4_sb_info *sbi,
 					  const char *buf, size_t count)
@@ -2617,6 +2670,7 @@ static struct ext4_attr ext4_attr_##_name = {			\
 EXT4_RO_ATTR(delayed_allocation_blocks);
 EXT4_RO_ATTR(session_write_kbytes);
 EXT4_RO_ATTR(lifetime_write_kbytes);
+EXT4_RO_ATTR(contains_errors);
 EXT4_RW_ATTR(reserved_clusters);
 EXT4_ATTR_OFFSET(inode_readahead_blks, 0644, sbi_ui_show,
 		 inode_readahead_blks_store, s_inode_readahead_blks);
@@ -2659,6 +2713,7 @@ static struct attribute *ext4_attrs[] = {
 	ATTR_LIST(warning_ratelimit_burst),
 	ATTR_LIST(msg_ratelimit_interval_ms),
 	ATTR_LIST(msg_ratelimit_burst),
+	ATTR_LIST(contains_errors),
 	NULL,
 };
 
@@ -2792,42 +2847,23 @@ static void print_daily_error_info(unsigned long arg)
 {
 	struct super_block *sb = (struct super_block *) arg;
 	struct ext4_sb_info *sbi;
-	struct ext4_super_block *es;
+	ssize_t size;
+	char *buf = NULL;
 
 	sbi = EXT4_SB(sb);
-	es = sbi->s_es;
 
-	if (es->s_error_count)
-		ext4_msg(sb, KERN_NOTICE, "error count: %u",
-			 le32_to_cpu(es->s_error_count));
-	if (es->s_first_error_time) {
-		printk(KERN_NOTICE "EXT4-fs (%s): initial error at %u: %.*s:%d",
-		       sb->s_id, le32_to_cpu(es->s_first_error_time),
-		       (int) sizeof(es->s_first_error_func),
-		       es->s_first_error_func,
-		       le32_to_cpu(es->s_first_error_line));
-		if (es->s_first_error_ino)
-			printk(": inode %u",
-			       le32_to_cpu(es->s_first_error_ino));
-		if (es->s_first_error_block)
-			printk(": block %llu", (unsigned long long)
-			       le64_to_cpu(es->s_first_error_block));
-		printk("\n");
-	}
-	if (es->s_last_error_time) {
-		printk(KERN_NOTICE "EXT4-fs (%s): last error at %u: %.*s:%d",
-		       sb->s_id, le32_to_cpu(es->s_last_error_time),
-		       (int) sizeof(es->s_last_error_func),
-		       es->s_last_error_func,
-		       le32_to_cpu(es->s_last_error_line));
-		if (es->s_last_error_ino)
-			printk(": inode %u",
-			       le32_to_cpu(es->s_last_error_ino));
-		if (es->s_last_error_block)
-			printk(": block %llu", (unsigned long long)
-			       le64_to_cpu(es->s_last_error_block));
-		printk("\n");
+	buf = kmalloc(255, GFP_NOFS);
+	if (!buf) {
+		ext4_msg(sb, KERN_NOTICE, "File system contains errors, "
+					  "running e2fsck is recommended");
+		return;
 	}
+
+	size = get_fs_errors(sbi, buf, 255);
+	if (size)
+		ext4_msg(sb, KERN_NOTICE, "%s", buf);
+	kfree(buf);
+
 	mod_timer(&sbi->s_err_report, jiffies + 24*60*60*HZ);  /* Once a day */
 }
 
-- 
1.8.3.1

