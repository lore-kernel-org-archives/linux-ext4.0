From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 04/36 v4] libext2fs: add ext2fs_find_entry_ext_attr function
Date: Tue, 31 Jul 2012 19:47:57 +0800
Message-ID: <1343735309-30579-5-git-send-email-wenqing.lz@taobao.com>
References: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35285 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715Ab2GaLjy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jul 2012 07:39:54 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so11540445pbb.19
        for <linux-ext4@vger.kernel.org>; Tue, 31 Jul 2012 04:39:54 -0700 (PDT)
In-Reply-To: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

We need to search extend attributes to get entry of inline data.
Thus, add this function to do this work.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/ext2fs.h   |    4 ++++
 lib/ext2fs/ext_attr.c |   26 ++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 65d30de..fd051b1 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1136,6 +1136,10 @@ extern errcode_t ext2fs_adjust_ea_refcount3(ext2_filsys fs, blk64_t blk,
 					   char *block_buf,
 					   int adjust, __u32 *newcount,
 					   ext2_ino_t inum);
+extern errcode_t ext2fs_find_entry_ext_attr(struct ext2_ext_attr_entry **pentry,
+					    int name_index, const char *name,
+					    size_t size, int sorted);
+ 
 
 /* extent.c */
 extern errcode_t ext2fs_extent_header_verify(void *ptr, int size);
diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index 9649a14..b2d36b6 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -171,6 +171,32 @@ errout:
 	return retval;
 }
 
+errcode_t ext2fs_find_entry_ext_attr(struct ext2_ext_attr_entry **pentry,
+				     int name_index, const char *name,
+				     size_t size, int sorted)
+{
+	struct ext2_ext_attr_entry *entry;
+	size_t name_len;
+	int cmp;
+
+	if (name == NULL)
+		return -1;
+	name_len = strlen(name);
+	entry = *pentry;
+	for (; !EXT2_EXT_IS_LAST_ENTRY(entry); entry = EXT2_EXT_ATTR_NEXT(entry)) {
+		cmp = name_index - entry->e_name_index;
+		if (!cmp)
+			cmp = name_len - entry->e_name_len;
+		if (!cmp)
+			cmp = memcmp(name, EXT2_EXT_ATTR_NAME(entry), name_len);
+		if (!cmp)
+			break;
+	}
+	*pentry = entry;
+
+	return cmp;
+}
+
 errcode_t ext2fs_adjust_ea_refcount2(ext2_filsys fs, blk64_t blk,
 				    char *block_buf, int adjust,
 				    __u32 *newcount)
-- 
1.7.4.1

