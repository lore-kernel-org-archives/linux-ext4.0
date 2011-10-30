From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 2/3] ext4: return ENOMEM if find_or_create_pages fails
Date: Sun, 30 Oct 2011 19:30:02 +0800
Message-ID: <1319974203-2625-2-git-send-email-xiaoqiangnk@gmail.com>
References: <1319974203-2625-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47841 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414Ab1J3Nes (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Oct 2011 09:34:48 -0400
Received: by mail-iy0-f174.google.com with SMTP id y12so6105160iab.19
        for <linux-ext4@vger.kernel.org>; Sun, 30 Oct 2011 06:34:47 -0700 (PDT)
In-Reply-To: <1319974203-2625-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3c4a9d5..e113de8 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3132,7 +3132,7 @@ int ext4_discard_partial_page_buffers(handle_t *handle,
 	page = find_or_create_page(mapping, from >> PAGE_CACHE_SHIFT,
 				   mapping_gfp_mask(mapping) & ~__GFP_FS);
 	if (!page)
-		return -EINVAL;
+		return -ENOMEM;
 
 	err = ext4_discard_partial_page_buffers_no_lock(handle, inode, page,
 		from, length, flags);
@@ -3375,7 +3375,7 @@ int ext4_block_zero_page_range(handle_t *handle,
 	page = find_or_create_page(mapping, from >> PAGE_CACHE_SHIFT,
 				   mapping_gfp_mask(mapping) & ~__GFP_FS);
 	if (!page)
-		return -EINVAL;
+		return -ENOMEM;
 
 	blocksize = inode->i_sb->s_blocksize;
 	max = blocksize - (offset & (blocksize - 1));
-- 
1.7.5.1

