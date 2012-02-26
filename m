From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] ext4: fix format flag in ext4_ext_binsearch_idx()
Date: Sun, 26 Feb 2012 23:55:55 +0800
Message-ID: <1330271755-10239-1-git-send-email-wenqing.lz@taobao.com>
Cc: tytso@mit.edu, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35309 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab2BZPvC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 26 Feb 2012 10:51:02 -0500
Received: by iazz13 with SMTP id z13so2205023iaz.19
        for <linux-ext4@vger.kernel.org>; Sun, 26 Feb 2012 07:51:02 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

fix ext_debug format flag in ext4_ext_binsearch_idx().

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/extents.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 74f23c2..2722533 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -519,7 +519,7 @@ ext4_ext_binsearch_idx(struct inode *inode,
 	}
 
 	path->p_idx = l - 1;
-	ext_debug("  -> %d->%lld ", le32_to_cpu(path->p_idx->ei_block),
+	ext_debug("  -> %u->%lld ", le32_to_cpu(path->p_idx->ei_block),
 		  ext4_idx_pblock(path->p_idx));
 
 #ifdef CHECK_BINSEARCH
-- 
1.7.4.1

