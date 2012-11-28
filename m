From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/1] ext4: Remove duplicate inclusion of ext4_extents.h
 in super.c
Date: Wed, 28 Nov 2012 13:08:34 -0500
Message-ID: <20121128180834.GD24431@thunk.org>
References: <1353323842-32283-1-git-send-email-sachin.kamat@linaro.org>
 <20121119133944.GA11095@gmail.com>
 <CAK9yfHyLzJE+rH3L0UN1x2dVNcEdaR=F7Z_Q2NfTidV2GKuP=g@mail.gmail.com>
 <20121119162356.GB2337@gmail.com>
 <CAK9yfHyVJjxX46C8b6fduxTmEeqvx5p9j-bE7X9v=Wcpq9aLVA@mail.gmail.com>
 <CAK9yfHxMBmLAoNTKbvAoCYEyA9zqumao6Ou-WWOD4PZwMtGiaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
	patches@linaro.org, Zheng Liu <gnehzuil.liu@gmail.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35496 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755573Ab2K1SIi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Nov 2012 13:08:38 -0500
Content-Disposition: inline
In-Reply-To: <CAK9yfHxMBmLAoNTKbvAoCYEyA9zqumao6Ou-WWOD4PZwMtGiaA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is the patch which I plan to be using instead.  There is more
cleanup that could be done, but I assume the reason the reason why you
were interested in this was to reduce ext4's compile time (we have
protection against double inclusion, so it otherwise wouldn't have
made much difference).  So this approach (which I had suggested and
had been hoping you would do :-) is better in that regard...

    	 	    	     	    - Ted

commit 4a092d737955301da22b9d5e07f5036da821a932
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Wed Nov 28 13:03:30 2012 -0500

    ext4: rationalize ext4_extents.h inclusion
    
    Previously, ext4_extents.h was being included at the end of ext4.h,
    which was bad for a number of reasons: (a) it was not being included
    in the expected place, and (b) it caused the header to be included
    multiple times.  There were #ifdef's to prevent this from causing any
    problems, but it still was unnecessary.
    
    By moving the function declarations that were in ext4_extents.h to
    ext4.h, which is standard practice for where the function declarations
    for the rest of ext4.h can be found, we can remove ext4_extents.h from
    being included in ext4.h at all, and then we can only include
    ext4_extents.h where it is needed in ext4's source files.
    
    It should be possible to move a few more things into ext4.h, and
    further reduce the number of source files that need to #include
    ext4_extents.h, but that's a cleanup for another day.
    
    Reported-by: Sachin Kamat <sachin.kamat@linaro.org>
    Reported-by: Wei Yongjun <weiyj.lk@gmail.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 246e38f..2e9ffa9 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -57,6 +57,16 @@
 #define ext4_debug(fmt, ...)	no_printk(fmt, ##__VA_ARGS__)
 #endif
 
