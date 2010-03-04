From: Leonard Michlmayr <leonard.michlmayr@gmail.com>
Subject: [incomplete PATCH] ext4: avoid overflow in fiemap
Date: Thu, 04 Mar 2010 23:28:35 +0100
Message-ID: <1267741715.13886.4.camel@michlmayr>
References: <1267553925-6308-1-git-send-email-tytso@mit.edu>
	 <1267553925-6308-12-git-send-email-tytso@mit.edu>
	 <4B8E1410.1010107@rs.jp.nec.com> <20100303175217.GA3530@thunk.org>
	 <4B8F47C6.9060408@rs.jp.nec.com>  <1267739098.4204.12.camel@michlmayr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:37927 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab0CDW2j (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Mar 2010 17:28:39 -0500
Received: by fxm19 with SMTP id 19so3424661fxm.21
        for <linux-ext4@vger.kernel.org>; Thu, 04 Mar 2010 14:28:38 -0800 (PST)
In-Reply-To: <1267739098.4204.12.camel@michlmayr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

A __u32 cannot hold the maximum number of blocks in a file. This may
lead to an overflow if a fiemap request has length = s_maxbytes.

I still get a segfault, I have to go through it again. This is just for
your information. I will work on it tomorrow.

The patch is to be applied after/at the end of the ext4 patch queue.
Appearently only fiemap uses ext4_ext_walk_space(). Therefore I changed
the semantics of the ext4_ext_walk_space() call. I hope this does not
introduce a new problem.

In the case that 1<<32 blocks are requested, but there are no allocated
extents, I return two gaps because, the length of a gap in the
ext4_ext_cache is a __u32 again.

Regards
Leonard 

Signed-off-by: Leonard Michlmayr <leonard.michlmayr@gmail.com>

diff -puar linux-2.6.33-ted/fs/ext4/extents.c linux-2.6.33-lm/fs/ext4/extents.c
--- linux-2.6.33-ted/fs/ext4/extents.c	2010-03-04 21:08:00.000000000 +0100
+++ linux-2.6.33-lm/fs/ext4/extents.c	2010-03-04 22:50:54.000000000 +0100
@@ -1853,21 +1853,21 @@ cleanup:
 }
 
 int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
-			ext4_lblk_t num, ext_prepare_callback func,
+			ext4_lblk_t last, ext_prepare_callback func,
 			void *cbdata)
 {
 	struct ext4_ext_path *path = NULL;
 	struct ext4_ext_cache cbex;
 	struct ext4_extent *ex;
 	ext4_lblk_t next, start = 0, end = 0;
-	ext4_lblk_t last = block + num;
 	int depth, exists, err = 0;
 
 	BUG_ON(func == NULL);
 	BUG_ON(inode == NULL);
 
-	while (block < last && block != EXT_MAX_BLOCK) {
-		num = last - block;
+	while (block <= last && block != EXT_MAX_BLOCK) {
+		/* num is one less than the number of blocks */
+		ext4_lblk_t num = last - block;
 		/* find extent for this block */
 		down_read(&EXT4_I(inode)->i_data_sem);
 		path = ext4_ext_find_extent(inode, block, path);
@@ -1893,10 +1893,12 @@ int ext4_ext_walk_space(struct inode *in
 			 * all requested space */
 			start = block;
 			end = block + num;
+			if (end - start >= EXT_MAX_BLOCK)
+				end = EXT_MAX_BLOCK - 1;
 		} else if (le32_to_cpu(ex->ee_block) > block) {
 			/* need to allocate space before found extent */
 			start = block;
-			end = le32_to_cpu(ex->ee_block);
+			end = le32_to_cpu(ex->ee_block) - 1;
 			if (block + num < end)
 				end = block + num;
 		} else if (block >= le32_to_cpu(ex->ee_block)
@@ -1904,8 +1906,11 @@ int ext4_ext_walk_space(struct inode *in
 			/* need to allocate space after found extent */
 			start = block;
 			end = block + num;
+			if (end - start >= EXT_MAX_BLOCK)
+				end = EXT_MAX_BLOCK - 1;
+			BUG_ON(next == 0);
 			if (end >= next)
-				end = next;
+				end = next - 1;
 		} else if (block >= le32_to_cpu(ex->ee_block)) {
 			/*
 			 * some part of requested space is covered
@@ -1913,7 +1918,7 @@ int ext4_ext_walk_space(struct inode *in
 			 */
 			start = block;
 			end = le32_to_cpu(ex->ee_block)
-				+ ext4_ext_get_actual_len(ex);
+				+ (ext4_ext_get_actual_len(ex) - 1);
 			if (block + num < end)
 				end = block + num;
 			exists = 1;
@@ -1924,7 +1929,7 @@ int ext4_ext_walk_space(struct inode *in
 
 		if (!exists) {
 			cbex.ec_block = start;
-			cbex.ec_len = end - start;
+			cbex.ec_len = end - start + 1;
 			cbex.ec_start = 0;
 			cbex.ec_type = EXT4_EXT_CACHE_GAP;
 		} else {
@@ -3894,7 +3899,6 @@ static int ext4_xattr_fiemap(struct inod
 int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		__u64 start, __u64 len)
 {
-	ext4_lblk_t start_blk;
 	int error = 0;
 
 	/* fallback to generic here if not in extents fmt */
@@ -3908,17 +3912,16 @@ int ext4_fiemap(struct inode *inode, str
 	if (fieinfo->fi_flags & FIEMAP_FLAG_XATTR) {
 		error = ext4_xattr_fiemap(inode, fieinfo);
 	} else {
-		ext4_lblk_t last_blk, len_blks;
+		ext4_lblk_t start_blk, last_blk;
 
 		start_blk = start >> inode->i_sb->s_blocksize_bits;
-		last_blk = (start + len - 1) >> inode->i_sb->s_blocksize_bits;
-		len_blks = last_blk - start_blk + 1;
+		last_blk = (len - 1 + start) >> inode->i_sb->s_blocksize_bits;
 
 		/*
 		 * Walk the extent tree gathering extent information.
 		 * ext4_ext_fiemap_cb will push extents back to user.
 		 */
-		error = ext4_ext_walk_space(inode, start_blk, len_blks,
+		error = ext4_ext_walk_space(inode, start_blk, last_blk,
 					  ext4_ext_fiemap_cb, fieinfo);
 	}
 



