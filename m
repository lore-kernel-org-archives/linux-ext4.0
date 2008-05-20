From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/3] libext2fs: allow ext2fs_extent_insert to split if needed
Date: Tue, 20 May 2008 10:15:27 -0500
Message-ID: <4832EB0F.9040506@redhat.com>
References: <4832EA22.2070301@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932459AbYETPPi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 May 2008 11:15:38 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m4KFFWLf021343
	for <linux-ext4@vger.kernel.org>; Tue, 20 May 2008 11:15:35 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4KFFVnK011822
	for <linux-ext4@vger.kernel.org>; Tue, 20 May 2008 11:15:31 -0400
Received: from Liberator.local (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4KFFSuu019684
	for <linux-ext4@vger.kernel.org>; Tue, 20 May 2008 11:15:29 -0400
In-Reply-To: <4832EA22.2070301@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If ext2fs_extent_insert finds that the requested node
for insertion is full, it will currently fail.

With this patch it will split as necessary to make room, unless
an EXT2_EXTENT_INSERT_NOSPLIT flag is sent in.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 lib/ext2fs/ext2fs.h |    4 ++--
 lib/ext2fs/extent.c |   15 ++++++++++++---
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 7a1d966..30ca906 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -332,8 +332,8 @@ typedef struct ext2_extent_path *ext2_extent_path_t;
 /*
  * Flags used by ext2fs_extent_insert()
  */
-
-#define EXT2_EXTENT_INSERT_AFTER  0x0001
+#define EXT2_EXTENT_INSERT_AFTER	0x0001 /* insert after handle loc'n */
+#define EXT2_EXTENT_INSERT_NOSPLIT	0x0002 /* insert may not cause split */
 
 /*
  * Data structure returned by ext2fs_extent_get_info()
diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index 5ec5c3e..34719d5 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -894,8 +894,17 @@ errcode_t ext2fs_extent_insert(ext2_extent_handle_t handle, int flags,
 
 	path = handle->path + handle->level;
 
-	if (path->entries >= path->max_entries)
-		return EXT2_ET_CANT_INSERT_EXTENT;
+	if (path->entries >= path->max_entries) {
+		if (flags & EXT2_EXTENT_INSERT_NOSPLIT) {
+			return EXT2_ET_CANT_INSERT_EXTENT;
+		} else {
+			dbg_printf("node full - splitting\n");
+			retval = ext2fs_node_split(handle, 0);
+			if (retval)
+				goto errout;
+			path = handle->path + handle->level;
+		}
+	}
 
 	eh = (struct ext3_extent_header *) path->buf;
 	if (path->curr) {
@@ -1245,7 +1254,7 @@ void do_insert_node(int argc, char *argv[])
 	}
 
 	if (argc != 4) {
-		fprintf(stderr, "usage: %s <lblk> <len> <pblk>\n", cmd);
+		fprintf(stderr, "usage: %s [--after] <lblk> <len> <pblk>\n", cmd);
 		return;
 	}
 
-- 1.5.4.1

