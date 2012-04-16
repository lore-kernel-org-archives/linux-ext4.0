From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 13/32] debufs: make blocks cmd support inline data
Date: Mon, 16 Apr 2012 19:39:48 +0800
Message-ID: <1334576407-4007-14-git-send-email-wenqing.lz@taobao.com>
References: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:62902 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab2DPLeR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Apr 2012 07:34:17 -0400
Received: by mail-pz0-f52.google.com with SMTP id e40so6801134dak.11
        for <linux-ext4@vger.kernel.org>; Mon, 16 Apr 2012 04:34:17 -0700 (PDT)
In-Reply-To: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Block entries don't point to blocks.  So it doesn't show anything when this
inode has inline data.

Singed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 debugfs/debugfs.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index df9b954..17e5ec8 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -958,6 +958,9 @@ void do_blocks(int argc, char *argv[])
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

