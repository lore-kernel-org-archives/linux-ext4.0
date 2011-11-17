From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 6/6] ext4: move code checking if leaf is full to the beginning of ext4_ext_split
Date: Thu, 17 Nov 2011 10:03:25 +0800
Message-ID: <1321495405-9583-6-git-send-email-xiaoqiangnk@gmail.com>
References: <1321495405-9583-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64882 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094Ab1KQEcD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Nov 2011 23:32:03 -0500
Received: by yenq3 with SMTP id q3so560251yen.19
        for <linux-ext4@vger.kernel.org>; Wed, 16 Nov 2011 20:32:01 -0800 (PST)
In-Reply-To: <1321495405-9583-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The work checking if the lead is full can be done before we do actual splitting
work.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/extents.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index d483635..6f0300e 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -817,6 +817,15 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 		EXT4_ERROR_INODE(inode, "p_ext > EXT_MAX_EXTENT!");
 		return -EIO;
 	}
+
+	if (unlikely(path[depth].p_hdr->eh_entries !=
+		     path[depth].p_hdr->eh_max)) {
+		EXT4_ERROR_INODE(inode, "eh_entries %d != eh_max %d!",
+				 path[depth].p_hdr->eh_entries,
+				 path[depth].p_hdr->eh_max);
+		return -EIO;
+	}
+
 	if (path[depth].p_ext != EXT_MAX_EXTENT(path[depth].p_hdr)) {
 		border = path[depth].p_ext[1].ee_block;
 		ext_debug("leaf will be split."
@@ -875,14 +884,6 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 	neh->eh_depth = 0;
 
 	/* move remainder of path[depth] to the new leaf */
-	if (unlikely(path[depth].p_hdr->eh_entries !=
-		     path[depth].p_hdr->eh_max)) {
-		EXT4_ERROR_INODE(inode, "eh_entries %d != eh_max %d!",
-				 path[depth].p_hdr->eh_entries,
-				 path[depth].p_hdr->eh_max);
-		err = -EIO;
-		goto cleanup;
-	}
 	/* start copy from next extent */
 	m = EXT_MAX_EXTENT(path[depth].p_hdr) - path[depth].p_ext++;
 	ext4_ext_show_move(inode, path, newblock, depth);
-- 
1.7.5.1

