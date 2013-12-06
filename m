From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v3 29/30] libext2fs: export inode cahce creation function
Date: Fri,  6 Dec 2013 17:58:16 +0800
Message-ID: <1386323897-2354-30-git-send-email-wenqing.lz@taobao.com>
References: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:51731 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757761Ab3LFJ4e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Dec 2013 04:56:34 -0500
Received: by mail-pb0-f45.google.com with SMTP id rp16so793051pbb.4
        for <linux-ext4@vger.kernel.org>; Fri, 06 Dec 2013 01:56:34 -0800 (PST)
In-Reply-To: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Currently we have already exported inode cache flush and free functions
for users.  This commit exports inode cache creation function.  Later
we will use this function to initialize inode cache and do some unit
tests for inline data.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/ext2fs.h  |    2 ++
 lib/ext2fs/ext2fsP.h |    2 +-
 lib/ext2fs/inode.c   |    8 ++++----
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 3237b03..fe6b0d9 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1372,6 +1372,8 @@ extern errcode_t ext2fs_get_memalign(unsigned long size,
 				     unsigned long align, void *ptr);
 
 /* inode.c */
+extern errcode_t ext2fs_create_inode_cache(ext2_filsys fs,
+					   unsigned int cache_size);
 extern void ext2fs_free_inode_cache(struct ext2_inode_cache *icache);
 extern errcode_t ext2fs_flush_icache(ext2_filsys fs);
 extern errcode_t ext2fs_get_next_inode_full(ext2_inode_scan scan,
diff --git a/lib/ext2fs/ext2fsP.h b/lib/ext2fs/ext2fsP.h
index e159128..6f175f7 100644
--- a/lib/ext2fs/ext2fsP.h
+++ b/lib/ext2fs/ext2fsP.h
@@ -69,7 +69,7 @@ struct ext2_inode_cache {
 	void *				buffer;
 	blk64_t				buffer_blk;
 	int				cache_last;
-	int				cache_size;
+	unsigned int			cache_size;
 	int				refcount;
 	struct ext2_inode_cache_ent	*cache;
 };
diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index 46c1c58..0cea9f0 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -91,7 +91,7 @@ void ext2fs_free_inode_cache(struct ext2_inode_cache *icache)
 	ext2fs_free_mem(&icache);
 }
 
-static errcode_t create_icache(ext2_filsys fs)
+errcode_t ext2fs_create_inode_cache(ext2_filsys fs, unsigned int cache_size)
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

