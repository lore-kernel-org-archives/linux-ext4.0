From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2] ext4: Add checks to validate extent entries.
Date: Mon, 16 Feb 2009 22:56:40 +0530
Message-ID: <1234805202-6922-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:47555 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbZBPR05 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Feb 2009 12:26:57 -0500
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id n1GHP8qI029713
	for <linux-ext4@vger.kernel.org>; Tue, 17 Feb 2009 04:25:08 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n1GHQuER483342
	for <linux-ext4@vger.kernel.org>; Tue, 17 Feb 2009 04:26:56 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n1GHQt0J003890
	for <linux-ext4@vger.kernel.org>; Tue, 17 Feb 2009 04:26:55 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds check to validate the extent entries along
with extent  headers. Should handle crash with corrupt filesystem.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

---
 fs/ext4/extents.c |   81 ++++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 71 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index e2eab19..503c97c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -301,7 +301,64 @@ ext4_ext_max_entries(struct inode *inode, int depth)
 	return max;
 }
 
-static int __ext4_ext_check_header(const char *function, struct inode *inode,
+static int ext4_valid_extent(struct inode *inode, struct ext4_extent *ext)
+{
+	ext4_fsblk_t block = ext_pblock(ext);
+	int len = ext4_ext_get_actual_len(ext);
+	struct ext4_super_block *es = EXT4_SB(inode->i_sb)->s_es;
+	if (unlikely(block < le32_to_cpu(es->s_first_data_block) ||
+			((block + len) > ext4_blocks_count(es))))
+		return 0;
+	else
+		return 1;
+}
+
+static int ext4_valid_extent_idx(struct inode *inode,
+				struct ext4_extent_idx *ext_idx)
+{
+	ext4_fsblk_t block = idx_pblock(ext_idx);
+	struct ext4_super_block *es = EXT4_SB(inode->i_sb)->s_es;
+	if (unlikely(block < le32_to_cpu(es->s_first_data_block) ||
+			(block > ext4_blocks_count(es))))
+		return 0;
+	else
+		return 1;
+}
+
+static int ext4_valid_extent_entries(struct inode *inode,
+				struct ext4_extent_header *eh,
+				int depth)
+{
+	struct ext4_extent *ext;
+	struct ext4_extent_idx *ext_idx;
+	unsigned short entries;
+	if (eh->eh_entries == 0)
+		return 1;
+
+	entries = le16_to_cpu(eh->eh_entries);
+
+	if (depth == 0) {
+		/* leaf entries */
+		ext = EXT_FIRST_EXTENT(eh);
+		while (entries) {
+			if (!ext4_valid_extent(inode, ext))
+				return 0;
+			ext++;
+			entries--;
+		}
+	} else {
+		ext_idx = EXT_FIRST_INDEX(eh);
+		while (entries) {
+			if (!ext4_valid_extent_idx(inode, ext_idx))
+				return 0;
+			ext_idx++;
+			entries--;
+		}
+	}
+	return 1;
+}
+
+static int __ext4_ext_check(const char *function, struct inode *inode,
 					struct ext4_extent_header *eh,
 					int depth)
 {
@@ -329,11 +386,15 @@ static int __ext4_ext_check_header(const char *function, struct inode *inode,
 		error_msg = "invalid eh_entries";
 		goto corrupted;
 	}
+	if (!ext4_valid_extent_entries(inode, eh, depth)) {
+		error_msg = "invalid extent entries";
+		goto corrupted;
+	}
 	return 0;
 
 corrupted:
 	ext4_error(inode->i_sb, function,
-			"bad header in inode #%lu: %s - magic %x, "
+			"bad header/extent in inode #%lu: %s - magic %x, "
 			"entries %u, max %u(%u), depth %u(%u)",
 			inode->i_ino, error_msg, le16_to_cpu(eh->eh_magic),
 			le16_to_cpu(eh->eh_entries), le16_to_cpu(eh->eh_max),
@@ -342,8 +403,8 @@ corrupted:
 	return -EIO;
 }
 
-#define ext4_ext_check_header(inode, eh, depth)	\
-	__ext4_ext_check_header(__func__, inode, eh, depth)
+#define ext4_ext_check(inode, eh, depth)	\
+	__ext4_ext_check(__func__, inode, eh, depth)
 
 #ifdef EXT_DEBUG
 static void ext4_ext_show_path(struct inode *inode, struct ext4_ext_path *path)
@@ -547,7 +608,7 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
 
 	eh = ext_inode_hdr(inode);
 	depth = ext_depth(inode);
-	if (ext4_ext_check_header(inode, eh, depth))
+	if (ext4_ext_check(inode, eh, depth))
 		return ERR_PTR(-EIO);
 
 
@@ -584,7 +645,7 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
 		path[ppos].p_hdr = eh;
 		i--;
 
-		if (ext4_ext_check_header(inode, eh, i))
+		if (ext4_ext_check(inode, eh, i))
 			goto err;
 	}
 
@@ -1179,7 +1240,7 @@ got_index:
 		if (bh == NULL)
 			return -EIO;
 		eh = ext_block_hdr(bh);
-		if (ext4_ext_check_header(inode, eh, depth)) {
+		if (ext4_ext_check(inode, eh, depth)) {
 			put_bh(bh);
 			return -EIO;
 		}
@@ -1192,7 +1253,7 @@ got_index:
 	if (bh == NULL)
 		return -EIO;
 	eh = ext_block_hdr(bh);
-	if (ext4_ext_check_header(inode, eh, path->p_depth - depth)) {
+	if (ext4_ext_check(inode, eh, path->p_depth - depth)) {
 		put_bh(bh);
 		return -EIO;
 	}
@@ -2135,7 +2196,7 @@ static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start)
 		return -ENOMEM;
 	}
 	path[0].p_hdr = ext_inode_hdr(inode);
-	if (ext4_ext_check_header(inode, path[0].p_hdr, depth)) {
+	if (ext4_ext_check(inode, path[0].p_hdr, depth)) {
 		err = -EIO;
 		goto out;
 	}
@@ -2189,7 +2250,7 @@ static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start)
 				err = -EIO;
 				break;
 			}
-			if (ext4_ext_check_header(inode, ext_block_hdr(bh),
+			if (ext4_ext_check(inode, ext_block_hdr(bh),
 							depth - i - 1)) {
 				err = -EIO;
 				break;
-- 
tg: (d2f8d7e..) extent_validate (depends on: master)
