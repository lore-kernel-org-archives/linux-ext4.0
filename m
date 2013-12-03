From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v2 15/28] debugfs: handle inline_data feature in bmap command
Date: Tue,  3 Dec 2013 20:11:42 +0800
Message-ID: <1386072715-9869-16-git-send-email-wenqing.lz@taobao.com>
References: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51190 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab3LCMJk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Dec 2013 07:09:40 -0500
Received: by mail-pa0-f46.google.com with SMTP id kl14so2869590pab.19
        for <linux-ext4@vger.kernel.org>; Tue, 03 Dec 2013 04:09:40 -0800 (PST)
In-Reply-To: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

No physical block mapping if an inode has inline data.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/bmap.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/lib/ext2fs/bmap.c b/lib/ext2fs/bmap.c
index 5074587..0d043bd 100644
--- a/lib/ext2fs/bmap.c
+++ b/lib/ext2fs/bmap.c
@@ -273,6 +273,13 @@ errcode_t ext2fs_bmap2(ext2_filsys fs, ext2_ino_t ino, struct ext2_inode *inode,
 		block_buf = buf;
 	}
 
+	/*
+	 * If an inode has inline data, that means that it doesn't have
+	 * any blocks and we shouldn't map any blocks for it.
+	 */
+	if (inode->i_flags & EXT4_INLINE_DATA_FL)
+		goto done;
+
 	if (inode->i_flags & EXT4_EXTENTS_FL) {
 		retval = ext2fs_extent_open2(fs, ino, inode, &handle);
 		if (retval)
-- 
1.7.9.7

