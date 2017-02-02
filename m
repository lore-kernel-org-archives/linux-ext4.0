From: Theodore Ts'o <tytso@mit.edu>
Subject: [RFC/PATCH 2/3] ext4: add shutdown bit and check for it
Date: Thu,  2 Feb 2017 17:59:23 -0500
Message-ID: <20170202225924.19301-3-tytso@mit.edu>
References: <20170202225924.19301-1-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54694 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751821AbdBBW7x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 2 Feb 2017 17:59:53 -0500
In-Reply-To: <20170202225924.19301-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add a shutdown bit that will cause ext4 processing to fail immediately
with EIO.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ext4.h      |  6 ++++++
 fs/ext4/ext4_jbd2.c |  2 ++
 fs/ext4/file.c      | 12 ++++++++++++
 fs/ext4/fsync.c     |  3 +++
 fs/ext4/ialloc.c    |  3 +++
 fs/ext4/inode.c     | 25 +++++++++++++++++++++++++
 fs/ext4/namei.c     | 12 ++++++++++++
 fs/ext4/xattr.c     |  3 +++
 8 files changed, 66 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index d5b7b2ccb302..94064b7ce16c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1836,6 +1836,12 @@ static inline bool ext4_has_incompat_features(struct super_block *sb)
  * Superblock flags
  */
 #define EXT4_FLAGS_RESIZING	0
+#define EXT4_FLAGS_SHUTDOWN	1
+
+static inline int ext4_forced_shutdown(struct ext4_sb_info *sbi)
+{
+	return test_bit(EXT4_FLAGS_SHUTDOWN, &sbi->s_ext4_flags);
+}
 
 
 /*
diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index e770c1ee4613..8ea22d066f5c 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -43,6 +43,8 @@ static int ext4_journal_check_start(struct super_block *sb)
 	journal_t *journal;
 
 	might_sleep();
+	if (unlikely(ext4_forced_shutdown(EXT4_SB(sb))))
+		return -EIO;
 	if (sb->s_flags & MS_RDONLY)
 		return -EROFS;
 	WARN_ON(sb->s_writers.frozen == SB_FREEZE_COMPLETE);
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index d663d3d7c81c..ff3f6107b0ba 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -57,6 +57,9 @@ static ssize_t ext4_dax_read_iter(struct kiocb *iocb, struct iov_iter *to)
 
 static ssize_t ext4_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
+	if (unlikely(ext4_forced_shutdown(EXT4_SB(file_inode(iocb->ki_filp)->i_sb))))
+		return -EIO;
+
 	if (!iov_iter_count(to))
 		return 0; /* skip atime */
 
@@ -213,6 +216,9 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	int overwrite = 0;
 	ssize_t ret;
 
+	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
+		return -EIO;
+
 #ifdef CONFIG_FS_DAX
 	if (IS_DAX(inode))
 		return ext4_dax_write_iter(iocb, from);
@@ -348,6 +354,9 @@ static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct inode *inode = file->f_mapping->host;
 
