From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/2] ext4: add debugging trigger for ext4_error()
Date: Wed, 30 May 2012 23:03:55 -0400
Message-ID: <1338433436-2782-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, ksumrall@google.com
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46615 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124Ab2EaDD6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 May 2012 23:03:58 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Make it easy to test whether or not the error handling subsystem in
ext4 is working correctly.  This allows us to simulate an ext4_error()
by echoing a string to /sys/fs/ext4/<dev>/trigger_fs_error.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: ksumrall@google.com
---
 fs/ext4/ext4.h  |  1 +
 fs/ext4/super.c | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 511011a..decc15d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1197,6 +1197,7 @@ struct ext4_sb_info {
 	struct proc_dir_entry *s_proc;
 	struct kobject s_kobj;
 	struct completion s_kobj_unregister;
+	struct super_block *s_sb;
 
 	/* Journaling */
 	struct journal_s *s_journal;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 628cfcd..9f1ae6b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2473,6 +2473,23 @@ static ssize_t sbi_ui_store(struct ext4_attr *a,
 	return count;
 }
 
+static ssize_t trigger_test_error(struct ext4_attr *a,
+				  struct ext4_sb_info *sbi,
+				  const char *buf, size_t count)
+{
+	int len = count;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (len && buf[len-1] == '\n')
+		len--;
+
+	if (len)
+		ext4_error(sbi->s_sb, "%.*s", len, buf);
+	return count;
+}
+
 #define EXT4_ATTR_OFFSET(_name,_mode,_show,_store,_elname) \
 static struct ext4_attr ext4_attr_##_name = {			\
 	.attr = {.name = __stringify(_name), .mode = _mode },	\
@@ -2503,6 +2520,7 @@ EXT4_RW_ATTR_SBI_UI(mb_order2_req, s_mb_order2_reqs);
 EXT4_RW_ATTR_SBI_UI(mb_stream_req, s_mb_stream_request);
 EXT4_RW_ATTR_SBI_UI(mb_group_prealloc, s_mb_group_prealloc);
 EXT4_RW_ATTR_SBI_UI(max_writeback_mb_bump, s_max_writeback_mb_bump);
+EXT4_ATTR(trigger_fs_error, 0200, NULL, trigger_test_error);
 
 static struct attribute *ext4_attrs[] = {
 	ATTR_LIST(delayed_allocation_blocks),
@@ -2517,6 +2535,7 @@ static struct attribute *ext4_attrs[] = {
 	ATTR_LIST(mb_stream_req),
 	ATTR_LIST(mb_group_prealloc),
 	ATTR_LIST(max_writeback_mb_bump),
+	ATTR_LIST(trigger_fs_error),
 	NULL,
 };
 
@@ -3087,6 +3106,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		goto out_free_orig;
 	}
 	sb->s_fs_info = sbi;
+	sbi->s_sb = sb;
 	sbi->s_mount_opt = 0;
 	sbi->s_resuid = EXT4_DEF_RESUID;
 	sbi->s_resgid = EXT4_DEF_RESGID;
-- 
1.7.10.2.552.gaa3bb87

