From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 2/2] libext2fs: remove useless code in ext2fs_super_and_bgd_loc2
Date: Wed, 16 Nov 2011 09:02:08 +0800
Message-ID: <1321405328-5298-2-git-send-email-xiaoqiangnk@gmail.com>
References: <1321405328-5298-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57491 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756881Ab1KPD3N (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Nov 2011 22:29:13 -0500
Received: by iage36 with SMTP id e36so7655iag.19
        for <linux-ext4@vger.kernel.org>; Tue, 15 Nov 2011 19:29:12 -0800 (PST)
In-Reply-To: <1321405328-5298-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Code below is useless because has_super is either 0 or 1.

if (has_super)
	has_super = 1;

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 lib/ext2fs/closefs.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index 973c2a2..54a24f8 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -102,8 +102,6 @@ errcode_t ext2fs_super_and_bgd_loc2(ext2_filsys fs,
 		if (((group % meta_bg_size) == 0) ||
 		    ((group % meta_bg_size) == 1) ||
 		    ((group % meta_bg_size) == (meta_bg_size-1))) {
-			if (has_super)
-				has_super = 1;
 			new_desc_blk = group_block + has_super;
 			numblocks++;
 		}
-- 
1.7.5.1

