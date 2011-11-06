From: Niu <niu@whamcloud.com>
Subject: [PATCH 3/3] libquota: fix quota usage compute
Date: Sun, 06 Nov 2011 21:40:53 +0800
Message-ID: <4EB68E65.5080804@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: adityakali@google.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42792 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab1KFNlk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Nov 2011 08:41:40 -0500
Received: by ggnb2 with SMTP id b2so4244464ggn.19
        for <linux-ext4@vger.kernel.org>; Sun, 06 Nov 2011 05:41:39 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In quota_compute_usage(), the space usage should be in bytes but
not quota block.

Signed-off-by: Niu Yawei <niu@whamcloud.com>
---
 lib/quota/mkquota.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/lib/quota/mkquota.c b/lib/quota/mkquota.c
index 2abb2d4..832b135 100644
--- a/lib/quota/mkquota.c
+++ b/lib/quota/mkquota.c
@@ -402,8 +402,7 @@ errcode_t quota_compute_usage(quota_ctx_t qctx)
 		if (ino == 0)
 			break;
 		if (inode.i_links_count) {
-			/* Convert i_blocks to # of 1k blocks */
-			space = (ext2fs_inode_i_blocks(fs, &inode) + 1) >> 1;
+			space = ext2fs_inode_i_blocks(fs, &inode) << 9;
 			quota_data_add(qctx, &inode, ino, space);
 			quota_data_inodes(qctx, &inode, ino, +1);
 		}
-- 1.7.1

