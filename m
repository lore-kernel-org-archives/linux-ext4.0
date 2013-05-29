From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/4] ext4: Fix overflows in SEEK_HOLE, SEEK_DATA implementations
Date: Wed, 29 May 2013 14:05:31 +0200
Message-ID: <1369829133-4307-3-git-send-email-jack@suse.cz>
References: <1369829133-4307-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52117 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965645Ab3E2MFl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 May 2013 08:05:41 -0400
In-Reply-To: <1369829133-4307-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_lblk_t is just u32 so multiplying it by blocksize can easily
overflow for files larger than 4 GB. Fix that by properly typing the
block offsets before shifting.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/file.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index b1b4d51..b19f0a4 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -312,7 +312,7 @@ static int ext4_find_unwritten_pgoff(struct inode *inode,
 	blkbits = inode->i_sb->s_blocksize_bits;
 	startoff = *offset;
 	lastoff = startoff;
-	endoff = (map->m_lblk + map->m_len) << blkbits;
+	endoff = (loff_t)(map->m_lblk + map->m_len) << blkbits;
 
 	index = startoff >> PAGE_CACHE_SHIFT;
 	end = endoff >> PAGE_CACHE_SHIFT;
@@ -457,7 +457,7 @@ static loff_t ext4_seek_data(struct file *file, loff_t offset, loff_t maxsize)
 		ret = ext4_map_blocks(NULL, inode, &map, 0);
 		if (ret > 0 && !(map.m_flags & EXT4_MAP_UNWRITTEN)) {
 			if (last != start)
-				dataoff = last << blkbits;
+				dataoff = (loff_t)last << blkbits;
 			break;
 		}
 
@@ -468,7 +468,7 @@ static loff_t ext4_seek_data(struct file *file, loff_t offset, loff_t maxsize)
 		ext4_es_find_delayed_extent_range(inode, last, last, &es);
 		if (es.es_len != 0 && in_range(last, es.es_lblk, es.es_len)) {
 			if (last != start)
-				dataoff = last << blkbits;
+				dataoff = (loff_t)last << blkbits;
 			break;
 		}
 
@@ -486,7 +486,7 @@ static loff_t ext4_seek_data(struct file *file, loff_t offset, loff_t maxsize)
 		}
 
 		last++;
-		dataoff = last << blkbits;
+		dataoff = (loff_t)last << blkbits;
 	} while (last <= end);
 
 	mutex_unlock(&inode->i_mutex);
@@ -540,7 +540,7 @@ static loff_t ext4_seek_hole(struct file *file, loff_t offset, loff_t maxsize)
 		ret = ext4_map_blocks(NULL, inode, &map, 0);
 		if (ret > 0 && !(map.m_flags & EXT4_MAP_UNWRITTEN)) {
 			last += ret;
-			holeoff = last << blkbits;
+			holeoff = (loff_t)last << blkbits;
 			continue;
 		}
 
@@ -551,7 +551,7 @@ static loff_t ext4_seek_hole(struct file *file, loff_t offset, loff_t maxsize)
 		ext4_es_find_delayed_extent_range(inode, last, last, &es);
 		if (es.es_len != 0 && in_range(last, es.es_lblk, es.es_len)) {
 			last = es.es_lblk + es.es_len;
-			holeoff = last << blkbits;
+			holeoff = (loff_t)last << blkbits;
 			continue;
 		}
 
@@ -566,7 +566,7 @@ static loff_t ext4_seek_hole(struct file *file, loff_t offset, loff_t maxsize)
 							      &map, &holeoff);
 			if (!unwritten) {
 				last += ret;
-				holeoff = last << blkbits;
+				holeoff = (loff_t)last << blkbits;
 				continue;
 			}
 		}
-- 
1.8.1.4

