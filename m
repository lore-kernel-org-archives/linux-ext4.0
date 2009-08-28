From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH]ext4: Enable mount ext4 with AGGRESSIVE_TEST
Date: Fri, 28 Aug 2009 10:40:45 -0400
Message-ID: <20090828144045.GH16732@mit.edu>
References: <4A96118F.5040707@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:36163 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbZH1Okq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Aug 2009 10:40:46 -0400
Content-Disposition: inline
In-Reply-To: <4A96118F.5040707@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 27, 2009 at 01:54:39PM +0900, Akira Fujita wrote:
> When the AGGRESSIVE_TEST is enabled,
> the maximum extent count of inode becomes '3' in ext4_ext_space_root(),
> but __ext4_ext_check() which is called via ext4_fill_super()
> checks eh_max is larger '4', therefore we always get -EIO and can not mount ext4.
> The patch fix this issue.

This isn't really the right fix for the problem.

What's actually going on here is that the patch which added which
sanity checks for extents, which added (among other functions)
__ext4_ext_check() and ext4_ext_max_entries() doesn't quite work right
in the presence of AGGRESSIVE_TEST.

The goal of AGGRESSIVE_TEST is to stress test the extent tree insert
and deletion code by forcing the size of eh_max to be a smaller value
than it otherwise would be.  It did this by dropping in limits to the
values returned by ext4_ext_space_root(), ext4_ext_space_idx(),
ext4_ext_space_block(), and ext4_ext_block_idx().  This worked all
very well and coded when these functions were only used to initialize
the eh_max field.

The problem is that the extent checking code also used these functions
to check whether or not the extent tree was sane, and if
AGGRESSIVE_TEST was enabled, it caused the journal to be considered
invalid.

Your patch patches over the problem by changing ext4_ext_space_root to
fix the one case where a problem arises, which patches over the
problem for a freshly created filesystem, but it doesn't fix problems
that will arise for a populated filesystem.  It also decreases the
effectiveness of AGGRESSIVE_TEST.

The following patch is a better way of fixing the problem.

    	      	       	 	       - Ted

commit e07fa129e97b33b3f7772d98c184813ea7604a35
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Fri Aug 28 10:40:33 2009 -0400

    ext4: fix extent sanity checking code with AGGRESSIVE_TEST
    
    The extents sanity-checking code depends on the ext4_ext_space_*()
    functions returning the maximum alloable size for eh_max; however,
    when the debugging #ifdef AGGRESSIVE_TEST is enabled to test the
    extent tree handling code, this prevents a normally created ext4
    filesystem from being mounted with the errors:
    
    Aug 26 15:43:50 bsd086 kernel: [   96.070277] EXT4-fs error (device sda8): ext4_ext_check_inode: bad header/extent in inode #8: too large eh_max - magic f30a, entries 1, max 4(3), depth 0(0)
    Aug 26 15:43:50 bsd086 kernel: [   96.070526] EXT4-fs (sda8): no journal found
    
    Bug reported by Akira Fujita.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 94f40b1..f7bdd55 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -229,57 +229,65 @@ ext4_ext_new_meta_block(handle_t *handle, struct inode *inode,
 	return newblock;
 }
 
-static int ext4_ext_space_block(struct inode *inode)
+static inline int ext4_ext_space_block(struct inode *inode, int check)
 {
 	int size;
 
 	size = (inode->i_sb->s_blocksize - sizeof(struct ext4_extent_header))
 			/ sizeof(struct ext4_extent);
+	if (!check) {
 #ifdef AGGRESSIVE_TEST
-	if (size > 6)
-		size = 6;
+		if (size > 6)
+			size = 6;
 #endif
+	}
 	return size;
 }
 
-static int ext4_ext_space_block_idx(struct inode *inode)
+static inline int ext4_ext_space_block_idx(struct inode *inode, int check)
 {
 	int size;
 
 	size = (inode->i_sb->s_blocksize - sizeof(struct ext4_extent_header))
 			/ sizeof(struct ext4_extent_idx);
+	if (!check) {
 #ifdef AGGRESSIVE_TEST
-	if (size > 5)
-		size = 5;
+		if (size > 5)
+			size = 5;
 #endif
+	}
 	return size;
 }
 
-static int ext4_ext_space_root(struct inode *inode)
+static inline int ext4_ext_space_root(struct inode *inode, int check)
 {
 	int size;
 
 	size = sizeof(EXT4_I(inode)->i_data);
 	size -= sizeof(struct ext4_extent_header);
 	size /= sizeof(struct ext4_extent);
+	if (!check) {
 #ifdef AGGRESSIVE_TEST
-	if (size > 3)
-		size = 3;
+		if (size > 3)
+			size = 3;
 #endif
+	}
 	return size;
 }
 
