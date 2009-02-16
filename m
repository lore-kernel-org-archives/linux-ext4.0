From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2] ext4: Validate extent details only when read from the disk
Date: Mon, 16 Feb 2009 22:56:41 +0530
Message-ID: <1234805202-6922-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1234805202-6922-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:48321 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbZBPR1A (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Feb 2009 12:27:00 -0500
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp07.au.ibm.com (8.13.1/8.13.1) with ESMTP id n1GHQwvG003660
	for <linux-ext4@vger.kernel.org>; Tue, 17 Feb 2009 04:26:58 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n1GHQwlv946400
	for <linux-ext4@vger.kernel.org>; Tue, 17 Feb 2009 04:26:58 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n1GHQwsi003922
	for <linux-ext4@vger.kernel.org>; Tue, 17 Feb 2009 04:26:58 +1100
In-Reply-To: <1234805202-6922-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Make sure we validate extent details only when read from the disk.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

---
 fs/ext4/ext4_extents.h |    1 +
 fs/ext4/extents.c      |   24 +++++++++++++++++-------
 fs/ext4/inode.c        |   10 ++++++++++
 3 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
index 18cb67b..f0c3ec8 100644
--- a/fs/ext4/ext4_extents.h
+++ b/fs/ext4/ext4_extents.h
@@ -241,5 +241,6 @@ extern int ext4_ext_search_left(struct inode *, struct ext4_ext_path *,
 extern int ext4_ext_search_right(struct inode *, struct ext4_ext_path *,
 						ext4_lblk_t *, ext4_fsblk_t *);
 extern void ext4_ext_drop_refs(struct ext4_ext_path *);
+extern int ext4_ext_check_inode(struct inode *inode);
 #endif /* _EXT4_EXTENTS */
 
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 503c97c..16acada 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -406,6 +406,11 @@ corrupted:
 #define ext4_ext_check(inode, eh, depth)	\
 	__ext4_ext_check(__func__, inode, eh, depth)
 
+int ext4_ext_check_inode(struct inode *inode)
+{
+	return ext4_ext_check(inode, ext_inode_hdr(inode), ext_depth(inode));
+}
+
 #ifdef EXT_DEBUG
 static void ext4_ext_show_path(struct inode *inode, struct ext4_ext_path *path)
 {
@@ -602,15 +607,13 @@ struct ext4_ext_path *
 ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
 					struct ext4_ext_path *path)
 {
+	int need_to_validate = 0;
 	struct ext4_extent_header *eh;
 	struct buffer_head *bh;
 	short int depth, i, ppos = 0, alloc = 0;
 
 	eh = ext_inode_hdr(inode);
 	depth = ext_depth(inode);
-	if (ext4_ext_check(inode, eh, depth))
-		return ERR_PTR(-EIO);
-
 
 	/* account possible depth increase */
 	if (!path) {
@@ -634,10 +637,17 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
 		path[ppos].p_depth = i;
 		path[ppos].p_ext = NULL;
 
-		bh = sb_bread(inode->i_sb, path[ppos].p_block);
-		if (!bh)
+		bh = sb_getblk(inode->i_sb, path[ppos].p_block);
+		if (unlikely(!bh))
 			goto err;
-
+		if (!bh_uptodate_or_lock(bh)) {
+			if (bh_submit_read(bh) < 0) {
+				put_bh(bh);
+				goto err;
+			}
+			/* validate the extent entries */
+			need_to_validate = 1;
+		}
 		eh = ext_block_hdr(bh);
 		ppos++;
 		BUG_ON(ppos > depth);
@@ -645,7 +655,7 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
 		path[ppos].p_hdr = eh;
 		i--;
 
-		if (ext4_ext_check(inode, eh, i))
+		if (need_to_validate && ext4_ext_check(inode, eh, i))
 			goto err;
 	}
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 03ba20b..61e8fc0 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4273,6 +4273,16 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 			(__u64)(le32_to_cpu(raw_inode->i_version_hi)) << 32;
 	}
 
+	if (ei->i_flags & EXT4_EXTENTS_FL) {
+		/* Validate extent which is part of inode */
+		ret = ext4_ext_check_inode(inode);
+		if (ret) {
+			brelse(bh);
+			goto bad_inode;
+		}
+
+	}
+
 	if (S_ISREG(inode->i_mode)) {
 		inode->i_op = &ext4_file_inode_operations;
 		inode->i_fop = &ext4_file_operations;
-- 
tg: (b76c986..) extent_validate2 (depends on: extent_validate)
