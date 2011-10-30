From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 3/3] ext4: let ext4_discard_partial_buffers handle unaligned range correctly
Date: Sun, 30 Oct 2011 19:30:03 +0800
Message-ID: <1319974203-2625-3-git-send-email-xiaoqiangnk@gmail.com>
References: <1319974203-2625-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47841 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414Ab1J3Neu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Oct 2011 09:34:50 -0400
Received: by mail-iy0-f174.google.com with SMTP id y12so6105160iab.19
        for <linux-ext4@vger.kernel.org>; Sun, 30 Oct 2011 06:34:49 -0700 (PDT)
In-Reply-To: <1319974203-2625-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As comment says, we should handle unaligned range rather than aligned
one.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e113de8..f97d671 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3209,8 +3209,8 @@ int ext4_discard_partial_page_buffers_no_lock(handle_t *handle,
 		 * to be updated with the contents of the block before
 		 * we write the zeros on top of it.
 		 */
-		if (!(from & (blocksize - 1)) ||
-		    !((from + length) & (blocksize - 1))) {
+		if ((from & (blocksize - 1)) ||
+		    ((from + length) & (blocksize - 1))) {
 			create_empty_buffers(page, blocksize, 0);
 		} else {
 			/*
-- 
1.7.5.1

