From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 24/32] debugfs: make dump and cat cmd support inline data
Date: Mon, 16 Apr 2012 19:39:59 +0800
Message-ID: <1334576407-4007-25-git-send-email-wenqing.lz@taobao.com>
References: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43674 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab2DPLeg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Apr 2012 07:34:36 -0400
Received: by mail-pb0-f46.google.com with SMTP id un15so6233785pbc.19
        for <linux-ext4@vger.kernel.org>; Mon, 16 Apr 2012 04:34:36 -0700 (PDT)
In-Reply-To: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

dump and cat command use the same function to read data.  We can direclty read
the data from inode.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 debugfs/dump.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/debugfs/dump.c b/debugfs/dump.c
index a15a0b7..10ebe7a 100644
--- a/debugfs/dump.c
+++ b/debugfs/dump.c
@@ -113,6 +113,36 @@ static void dump_file(const char *cmdname, ext2_ino_t ino, int fd,
 	if (debugfs_read_inode(ino, &inode, cmdname))
 		return;
 
+	if (ext2fs_has_inline_data(current_fs, ino)) {
+		struct ext2_inode_large *inode;
+		struct inline_data idata;
+		void *inline_start;
+		int inline_size;
+
+		retval = ext2fs_get_mem(EXT2_INODE_SIZE(current_fs->super),
+							&inode);
+		if (retval)
+			return;
+
+		retval = ext2fs_read_inode_full(current_fs, ino, (void *)inode,
+						EXT2_INODE_SIZE(current_fs->super));
+		if (retval)
+			goto out;
+		write(fd, inode->i_block, EXT4_MIN_INLINE_DATA_SIZE);
+
+		ext2fs_iget_extra_inode(current_fs, inode, &idata);
+		if (idata.inline_off == EXT4_MIN_INLINE_DATA_SIZE)
+			goto out;
+
+		inline_start = ext2fs_get_inline_xattr_pos(inode, &idata);
+		inline_size = idata.inline_size - EXT4_MIN_INLINE_DATA_SIZE;
+		write(fd, inline_start, inline_size);
+
+out:
+		ext2fs_free_mem(&inode);
+		return;
+	}
+
 	retval = ext2fs_file_open(current_fs, ino, 0, &e2_file);
 	if (retval) {
 		com_err(cmdname, retval, "while opening ext2 file");
-- 
1.7.4.1

