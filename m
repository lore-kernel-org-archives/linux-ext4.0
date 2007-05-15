From: Martin Michlmayr <tbm@cyrius.com>
Subject: Fix section conflict of ext4_ext_{find_goal,invalidate_cache}
Date: Tue, 15 May 2007 19:15:27 +0200
Message-ID: <20070515171527.GA20407@deprecation.cyrius.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sorrow.cyrius.com ([65.19.161.204]:2268 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757277AbXEOReV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 May 2007 13:34:21 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Building with GCC 4.2, I get the following error:

  CC [M]  fs/ext4/extents.o
fs/ext4/extents.c:2166: error: __ksymtab_ext4_ext_find_goal causes a section type conflict
fs/ext4/extents.c:2163: error: __ksymtab_ext4_ext_invalidate_cache causes a section type conflict

This is because ext4_ext_find_goal and ext4_ext_invalidate_cache are
declared static but also exported.

Signed-off-by: Martin Michlmayr <tbm@cyrius.com>

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -172,7 +172,7 @@ static int ext4_ext_dirty(handle_t *handle, struct inode *inode,
 	return err;
 }
 
-static ext4_fsblk_t ext4_ext_find_goal(struct inode *inode,
+ext4_fsblk_t ext4_ext_find_goal(struct inode *inode,
 			      struct ext4_ext_path *path,
 			      ext4_fsblk_t block)
 {
--- a/include/linux/ext4_fs_extents.h
+++ b/include/linux/ext4_fs_extents.h
@@ -182,7 +182,7 @@ static inline void ext4_ext_tree_changed(struct inode *inode)
 	EXT4_I(inode)->i_ext_generation++;
 }
 
-static inline void
+inline void
 ext4_ext_invalidate_cache(struct inode *inode)
 {
 	EXT4_I(inode)->i_cached_extent.ec_type = EXT4_EXT_CACHE_NO;

-- 
Martin Michlmayr
http://www.cyrius.com/
