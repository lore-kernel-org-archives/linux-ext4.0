From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 13/36 v4] debugfs: make blocks cmd support inline data
Date: Tue, 31 Jul 2012 19:48:06 +0800
Message-ID: <1343735309-30579-14-git-send-email-wenqing.lz@taobao.com>
References: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35285 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021Ab2GaLkL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jul 2012 07:40:11 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so11540445pbb.19
        for <linux-ext4@vger.kernel.org>; Tue, 31 Jul 2012 04:40:11 -0700 (PDT)
In-Reply-To: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Block entries don't point to blocks.  So it doesn't show anything when
this inode has inline data.

Singed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 debugfs/debugfs.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 14092e0..db3d3b9 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -968,6 +968,9 @@ void do_blocks(int argc, char *argv[])
 		return;
 	}
 
+	if (ext2fs_has_inline_data(current_fs, inode))
+		return;
+
 	ext2fs_block_iterate3(current_fs, inode, BLOCK_FLAG_READ_ONLY, NULL,
 			      print_blocks_proc, NULL);
 	fputc('\n', stdout);
-- 
1.7.4.1

