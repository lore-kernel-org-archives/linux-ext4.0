From: Theodore Tso <tytso@mit.edu>
Subject: Re: [patch 2/2] move init_ext4_proc() last and add cleanup call exit_ext4_proc()
Date: Tue, 9 Oct 2007 20:41:16 -0400
Message-ID: <20071010004116.GN31713@thunk.org>
References: <20071009055033.145153755@au1.ibm.com> <20071009061102.363619477@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, akpm@linux-foundation.org
To: markn@au1.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:50178 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176AbXJJAlV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Oct 2007 20:41:21 -0400
Content-Disposition: inline
In-Reply-To: <20071009061102.363619477@au1.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Oct 09, 2007 at 03:50:35PM +1000, markn@au1.ibm.com wrote:
> The first problem that is addressed is that the addition of init_ext4_proc()
> means that the code doesn't clean up after itself on a failure of
> init_ext4_xattr(), and the second is that usually init_*_proc() should be
> the last thing called, so we move it to the end and add the cleanup call to
> exit_ext4_proc().

I've fixed the first simply by just doing this.  The order really
doesn't matter much here, and in fact it would probably be better to
change {init,exit}_ext4_proc() to be {init,exit}_ext4_mballoc() since
that's actually more accurate, and you need the call to
init_ext4_proc() even if you aren't using procfs.

I will fold this into the mballoc-core.patch.

		      	     	    	  - Ted

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 2305af4..b247ca0 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2845,7 +2845,7 @@ static int ext4_mb_destroy_per_dev_proc(struct super_block *sb)
 	return 0;
 }
 
-int __init init_ext4_proc(void)
+int __init init_ext4_mballoc(void)
 {
 	ext4_pspace_cachep =
 		kmem_cache_create("ext4_prealloc_space",
@@ -2863,7 +2863,7 @@ int __init init_ext4_proc(void)
 	return 0;
 }
 
-void exit_ext4_proc(void)
+void exit_ext4_mballoc(void)
 {
 	/* XXX: synchronize_rcu(); */
 	kmem_cache_destroy(ext4_pspace_cachep);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 30e2b64..5882165 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2994,13 +2994,13 @@ static int __init init_ext4_fs(void)
 {
 	int err;
 
-	err = init_ext4_proc();
+	err = init_ext4_mballoc();
 	if (err)
 		return err;
 
 	err = init_ext4_xattr();
 	if (err)
-		return err;
+		goto out2;
 	err = init_inodecache();
 	if (err)
 		goto out1;
@@ -3012,6 +3012,8 @@ out:
 	destroy_inodecache();
 out1:
 	exit_ext4_xattr();
+out2:
+	exit_ext4_mballoc();
 	return err;
 }
 
@@ -3020,7 +3022,7 @@ static void __exit exit_ext4_fs(void)
 	unregister_filesystem(&ext4dev_fs_type);
 	destroy_inodecache();
 	exit_ext4_xattr();
-	exit_ext4_proc();
+	exit_ext4_mballoc();
 }
 
 MODULE_AUTHOR("Remy Card, Stephen Tweedie, Andrew Morton, Andreas Dilger, Theodore Ts'o and others");
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 6a0909f..783c6f3 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -954,8 +954,8 @@ extern int ext4_mb_release(struct super_block *);
 extern ext4_fsblk_t ext4_mb_new_blocks(handle_t *, struct ext4_allocation_request *, int *);
 extern int ext4_mb_reserve_blocks(struct super_block *, int);
 extern void ext4_mb_discard_inode_preallocations(struct inode *);
-extern int __init init_ext4_proc(void);
-extern void exit_ext4_proc(void);
+extern int __init init_ext4_mballoc(void);
+extern void exit_ext4_mballoc(void);
 extern void ext4_mb_free_blocks(handle_t *, struct inode *,
 		unsigned long, unsigned long, int, unsigned long *);
 
