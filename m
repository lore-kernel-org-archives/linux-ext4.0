From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [RFC][Patch 1/1] Persistent preallocation in ext4
Date: Wed, 6 Dec 2006 11:28:22 +0530
Message-ID: <20061206055822.GA6182@amitarora.in.ibm.com>
References: <20061205134338.GA1894@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: suparna@in.ibm.com, cmm@us.ibm.com, suzuki@in.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:54756 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760228AbWLFF6r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Dec 2006 00:58:47 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id kB65wkdR028315
	for <linux-ext4@vger.kernel.org>; Wed, 6 Dec 2006 00:58:46 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kB65wkZS431028
	for <linux-ext4@vger.kernel.org>; Tue, 5 Dec 2006 22:58:46 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kB65wkjZ018174
	for <linux-ext4@vger.kernel.org>; Tue, 5 Dec 2006 22:58:46 -0700
To: linux-ext4@vger.kernel.org
Content-Disposition: inline
In-Reply-To: <20061205134338.GA1894@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch takes care of few suggestions given by Suzuki.
Suzuki, Thanks!

Signed-off-by: Amit Arora <aarora@in.ibm.com>
---
 fs/ext4/extents.c       |  117 ++++++++++++++++++++++++++++++++----------------
 fs/ext4/ioctl.c         |   41 ++++++++++++++++
 include/linux/ext4_fs.h |   21 ++++++++
 3 files changed, 141 insertions(+), 38 deletions(-)

Index: linux-2.6.19/fs/ext4/extents.c
===================================================================
--- linux-2.6.19.orig/fs/ext4/extents.c	2006-12-06 10:18:12.000000000 +0530
+++ linux-2.6.19/fs/ext4/extents.c	2006-12-06 10:23:02.000000000 +0530
@@ -282,7 +282,7 @@
 		} else if (path->p_ext) {
 			ext_debug("  %d:%d:%llu ",
 				  le32_to_cpu(path->p_ext->ee_block),
-				  le16_to_cpu(path->p_ext->ee_len),
+				  ext4_ext_get_actual_len(path->p_ext),
 				  ext_pblock(path->p_ext));
 		} else
 			ext_debug("  []");
@@ -305,7 +305,7 @@
 
 	for (i = 0; i < le16_to_cpu(eh->eh_entries); i++, ex++) {
 		ext_debug("%d:%d:%llu ", le32_to_cpu(ex->ee_block),
-			  le16_to_cpu(ex->ee_len), ext_pblock(ex));
+			  	ext4_ext_get_actual_len(ex), ext_pblock(ex));
 	}
 	ext_debug("\n");
 }
@@ -425,7 +425,7 @@
 	ext_debug("  -> %d:%llu:%d ",
 		        le32_to_cpu(path->p_ext->ee_block),
 		        ext_pblock(path->p_ext),
-			le16_to_cpu(path->p_ext->ee_len));
+			ext4_ext_get_actual_len(path->p_ext));
 
 #ifdef CHECK_BINSEARCH
 	{
@@ -686,7 +686,7 @@
 		ext_debug("move %d:%llu:%d in new leaf %llu\n",
 			        le32_to_cpu(path[depth].p_ext->ee_block),
 			        ext_pblock(path[depth].p_ext),
-			        le16_to_cpu(path[depth].p_ext->ee_len),
+			        ext4_ext_get_actual_len(path[depth].p_ext),
 				newblock);
 		/*memmove(ex++, path[depth].p_ext++,
 				sizeof(struct ext4_extent));
@@ -1097,7 +1097,20 @@
 ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
 				struct ext4_extent *ex2)
 {
-	if (le32_to_cpu(ex1->ee_block) + le16_to_cpu(ex1->ee_len) !=
+	unsigned short ext1_ee_len, ext2_ee_len;
+
+
+	/*
+	 * Make sure that either both extents are uninitialized, or
+	 * both are _not_.
+	 */
+	if (ext4_ext_is_uninitialized(ex1) ^ ext4_ext_is_uninitialized(ex2))
+		return 0;
+
+	ext1_ee_len = ext4_ext_get_actual_len(ex1);
+	ext2_ee_len = ext4_ext_get_actual_len(ex2);
+
+	if (le32_to_cpu(ex1->ee_block) + ext1_ee_len !=
 			le32_to_cpu(ex2->ee_block))
 		return 0;
 
@@ -1106,14 +1119,14 @@
 	 * as an RO_COMPAT feature, refuse to merge to extents if
 	 * this can result in the top bit of ee_len being set.
 	 */
-	if (le16_to_cpu(ex1->ee_len) + le16_to_cpu(ex2->ee_len) > EXT_MAX_LEN)
+	if (ext1_ee_len + ext2_ee_len > EXT_MAX_LEN)
 		return 0;
 #ifdef AGRESSIVE_TEST
 	if (le16_to_cpu(ex1->ee_len) >= 4)
 		return 0;
 #endif
 
-	if (ext_pblock(ex1) + le16_to_cpu(ex1->ee_len) == ext_pblock(ex2))
+	if (ext_pblock(ex1) + ext1_ee_len == ext_pblock(ex2))
 		return 1;
 	return 0;
 }
