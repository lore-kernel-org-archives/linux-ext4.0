From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH] ext3: Remove misplaced BUFFER_TRACE() in ext3_truncate()
Date: Fri, 15 Oct 2010 20:03:02 +0900
Message-ID: <1287140582-5925-1-git-send-email-namhyung@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62707 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab0JOLDN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Oct 2010 07:03:13 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/ext3/inode.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 5e0faf4..90a9c3d 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2530,7 +2530,6 @@ void ext3_truncate(struct inode *inode)
 			 */
 		} else {
 			/* Shared branch grows from an indirect block */
-			BUFFER_TRACE(partial->bh, "get_write_access");
 			ext3_free_branches(handle, inode, partial->bh,
 					partial->p,
 					partial->p+1, (chain+n-1) - partial);
-- 
1.7.0.4

