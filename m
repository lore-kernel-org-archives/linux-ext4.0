From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 3/5] fix ext2fs_extent_insert when at last extent in node
Date: Mon,  7 Apr 2008 22:00:58 -0500
Message-ID: <1207623660-1088-4-git-send-email-sandeen@redhat.com>
References: <1207623660-1088-1-git-send-email-sandeen@redhat.com>
Cc: tytso@mit.edu, Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758285AbYDKSQ2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Apr 2008 14:16:28 -0400
In-Reply-To: <1207623660-1088-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext2fs_extent_insert() only did a memmove if path->left
was > 0, but if we are at the last extent in the node,
path->left == 0, and this node must be moved before the
current extent is replaced with the newly inserted node.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 lib/ext2fs/extent.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index 76f6f65..9f19e7b 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -689,7 +689,7 @@ errcode_t ext2fs_extent_insert(ext2_extent_handle_t handle, int flags,
 
 	path->curr = ix;
 
-	if (path->left > 0)
+	if (path->left >= 0)
 		memmove(ix + 1, ix,
 			(path->left+1) * sizeof(struct ext3_extent_idx));
 	path->left++;
-- 
1.5.4.1