@@ -1132,9 +1145,9 @@
 	struct ext4_extent *ex, *fex;
 	struct ext4_extent *nearex; /* nearest extent */
 	struct ext4_ext_path *npath = NULL;
-	int depth, len, err, next;
+	int depth, len, err, next, uninitialized = 0;
 
-	BUG_ON(newext->ee_len == 0);
+	BUG_ON(ext4_ext_get_actual_len(newext) == 0);
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
 	BUG_ON(path[depth].p_hdr == NULL);
@@ -1142,13 +1155,22 @@
 	/* try to insert block into found extent and return */
 	if (ex && ext4_can_extents_be_merged(inode, ex, newext)) {
 		ext_debug("append %d block to %d:%d (from %llu)\n",
-				le16_to_cpu(newext->ee_len),
+				ext4_ext_get_actual_len(newext),
 				le32_to_cpu(ex->ee_block),
-				le16_to_cpu(ex->ee_len), ext_pblock(ex));
+				ext4_ext_get_actual_len(ex), ext_pblock(ex));
 		if ((err = ext4_ext_get_access(handle, inode, path + depth)))
 			return err;
-		ex->ee_len = cpu_to_le16(le16_to_cpu(ex->ee_len)
-					 + le16_to_cpu(newext->ee_len));
+
+		/* ext4_can_extents_be_merged should have checked that either
+		 * both extents are uninitialized, or both aren't. Thus we
+		 * need to check any of them here.
+		 */
+		if (ext4_ext_is_uninitialized(ex))
+			uninitialized = 1;
+		ex->ee_len = cpu_to_le16(ext4_ext_get_actual_len(ex)
+					 + ext4_ext_get_actual_len(newext));
+		if(uninitialized)
+			ext4_mark_uninitialized_ext(ex);
 		eh = path[depth].p_hdr;
 		nearex = ex;
 		goto merge;
@@ -1203,7 +1225,7 @@
 		ext_debug("first extent in the leaf: %d:%llu:%d\n",
 			        le32_to_cpu(newext->ee_block),
 			        ext_pblock(newext),
-			        le16_to_cpu(newext->ee_len));
+			        ext4_ext_get_actual_len(newext));
 		path[depth].p_ext = EXT_FIRST_EXTENT(eh);
 	} else if (le32_to_cpu(newext->ee_block)
 		           > le32_to_cpu(nearex->ee_block)) {
@@ -1216,7 +1238,7 @@
 					"move %d from 0x%p to 0x%p\n",
 				        le32_to_cpu(newext->ee_block),
 				        ext_pblock(newext),
-				        le16_to_cpu(newext->ee_len),
+				        ext4_ext_get_actual_len(newext),
 					nearex, len, nearex + 1, nearex + 2);
 			memmove(nearex + 2, nearex + 1, len);
 		}
@@ -1229,7 +1251,7 @@
 				"move %d from 0x%p to 0x%p\n",
 				le32_to_cpu(newext->ee_block),
 				ext_pblock(newext),
-				le16_to_cpu(newext->ee_len),
+				ext4_ext_get_actual_len(newext),
 				nearex, len, nearex + 1, nearex + 2);
 		memmove(nearex + 1, nearex, len);
 		path[depth].p_ext = nearex;
@@ -1248,8 +1270,13 @@
 		if (!ext4_can_extents_be_merged(inode, nearex, nearex + 1))
 			break;
 		/* merge with next extent! */
