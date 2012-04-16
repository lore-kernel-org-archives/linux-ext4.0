From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 12/32] debugfs: make stat cmd support inline data
Date: Mon, 16 Apr 2012 19:39:47 +0800
Message-ID: <1334576407-4007-13-git-send-email-wenqing.lz@taobao.com>
References: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43674 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab2DPLeP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Apr 2012 07:34:15 -0400
Received: by mail-pb0-f46.google.com with SMTP id un15so6233785pbc.19
        for <linux-ext4@vger.kernel.org>; Mon, 16 Apr 2012 04:34:15 -0700 (PDT)
In-Reply-To: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

It only tells the user that this inode contains inline data.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 debugfs/debugfs.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 590468d..df9b954 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -801,6 +801,10 @@ void internal_dump_inode(FILE *out, const char *prefix,
 	if (inode->i_dtime)
 	  fprintf(out, "%sdtime: 0x%08x -- %s", prefix, inode->i_dtime,
 		  time_to_string(inode->i_dtime));
+	if (inode->i_flags & EXT4_INLINE_DATA_FL) {
+		fprintf(out, "Inode has inline data\n");
+		return;
+	}
 	if (EXT2_INODE_SIZE(current_fs->super) > EXT2_GOOD_OLD_INODE_SIZE)
 		internal_dump_inode_extra(out, prefix, inode_num,
 					  (struct ext2_inode_large *) inode);
-- 
1.7.4.1

