From: Manish Katiyar <mkatiyar@gmail.com>
Subject: [PATCH 1/3] jbd2 : Make jbd2 transaction handle allocation to return
 errors and handle them gracefully.
Date: Sat, 22 Jan 2011 19:32:44 -0800
Message-ID: <AANLkTi=o-rcsbY1gOExGyWdQ41m7KWpJ7=UzX4306m=t@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: mkatiyar@gmail.com
To: Jan Kara <jack@suse.cz>, ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37535 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab1AWDdH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 22 Jan 2011 22:33:07 -0500
Received: by qwa26 with SMTP id 26so2977285qwa.19
        for <linux-ext4@vger.kernel.org>; Sat, 22 Jan 2011 19:33:06 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

 Hi Jan,

This is the follow up from https://lkml.org/lkml/2011/1/17/154
Following patches make jbd2 to use GFP_KERNEL for transaction
allocation if the caller can handle the errors. Following is the list
of functions that I updated to pass the new flag. Also below is the
list of functions which still have the old behavior and pass the old
flags (either because they can't deal with errors, or I wasn't too
sure so I did conservatively). Appreciate your feedback. The other
callers of jbd2_journal_start() are from ocfs2, they still pass the
old flag.

OK to handle errors.
-------------------------
ext4_init_inode_table
ext4_group_add
setup_new_group_blocks
update_backups
ext4_group_extend
ext4_release_dquot
ext4_acquire_dquot
ext4_acl_chmod
ext4_xattr_set_acl
ext4_xattr_set
et4_ioctl - For setting EXT4_IOC_SETVERSION_OLD
ext4_ext_migrate
ext4_ext_migrate
ext4_rmdir
ext4_unlink
ext4_symlink
ext4_link
ext4_rename
ext4_mkdir
ext4_mknod
ext4_fallocate
ext4_create
move_extent_per_page
ext4_change_inode_journal_flag
ext4_setattr
ext4_setattr

NOT ok
-------------------
ext4_write_dquot
ext4_ioctl - Not ok for EXT4_EOFBLOCKS_FL
ext4_ext_remove_space
ext4_ext_truncate
ext4_write_info
ext4_convert_unwritten_extents
ext4_ind_direct_IO
ext4_ind_direct_IO
ext4_dirty_inode
ext4_setattr
ext4_evict_inode
_ext4_get_block
ext4_write_begin
__ext4_journalled_writepage
ext4_da_writepages
ext4_da_write_begin
start_transaction

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 fs/jbd2/transaction.c |   12 +++++++-----
 include/linux/jbd2.h  |    4 ++--
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index faad2bd..0fa4c86 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -346,9 +346,10 @@ handle_t *jbd2__journal_start(journal_t *journal,
int nblocks, int gfp_mask)
 EXPORT_SYMBOL(jbd2__journal_start);


-handle_t *jbd2_journal_start(journal_t *journal, int nblocks)
+handle_t *jbd2_journal_start(journal_t *journal, int nblocks, bool errok)
 {
-	return jbd2__journal_start(journal, nblocks, GFP_NOFS);
+	return jbd2__journal_start(journal, nblocks,
+				   errok ? GFP_KERNEL : GFP_NOFS);
 }
 EXPORT_SYMBOL(jbd2_journal_start);

@@ -476,9 +477,10 @@ int jbd2__journal_restart(handle_t *handle, int
nblocks, int gfp_mask)
 EXPORT_SYMBOL(jbd2__journal_restart);


-int jbd2_journal_restart(handle_t *handle, int nblocks)
+int jbd2_journal_restart(handle_t *handle, int nblocks, bool errok)
 {
-	return jbd2__journal_restart(handle, nblocks, GFP_NOFS);
+	return jbd2__journal_restart(handle, nblocks,
+				     errok ? GFP_KERNEL : GFP_NOFS);
 }
 EXPORT_SYMBOL(jbd2_journal_restart);

@@ -1429,7 +1431,7 @@ int jbd2_journal_force_commit(journal_t *journal)
 	handle_t *handle;
 	int ret;

-	handle = jbd2_journal_start(journal, 1);
+	handle = jbd2_journal_start(journal, 1, false);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 	} else {
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 27e79c2..b24342f 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1081,9 +1081,9 @@ static inline handle_t *journal_current_handle(void)
  * Register buffer modifications against the current transaction.
  */

-extern handle_t *jbd2_journal_start(journal_t *, int nblocks);
+extern handle_t *jbd2_journal_start(journal_t *, int nblocks, bool errok);
 extern handle_t *jbd2__journal_start(journal_t *, int nblocks, int gfp_mask);
-extern int	 jbd2_journal_restart(handle_t *, int nblocks);
+extern int	 jbd2_journal_restart(handle_t *, int nblocks, bool errok);
 extern int	 jbd2__journal_restart(handle_t *, int nblocks, int gfp_mask);
 extern int	 jbd2_journal_extend (handle_t *, int nblocks);
 extern int	 jbd2_journal_get_write_access(handle_t *, struct buffer_head *);
-- 
1.6.0.4




-- 
Thanks -
Manish
==================================
[$\*.^ -- I miss being one of them
==================================
