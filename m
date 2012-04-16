From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 05/32] libext2fs: add ext2fs_find_entry_ext_attr function
Date: Mon, 16 Apr 2012 19:39:40 +0800
Message-ID: <1334576407-4007-6-git-send-email-wenqing.lz@taobao.com>
References: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:62902 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab2DPLeA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Apr 2012 07:34:00 -0400
Received: by mail-pz0-f52.google.com with SMTP id e40so6801134dak.11
        for <linux-ext4@vger.kernel.org>; Mon, 16 Apr 2012 04:34:00 -0700 (PDT)
In-Reply-To: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

we need to search extend attributes to get entry of inline data.
Thus, add this function to do this work.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/ext2fs.h   |    3 +++
 lib/ext2fs/ext_attr.c |   26 ++++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 89815eb..a6518be 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1075,6 +1075,9 @@ extern errcode_t ext2fs_adjust_ea_refcount(ext2_filsys fs, blk_t blk,
 extern errcode_t ext2fs_adjust_ea_refcount2(ext2_filsys fs, blk64_t blk,
 					   char *block_buf,
 					   int adjust, __u32 *newcount);
+extern errcode_t ext2fs_find_entry_ext_attr(struct ext2_ext_attr_entry **pentry,
+					    int name_index, const char *name,
+					    size_t size, int sorted);
 
 /* extent.c */
 extern errcode_t ext2fs_extent_header_verify(void *ptr, int size);
diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index 1889824..f027296 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -155,3 +155,29 @@ errcode_t ext2fs_adjust_ea_refcount(ext2_filsys fs, blk_t blk,
 {
 	return ext2fs_adjust_ea_refcount(fs, blk, block_buf, adjust, newcount);
 }
+
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
-- 
1.7.4.1

