From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 1/3] ext4: move variables to its scope
Date: Sun, 30 Oct 2011 19:30:01 +0800
Message-ID: <1319974203-2625-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47841 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414Ab1J3Neq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Oct 2011 09:34:46 -0400
Received: by iaby12 with SMTP id y12so6105160iab.19
        for <linux-ext4@vger.kernel.org>; Sun, 30 Oct 2011 06:34:45 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/inode.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e4b26fa..3c4a9d5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3182,7 +3182,6 @@ int ext4_discard_partial_page_buffers_no_lock(handle_t *handle,
 	ext4_fsblk_t index = from >> PAGE_CACHE_SHIFT;
 	unsigned int offset = from & (PAGE_CACHE_SIZE-1);
 	unsigned int blocksize, max, pos;
-	unsigned int end_of_block, range_to_discard;
 	ext4_lblk_t iblock;
 	struct buffer_head *bh;
 	int err = 0;
@@ -3234,6 +3233,8 @@ int ext4_discard_partial_page_buffers_no_lock(handle_t *handle,
 
 	pos = offset;
 	while (pos < offset + length) {
+		unsigned int end_of_block, range_to_discard;
+
 		err = 0;
 
 		/* The length of space left to zero and unmap */
-- 
1.7.5.1