+/*
+ * Turn on EXT_DEBUG to get lots of info about extents operations.
+ */
+#define EXT_DEBUG__
+#ifdef EXT_DEBUG
+#define ext_debug(fmt, ...)	printk(fmt, ##__VA_ARGS__)
+#else
+#define ext_debug(fmt, ...)	no_printk(fmt, ##__VA_ARGS__)
+#endif
+
 #define EXT4_ERROR_INODE(inode, fmt, a...) \
 	ext4_error_inode((inode), __func__, __LINE__, 0, (fmt), ## a)
 
@@ -2399,6 +2409,9 @@ extern int ext4_check_blockref(const char *, unsigned int,
 			       struct inode *, __le32 *, unsigned int);
 
 /* extents.c */
+struct ext4_ext_path;
+struct ext4_extent;
+
 extern int ext4_ext_tree_init(handle_t *handle, struct inode *);
 extern int ext4_ext_writepage_trans_blocks(struct inode *, int);
 extern int ext4_ext_index_trans_blocks(struct inode *inode, int nrblocks,
@@ -2416,8 +2429,27 @@ extern int ext4_convert_unwritten_extents(struct inode *inode, loff_t offset,
 			  ssize_t len);
 extern int ext4_map_blocks(handle_t *handle, struct inode *inode,
 			   struct ext4_map_blocks *map, int flags);
+extern int ext4_ext_calc_metadata_amount(struct inode *inode,
+					 ext4_lblk_t lblocks);
+extern int ext4_extent_tree_init(handle_t *, struct inode *);
+extern int ext4_ext_calc_credits_for_single_extent(struct inode *inode,
+						   int num,
+						   struct ext4_ext_path *path);
+extern int ext4_can_extents_be_merged(struct inode *inode,
+				      struct ext4_extent *ex1,
+				      struct ext4_extent *ex2);
+extern int ext4_ext_insert_extent(handle_t *, struct inode *,
+				  struct ext4_ext_path *,
+				  struct ext4_extent *, int);
+extern struct ext4_ext_path *ext4_ext_find_extent(struct inode *, ext4_lblk_t,
+						  struct ext4_ext_path *);
+extern void ext4_ext_drop_refs(struct ext4_ext_path *);
+extern int ext4_ext_check_inode(struct inode *inode);
+extern int ext4_find_delalloc_cluster(struct inode *inode, ext4_lblk_t lblk);
 extern int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			__u64 start, __u64 len);
+
+
 /* move_extent.c */
 extern int ext4_move_extents(struct file *o_filp, struct file *d_filp,
 			     __u64 start_orig, __u64 start_donor,
@@ -2505,6 +2537,4 @@ extern void ext4_resize_end(struct super_block *sb);
 
 #endif	/* __KERNEL__ */
 
-#include "ext4_extents.h"
-
 #endif	/* _EXT4_H */
diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
index 173b6c5..487fda1 100644
--- a/fs/ext4/ext4_extents.h
+++ b/fs/ext4/ext4_extents.h
@@ -43,16 +43,6 @@
 #define CHECK_BINSEARCH__
 
 /*
- * Turn on EXT_DEBUG to get lots of info about extents operations.
- */
-#define EXT_DEBUG__
-#ifdef EXT_DEBUG
-#define ext_debug(fmt, ...)	printk(fmt, ##__VA_ARGS__)
-#else
-#define ext_debug(fmt, ...)	no_printk(fmt, ##__VA_ARGS__)
-#endif
-
-/*
  * If EXT_STATS is defined then stats numbers are collected.
  * These number will be displayed at umount time.
  */
@@ -286,20 +276,5 @@ static inline void ext4_idx_store_pblock(struct ext4_extent_idx *ix,
 				     0xffff);
 }
 
-extern int ext4_ext_calc_metadata_amount(struct inode *inode,
-					 ext4_lblk_t lblocks);
-extern int ext4_extent_tree_init(handle_t *, struct inode *);
-extern int ext4_ext_calc_credits_for_single_extent(struct inode *inode,
-						   int num,
-						   struct ext4_ext_path *path);
-extern int ext4_can_extents_be_merged(struct inode *inode,
-				      struct ext4_extent *ex1,
-				      struct ext4_extent *ex2);
-extern int ext4_ext_insert_extent(handle_t *, struct inode *, struct ext4_ext_path *, struct ext4_extent *, int);
-extern struct ext4_ext_path *ext4_ext_find_extent(struct inode *, ext4_lblk_t,
-							struct ext4_ext_path *);
-extern void ext4_ext_drop_refs(struct ext4_ext_path *);
-extern int ext4_ext_check_inode(struct inode *inode);
-extern int ext4_find_delalloc_cluster(struct inode *inode, ext4_lblk_t lblk);
 #endif /* _EXT4_EXTENTS */
 
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 5625146..1dc19a7 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -41,6 +41,7 @@
 #include <asm/uaccess.h>
 #include <linux/fiemap.h>
 #include "ext4_jbd2.h"
+#include "ext4_extents.h"
 
 #include <trace/events/ext4.h>
 
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index f6663c3..20862f9 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -22,6 +22,7 @@
 
 #include "ext4_jbd2.h"
 #include "truncate.h"
+#include "ext4_extents.h"	/* Needed for EXT_MAX_BLOCKS */
 
 #include <trace/events/ext4.h>
 
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index f1bb32e..db8226d 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -14,6 +14,7 @@
 
 #include <linux/slab.h>
 #include "ext4_jbd2.h"
+#include "ext4_extents.h"
 
 /*
  * The contiguous blocks details which can be
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 292daee..d9cc5ee 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include "ext4_jbd2.h"
 #include "ext4.h"
+#include "ext4_extents.h"
 
 /**
  * get_ext_path - Find an extent path for designated logical block number.
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 0fd16e6..0016fbc 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -27,7 +27,6 @@
 #include "ext4_jbd2.h"
 #include "xattr.h"
 #include "acl.h"
-#include "ext4_extents.h"
 
 static struct kmem_cache *io_page_cachep, *io_end_cachep;
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 66a4e20..856206f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -45,12 +45,11 @@
 #include <linux/freezer.h>
 
 #include "ext4.h"
-#include "ext4_extents.h"
+#include "ext4_extents.h"	/* Needed for trace points definition */
 #include "ext4_jbd2.h"
 #include "xattr.h"
 #include "acl.h"
 #include "mballoc.h"
-#include "ext4_extents.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/ext4.h>
