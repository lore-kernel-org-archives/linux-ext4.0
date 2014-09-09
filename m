From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/2] ext4: add sysfs entry showing whether the fs contains errors
Date: Tue,  9 Sep 2014 13:32:19 +0200
Message-ID: <1410262340-13713-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753423AbaIILcZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Sep 2014 07:32:25 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s89BWPJX029614
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Tue, 9 Sep 2014 07:32:25 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently there is no easy way to tell that the mounted file system
contains errors other than checking for log messages, or reading the
information directly from superblock.

This patch adds new sysfs entries:

errors_count		(number of fs errors we encounter)
first_error_time	(unix timestamp for the first error we see)
last_error_time		(unix timestamp for the last error we see)

If the file system is not marked as containing errors then any of the
file will return 0. Otherwise it will contain valid information. More
details about the errors should as always be found in the logs.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/super.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0b28b36..8e55ae1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2548,6 +2548,16 @@ static ssize_t sbi_ui_store(struct ext4_attr *a,
 	return count;
 }
 
+static ssize_t es_ui_show(struct ext4_attr *a,
+			   struct ext4_sb_info *sbi, char *buf)
+{
+
+	unsigned int *ui = (unsigned int *) (((char *) sbi->s_es) +
+			   a->u.offset);
+
+	return snprintf(buf, PAGE_SIZE, "%u\n", *ui);
+}
+
 static ssize_t reserved_clusters_show(struct ext4_attr *a,
 				  struct ext4_sb_info *sbi, char *buf)
 {
@@ -2601,14 +2611,29 @@ static struct ext4_attr ext4_attr_##_name = {			\
 		.offset = offsetof(struct ext4_sb_info, _elname),\
 	},							\
 }
+
+#define EXT4_ATTR_OFFSET_ES(_name,_mode,_show,_store,_elname)		\
+static struct ext4_attr ext4_attr_##_name = {				\
+	.attr = {.name = __stringify(_name), .mode = _mode },		\
+	.show	= _show,						\
+	.store	= _store,						\
+	.u = {								\
+		.offset = offsetof(struct ext4_super_block, _elname),	\
+	},								\
+}
+
 #define EXT4_ATTR(name, mode, show, store) \
 static struct ext4_attr ext4_attr_##name = __ATTR(name, mode, show, store)
 
 #define EXT4_INFO_ATTR(name) EXT4_ATTR(name, 0444, NULL, NULL)
 #define EXT4_RO_ATTR(name) EXT4_ATTR(name, 0444, name##_show, NULL)
 #define EXT4_RW_ATTR(name) EXT4_ATTR(name, 0644, name##_show, name##_store)
+
+#define EXT4_RO_ATTR_ES_UI(name, elname)	\
+	EXT4_ATTR_OFFSET_ES(name, 0444, es_ui_show, NULL, elname)
 #define EXT4_RW_ATTR_SBI_UI(name, elname)	\
 	EXT4_ATTR_OFFSET(name, 0644, sbi_ui_show, sbi_ui_store, elname)
+
 #define ATTR_LIST(name) &ext4_attr_##name.attr
 #define EXT4_DEPRECATED_ATTR(_name, _val)	\
 static struct ext4_attr ext4_attr_##_name = {			\
@@ -2641,6 +2666,9 @@ EXT4_RW_ATTR_SBI_UI(warning_ratelimit_interval_ms, s_warning_ratelimit_state.int
 EXT4_RW_ATTR_SBI_UI(warning_ratelimit_burst, s_warning_ratelimit_state.burst);
 EXT4_RW_ATTR_SBI_UI(msg_ratelimit_interval_ms, s_msg_ratelimit_state.interval);
 EXT4_RW_ATTR_SBI_UI(msg_ratelimit_burst, s_msg_ratelimit_state.burst);
+EXT4_RO_ATTR_ES_UI(errors_count, s_error_count);
+EXT4_RO_ATTR_ES_UI(first_error_time, s_first_error_time);
+EXT4_RO_ATTR_ES_UI(last_error_time, s_last_error_time);
 
 static struct attribute *ext4_attrs[] = {
 	ATTR_LIST(delayed_allocation_blocks),
@@ -2664,6 +2692,9 @@ static struct attribute *ext4_attrs[] = {
 	ATTR_LIST(warning_ratelimit_burst),
 	ATTR_LIST(msg_ratelimit_interval_ms),
 	ATTR_LIST(msg_ratelimit_burst),
+	ATTR_LIST(errors_count),
+	ATTR_LIST(first_error_time),
+	ATTR_LIST(last_error_time),
 	NULL,
 };
 
-- 
1.8.3.1

