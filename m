From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 17/32] debugfs: make mkdir cmd support inline data
Date: Mon, 16 Apr 2012 19:39:52 +0800
Message-ID: <1334576407-4007-18-git-send-email-wenqing.lz@taobao.com>
References: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:62902 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab2DPLeY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Apr 2012 07:34:24 -0400
Received: by mail-pz0-f52.google.com with SMTP id e40so6801134dak.11
        for <linux-ext4@vger.kernel.org>; Mon, 16 Apr 2012 04:34:24 -0700 (PDT)
In-Reply-To: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

We need to reload inode in ext2fs_mkdir because inode with inline itself
data is modified in ext2fs_link.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/mkdir.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/mkdir.c b/lib/ext2fs/mkdir.c
index b12bf2d..d9a8278 100644
--- a/lib/ext2fs/mkdir.c
+++ b/lib/ext2fs/mkdir.c
@@ -134,6 +134,10 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 	 * Update parent inode's counts
 	 */
 	if (parent != ino) {
+		/* Reload parent inode */
+		retval = ext2fs_read_inode(fs, parent, &parent_inode);
+		if (retval)
+			goto cleanup;
 		parent_inode.i_links_count++;
 		retval = ext2fs_write_inode(fs, parent, &parent_inode);
 		if (retval)
-- 
1.7.4.1

