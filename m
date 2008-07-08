From: Girish Shilamkar <Girish.Shilamkar@Sun.COM>
Subject: Re: [PATCH] EXT_MAX_BLOCK for >= 16TB fs
Date: Tue, 08 Jul 2008 23:42:30 +0530
Message-ID: <1215540750.6011.10.camel@alpha.linsyssoft.com>
References: <1215449732.1167.11.camel@alpha.linsyssoft.com>
 <1215521471.3249.15.camel@alpha.linsyssoft.com>
 <1215523338.3249.18.camel@alpha.linsyssoft.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_75uMxMsvSRNw25Os10HVmw)"
Cc: adilger@Sun.COM, Theodore Tso <tytso@mit.edu>
To: Ext4 Mailing List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-1.sun.com ([192.18.19.6]:59251 "EHLO
	sineb-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbYGHSMr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Jul 2008 14:12:47 -0400
Received: from fe-apac-06.sun.com (fe-apac-06.sun.com [192.18.19.177] (may be forged))
	by sineb-mail-1.sun.com (8.13.6+Sun/8.12.9) with ESMTP id m68IDCo8007642
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jul 2008 18:13:12 GMT
Received: from conversion-daemon.mail-apac.sun.com by mail-apac.sun.com
 (Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
 id <0K3P008018N62W00@mail-apac.sun.com>
 (original mail from Girish.Shilamkar@Sun.COM) for linux-ext4@vger.kernel.org;
 Wed, 09 Jul 2008 02:10:34 +0800 (SGT)
In-reply-to: <1215523338.3249.18.camel@alpha.linsyssoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Boundary_(ID_75uMxMsvSRNw25Os10HVmw)
Content-type: text/plain
Content-transfer-encoding: 7BIT

Hi, 
	Please disregard the last mail as it had incorrect patch, sorry for
that. 
The correct patch is attached here.

Thanks,
Girish



On Tue, 2008-07-08 at 18:52 +0530, Girish Shilamkar wrote:
> Oops ...
> 
> On Tue, 2008-07-08 at 18:21 +0530, Girish Shilamkar wrote:
> > Hi,	
> > 	Here is the patch for same.
> > 
> > Thanks,
> > Girish
> > 
> > On Mon, 2008-07-07 at 22:25 +0530, Girish Shilamkar wrote:
> > > Hi,
> > > 	The magic constant EXT_MAX_BLOCK = 0xffffffff in extents code is used
> > > in some places to return "invalid block number", and to set the extent
> > > length = "whole file" in other places.
> > > 	So with >= 16 TB fs we would prefer to use it differently. We can have
> > > EXT_UNSET_BLOCK = 1 to indicate "invalid block number" as it will never
> > > be valid block for allocation. And for "whole file" usecase we can
> > > continue using current EXT_MAX_BLOCK
> > > 
> > > Regards,
> > > Girish
> > > 
> > > 
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Boundary_(ID_75uMxMsvSRNw25Os10HVmw)
Content-type: text/x-patch; NAME=change-EXT_MAX_BLOCK.patch; charset=utf-8
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=change-EXT_MAX_BLOCK.patch
Content-description: 

Index: linux-2.6/fs/ext4/ext4_extents.h
===================================================================
--- linux-2.6.orig/fs/ext4/ext4_extents.h
+++ linux-2.6/fs/ext4/ext4_extents.h
@@ -139,6 +139,7 @@ typedef int (*ext_prepare_callback)(stru
 #define EXT_REPEAT     2
 
 #define EXT_MAX_BLOCK	0xffffffff
+#define EXT_UNSET_BLOCK 1
 
 /*
  * EXT_INIT_MAX_LEN is the maximum number of blocks we can have in an
Index: linux-2.6/fs/ext4/extents.c
===================================================================
--- linux-2.6.orig/fs/ext4/extents.c
+++ linux-2.6/fs/ext4/extents.c
@@ -1217,7 +1217,7 @@ ext4_ext_search_right(struct inode *inod
 
 /*
  * ext4_ext_next_allocated_block:
- * returns allocated block in subsequent extent or EXT_MAX_BLOCK.
+ * returns allocated block in subsequent extent or EXT_UNSET_BLOCK.
  * NOTE: it considers block number from index entry as
  * allocated block. Thus, index entries have to be consistent
  * with leaves.
@@ -1231,7 +1231,7 @@ ext4_ext_next_allocated_block(struct ext
 	depth = path->p_depth;
 
 	if (depth == 0 && path->p_ext == NULL)
-		return EXT_MAX_BLOCK;
+		return EXT_UNSET_BLOCK;
 
 	while (depth >= 0) {
 		if (depth == path->p_depth) {
@@ -1248,12 +1248,12 @@ ext4_ext_next_allocated_block(struct ext
 		depth--;
 	}
 
-	return EXT_MAX_BLOCK;
+	return EXT_UNSET_BLOCK;
 }
 
 /*
  * ext4_ext_next_leaf_block:
- * returns first allocated block from next leaf or EXT_MAX_BLOCK
+ * returns first allocated block from next leaf or EXT_UNSET_BLOCK
  */
 static ext4_lblk_t ext4_ext_next_leaf_block(struct inode *inode,
 					struct ext4_ext_path *path)
@@ -1265,7 +1265,7 @@ static ext4_lblk_t ext4_ext_next_leaf_bl
 
 	/* zero-tree has no leaf blocks at all */
 	if (depth == 0)
-		return EXT_MAX_BLOCK;
+		return EXT_UNSET_BLOCK;
 
 	/* go to index block */
 	depth--;
@@ -1278,7 +1278,7 @@ static ext4_lblk_t ext4_ext_next_leaf_bl
 		depth--;
 	}
 
-	return EXT_MAX_BLOCK;
+	return EXT_UNSET_BLOCK;
 }
 
 /*
@@ -1458,7 +1458,7 @@ unsigned int ext4_ext_check_overlap(stru
 	 */
 	if (b2 < b1) {
 		b2 = ext4_ext_next_allocated_block(path);
-		if (b2 == EXT_MAX_BLOCK)
+		if (b2 == EXT_UNSET_BLOCK)
 			goto out;
 	}
 
@@ -1551,7 +1551,7 @@ repeat:
 	fex = EXT_LAST_EXTENT(eh);
 	next = ext4_ext_next_leaf_block(inode, path);
 	if (le32_to_cpu(newext->ee_block) > le32_to_cpu(fex->ee_block)
-	    && next != EXT_MAX_BLOCK) {
+	    && next != EXT_UNSET_BLOCK) {
 		ext_debug("next leaf block - %d\n", next);
 		BUG_ON(npath != NULL);
 		npath = ext4_ext_find_extent(inode, next, NULL);
@@ -1671,7 +1671,7 @@ int ext4_ext_walk_space(struct inode *in
 	BUG_ON(func == NULL);
 	BUG_ON(inode == NULL);
 
-	while (block < last && block != EXT_MAX_BLOCK) {
+	while (block < last && block != EXT_UNSET_BLOCK) {
 		num = last - block;
 		/* find extent for this block */
 		path = ext4_ext_find_extent(inode, block, path);
@@ -1703,7 +1703,9 @@ int ext4_ext_walk_space(struct inode *in
 			/* need to allocate space after found extent */
 			start = block;
 			end = block + num;
-			if (end >= next)
+			if (next == EXT_UNSET_BLOCK)
+				end = EXT_MAX_BLOCK;
+			else if (end >= next)
 				end = next;
 		} else if (block >= le32_to_cpu(ex->ee_block)) {
 			/*
@@ -2021,8 +2023,8 @@ ext4_ext_rm_leaf(handle_t *handle, struc
 		path[depth].p_ext = ex;
 
 		a = ex_ee_block > start ? ex_ee_block : start;
-		b = ex_ee_block + ex_ee_len - 1 < EXT_MAX_BLOCK ?
-			ex_ee_block + ex_ee_len - 1 : EXT_MAX_BLOCK;
+		b = (unsigned long long)ex_ee_block + ex_ee_len - 1 <
+		    EXT_MAX_BLOCK ? ex_ee_block + ex_ee_len - 1 : EXT_MAX_BLOCK;
 
 		ext_debug("  border %u:%u\n", a, b);
 

--Boundary_(ID_75uMxMsvSRNw25Os10HVmw)--