-		nearex->ee_len = cpu_to_le16(le16_to_cpu(nearex->ee_len)
-					     + le16_to_cpu(nearex[1].ee_len));
+		if (ext4_ext_is_uninitialized(nearex))
+                        uninitialized = 1;
+                nearex->ee_len = cpu_to_le16(ext4_ext_get_actual_len(nearex)
+                                         + ext4_ext_get_actual_len(nearex + 1));
+                if(uninitialized)
+                        ext4_mark_uninitialized_ext(nearex);
+
 		if (nearex + 1 < EXT_LAST_EXTENT(eh)) {
 			len = (EXT_LAST_EXTENT(eh) - nearex - 1)
 					* sizeof(struct ext4_extent);
@@ -1319,8 +1346,8 @@
 			end = le32_to_cpu(ex->ee_block);
 			if (block + num < end)
 				end = block + num;
-		} else if (block >=
-			     le32_to_cpu(ex->ee_block) + le16_to_cpu(ex->ee_len)) {
+		} else if (block >= le32_to_cpu(ex->ee_block) 
+						+ ext4_ext_get_actual_len(ex)) {
 			/* need to allocate space after found extent */
 			start = block;
 			end = block + num;
@@ -1332,7 +1359,8 @@
 			 * by found extent
 			 */
 			start = block;
-			end = le32_to_cpu(ex->ee_block) + le16_to_cpu(ex->ee_len);
+			end = le32_to_cpu(ex->ee_block) 
+						+ ext4_ext_get_actual_len(ex);
 			if (block + num < end)
 				end = block + num;
 			exists = 1;
@@ -1348,7 +1376,7 @@
 			cbex.ec_type = EXT4_EXT_CACHE_GAP;
 		} else {
 		        cbex.ec_block = le32_to_cpu(ex->ee_block);
-		        cbex.ec_len = le16_to_cpu(ex->ee_len);
+		        cbex.ec_len = ext4_ext_get_actual_len(ex);
 		        cbex.ec_start = ext_pblock(ex);
 			cbex.ec_type = EXT4_EXT_CACHE_EXTENT;
 		}
@@ -1556,12 +1584,12 @@
 				unsigned long from, unsigned long to)
 {
 	struct buffer_head *bh;
+	unsigned short ee_len =  ext4_ext_get_actual_len(ex);
 	int i;
 
 #ifdef EXTENTS_STATS
 	{
 		struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-		unsigned short ee_len =  le16_to_cpu(ex->ee_len);
 		spin_lock(&sbi->s_ext_stats_lock);
 		sbi->s_ext_blocks += ee_len;
 		sbi->s_ext_extents++;
@@ -1575,12 +1603,12 @@
 	}
 #endif
 	if (from >= le32_to_cpu(ex->ee_block)
-	    && to == le32_to_cpu(ex->ee_block) + le16_to_cpu(ex->ee_len) - 1) {
+	    && to == le32_to_cpu(ex->ee_block) + ee_len - 1) {
 		/* tail removal */
 		unsigned long num;
 		ext4_fsblk_t start;
-		num = le32_to_cpu(ex->ee_block) + le16_to_cpu(ex->ee_len) - from;
-		start = ext_pblock(ex) + le16_to_cpu(ex->ee_len) - num;
+		num = le32_to_cpu(ex->ee_block) + ee_len - from;
+		start = ext_pblock(ex) + ee_len - num;
 		ext_debug("free last %lu blocks starting %llu\n", num, start);
 		for (i = 0; i < num; i++) {
 			bh = sb_find_get_block(inode->i_sb, start + i);
@@ -1588,12 +1616,12 @@
 		}
 		ext4_free_blocks(handle, inode, start, num);
 	} else if (from == le32_to_cpu(ex->ee_block)
-		   && to <= le32_to_cpu(ex->ee_block) + le16_to_cpu(ex->ee_len) - 1) {
+		   && to <= le32_to_cpu(ex->ee_block) + ee_len - 1) {
 		printk("strange request: removal %lu-%lu from %u:%u\n",
-		       from, to, le32_to_cpu(ex->ee_block), le16_to_cpu(ex->ee_len));
+		       from, to, le32_to_cpu(ex->ee_block), ee_len);
 	} else {
 		printk("strange request: removal(2) %lu-%lu from %u:%u\n",
-		       from, to, le32_to_cpu(ex->ee_block), le16_to_cpu(ex->ee_len));
+		       from, to, le32_to_cpu(ex->ee_block), ee_len);
 	}
 	return 0;
 }
