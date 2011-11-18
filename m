From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH] e2fsck: fix "can't find dup_blk" error
Date: Fri, 18 Nov 2011 10:52:38 +0800
Message-ID: <1321584758-4259-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45916 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab1KRCws (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Nov 2011 21:52:48 -0500
Received: by iage36 with SMTP id e36so3031377iag.19
        for <linux-ext4@vger.kernel.org>; Thu, 17 Nov 2011 18:52:48 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

After:
1. mke2fs -O ^has_journal,^resize_inode,^uninit_bg,extent,meta_bg,flex_bg,bigalloc /dev/sda
2. mount -t ext4 /dev/sda /test/
3. create file (8192K size, extent' e_len is 2) /test/1 ~ /test/10
4. use tool to change the /test/5 extent's e_len to 100, corrupt file
5. e2fsck -f /dev/sda

And it will report like:

 Clone multiply-claimed blocks<y>? yes

 clone_file_block: internal error: can't find dup_blk for 525345

 clone_file_block: internal error: can't find dup_blk for 525346

 clone_file_block: internal error: can't find dup_blk for 525347

 clone_file_block: internal error: can't find dup_blk for 525348


In bigalloc filesystem, "blockcnt > 0" should change to "blockcnt >= cluster_ratio"

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 e2fsck/pass1b.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index d5585dd..a9cdd9e 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -703,7 +703,7 @@ static int clone_file_block(ext2_filsys fs,
 	if (check_if_fs_cluster(ctx, EXT2FS_B2C(fs, *block_nr)))
 		is_meta = 1;
 
-	if (((blockcnt > 0) && c == cs->dup_cluster) ||
+	if (((blockcnt >= EXT2FS_CLUSTER_RATIO(fs)) && c == cs->dup_cluster) ||
 	    ext2fs_test_block_bitmap2(ctx->block_dup_map, *block_nr)) {
 		n = dict_lookup(&clstr_dict,
 				INT_TO_VOIDPTR(EXT2FS_B2C(fs, *block_nr)));
-- 
1.7.3.2

