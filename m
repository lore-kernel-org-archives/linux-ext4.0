From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 05/36 v4] libext2fs: add EXT4_INLINE_DATA_FL flag for inode
Date: Tue, 31 Jul 2012 19:47:58 +0800
Message-ID: <1343735309-30579-6-git-send-email-wenqing.lz@taobao.com>
References: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35285 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715Ab2GaLj4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jul 2012 07:39:56 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so11540445pbb.19
        for <linux-ext4@vger.kernel.org>; Tue, 31 Jul 2012 04:39:56 -0700 (PDT)
In-Reply-To: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Add EXT4_INLINE_DATA_FL flag.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/ext2_fs.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index c6de26a..6688763 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -318,6 +318,7 @@ struct ext2_dx_tail {
 #define EXT4_SNAPFILE_FL		0x01000000  /* Inode is a snapshot */
 #define EXT4_SNAPFILE_DELETED_FL	0x04000000  /* Snapshot is being deleted */
 #define EXT4_SNAPFILE_SHRUNK_FL		0x08000000  /* Snapshot shrink has completed */
+#define EXT4_INLINE_DATA_FL		0x10000000 /* Inode has inline data */
 #define EXT2_RESERVED_FL		0x80000000 /* reserved for ext2 lib */
 
 #define EXT2_FL_USER_VISIBLE		0x004BDFFF /* User visible flags */
-- 
1.7.4.1

