From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 12/36 v4] debugfs: make stat cmd support inline data
Date: Tue, 31 Jul 2012 19:48:05 +0800
Message-ID: <1343735309-30579-13-git-send-email-wenqing.lz@taobao.com>
References: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35285 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004Ab2GaLkJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jul 2012 07:40:09 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so11540445pbb.19
        for <linux-ext4@vger.kernel.org>; Tue, 31 Jul 2012 04:40:09 -0700 (PDT)
In-Reply-To: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

It only tells the user that this inode contains inline data.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 debugfs/debugfs.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 76c0867..14092e0 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -836,7 +836,9 @@ void internal_dump_inode(FILE *out, const char *prefix,
 		fprintf(out, "%sDevice major/minor number: %02d:%02d (hex %02x:%02x)\n",
 			devnote, major, minor, major, minor);
 	} else if (do_dump_blocks) {
-		if (inode->i_flags & EXT4_EXTENTS_FL)
+		if (inode->i_flags & EXT4_INLINE_DATA_FL)
+			fprintf(out, "Inode has inline data\n");
+		else if (inode->i_flags & EXT4_EXTENTS_FL)
 			dump_extents(out, prefix, inode_num,
 				     DUMP_LEAF_EXTENTS|DUMP_NODE_EXTENTS, 0, 0);
 		else
-- 
1.7.4.1

