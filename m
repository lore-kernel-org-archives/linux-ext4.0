From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] Faster ext2_clear_inode()
Date: Mon, 9 Jul 2007 08:11:22 +0400
Message-ID: <20070709041122.GA5889@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: akpm@osdl.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:48669 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbXGIEL1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Jul 2007 00:11:27 -0400
Received: by ug-out-1314.google.com with SMTP id j3so1063570ugf
        for <linux-ext4@vger.kernel.org>; Sun, 08 Jul 2007 21:11:25 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

If CONFIG_EXT2_FS_POSIX_ACL is not configured, ext2_clear_inode() will be empty
function. However, there still will be call and immediate return which can be
avoided.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/ext2/super.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -184,9 +184,9 @@ static void destroy_inodecache(void)
 	kmem_cache_destroy(ext2_inode_cachep);
 }
 
+#ifdef CONFIG_EXT2_FS_POSIX_ACL
 static void ext2_clear_inode(struct inode *inode)
 {
-#ifdef CONFIG_EXT2_FS_POSIX_ACL
 	struct ext2_inode_info *ei = EXT2_I(inode);
 
 	if (ei->i_acl && ei->i_acl != EXT2_ACL_NOT_CACHED) {
@@ -197,8 +197,10 @@ static void ext2_clear_inode(struct inode *inode)
 		posix_acl_release(ei->i_default_acl);
 		ei->i_default_acl = EXT2_ACL_NOT_CACHED;
 	}
-#endif
 }
+#else
+#define ext2_clear_inode NULL
+#endif
 
 static int ext2_show_options(struct seq_file *seq, struct vfsmount *vfs)
 {