@@ -1607,7 +1635,7 @@
 	struct ext4_extent_header *eh;
 	unsigned a, b, block, num;
 	unsigned long ex_ee_block;
-	unsigned short ex_ee_len;
+	unsigned short ex_ee_len, uninitialized = 0;
 	struct ext4_extent *ex;
 
 	ext_debug("truncate since %lu in leaf\n", start);
@@ -1622,7 +1650,9 @@
 	ex = EXT_LAST_EXTENT(eh);
 
 	ex_ee_block = le32_to_cpu(ex->ee_block);
-	ex_ee_len = le16_to_cpu(ex->ee_len);
+	if(ext4_ext_is_uninitialized(ex))
+		uninitialized = 1;
+	ex_ee_len = ext4_ext_get_actual_len(ex);
 
 	while (ex >= EXT_FIRST_EXTENT(eh) &&
 			ex_ee_block + ex_ee_len > start) {
@@ -1690,6 +1720,8 @@
 
 		ex->ee_block = cpu_to_le32(block);
 		ex->ee_len = cpu_to_le16(num);
+		if(uninitialized)
+			ext4_mark_uninitialized_ext(ex);
 
 		err = ext4_ext_dirty(handle, inode, path + depth);
 		if (err)
@@ -1699,7 +1731,7 @@
 				ext_pblock(ex));
 		ex--;
 		ex_ee_block = le32_to_cpu(ex->ee_block);
-		ex_ee_len = le16_to_cpu(ex->ee_len);
+		ex_ee_len = ext4_ext_get_actual_len(ex);
 	}
 
 	if (correct_index && eh->eh_entries)
@@ -1974,7 +2006,7 @@
 	if ((ex = path[depth].p_ext)) {
 	        unsigned long ee_block = le32_to_cpu(ex->ee_block);
 		ext4_fsblk_t ee_start = ext_pblock(ex);
-		unsigned short ee_len  = le16_to_cpu(ex->ee_len);
+		unsigned short ee_len;
 
 		/*
 		 * Allow future support for preallocated extents to be added
@@ -1982,8 +2014,11 @@
 		 * Uninitialized extents are treated as holes, except that
 		 * we avoid (fail) allocating new blocks during a write.
 		 */
-		if (ee_len > EXT_MAX_LEN)
+		if (le16_to_cpu(ex->ee_len) > EXT_MAX_LEN
+				&& create != EXT4_CREATE_UNINITIALIZED_EXT)
 			goto out2;
+
+		ee_len  = ext4_ext_get_actual_len(ex);
 		/* if found extent covers block, simply return it */
 	        if (iblock >= ee_block && iblock < ee_block + ee_len) {
 			newblock = iblock - ee_block + ee_start;
@@ -1991,8 +2026,10 @@
 			allocated = ee_len - (iblock - ee_block);
 			ext_debug("%d fit into %lu:%d -> %llu\n", (int) iblock,
 					ee_block, ee_len, newblock);
-			ext4_ext_put_in_cache(inode, ee_block, ee_len,
-						ee_start, EXT4_EXT_CACHE_EXTENT);
+			/* Do not put uninitialized extent in the cache */
+			if(!ext4_ext_is_uninitialized(ex))
+				ext4_ext_put_in_cache(inode, ee_block, ee_len,
+					ee_start, EXT4_EXT_CACHE_EXTENT);
 			goto out;
 		}
 	}
@@ -2027,6 +2064,8 @@
 	newex.ee_block = cpu_to_le32(iblock);
 	ext4_ext_store_pblock(&newex, newblock);
 	newex.ee_len = cpu_to_le16(allocated);
+	if(create == EXT4_CREATE_UNINITIALIZED_EXT)  /* Mark uninitialized */
+		ext4_mark_uninitialized_ext(&newex);
 	err = ext4_ext_insert_extent(handle, inode, path, &newex);
 	if (err)
 		goto out2;
@@ -2038,8 +2077,10 @@
 	newblock = ext_pblock(&newex);
 	__set_bit(BH_New, &bh_result->b_state);
 
-	ext4_ext_put_in_cache(inode, iblock, allocated, newblock,
-				EXT4_EXT_CACHE_EXTENT);
+	/* Cache only when it is _not_ an uninitialized extent */
+	if(create!=EXT4_CREATE_UNINITIALIZED_EXT)
+		ext4_ext_put_in_cache(inode, iblock, allocated, newblock,
+						EXT4_EXT_CACHE_EXTENT);
 out:
 	if (allocated > max_blocks)
 		allocated = max_blocks;
