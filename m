From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v1 10/22] debugfs: handle inline_data feature in dirsearch command
Date: Fri,  2 Aug 2013 17:49:37 +0800
Message-ID: <1375436989-18948-11-git-send-email-wenqing.lz@taobao.com>
References: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:63481 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758379Ab3HBJuv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Aug 2013 05:50:51 -0400
Received: by mail-pa0-f50.google.com with SMTP id fb10so499666pad.9
        for <linux-ext4@vger.kernel.org>; Fri, 02 Aug 2013 02:50:50 -0700 (PDT)
In-Reply-To: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

We don't need to support inline data in dirsearch command.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 debugfs/htree.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/debugfs/htree.c b/debugfs/htree.c
index d94dbea..b226f1d 100644
--- a/debugfs/htree.c
+++ b/debugfs/htree.c
@@ -387,9 +387,13 @@ void do_dirsearch(int argc, char *argv[])
 	pb.search_name = argv[2];
 	pb.len = strlen(pb.search_name);
 
+	if (ext2fs_inode_has_inline_data(current_fs, inode))
+		goto out;
+
 	ext2fs_block_iterate3(current_fs, inode, BLOCK_FLAG_READ_ONLY, 0,
 			      search_dir_block, &pb);
 
+out:
 	free(pb.buf);
 }
 
-- 
1.7.9.7

