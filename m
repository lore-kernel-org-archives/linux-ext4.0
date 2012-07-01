From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 06/35 v3] libext2fs: add data structures for inline data feature
Date: Sun,  1 Jul 2012 21:48:29 +0800
Message-ID: <1341150538-32047-7-git-send-email-wenqing.lz@taobao.com>
References: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taoba.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36672 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932398Ab2GANlB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jul 2012 09:41:01 -0400
Received: by mail-pz0-f46.google.com with SMTP id y13so6319540dad.19
        for <linux-ext4@vger.kernel.org>; Sun, 01 Jul 2012 06:41:00 -0700 (PDT)
In-Reply-To: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Add ext2_ext_attr_ibody_heaer to check extend attribute.
Add inline_data to indicate the position of inline data in
extend attribute and the size of inline data.

Signed-off-by: Zheng Liu <wenqing.lz@taoba.com>
---
 lib/ext2fs/ext2_ext_attr.h |    4 ++++
 lib/ext2fs/ext2_fs.h       |    7 +++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/ext2_ext_attr.h b/lib/ext2fs/ext2_ext_attr.h
index bbb0aaa..5c7c715 100644
--- a/lib/ext2fs/ext2_ext_attr.h
+++ b/lib/ext2fs/ext2_ext_attr.h
@@ -25,6 +25,10 @@ struct ext2_ext_attr_header {
 	__u32	h_reserved[3];	/* zero right now */
 };
 
+struct ext2_ext_attr_ibody_header {
+	__u32	h_magic;
+};
+
 struct ext2_ext_attr_entry {
 	__u8	e_name_len;	/* length of name */
 	__u8	e_name_index;	/* attribute name index */
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index aa3e808..7e05183 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -904,4 +904,11 @@ struct mmp_struct {
  */
 #define EXT4_MMP_MIN_CHECK_INTERVAL     5
 
+struct inline_data {
+	__u16	inline_off;
+	__u16	inline_size;
+};
+
+#define EXT4_MIN_INLINE_DATA_SIZE	((sizeof(__u32) * EXT2_N_BLOCKS))
+
 #endif	/* _LINUX_EXT2_FS_H */
-- 
1.7.4.1

