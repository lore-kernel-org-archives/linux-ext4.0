From: Pekka J Enberg <penberg@cs.helsinki.fi>
Subject: [RFC/PATCH] ext3: remove inode constructor
Date: Fri, 4 May 2007 13:14:35 +0300 (EEST)
Message-ID: <Pine.LNX.4.64.0705041311230.1455@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
	clameter@sgi.com
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45005 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612AbXEDKOi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 May 2007 06:14:38 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

As explained by Christoph Lameter, ext3_alloc_inode() touches the same
cache line as init_once() so we gain nothing from using slab
constructors.  The SLUB allocator will be more effective without it
(free pointer can be placed inside the free'd object), so move inode
initialization to ext3_alloc_inode completely.

[postmark: numbers = 10000, transactions = 10000, 2 GHz Pentium M]

2.6.21 vanilla:

  real	0m19.006s
  user	0m0.144s
  sys	0m7.424s

  real	0m9.040s
  user	0m0.156s
  sys	0m5.164s

  real	0m8.939s
  user	0m0.128s
  sys	0m5.180s

2.6.21 + ext3-remove-inode-constructor:

  real	0m19.176s
  user	0m0.176s
  sys	0m7.436s

  real	0m9.030s
  user	0m0.172s
  sys	0m5.120s

  real	0m8.966s
  user	0m0.168s
  sys	0m5.132s

Cc: Stephen C. Tweedie <sct@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger@clusterfs.com>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/ext3/super.c |   30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

Index: 2.6/fs/ext3/super.c
===================================================================
--- 2.6.orig/fs/ext3/super.c	2007-05-04 12:57:09.000000000 +0300
+++ 2.6/fs/ext3/super.c	2007-05-04 13:01:27.000000000 +0300
@@ -444,17 +444,26 @@ static struct kmem_cache *ext3_inode_cac
 static struct inode *ext3_alloc_inode(struct super_block *sb)
 {
 	struct ext3_inode_info *ei;
+	struct inode *inode;
 
 	ei = kmem_cache_alloc(ext3_inode_cachep, GFP_NOFS);
 	if (!ei)
 		return NULL;
+        INIT_LIST_HEAD(&ei->i_orphan);
+#ifdef CONFIG_EXT3_FS_XATTR
+        init_rwsem(&ei->xattr_sem);
+#endif
+        mutex_init(&ei->truncate_mutex);
 #ifdef CONFIG_EXT3_FS_POSIX_ACL
 	ei->i_acl = EXT3_ACL_NOT_CACHED;
 	ei->i_default_acl = EXT3_ACL_NOT_CACHED;
 #endif
 	ei->i_block_alloc_info = NULL;
-	ei->vfs_inode.i_version = 1;
-	return &ei->vfs_inode;
+
+	inode = &ei->vfs_inode;
+	inode_init_once(inode);
+	inode->i_version = 1;
+	return inode;
 }
 
 static void ext3_destroy_inode(struct inode *inode)
@@ -462,28 +471,13 @@ static void ext3_destroy_inode(struct in
 	kmem_cache_free(ext3_inode_cachep, EXT3_I(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
-{
-	struct ext3_inode_info *ei = (struct ext3_inode_info *) foo;
-
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
-		INIT_LIST_HEAD(&ei->i_orphan);
-#ifdef CONFIG_EXT3_FS_XATTR
-		init_rwsem(&ei->xattr_sem);
-#endif
-		mutex_init(&ei->truncate_mutex);
-		inode_init_once(&ei->vfs_inode);
-	}
-}
-
 static int init_inodecache(void)
 {
 	ext3_inode_cachep = kmem_cache_create("ext3_inode_cache",
 					     sizeof(struct ext3_inode_info),
 					     0, (SLAB_RECLAIM_ACCOUNT|
 						SLAB_MEM_SPREAD),
-					     init_once, NULL);
+					     NULL, NULL);
 	if (ext3_inode_cachep == NULL)
 		return -ENOMEM;
 	return 0;
