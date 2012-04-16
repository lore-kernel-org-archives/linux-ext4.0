From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 07/32] libext2fs: add data structures for inline data feature
Date: Mon, 16 Apr 2012 19:39:42 +0800
Message-ID: <1334576407-4007-8-git-send-email-wenqing.lz@taobao.com>
References: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taoba.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:62902 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab2DPLeE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Apr 2012 07:34:04 -0400
Received: by mail-pz0-f52.google.com with SMTP id e40so6801134dak.11
        for <linux-ext4@vger.kernel.org>; Mon, 16 Apr 2012 04:34:04 -0700 (PDT)
In-Reply-To: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
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
index ed548d1..78ef7fc 100644
--- a/lib/ext2fs/ext2_ext_attr.h
+++ b/lib/ext2fs/ext2_ext_attr.h
@@ -23,6 +23,10 @@ struct ext2_ext_attr_header {
 	__u32	h_reserved[4];	/* zero right now */
 };
 
+struct ext2_ext_attr_ibody_header {
+	__u32	h_magic;
+};
+
 struct ext2_ext_attr_entry {
 	__u8	e_name_len;	/* length of name */
 	__u8	e_name_index;	/* attribute name index */
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 0f0239b..4a275d9 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -855,4 +855,11 @@ struct mmp_struct {
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

