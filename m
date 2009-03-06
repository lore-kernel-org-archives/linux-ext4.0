From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] fix header check in ext4_ext_search_right() for deep extent
 trees.
Date: Fri, 06 Mar 2009 14:50:51 -0600
Message-ID: <49B18CAB.5020605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: David Dindorp <ddi@dubex.dk>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:54287 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbZCFUu5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Mar 2009 15:50:57 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This should resolve kernel.org bugzilla 12821

I've not actually crafted a workload to exercise this code; 
this is from inspection...

The ext4_ext_search_right() function is confusing; it uses a
"depth" variable which is 0 at the root and maximum at the leaves, 
but the on-disk metadata uses a "depth" (actually eh_depth) which
is opposite: maximum at the root, and 0 at the leaves.

The ext4_ext_check_header() function is given a depth and checks
the header agaisnt that depth; it expects the on-disk semantics,
but we are giving it the opposite in the while loop in this 
function.  We should be giving it the on-disk notion of "depth"
which we can get from (p_depth - depth) - and if you look, the last
(more commonly hit) call to ext4_ext_check_header() does just this.

Sending in the wrong depth results in (incorrect) messages
about corruption:

EXT4-fs error (device sdb1): ext4_ext_search_right: bad header
in inode #2621457: unexpected eh_depth - magic f30a, entries 340,
max 340(0), depth 1(2)

Reported-by: David Dindorp <ddi@dubex.dk>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
--

Index: linux-2.6/fs/ext4/extents.c
===================================================================
--- linux-2.6.orig/fs/ext4/extents.c
+++ linux-2.6/fs/ext4/extents.c
@@ -1122,7 +1122,8 @@ ext4_ext_search_right(struct inode *inod
 	struct ext4_extent_idx *ix;
 	struct ext4_extent *ex;
 	ext4_fsblk_t block;
-	int depth, ee_len;
+	int depth;	/* Note, NOT eh_depth; depth from top of tree */
+	int ee_len;
 
 	BUG_ON(path == NULL);
 	depth = path->p_depth;
@@ -1179,7 +1180,8 @@ got_index:
 		if (bh == NULL)
 			return -EIO;
 		eh = ext_block_hdr(bh);
-		if (ext4_ext_check_header(inode, eh, depth)) {
+		/* subtract from p_depth to get proper eh_depth */
+		if (ext4_ext_check_header(inode, eh, path->p_depth - depth)) {
 			put_bh(bh);
 			return -EIO;
 		}