-static int ext4_ext_space_root_idx(struct inode *inode)
+static inline int ext4_ext_space_root_idx(struct inode *inode, int check)
 {
 	int size;
 
 	size = sizeof(EXT4_I(inode)->i_data);
 	size -= sizeof(struct ext4_extent_header);
 	size /= sizeof(struct ext4_extent_idx);
+	if (!check) {
 #ifdef AGGRESSIVE_TEST
-	if (size > 4)
-		size = 4;
+		if (size > 4)
+			size = 4;
 #endif
+	}
 	return size;
 }
 
@@ -293,9 +301,9 @@ int ext4_ext_calc_metadata_amount(struct inode *inode, int blocks)
 	int lcap, icap, rcap, leafs, idxs, num;
 	int newextents = blocks;
 
-	rcap = ext4_ext_space_root_idx(inode);
-	lcap = ext4_ext_space_block(inode);
-	icap = ext4_ext_space_block_idx(inode);
+	rcap = ext4_ext_space_root_idx(inode, 0);
+	lcap = ext4_ext_space_block(inode, 0);
+	icap = ext4_ext_space_block_idx(inode, 0);
 
 	/* number of new leaf blocks needed */
 	num = leafs = (newextents + lcap - 1) / lcap;
@@ -320,14 +328,14 @@ ext4_ext_max_entries(struct inode *inode, int depth)
 
 	if (depth == ext_depth(inode)) {
 		if (depth == 0)
-			max = ext4_ext_space_root(inode);
+			max = ext4_ext_space_root(inode, 1);
 		else
-			max = ext4_ext_space_root_idx(inode);
+			max = ext4_ext_space_root_idx(inode, 1);
 	} else {
 		if (depth == 0)
-			max = ext4_ext_space_block(inode);
+			max = ext4_ext_space_block(inode, 1);
 		else
-			max = ext4_ext_space_block_idx(inode);
+			max = ext4_ext_space_block_idx(inode, 1);
 	}
 
 	return max;
@@ -626,7 +634,7 @@ int ext4_ext_tree_init(handle_t *handle, struct inode *inode)
 	eh->eh_depth = 0;
 	eh->eh_entries = 0;
 	eh->eh_magic = EXT4_EXT_MAGIC;
-	eh->eh_max = cpu_to_le16(ext4_ext_space_root(inode));
+	eh->eh_max = cpu_to_le16(ext4_ext_space_root(inode, 0));
 	ext4_mark_inode_dirty(handle, inode);
 	ext4_ext_invalidate_cache(inode);
 	return 0;
@@ -851,7 +859,7 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 
 	neh = ext_block_hdr(bh);
 	neh->eh_entries = 0;
-	neh->eh_max = cpu_to_le16(ext4_ext_space_block(inode));
+	neh->eh_max = cpu_to_le16(ext4_ext_space_block(inode, 0));
 	neh->eh_magic = EXT4_EXT_MAGIC;
 	neh->eh_depth = 0;
 	ex = EXT_FIRST_EXTENT(neh);
@@ -927,7 +935,7 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 		neh = ext_block_hdr(bh);
 		neh->eh_entries = cpu_to_le16(1);
 		neh->eh_magic = EXT4_EXT_MAGIC;
-		neh->eh_max = cpu_to_le16(ext4_ext_space_block_idx(inode));
+		neh->eh_max = cpu_to_le16(ext4_ext_space_block_idx(inode, 0));
 		neh->eh_depth = cpu_to_le16(depth - i);
 		fidx = EXT_FIRST_INDEX(neh);
 		fidx->ei_block = border;
@@ -1052,9 +1060,9 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
 	/* old root could have indexes or leaves
 	 * so calculate e_max right way */
 	if (ext_depth(inode))
-	  neh->eh_max = cpu_to_le16(ext4_ext_space_block_idx(inode));
+		neh->eh_max = cpu_to_le16(ext4_ext_space_block_idx(inode, 0));
 	else
-	  neh->eh_max = cpu_to_le16(ext4_ext_space_block(inode));
+		neh->eh_max = cpu_to_le16(ext4_ext_space_block(inode, 0));
 	neh->eh_magic = EXT4_EXT_MAGIC;
 	set_buffer_uptodate(bh);
 	unlock_buffer(bh);
@@ -1069,7 +1077,7 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
 		goto out;
 
 	curp->p_hdr->eh_magic = EXT4_EXT_MAGIC;
-	curp->p_hdr->eh_max = cpu_to_le16(ext4_ext_space_root_idx(inode));
+	curp->p_hdr->eh_max = cpu_to_le16(ext4_ext_space_root_idx(inode, 0));
 	curp->p_hdr->eh_entries = cpu_to_le16(1);
 	curp->p_idx = EXT_FIRST_INDEX(curp->p_hdr);
 
@@ -2348,7 +2356,7 @@ static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start)
 		if (err == 0) {
 			ext_inode_hdr(inode)->eh_depth = 0;
 			ext_inode_hdr(inode)->eh_max =
-				cpu_to_le16(ext4_ext_space_root(inode));
+				cpu_to_le16(ext4_ext_space_root(inode, 0));
 			err = ext4_ext_dirty(handle, inode, path);
 		}
 	}
