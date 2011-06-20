From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: [PATCH 3/3] dx read-ahead: Map blocks with a single semaphore lock
Date: Mon, 20 Jun 2011 22:29:00 +0200
Message-ID: <20110620202900.2473133.26051.stgit@localhost.localdomain>
References: <20110620202631.2473133.4166.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: adilger@whamcloud.com, colyli@gmail.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:39455 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167Ab1FTU3C (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Jun 2011 16:29:02 -0400
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id p5KKT0ht028656
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Mon, 20 Jun 2011 22:29:00 +0200
In-Reply-To: <20110620202631.2473133.4166.stgit@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Map all ra-blocks using a single down_read(&EXT4_I(inode)->i_data_sem
as Andreas suggested.

Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
---
 fs/ext4/ext4.h  |    2 +
 fs/ext4/inode.c |   93 +++++++++++++++++++++++++++++++++++++++++++++++--------
 fs/ext4/namei.c |   23 +++++++++-----
 3 files changed, 96 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 997323a..213ac7c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1804,7 +1804,7 @@ struct buffer_head *ext4_getblk(handle_t *, struct inode *,
 						ext4_lblk_t, int, int *);
 struct buffer_head *ext4_bread(handle_t *, struct inode *,
 						ext4_lblk_t, int, int *);
-int ext4_bread_ra(struct inode *inode, ext4_lblk_t block);
+void ext4_bread_ra(struct inode *inode, ext4_lblk_t blocks[], int nblocks);
 int ext4_get_block(struct inode *inode, sector_t iblock,
 				struct buffer_head *bh_result, int create);
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 938fb6c..5b325c0 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1382,6 +1382,36 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	return retval;
 }
 
+
+/*
+ * Simplified version to map blocks for read-aheads. We only try
+ * to map existing blocks
+ * NOTE: Should be called with down_read(&EXT4_I(inode)->i_data_sem)
+ */
+int ext4_ra_map_blocks(struct inode *inode, struct ext4_map_blocks *map)
+{
+	int retval;
+
+	map->m_flags = 0;
+	ext_debug("ext4_map_blocks(): inode %lu, flag %d, max_blocks %u,"
+		  "logical block %lu\n", inode->i_ino, flags, map->m_len,
+		  (unsigned long) map->m_lblk);
+
+	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
+		retval = ext4_ext_map_blocks(NULL, inode, map, 0);
+	} else {
+		retval = ext4_ind_map_blocks(NULL, inode, map, 0);
+	}
+
+	if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED) {
+		int ret = check_block_validity(inode, map);
+		if (ret != 0)
+			return ret;
+	}
+
+	return retval;
+}
+
 /* Maximum number of blocks we map for direct IO at once. */
 #define DIO_MAX_BLOCKS 4096
 
@@ -1491,6 +1521,34 @@ struct buffer_head *ext4_getblk(handle_t *handle, struct inode *inode,
 }
 
 /*
+ * Get an array of buffer heads for read-head.
+ * Blocks that cannot be mapped will be filled into bhs as NULL. The caller
+ * needs to check for that.
+ */
+void ext4_ra_getblks(struct buffer_head *bhs[], struct inode *inode,
+				ext4_lblk_t *blocks, int nblocks)
+{
+	struct ext4_map_blocks map;
+	int err;
+	int i;
+
+	down_read((&EXT4_I(inode)->i_data_sem));
+	for(i = 0; i < nblocks; i++) {
+		map.m_lblk = blocks[i];
+		map.m_len = 1;
+		err = ext4_ra_map_blocks(inode, &map);
+
+		if (err <= 0) {
+			bhs[i] = NULL;
+			continue;
+		}
+
+		bhs[i] = sb_getblk(inode->i_sb, map.m_pblk);
+	}
+	up_read((&EXT4_I(inode)->i_data_sem));
+}
+
+/*
   * Synchronous read of blocks
   */
 struct buffer_head *ext4_bread(handle_t *handle, struct inode *inode,
@@ -1514,26 +1572,35 @@ struct buffer_head *ext4_bread(handle_t *handle, struct inode *inode,
 }
 
 /*
- * Read-ahead blocks
+ * Read-ahead blocks. If something fails we just return silently.
  */
-int ext4_bread_ra(struct inode *inode, ext4_lblk_t block)
+void ext4_bread_ra(struct inode *inode, ext4_lblk_t blocks[], int nblocks)
 {
-	struct buffer_head *bh;
-	int err;
+	int i;
+	size_t size = sizeof(struct buffer_head *) * nblocks;
+	struct buffer_head **bhs = kmalloc(size, GFP_KERNEL);
 
-	bh = ext4_getblk(NULL, inode, block, 0, &err);
-	if (!bh)
-		return -1;
+	if (!bhs)
+		return; /* out of memory */
+
+	ext4_ra_getblks(bhs, inode, blocks, nblocks);
+
+	for (i = 0; i < nblocks; i++) {
+		struct buffer_head *bh = bhs[i];
 
-	if (buffer_uptodate(bh)) {
+		if (!bh)
+			continue;
+
+		if (buffer_uptodate(bh)) {
+			brelse(bh);
+			continue;
+		}
+	
+		ll_rw_block(READA, 1, &bh);
 		brelse(bh);
-		return 0;
 	}
 
-	ll_rw_block(READA, 1, &bh);
-
-	brelse(bh);
-	return 0;
+	kfree(bhs);
 }
 
 
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 9643722..34f6f90 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -51,6 +51,7 @@
 
 #define NAMEI_RA_DX_BLOCKS  32 /* Better use BH_LRU_SIZE? */
 
+
 static struct buffer_head *ext4_append(handle_t *handle,
 					struct inode *inode,
 					ext4_lblk_t *block, int *err)
@@ -336,18 +337,25 @@ struct stats dx_show_entries(struct dx_hash_info *hinfo, struct inode *dir,
 #endif /* DX_DEBUG */
 
 /*
- * Read ahead directory index blocks
+ * Read ahead directory index blocks. Quit silently on errors.
  */
 static void dx_ra_blocks(struct inode *dir, struct dx_entry *entries,
 			 struct dx_entry *at)
 {
-	int i, err = 0;
+	int i;
 	struct dx_entry *first_ra_entry = entries + 1;
 	unsigned num_entries = dx_get_count(entries) - 1;
+	
+	size_t size = sizeof(ext4_lblk_t) * NAMEI_RA_DX_BLOCKS;
+	ext4_lblk_t *blocks = kmalloc(size, GFP_KERNEL);
+	
+	if (!blocks)
+		return; /* out of memory */
 
 	if (num_entries < 2 || num_entries > dx_get_limit(entries)) {
 		dxtrace(printk("dx read-ahead: invalid number of entries:%d\n",
 			       num_entries));
+		kfree(blocks);
 		return;
 	}
 
@@ -370,13 +378,12 @@ static void dx_ra_blocks(struct inode *dir, struct dx_entry *entries,
 	dxtrace(printk("dx read-ahead: %d entries in dir-ino %lu \n",
 			num_entries, dir->i_ino));
 
-	i = 0;
-	do {
-		struct dx_entry *entry = first_ra_entry + i;
+	for(i = 0; i < num_entries; i++)
+		blocks[i] = dx_get_block(first_ra_entry + i);
+
+	ext4_bread_ra(dir, blocks, num_entries);
 
-		err = ext4_bread_ra(dir, dx_get_block(entry));
-		i++;
-	 } while (i < num_entries && !err);
+	kfree(blocks);
 }
 
 /*