Index: linux-2.6.19/fs/ext4/ioctl.c
===================================================================
--- linux-2.6.19.orig/fs/ext4/ioctl.c	2006-12-06 10:18:12.000000000 +0530
+++ linux-2.6.19/fs/ext4/ioctl.c	2006-12-06 10:18:15.000000000 +0530
@@ -248,6 +248,47 @@
 		return err;
 	}
 
+	case EXT4_IOC_PREALLOCATE: {
+		struct ext4_falloc_input input;
+		handle_t *handle;
+		ext4_fsblk_t block, max_blocks;
+		int ret = 0;
+		struct buffer_head map_bh;
+		unsigned int blkbits = inode->i_blkbits;
+
+		if (IS_RDONLY(inode))
+                        return -EROFS;
+
+		if (copy_from_user(&input,
+			(struct ext4_falloc_input __user *) arg, sizeof(input)))
+                        return -EFAULT;
+
+		if (input.len == 0)
+			return -EINVAL;
+
+		if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
+			return -ENOTTY;
+
+		block = EXT4_BLOCK_ALIGN(input.offset, blkbits) >> blkbits;
+		max_blocks = EXT4_BLOCK_ALIGN(input.len, blkbits) >> blkbits;
+		handle=ext4_journal_start(inode,
+				EXT4_DATA_TRANS_BLOCKS(inode->i_sb)+max_blocks);
+		if (IS_ERR(handle))
+			return PTR_ERR(handle);
+		while(ret>=0 && ret<max_blocks)
+		{
+			block = block + ret;
+			max_blocks = max_blocks - ret;
+	  		ret = ext4_ext_get_blocks(handle, inode, block,
+					max_blocks, &map_bh,
+					EXT4_CREATE_UNINITIALIZED_EXT, 1);
+		}
+		ext4_mark_inode_dirty(handle, inode);
+		ext4_journal_stop(handle);
+
+		return ret>0?0:ret;
+	}
+
 	default:
 		return -ENOTTY;
 	}
Index: linux-2.6.19/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.19.orig/include/linux/ext4_fs.h	2006-12-06 10:18:12.000000000 +0530
+++ linux-2.6.19/include/linux/ext4_fs.h	2006-12-06 10:18:16.000000000 +0530
@@ -102,6 +102,8 @@
 				 EXT4_GOOD_OLD_FIRST_INO : \
 				 (s)->s_first_ino)
 #endif
+#define EXT4_BLOCK_ALIGN(size, blkbits) 	(((size)+(1 << blkbits)-1) & \
+							(~((1 << blkbits)-1)))
 
 /*
  * Macro-instructions used to manage fragments
@@ -118,6 +120,19 @@
 #endif
 
 /*
+ * Macro-instructions used to handle (mark/unmark/check/create) unitialized
+ * extents. Applications can issue an IOCTL for preallocation, which results
+ * in assigning unitialized extents to the file
+ */
+#define EXT4_CREATE_UNINITIALIZED_EXT		2
+#define ext4_mark_uninitialized_ext(ext)	((ext)->ee_len |= \
+							cpu_to_le16(0x8000))
+#define ext4_ext_is_uninitialized(ext)		((le16_to_cpu((ext)->ee_len))& \
+									0x8000)
+#define ext4_ext_get_actual_len(ext)		((le16_to_cpu((ext)->ee_len))& \
+									0x7FFF)
+
+/*
  * Structure of a blocks group descriptor
  */
 struct ext4_group_desc
@@ -225,6 +240,11 @@
 	__u32 free_blocks_count;
 };
 
+/* The struct ext4_falloc_input in kernel, for EXT4_IOC_PREALLOCATE */
+struct ext4_falloc_input {
+	__u64 offset;
+	__u64 len;
+};
 
 /*
  * ioctl commands
@@ -242,6 +262,7 @@
 #endif
 #define EXT4_IOC_GETRSVSZ		_IOR('f', 5, long)
 #define EXT4_IOC_SETRSVSZ		_IOW('f', 6, long)
+#define EXT4_IOC_PREALLOCATE		_IOW('f', 9, struct ext4_falloc_input)
 
 /*
  * ioctl commands in 32 bit emulation
