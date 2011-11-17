From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 5/6] ext4: remove useless code in ext4_ext_split
Date: Thu, 17 Nov 2011 10:03:24 +0800
Message-ID: <1321495405-9583-5-git-send-email-xiaoqiangnk@gmail.com>
References: <1321495405-9583-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38853 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094Ab1KQEb7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Nov 2011 23:31:59 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so1594550iag.19
        for <linux-ext4@vger.kernel.org>; Wed, 16 Nov 2011 20:31:59 -0800 (PST)
In-Reply-To: <1321495405-9583-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

New allocated blocks have been checked after allocating,
so there is no need to recheck them.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/extents.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 720070d..d483635 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -857,11 +857,6 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 
 	/* initialize new leaf */
 	newblock = ablocks[--a];
-	if (unlikely(newblock == 0)) {
-		EXT4_ERROR_INODE(inode, "newblock == 0!");
-		err = -EIO;
-		goto cleanup;
-	}
 	bh = sb_getblk(inode->i_sb, newblock);
 	if (!bh) {
 		err = -EIO;
-- 
1.7.5.1

