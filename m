From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH v2] ext4: add sysfs entry showing whether the fs contains errors
Date: Wed,  7 May 2014 14:04:34 +0200
Message-ID: <1399464274-16310-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932181AbaEGMEp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 May 2014 08:04:45 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s47C4iT2030195
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 7 May 2014 08:04:45 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently there is no easy way to tell that the mounted file system
contains errors other than checking for log messages, or reading the
information directly from superblock.

This patch adds new sysfs entry "errors" for each ext4 file
system so user can simply check

cat /sys/fs/ext4/sda/errors

If the file system is not marked as containing errors then the file
returns just 0. Otherwise it would print out the following information:

<error count> first <first_error_time> <first_error_func>:<first_error_line> \
last <last_error_time> <last_error_func>:<last_error_line>

For example:

2 first 1399305407 trigger_test_error:2630 last 1399463224 trigger_test_error:2601

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
v2: Change the name of the file to errors and change the output format

 fs/ext4/super.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6f9e6fa..9d49ec1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2502,6 +2502,27 @@ static ssize_t lifetime_write_kbytes_show(struct ext4_attr *a,
 			  EXT4_SB(sb)->s_sectors_written_start) >> 1)));
 }
 
+static ssize_t errors_show(struct ext4_attr *a,
+			   struct ext4_sb_info *sbi, char *buf)
+{
+	struct ext4_super_block *es = sbi->s_es;
+
+	if (es->s_error_count)
+		return snprintf(buf, PAGE_SIZE,
+				"%u first %u %.*s:%d last %u %.*s:%d\n",
+				le32_to_cpu(es->s_error_count),
+				le32_to_cpu(es->s_first_error_time),
+				(int) sizeof(es->s_first_error_func),
+				es->s_first_error_func,
+				le32_to_cpu(es->s_first_error_line),
+				le32_to_cpu(es->s_last_error_time),
+				(int) sizeof(es->s_last_error_func),
+				es->s_last_error_func,
+				le32_to_cpu(es->s_last_error_line));
+	else
+		return snprintf(buf, PAGE_SIZE, "0\n");
+}
+
 static ssize_t inode_readahead_blks_store(struct ext4_attr *a,
 					  struct ext4_sb_info *sbi,
 					  const char *buf, size_t count)
@@ -2617,6 +2638,7 @@ static struct ext4_attr ext4_attr_##_name = {			\
 EXT4_RO_ATTR(delayed_allocation_blocks);
 EXT4_RO_ATTR(session_write_kbytes);
 EXT4_RO_ATTR(lifetime_write_kbytes);
+EXT4_RO_ATTR(errors);
 EXT4_RW_ATTR(reserved_clusters);
 EXT4_ATTR_OFFSET(inode_readahead_blks, 0644, sbi_ui_show,
 		 inode_readahead_blks_store, s_inode_readahead_blks);
@@ -2641,6 +2663,7 @@ static struct attribute *ext4_attrs[] = {
 	ATTR_LIST(delayed_allocation_blocks),
 	ATTR_LIST(session_write_kbytes),
 	ATTR_LIST(lifetime_write_kbytes),
+	ATTR_LIST(errors),
 	ATTR_LIST(reserved_clusters),
 	ATTR_LIST(inode_readahead_blks),
 	ATTR_LIST(inode_goal),
-- 
1.8.3.1

