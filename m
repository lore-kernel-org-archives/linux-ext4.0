From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v2 27/28] libext2fs: export inode cahce creation function
Date: Tue,  3 Dec 2013 20:11:54 +0800
Message-ID: <1386072715-9869-28-git-send-email-wenqing.lz@taobao.com>
References: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:60115 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab3LCMKI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Dec 2013 07:10:08 -0500
Received: by mail-pa0-f50.google.com with SMTP id kl14so2838193pab.23
        for <linux-ext4@vger.kernel.org>; Tue, 03 Dec 2013 04:10:08 -0800 (PST)
In-Reply-To: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Currently we have already exported inode cache flush and free functions
for users.  This commit exports inode cache creation function.  Later
we will use this function to initialize inode cache and do some unit
tests for inline data.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/ext2fs.h |    1 +
 lib/ext2fs/inode.c  |    8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index bf0ef26..a47bb40 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1369,6 +1369,7 @@ extern errcode_t ext2fs_get_memalign(unsigned long size,
 				     unsigned long align, void *ptr);
 
 /* inode.c */
+extern errcode_t ext2fs_create_inode_cache(ext2_filsys fs, int cache_size);
 extern void ext2fs_free_inode_cache(struct ext2_inode_cache *icache);
 extern errcode_t ext2fs_flush_icache(ext2_filsys fs);
 extern errcode_t ext2fs_get_next_inode_full(ext2_inode_scan scan,
diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index 46c1c58..8cf76b0 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -91,7 +91,7 @@ void ext2fs_free_inode_cache(struct ext2_inode_cache *icache)
 	ext2fs_free_mem(&icache);
 }
 
-static errcode_t create_icache(ext2_filsys fs)
+errcode_t ext2fs_create_inode_cache(ext2_filsys fs, int cache_size)
 {
 	int		i;
 	errcode_t	retval;
@@ -109,7 +109,7 @@ static errcode_t create_icache(ext2_filsys fs)
 
 	fs->icache->buffer_blk = 0;
 	fs->icache->cache_last = -1;
-	fs->icache->cache_size = 4;
+	fs->icache->cache_size = cache_size;
 	fs->icache->refcount = 1;
 	retval = ext2fs_get_array(fs->icache->cache_size,
 				  sizeof(struct ext2_inode_cache_ent),
@@ -596,7 +596,7 @@ errcode_t ext2fs_read_inode_full(ext2_filsys fs, ext2_ino_t ino,
 		return EXT2_ET_BAD_INODE_NUM;
 	/* Create inode cache if not present */
 	if (!fs->icache) {
-		retval = create_icache(fs);
+		retval = ext2fs_create_inode_cache(fs, 4);
 		if (retval)
 			return retval;
 	}
@@ -732,7 +732,7 @@ errcode_t ext2fs_write_inode_full(ext2_filsys fs, ext2_ino_t ino,
 			}
 		}
 	} else {
-		retval = create_icache(fs);
+		retval = ext2fs_create_inode_cache(fs, 4);
 		if (retval)
 			goto errout;
 	}
-- 
1.7.9.7

