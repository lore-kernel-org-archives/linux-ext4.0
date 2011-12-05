From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] ext4: fix a ext4_msg format in ext4_fill_super()
Date: Mon,  5 Dec 2011 15:58:23 +0800
Message-ID: <1323071903-4734-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57140 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab1LEHz7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Dec 2011 02:55:59 -0500
Received: by iakc1 with SMTP id c1so1720420iak.19
        for <linux-ext4@vger.kernel.org>; Sun, 04 Dec 2011 23:55:59 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix a ext4_msg format in ext4_fill_super().

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3858767..5d4e2e2a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3509,7 +3509,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	 * of the filesystem.
 	 */
 	if (le32_to_cpu(es->s_first_data_block) >= ext4_blocks_count(es)) {
-                ext4_msg(sb, KERN_WARNING, "bad geometry: first data"
+                ext4_msg(sb, KERN_WARNING, "bad geometry: first data "
 			 "block %u is beyond end of filesystem (%llu)",
 			 le32_to_cpu(es->s_first_data_block),
 			 ext4_blocks_count(es));
-- 
1.7.4.1

