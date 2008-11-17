From: Kalpak Shah <Kalpak.Shah@Sun.COM>
Subject: [PATCH 1/2] Add goal argument to ext4_new_inode()
Date: Tue, 18 Nov 2008 02:06:17 +0530
Message-ID: <1226954177.3972.71.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_OvTkrWE+gyx236mbF9oN7A)"
Cc: TheodoreTso <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	Andreas Dilger <adilger@Sun.COM>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-2.sun.com ([192.18.19.7]:36684 "EHLO
	sineb-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbYKQUqB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Nov 2008 15:46:01 -0500
Received: from fe-apac-06.sun.com (fe-apac-06.sun.com [192.18.19.177] (may be forged))
	by sineb-mail-2.sun.com (8.13.6+Sun/8.12.9) with ESMTP id mAHKZblH015653
	for <linux-ext4@vger.kernel.org>; Mon, 17 Nov 2008 20:35:37 GMT
Received: from conversion-daemon.mail-apac.sun.com by mail-apac.sun.com
 (Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
 id <0KAH00701VT6D500@mail-apac.sun.com>
 (original mail from Kalpak.Shah@Sun.COM) for linux-ext4@vger.kernel.org; Tue,
 18 Nov 2008 04:35:37 +0800 (SGT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Boundary_(ID_OvTkrWE+gyx236mbF9oN7A)
Content-type: text/plain
Content-transfer-encoding: 7BIT

The EA inodes are not linked into any directory since a single directory
per filesystem will cause a bottleneck. Instead a "goal" argument has
been added to the ext4_new_inode() function to help a localized
selection of the EA inode. Since ext4_new_inode() only used the dir
argument to choose the group, we use goal argument to do the same.

Signed-off-by: Andreas Dilger <adilger@sun.com>
Signed-off-by: Kalpak Shah <kalpak.shah@sun.com>

 ext4.h    |    3 ++-
 ialloc.c  |   45 +++++++++++++++++++++++++++++++++++++++++++--
 migrate.c |    5 ++---
 namei.c   |    8 ++++----
 4 files changed, 51 insertions(+), 10 deletions(-)


Thanks,
Kalpak.


--Boundary_(ID_OvTkrWE+gyx236mbF9oN7A)
Content-type: text/x-patch; charset=UTF-8; name=ext4-new-inode-goal.patch
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=ext4-new-inode-goal.patch

Signed-off-by: Kalpak Shah <kalpak.shah@sun.com>
Signed-off-by: Andreas Dilger <adilger@sun.com>

Index: linux-2.6.27/fs/ext4/ialloc.c
===================================================================
--- linux-2.6.27.orig/fs/ext4/ialloc.c
+++ linux-2.6.27/fs/ext4/ialloc.c
@@ -578,8 +578,12 @@ static int find_group_other(struct super
  *
  * For other inodes, search forward from the parent directory's block
  * group to find a free inode.
+ *
+ * If a goal inode is specified then try to allocate it else continue
+ * allocation as is.
  */
-struct inode *ext4_new_inode(handle_t *handle, struct inode *dir, int mode)
+struct inode *ext4_new_inode(handle_t *handle, struct inode *dir, int mode,
+			     unsigned long goal)
 {
 	struct super_block *sb;
 	struct buffer_head *bitmap_bh = NULL;
@@ -591,7 +595,7 @@ struct inode *ext4_new_inode(handle_t *h
 	struct ext4_super_block *es;
 	struct ext4_inode_info *ei;
 	struct ext4_sb_info *sbi;
-	int ret2, err = 0;
+	int ret2 = 0, err = 0;
 	struct inode *ret;
 	ext4_group_t i;
 	int free = 0;
@@ -610,6 +614,43 @@ struct inode *ext4_new_inode(handle_t *h
 	sbi = EXT4_SB(sb);
 	es = sbi->s_es;
 
+	if (goal) {
+		group = (goal - 1) / EXT4_INODES_PER_GROUP(sb);
+		ino = (goal - 1) % EXT4_INODES_PER_GROUP(sb);
+
+		err = -EIO;
+		gdp = ext4_get_group_desc(sb, group, &bh2);
+		if (!gdp)
+			goto fail;
+
+		bitmap_bh = ext4_read_inode_bitmap(sb, group);
+		if (!bitmap_bh)
+			goto fail;
+
+		BUFFER_TRACE(bh, "get_write_access");
+		err = ext4_journal_get_write_access(handle, bitmap_bh);
+		if (err)
+			goto fail;
+
+		if (ext4_set_bit_atomic(sb_bgl_lock(sbi, group),
+					ino, bitmap_bh->b_data)) {
+			goto continue_allocation;
+		}
+
+		BUFFER_TRACE(bh, "call ext4_journal_dirty_metadata");
+		err = ext4_journal_dirty_metadata(handle, bitmap_bh);
+		if (err)
+			goto fail;
+
+		/*
+		 * We've shortcircuited the allocation system successfully,
+		 * now finish filling in the inode.
+		 */
+		goto got;
+	}
+
+continue_allocation:
+
 	if (sbi->s_log_groups_per_flex) {
 		ret2 = find_group_flex(sb, dir, &group);
 		goto got_group;
Index: linux-2.6.27/fs/ext4/namei.c
===================================================================
--- linux-2.6.27.orig/fs/ext4/namei.c
+++ linux-2.6.27/fs/ext4/namei.c
@@ -1725,7 +1725,7 @@ retry:
 	if (IS_DIRSYNC(dir))
 		handle->h_sync = 1;
 
-	inode = ext4_new_inode (handle, dir, mode);
+	inode = ext4_new_inode (handle, dir, mode, 0);
 	err = PTR_ERR(inode);
 	if (!IS_ERR(inode)) {
 		inode->i_op = &ext4_file_inode_operations;
@@ -1759,7 +1759,7 @@ retry:
 	if (IS_DIRSYNC(dir))
 		handle->h_sync = 1;
 
-	inode = ext4_new_inode(handle, dir, mode);
+	inode = ext4_new_inode(handle, dir, mode, 0);
 	err = PTR_ERR(inode);
 	if (!IS_ERR(inode)) {
 		init_special_inode(inode, inode->i_mode, rdev);
@@ -1795,7 +1795,7 @@ retry:
 	if (IS_DIRSYNC(dir))
 		handle->h_sync = 1;
 
-	inode = ext4_new_inode(handle, dir, S_IFDIR | mode);
+	inode = ext4_new_inode(handle, dir, S_IFDIR | mode, 0);
 	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
 		goto out_stop;
@@ -2195,7 +2195,7 @@ retry:
 	if (IS_DIRSYNC(dir))
 		handle->h_sync = 1;
 
-	inode = ext4_new_inode(handle, dir, S_IFLNK|S_IRWXUGO);
+	inode = ext4_new_inode(handle, dir, S_IFLNK|S_IRWXUGO, 0);
 	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
 		goto out_stop;
Index: linux-2.6.27/fs/ext4/migrate.c
===================================================================
--- linux-2.6.27.orig/fs/ext4/migrate.c
+++ linux-2.6.27/fs/ext4/migrate.c
@@ -482,9 +482,8 @@ int ext4_ext_migrate(struct inode *inode
 		retval = PTR_ERR(handle);
 		goto err_out;
 	}
-	tmp_inode = ext4_new_inode(handle,
-				inode->i_sb->s_root->d_inode,
-				S_IFREG);
+	tmp_inode = ext4_new_inode(handle, inode->i_sb->s_root->d_inode,
+				   S_IFREG, 0);
 	if (IS_ERR(tmp_inode)) {
 		retval = -ENOMEM;
 		ext4_journal_stop(handle);
Index: linux-2.6.27/fs/ext4/ext4.h
===================================================================
--- linux-2.6.27.orig/fs/ext4/ext4.h
+++ linux-2.6.27/fs/ext4/ext4.h
@@ -1033,7 +1033,8 @@ extern int ext4fs_dirhash(const char *na
 			  dx_hash_info *hinfo);
 
 /* ialloc.c */
-extern struct inode * ext4_new_inode(handle_t *, struct inode *, int);
+extern struct inode * ext4_new_inode(handle_t *, struct inode *, int,
+				     unsigned long);
 extern void ext4_free_inode(handle_t *, struct inode *);
 extern struct inode * ext4_orphan_get(struct super_block *, unsigned long);
 extern unsigned long ext4_count_free_inodes(struct super_block *);

--Boundary_(ID_OvTkrWE+gyx236mbF9oN7A)--