+	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
+		return -EIO;
+
 	if (ext4_encrypted_inode(inode)) {
 		int err = fscrypt_get_encryption_info(inode);
 		if (err)
@@ -375,6 +384,9 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
 	char buf[64], *cp;
 	int ret;
 
+	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
+		return -EIO;
+
 	if (unlikely(!(sbi->s_mount_flags & EXT4_MF_MNTDIR_SAMPLED) &&
 		     !(sb->s_flags & MS_RDONLY))) {
 		sbi->s_mount_flags |= EXT4_MF_MNTDIR_SAMPLED;
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 88effb1053c7..9d549608fd30 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -100,6 +100,9 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	tid_t commit_tid;
 	bool needs_barrier = false;
 
+	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
+		return -EIO;
+
 	J_ASSERT(ext4_journal_current_handle() == NULL);
 
 	trace_ext4_sync_file_enter(file, datasync);
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index f372fc431b8e..b14bae2598bc 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -764,6 +764,9 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 	if (!dir || !dir->i_nlink)
 		return ERR_PTR(-EPERM);
 
+	if (unlikely(ext4_forced_shutdown(EXT4_SB(dir->i_sb))))
+		return ERR_PTR(-EIO);
+
 	if ((ext4_encrypted_inode(dir) ||
 	     DUMMY_ENCRYPTION_ENABLED(EXT4_SB(dir->i_sb))) &&
 	    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode))) {
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 918d351d5b94..e4416e94fb92 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1189,6 +1189,9 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
 	pgoff_t index;
 	unsigned from, to;
 
+	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
+		return -EIO;
+
 	trace_ext4_write_begin(inode, pos, len, flags);
 	/*
 	 * Reserve one block more for addition to orphan list in case
@@ -2037,6 +2040,9 @@ static int ext4_writepage(struct page *page,
 	struct ext4_io_submit io_submit;
 	bool keep_towrite = false;
 
+	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
+		return -EIO;
+
 	trace_ext4_writepage(page);
 	size = i_size_read(inode);
 	if (page->index == size >> PAGE_SHIFT)
@@ -2634,6 +2640,9 @@ static int ext4_writepages(struct address_space *mapping,
 	struct blk_plug plug;
 	bool give_up_on_write = false;
 
+	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
+		return -EIO;
+
 	percpu_down_read(&sbi->s_journal_flag_rwsem);
 	trace_ext4_writepages(inode, wbc);
 
@@ -2895,6 +2904,9 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 	struct inode *inode = mapping->host;
 	handle_t *handle;
 
+	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
+		return -EIO;
+
 	index = pos >> PAGE_SHIFT;
 
 	if (ext4_nonda_switch(inode->i_sb) ||
@@ -3199,6 +3211,9 @@ static int ext4_readpage(struct file *file, struct page *page)
 	int ret = -EAGAIN;
 	struct inode *inode = page->mapping->host;
 
+	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
+		return -EIO;
+
 	trace_ext4_readpage(page);
 
 	if (ext4_has_inline_data(inode))
@@ -3216,6 +3231,9 @@ ext4_readpages(struct file *file, struct address_space *mapping,
 {
 	struct inode *inode = mapping->host;
 
+	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
+		return -EIO;
+
 	/* If the file has inline data, no need to do readpages. */
 	if (ext4_has_inline_data(inode))
 		return 0;
@@ -5202,6 +5220,9 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 	int orphan = 0;
 	const unsigned int ia_valid = attr->ia_valid;
 
+	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
+		return -EIO;
+
 	error = setattr_prepare(dentry, attr);
 	if (error)
 		return error;
@@ -5488,6 +5509,8 @@ int ext4_mark_iloc_dirty(handle_t *handle,
 {
 	int err = 0;
 
+	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
+		return -EIO;
 	if (IS_I_VERSION(inode))
 		inode_inc_iversion(inode);
 
@@ -5511,6 +5534,8 @@ ext4_reserve_inode_write(handle_t *handle, struct inode *inode,
 {
 	int err;
 
+	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
+		return -EIO;
 	err = ext4_get_inode_loc(inode, iloc);
 	if (!err) {
 		BUFFER_TRACE(iloc->bh, "get_write_access");
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index af6fa5949193..32906ea1dc6b 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2939,6 +2939,9 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 	struct ext4_dir_entry_2 *de;
 	handle_t *handle = NULL;
 
+	if (unlikely(ext4_forced_shutdown(EXT4_SB(dir->i_sb))))
+		return -EIO;
+
 	/* Initialize quotas before so that eventual writes go in
 	 * separate transaction */
 	retval = dquot_initialize(dir);
@@ -3012,6 +3015,9 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 	struct ext4_dir_entry_2 *de;
 	handle_t *handle = NULL;
 
+	if (unlikely(ext4_forced_shutdown(EXT4_SB(dir->i_sb))))
+		return -EIO;
+
 	trace_ext4_unlink_enter(dir, dentry);
 	/* Initialize quotas before so that eventual writes go
 	 * in separate transaction */
@@ -3082,6 +3088,9 @@ static int ext4_symlink(struct inode *dir,
 	struct fscrypt_str disk_link;
 	struct fscrypt_symlink_data *sd = NULL;
 
+	if (unlikely(ext4_forced_shutdown(EXT4_SB(dir->i_sb))))
+		return -EIO;
+
 	disk_link.len = len + 1;
 	disk_link.name = (char *) symname;
 
@@ -3886,6 +3895,9 @@ static int ext4_rename2(struct inode *old_dir, struct dentry *old_dentry,
 			struct inode *new_dir, struct dentry *new_dentry,
 			unsigned int flags)
 {
+	if (unlikely(ext4_forced_shutdown(EXT4_SB(old_dir->i_sb))))
+		return -EIO;
+
 	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE | RENAME_WHITEOUT))
 		return -EINVAL;
 
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index c40bd55b6400..67636acf7624 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -411,6 +411,9 @@ ext4_xattr_get(struct inode *inode, int name_index, const char *name,
 {
 	int error;
 
+	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
+		return -EIO;
+
 	if (strlen(name) > 255)
 		return -ERANGE;
 
-- 
2.11.0.rc0.7.gbe5a750
