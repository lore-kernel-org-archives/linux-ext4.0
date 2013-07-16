From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: call ext4_es_lru_add() after handling cache miss
Date: Tue, 16 Jul 2013 10:29:40 -0400
Message-ID: <1373984980-9895-1-git-send-email-tytso@mit.edu>
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, Theodore Ts'o <tytso@mit.edu>,
	Zheng Liu <wenqing.lz@taobao.com>, stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38251 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932381Ab3GPO3q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Jul 2013 10:29:46 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If there are no items in the extent status tree, ext4_es_lru_add() is
a no-op.  So it is not sufficient to call ext4_es_lru_add() before we
try to lookup an entry in the extent status tree.  We also need to
call it at the end of ext4_ext_map_blocks(), after items have been
added to the extent status tree.

This could lead to inodes with that have extent status trees but which
are not in the LRU list, which means they won't get considered for
eviction by the es_shrinker.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Zheng Liu <wenqing.lz@taobao.com>
Cc: stable@vger.kernel.org
---
 fs/ext4/extents.c | 5 +++--
 fs/ext4/inode.c   | 7 ++-----
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index cfdc51e..a618738 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4385,8 +4385,9 @@ out2:
 	}
 
 out3:
-	trace_ext4_ext_map_blocks_exit(inode, flags, map, err ? err : allocated);
-
+	trace_ext4_ext_map_blocks_exit(inode, flags, map,
+				       err ? err : allocated);
+	ext4_es_lru_add(inode);
 	return err ? err : allocated;
 }
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3c5edf2..ea2cbf1 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -514,10 +514,9 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 		  "logical block %lu\n", inode->i_ino, flags, map->m_len,
 		  (unsigned long) map->m_lblk);
 
-	ext4_es_lru_add(inode);
-
 	/* Lookup extent status tree firstly */
 	if (ext4_es_lookup_extent(inode, map->m_lblk, &es)) {
+		ext4_es_lru_add(inode);
 		if (ext4_es_is_written(&es) || ext4_es_is_unwritten(&es)) {
 			map->m_pblk = ext4_es_pblock(&es) +
 					map->m_lblk - es.es_lblk;
@@ -1529,11 +1528,9 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
 		  "logical block %lu\n", inode->i_ino, map->m_len,
 		  (unsigned long) map->m_lblk);
 
-	ext4_es_lru_add(inode);
-
 	/* Lookup extent status tree firstly */
 	if (ext4_es_lookup_extent(inode, iblock, &es)) {
