From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 26/32] debugfs: make dirsearch cmd support inline data
Date: Mon, 16 Apr 2012 19:40:01 +0800
Message-ID: <1334576407-4007-27-git-send-email-wenqing.lz@taobao.com>
References: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:62902 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab2DPLek (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Apr 2012 07:34:40 -0400
Received: by mail-pz0-f52.google.com with SMTP id e40so6801134dak.11
        for <linux-ext4@vger.kernel.org>; Mon, 16 Apr 2012 04:34:40 -0700 (PDT)
In-Reply-To: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 debugfs/htree.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/debugfs/htree.c b/debugfs/htree.c
index 05745eb..0e77c31 100644
--- a/debugfs/htree.c
+++ b/debugfs/htree.c
@@ -354,9 +354,15 @@ void do_dirsearch(int argc, char *argv[])
 	pb.search_name = argv[2];
 	pb.len = strlen(pb.search_name);
 
+	if (ext2fs_has_inline_data(current_fs, inode))
+		if (ext2fs_inline_data_search_dir(current_fs, inode, argv[2],
+						  strlen(argv[2])) == 0)
+			goto out;
+
 	ext2fs_block_iterate3(current_fs, inode, BLOCK_FLAG_READ_ONLY, 0,
 			      search_dir_block, &pb);
 
+out:
 	free(pb.buf);
 }
 
-- 
1.7.4.1

