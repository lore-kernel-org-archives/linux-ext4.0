From: David Howells <dhowells@redhat.com>
Subject: [PATCH] ext4: Add statx support
Date: Thu, 16 Mar 2017 11:35:33 +0000
Message-ID: <148966413352.3279.15659219505999889147.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45424 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751321AbdCPLfg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 16 Mar 2017 07:35:36 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Return enhanced file attributes from the Ext4 filesystem.  This includes
the following:

 (1) The inode creation time (i_crtime) as stx_btime, setting STATX_BTIME.

 (2) Certain FS_xxx_FL flags are mapped to stx_attribute flags.

This requires that all ext4 inodes have a getattr call, not just some of
them, so to this end, split the ext4_getattr() function and only call part
of it where appropriate.

Example output:

	[root@andromeda ~]# touch foo
	[root@andromeda ~]# chattr +ai foo
	[root@andromeda ~]# /tmp/test-statx foo
	statx(foo) = 0
	results=fff
	  Size: 0               Blocks: 0          IO Block: 4096    regular file
	Device: 08:12           Inode: 2101950     Links: 1
	Access: (0644/-rw-r--r--)  Uid:     0   Gid:     0
	Access: 2016-02-11 17:08:29.031795451+0000
	Modify: 2016-02-11 17:08:29.031795451+0000
	Change: 2016-02-11 17:11:11.987790114+0000
	 Birth: 2016-02-11 17:08:29.031795451+0000
	Attributes: 0000000000000030 (-------- -------- -------- -------- -------- -------- -------- --ai----)

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ext4/ext4.h    |    1 +
 fs/ext4/file.c    |    2 +-
 fs/ext4/inode.c   |   36 +++++++++++++++++++++++++++++++++---
 fs/ext4/namei.c   |    2 ++
 fs/ext4/symlink.c |    2 ++
 5 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f493af666591..fb69ee2388db 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2466,6 +2466,7 @@ extern int  ext4_setattr(struct dentry *, struct iattr *);
 extern int  ext4_getattr(const struct path *, struct kstat *, u32, unsigned int);
 extern void ext4_evict_inode(struct inode *);
 extern void ext4_clear_inode(struct inode *);
+extern int  ext4_file_getattr(const struct path *, struct kstat *, u32, unsigned int);
 extern int  ext4_sync_inode(handle_t *, struct inode *);
 extern void ext4_dirty_inode(struct inode *, int);
 extern int ext4_change_inode_journal_flag(struct inode *, int);
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 8210c1f43556..cefa9835f275 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -744,7 +744,7 @@ const struct file_operations ext4_file_operations = {
 
 const struct inode_operations ext4_file_inode_operations = {
 	.setattr	= ext4_setattr,
-	.getattr	= ext4_getattr,
+	.getattr	= ext4_file_getattr,
 	.listxattr	= ext4_listxattr,
 	.get_acl	= ext4_get_acl,
 	.set_acl	= ext4_set_acl,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7385e6a6b6cb..5450e1eade1d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5390,11 +5390,41 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 int ext4_getattr(const struct path *path, struct kstat *stat,
 		 u32 request_mask, unsigned int query_flags)
 {
-	struct inode *inode;
-	unsigned long long delalloc_blocks;
+	struct inode *inode = d_inode(path->dentry);
+	struct ext4_inode *raw_inode;
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	unsigned int flags;
+
+	if (EXT4_FITS_IN_INODE(raw_inode, ei, i_crtime)) {
+		stat->result_mask |= STATX_BTIME;
+		stat->btime.tv_sec = ei->i_crtime.tv_sec;
+		stat->btime.tv_nsec = ei->i_crtime.tv_nsec;
+	}
+
+	ext4_get_inode_flags(ei);
+	flags = ei->i_flags & EXT4_FL_USER_VISIBLE;
+	if (flags & EXT4_APPEND_FL)
+		stat->attributes |= STATX_ATTR_APPEND;
+	if (flags & EXT4_COMPR_FL)
+		stat->attributes |= STATX_ATTR_COMPRESSED;
+	if (flags & EXT4_ENCRYPT_FL)
+		stat->attributes |= STATX_ATTR_ENCRYPTED;
+	if (flags & EXT4_IMMUTABLE_FL)
+		stat->attributes |= STATX_ATTR_IMMUTABLE;
+	if (flags & EXT4_NODUMP_FL)
+		stat->attributes |= STATX_ATTR_NODUMP;
 
-	inode = d_inode(path->dentry);
 	generic_fillattr(inode, stat);
+	return 0;
+}
+
+int ext4_file_getattr(const struct path *path, struct kstat *stat,
+		      u32 request_mask, unsigned int query_flags)
+{
+	struct inode *inode = d_inode(path->dentry);
+	u64 delalloc_blocks;
+
+	ext4_getattr(path, stat, request_mask, query_flags);
 
 	/*
 	 * If there is inline data in the inode, the inode will normally not
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 6ad612c576fc..07e5e1405771 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3912,6 +3912,7 @@ const struct inode_operations ext4_dir_inode_operations = {
 	.tmpfile	= ext4_tmpfile,
 	.rename		= ext4_rename2,
 	.setattr	= ext4_setattr,
+	.getattr	= ext4_getattr,
 	.listxattr	= ext4_listxattr,
 	.get_acl	= ext4_get_acl,
 	.set_acl	= ext4_set_acl,
@@ -3920,6 +3921,7 @@ const struct inode_operations ext4_dir_inode_operations = {
 
 const struct inode_operations ext4_special_inode_operations = {
 	.setattr	= ext4_setattr,
+	.getattr	= ext4_getattr,
 	.listxattr	= ext4_listxattr,
 	.get_acl	= ext4_get_acl,
 	.set_acl	= ext4_set_acl,
diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
index 73b184d161fc..4c6b23a0603e 100644
--- a/fs/ext4/symlink.c
+++ b/fs/ext4/symlink.c
@@ -91,11 +91,13 @@ const struct inode_operations ext4_encrypted_symlink_inode_operations = {
 const struct inode_operations ext4_symlink_inode_operations = {
 	.get_link	= page_get_link,
 	.setattr	= ext4_setattr,
+	.getattr	= ext4_getattr,
 	.listxattr	= ext4_listxattr,
 };
 
 const struct inode_operations ext4_fast_symlink_inode_operations = {
 	.get_link	= simple_get_link,
 	.setattr	= ext4_setattr,
+	.getattr	= ext4_getattr,
 	.listxattr	= ext4_listxattr,
 };
