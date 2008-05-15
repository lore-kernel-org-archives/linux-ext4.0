From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/3] libext2fs: allow ext2fs_extent_insert to split if needed
Date: Thu, 15 May 2008 13:17:43 -0500
Message-ID: <1210875464-25552-3-git-send-email-sandeen@redhat.com>
References: <1210875464-25552-1-git-send-email-sandeen@redhat.com>
To: sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbYEOSTJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 May 2008 14:19:09 -0400
In-Reply-To: <1210875464-25552-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If ext2fs_extent_insert finds that the requested node
for insertion is full, it will currently fail.

With this patch it will split as necessary to make room.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 lib/ext2fs/extent.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index 41b5307..8a6eaa2 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -894,8 +894,13 @@ errcode_t ext2fs_extent_insert(ext2_extent_handle_t handle, int flags,
 
 	path = handle->path + handle->level;
 
-	if (path->entries >= path->max_entries)
-		return EXT2_ET_CANT_INSERT_EXTENT;
+	if (path->entries >= path->max_entries) {
+		dbg_printf("node full - splitting\n");
+		retval = ext2fs_node_split(handle, 0);
+		if (retval)
+			goto errout;
+		path = handle->path + handle->level;
+	}
 
 	eh = (struct ext3_extent_header *) path->buf;
 	if (path->curr) {
@@ -1245,7 +1250,7 @@ void do_insert_node(int argc, char *argv[])
 	}
 
 	if (argc != 4) {
-		fprintf(stderr, "usage: %s <lblk> <len> <pblk>\n", cmd);
+		fprintf(stderr, "usage: %s [--after] <lblk> <len> <pblk>\n", cmd);
 		return;
 	}
 
-- 
1.5.4.1

