From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 06/36 v4] libext2fs: add data structures for inline data feature
Date: Tue, 31 Jul 2012 19:47:59 +0800
Message-ID: <1343735309-30579-7-git-send-email-wenqing.lz@taobao.com>
References: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42093 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715Ab2GaLj6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jul 2012 07:39:58 -0400
Received: by yenl2 with SMTP id l2so5911698yen.19
        for <linux-ext4@vger.kernel.org>; Tue, 31 Jul 2012 04:39:58 -0700 (PDT)
In-Reply-To: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Add ext2_ext_attr_ibody_heaer to check extend attribute.  Add inline_data
to indicate the position of inline data in extend attribute and the size
of inline data.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
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

