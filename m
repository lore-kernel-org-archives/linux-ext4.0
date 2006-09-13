From: Alexandre Ratchov <alexandre.ratchov@bull.net>
Subject: rfc: [patch] change attribute for ext3
Date: Wed, 13 Sep 2006 18:42:02 +0200
Message-ID: <20060913164202.GA14838@openx1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:38536 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP
	id S1750750AbWIMQmN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Sep 2006 12:42:13 -0400
To: linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

hello, 

here is a small patch that adds the "change attribute" for ext3
file-systems;

the change attribute is a simple counter that is reset to zero on
inode creation and that is incremented every time the inode data is
modified (similarly to the "ctime" time-stamp).

Its purpose is to make possible to watch a file for changes, as
in the following pseudo-code:

        stat(filename, oldsb);

        ...     /* do something */ 

        stat(filename, newsb);
        if (oldsb->st_ctime != newsb->st_ctime ||
            oldsb->st_change_attribute != newsb->st_changeattribute) {

                /* file changed */
        } else {

                /* file didn't change */
        }

The patch also adds a new ``st_change_attribute'' field in the stat
structure, and modifies the stat(2) syscall accordingly. Currently the
change is only visible on i386 and x86_64 archs.

In order to test the patch, there's a trivial utility that displays the
value of the change attribute:

	http://www.bullopensource.org/ext4/20060913/chinfo.tar.gz

Comments?

cheers,

-- Alexandre


Signed-off-by: Celine Bourde
Signed-off-by: Alexandre Ratchov

Index: fs/attr.c
===================================================================
RCS file: /home/ratchova/cvs/linux/fs/attr.c,v
retrieving revision 1.1.1.1
retrieving revision 1.1.1.1.10.1
diff -u -p -r1.1.1.1 -r1.1.1.1.10.1
--- fs/attr.c	28 Jun 2006 18:41:20 -0000	1.1.1.1
+++ fs/attr.c	13 Sep 2006 18:15:43 -0000	1.1.1.1.10.1
@@ -88,6 +88,9 @@ int inode_setattr(struct inode * inode, 
 	if (ia_valid & ATTR_CTIME)
 		inode->i_ctime = timespec_trunc(attr->ia_ctime,
 						inode->i_sb->s_time_gran);
+	if (ia_valid & ATTR_CHANGE_ATTRIBUTE)
+	        inode->i_change_attribute = attr->ia_change_attribute;
+	
 	if (ia_valid & ATTR_MODE) {
 		umode_t mode = attr->ia_mode;
 
@@ -111,7 +114,7 @@ int notify_change(struct dentry * dentry
 
 	mode = inode->i_mode;
 	now = current_fs_time(inode->i_sb);
-
+	inode->i_change_attribute++;
 	attr->ia_ctime = now;
 	if (!(ia_valid & ATTR_ATIME_SET))
 		attr->ia_atime = now;
Index: fs/bad_inode.c
===================================================================
RCS file: /home/ratchova/cvs/linux/fs/bad_inode.c,v
retrieving revision 1.1.1.2
retrieving revision 1.1.1.2.6.1
diff -u -p -r1.1.1.2 -r1.1.1.2.6.1
--- fs/bad_inode.c	28 Jun 2006 18:42:06 -0000	1.1.1.2
+++ fs/bad_inode.c	13 Sep 2006 18:15:43 -0000	1.1.1.2.6.1
@@ -97,6 +97,7 @@ void make_bad_inode(struct inode * inode
 	inode->i_mode = S_IFREG;
 	inode->i_atime = inode->i_mtime = inode->i_ctime =
 		current_fs_time(inode->i_sb);
+	inode->i_change_attribute++;
 	inode->i_op = &bad_inode_ops;	
 	inode->i_fop = &bad_file_ops;	
 }
Index: fs/binfmt_misc.c
===================================================================
RCS file: /home/ratchova/cvs/linux/fs/binfmt_misc.c,v
retrieving revision 1.1.1.3
retrieving revision 1.1.1.3.2.1
diff -u -p -r1.1.1.3 -r1.1.1.3.2.1
--- fs/binfmt_misc.c	13 Sep 2006 17:45:04 -0000	1.1.1.3
+++ fs/binfmt_misc.c	13 Sep 2006 18:15:43 -0000	1.1.1.3.2.1
@@ -511,6 +511,7 @@ static struct inode *bm_get_inode(struct
 		inode->i_blocks = 0;
 		inode->i_atime = inode->i_mtime = inode->i_ctime =
 			current_fs_time(inode->i_sb);
+		inode->i_change_attribute = 0;
 	}
 	return inode;
 }
Index: fs/eventpoll.c
===================================================================
RCS file: /home/ratchova/cvs/linux/fs/eventpoll.c,v
retrieving revision 1.1.1.3
retrieving revision 1.1.1.3.2.1
diff -u -p -r1.1.1.3 -r1.1.1.3.2.1
--- fs/eventpoll.c	13 Sep 2006 17:45:04 -0000	1.1.1.3
+++ fs/eventpoll.c	13 Sep 2006 18:15:43 -0000	1.1.1.3.2.1
@@ -1590,6 +1590,7 @@ static struct inode *ep_eventpoll_inode(
 	inode->i_uid = current->fsuid;
 	inode->i_gid = current->fsgid;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+	inode->i_change_attribute = 0;
 	inode->i_blksize = PAGE_SIZE;
 	return inode;
 
Index: fs/inode.c
===================================================================
RCS file: /home/ratchova/cvs/linux/fs/inode.c,v
retrieving revision 1.1.1.3
retrieving revision 1.1.1.3.2.1
diff -u -p -r1.1.1.3 -r1.1.1.3.2.1
--- fs/inode.c	13 Sep 2006 17:45:04 -0000	1.1.1.3
+++ fs/inode.c	13 Sep 2006 18:15:43 -0000	1.1.1.3.2.1
@@ -1232,16 +1232,10 @@ void file_update_time(struct file *file)
 		return;
 
 	now = current_fs_time(inode->i_sb);
-	if (!timespec_equal(&inode->i_mtime, &now))
-		sync_it = 1;
 	inode->i_mtime = now;
-
-	if (!timespec_equal(&inode->i_ctime, &now))
-		sync_it = 1;
 	inode->i_ctime = now;
-
-	if (sync_it)
-		mark_inode_dirty_sync(inode);
+	inode->i_change_attribute++;
+	mark_inode_dirty_sync(inode);
 }
 
 EXPORT_SYMBOL(file_update_time);
Index: fs/libfs.c
===================================================================
RCS file: /home/ratchova/cvs/linux/fs/libfs.c,v
retrieving revision 1.1.1.3
retrieving revision 1.1.1.3.2.1
diff -u -p -r1.1.1.3 -r1.1.1.3.2.1
--- fs/libfs.c	13 Sep 2006 17:45:04 -0000	1.1.1.3
+++ fs/libfs.c	13 Sep 2006 18:15:43 -0000	1.1.1.3.2.1
@@ -220,6 +220,7 @@ int get_sb_pseudo(struct file_system_typ
 	root->i_mode = S_IFDIR | S_IRUSR | S_IWUSR;
 	root->i_uid = root->i_gid = 0;
 	root->i_atime = root->i_mtime = root->i_ctime = CURRENT_TIME;
+	root->i_change_attribute = 0;	
 	dentry = d_alloc(NULL, &d_name);
 	if (!dentry) {
 		iput(root);
@@ -242,6 +243,8 @@ int simple_link(struct dentry *old_dentr
 {
 	struct inode *inode = old_dentry->d_inode;
 
+	inode->i_change_attribute++;
+	dir->i_change_attribute++;	
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 	inode->i_nlink++;
 	atomic_inc(&inode->i_count);
@@ -274,6 +277,8 @@ int simple_unlink(struct inode *dir, str
 {
 	struct inode *inode = dentry->d_inode;
 
+	inode->i_change_attribute++;
+	dir->i_change_attribute++;	
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 	inode->i_nlink--;
 	dput(dentry);
@@ -311,7 +316,8 @@ int simple_rename(struct inode *old_dir,
 
 	old_dir->i_ctime = old_dir->i_mtime = new_dir->i_ctime =
 		new_dir->i_mtime = inode->i_ctime = CURRENT_TIME;
-
+	old_dir->i_change_attribute++;
+	new_dir->i_change_attribute++;
 	return 0;
 }
 
@@ -386,6 +392,7 @@ int simple_fill_super(struct super_block
 	inode->i_blksize = PAGE_CACHE_SIZE;
 	inode->i_blocks = 0;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+	inode->i_change_attribute = 0;	
 	inode->i_op = &simple_dir_inode_operations;
 	inode->i_fop = &simple_dir_operations;
 	inode->i_nlink = 2;
@@ -408,6 +415,7 @@ int simple_fill_super(struct super_block
 		inode->i_blksize = PAGE_CACHE_SIZE;
 		inode->i_blocks = 0;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+		inode->i_change_attribute = 0;
 		inode->i_fop = files->ops;
 		inode->i_ino = i;
 		d_add(dentry, inode);
Index: fs/pipe.c
===================================================================
RCS file: /home/ratchova/cvs/linux/fs/pipe.c,v
retrieving revision 1.1.1.3
retrieving revision 1.1.1.3.2.1
diff -u -p -r1.1.1.3 -r1.1.1.3.2.1
--- fs/pipe.c	13 Sep 2006 17:45:04 -0000	1.1.1.3
+++ fs/pipe.c	13 Sep 2006 18:15:43 -0000	1.1.1.3.2.1
@@ -879,6 +879,7 @@ static struct inode * get_pipe_inode(voi
 	inode->i_uid = current->fsuid;
 	inode->i_gid = current->fsgid;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+	inode->i_change_attribute = 0;	
 	inode->i_blksize = PAGE_SIZE;
 
 	return inode;
Index: fs/stat.c
===================================================================
RCS file: /home/ratchova/cvs/linux/fs/stat.c,v
retrieving revision 1.1.1.3
retrieving revision 1.1.1.3.2.1
diff -u -p -r1.1.1.3 -r1.1.1.3.2.1
--- fs/stat.c	13 Sep 2006 17:45:04 -0000	1.1.1.3
+++ fs/stat.c	13 Sep 2006 18:15:43 -0000	1.1.1.3.2.1
@@ -30,6 +30,7 @@ void generic_fillattr(struct inode *inod
 	stat->atime = inode->i_atime;
 	stat->mtime = inode->i_mtime;
 	stat->ctime = inode->i_ctime;
+	stat->change_attribute = inode->i_change_attribute;
 	stat->size = i_size_read(inode);
 	stat->blocks = inode->i_blocks;
 	stat->blksize = inode->i_blksize;
@@ -228,6 +229,7 @@ static int cp_new_stat(struct kstat *sta
 	tmp.st_atime = stat->atime.tv_sec;
 	tmp.st_mtime = stat->mtime.tv_sec;
 	tmp.st_ctime = stat->ctime.tv_sec;
+	tmp.st_change_attribute = stat->change_attribute;
 #ifdef STAT_HAVE_NSEC
 	tmp.st_atime_nsec = stat->atime.tv_nsec;
 	tmp.st_mtime_nsec = stat->mtime.tv_nsec;
@@ -359,6 +361,7 @@ static long cp_new_stat64(struct kstat *
 	tmp.st_mtime_nsec = stat->mtime.tv_nsec;
 	tmp.st_ctime = stat->ctime.tv_sec;
 	tmp.st_ctime_nsec = stat->ctime.tv_nsec;
+	tmp.st_change_attribute = stat->change_attribute;
 	tmp.st_size = stat->size;
 	tmp.st_blocks = stat->blocks;
 	tmp.st_blksize = stat->blksize;
Index: fs/ext3/ialloc.c
===================================================================
RCS file: /home/ratchova/cvs/linux/fs/ext3/ialloc.c,v
retrieving revision 1.1.1.2
retrieving revision 1.1.1.2.2.1
diff -u -p -r1.1.1.2 -r1.1.1.2.2.1
--- fs/ext3/ialloc.c	13 Sep 2006 17:45:04 -0000	1.1.1.2
+++ fs/ext3/ialloc.c	13 Sep 2006 18:15:43 -0000	1.1.1.2.2.1
@@ -562,7 +562,8 @@ got:
 	inode->i_blksize = PAGE_SIZE;
 	inode->i_blocks = 0;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
-
+	inode->i_change_attribute = 0;
+	
 	memset(ei->i_data, 0, sizeof(ei->i_data));
 	ei->i_dir_start_lookup = 0;
 	ei->i_disksize = 0;
Index: fs/ext3/inode.c
===================================================================
RCS file: /home/ratchova/cvs/linux/fs/ext3/inode.c,v
retrieving revision 1.1.1.3
retrieving revision 1.1.1.3.2.1
diff -u -p -r1.1.1.3 -r1.1.1.3.2.1
--- fs/ext3/inode.c	13 Sep 2006 17:45:05 -0000	1.1.1.3
+++ fs/ext3/inode.c	13 Sep 2006 18:15:43 -0000	1.1.1.3.2.1
@@ -729,6 +729,7 @@ static int ext3_splice_branch(handle_t *
 	/* We are done with atomic stuff, now do the rest of housekeeping */
 
 	inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_change_attribute++;	
 	ext3_mark_inode_dirty(handle, inode);
 
 	/* had we spliced it onto indirect block? */
@@ -2371,6 +2372,7 @@ do_indirects:
 
 	mutex_unlock(&ei->truncate_mutex);
 	inode->i_mtime = inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_change_attribute++;	
 	ext3_mark_inode_dirty(handle, inode);
 
 	/*
@@ -2608,7 +2610,8 @@ void ext3_read_inode(struct inode * inod
 	inode->i_ctime.tv_sec = le32_to_cpu(raw_inode->i_ctime);
 	inode->i_mtime.tv_sec = le32_to_cpu(raw_inode->i_mtime);
 	inode->i_atime.tv_nsec = inode->i_ctime.tv_nsec = inode->i_mtime.tv_nsec = 0;
-
+	inode->i_change_attribute = le32_to_cpu(raw_inode->i_chattr);
+	
 	ei->i_state = 0;
 	ei->i_dir_start_lookup = 0;
 	ei->i_dtime = le32_to_cpu(raw_inode->i_dtime);
@@ -2765,6 +2768,7 @@ static int ext3_do_update_inode(handle_t
 	raw_inode->i_atime = cpu_to_le32(inode->i_atime.tv_sec);
 	raw_inode->i_ctime = cpu_to_le32(inode->i_ctime.tv_sec);
 	raw_inode->i_mtime = cpu_to_le32(inode->i_mtime.tv_sec);
+	raw_inode->i_chattr = cpu_to_le32(inode->i_change_attribute);
 	raw_inode->i_blocks = cpu_to_le32(inode->i_blocks);
 	raw_inode->i_dtime = cpu_to_le32(ei->i_dtime);
 	raw_inode->i_flags = cpu_to_le32(ei->i_flags);
Index: fs/ext3/ioctl.c
===================================================================
RCS file: /home/ratchova/cvs/linux/fs/ext3/ioctl.c,v
retrieving revision 1.1.1.3
retrieving revision 1.1.1.3.2.1
diff -u -p -r1.1.1.3 -r1.1.1.3.2.1
--- fs/ext3/ioctl.c	13 Sep 2006 17:45:05 -0000	1.1.1.3
+++ fs/ext3/ioctl.c	13 Sep 2006 18:15:43 -0000	1.1.1.3.2.1
@@ -96,6 +96,7 @@ int ext3_ioctl (struct inode * inode, st
 
 		ext3_set_inode_flags(inode);
 		inode->i_ctime = CURRENT_TIME_SEC;
+		inode->i_change_attribute++;
 
 		err = ext3_mark_iloc_dirty(handle, inode, &iloc);
 flags_err:
@@ -133,6 +134,7 @@ flags_err:
 		err = ext3_reserve_inode_write(handle, inode, &iloc);
 		if (err == 0) {
 			inode->i_ctime = CURRENT_TIME_SEC;
+			inode->i_change_attribute++;
 			inode->i_generation = generation;
 			err = ext3_mark_iloc_dirty(handle, inode, &iloc);
 		}
Index: fs/ext3/namei.c
===================================================================
RCS file: /home/ratchova/cvs/linux/fs/ext3/namei.c,v
retrieving revision 1.1.1.2
retrieving revision 1.1.1.2.2.1
diff -u -p -r1.1.1.2 -r1.1.1.2.2.1
--- fs/ext3/namei.c	13 Sep 2006 17:45:05 -0000	1.1.1.2
+++ fs/ext3/namei.c	13 Sep 2006 18:15:43 -0000	1.1.1.2.2.1
@@ -1275,6 +1275,7 @@ static int add_dirent_to_buf(handle_t *h
 	 * and/or different from the directory change time.
 	 */
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
+	dir->i_change_attribute++;
 	ext3_update_dx_flag(dir);
 	dir->i_version++;
 	ext3_mark_inode_dirty(handle, dir);
@@ -2051,6 +2052,8 @@ static int ext3_rmdir (struct inode * di
 	inode->i_size = 0;
 	ext3_orphan_add(handle, inode);
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME_SEC;
+	inode->i_change_attribute++;
+	dir->i_change_attribute++;
 	ext3_mark_inode_dirty(handle, inode);
 	dir->i_nlink--;
 	ext3_update_dx_flag(dir);
@@ -2101,12 +2104,14 @@ static int ext3_unlink(struct inode * di
 	if (retval)
 		goto end_unlink;
 	dir->i_ctime = dir->i_mtime = CURRENT_TIME_SEC;
+	dir->i_change_attribute++;
 	ext3_update_dx_flag(dir);
 	ext3_mark_inode_dirty(handle, dir);
 	inode->i_nlink--;
 	if (!inode->i_nlink)
 		ext3_orphan_add(handle, inode);
 	inode->i_ctime = dir->i_ctime;
+	inode->i_change_attribute++;
 	ext3_mark_inode_dirty(handle, inode);
 	retval = 0;
 
@@ -2192,6 +2197,7 @@ retry:
 		handle->h_sync = 1;
 
 	inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_change_attribute++;
 	ext3_inc_count(handle, inode);
 	atomic_inc(&inode->i_count);
 
@@ -2294,6 +2300,7 @@ static int ext3_rename (struct inode * o
 	 * rename.
 	 */
 	old_inode->i_ctime = CURRENT_TIME_SEC;
+	old_inode->i_change_attribute++;
 	ext3_mark_inode_dirty(handle, old_inode);
 
 	/*
@@ -2327,8 +2334,10 @@ static int ext3_rename (struct inode * o
 	if (new_inode) {
 		new_inode->i_nlink--;
 		new_inode->i_ctime = CURRENT_TIME_SEC;
+		new_inode->i_change_attribute++;
 	}
 	old_dir->i_ctime = old_dir->i_mtime = CURRENT_TIME_SEC;
+	old_dir->i_change_attribute++;
 	ext3_update_dx_flag(old_dir);
 	if (dir_bh) {
 		BUFFER_TRACE(dir_bh, "get_write_access");
Index: fs/ext3/super.c
===================================================================
RCS file: /home/ratchova/cvs/linux/fs/ext3/super.c,v
retrieving revision 1.1.1.3
retrieving revision 1.1.1.3.2.1
diff -u -p -r1.1.1.3 -r1.1.1.3.2.1
--- fs/ext3/super.c	13 Sep 2006 17:45:05 -0000	1.1.1.3
+++ fs/ext3/super.c	13 Sep 2006 18:15:43 -0000	1.1.1.3.2.1
@@ -2656,6 +2656,7 @@ out:
 	}
 	inode->i_version++;
 	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+	inode->i_change_attribute = 0;
 	ext3_mark_inode_dirty(handle, inode);
 	mutex_unlock(&inode->i_mutex);
 	return len - towrite;
Index: fs/ext3/xattr.c
===================================================================
RCS file: /home/ratchova/cvs/linux/fs/ext3/xattr.c,v
retrieving revision 1.1.1.2
retrieving revision 1.1.1.2.2.1
diff -u -p -r1.1.1.2 -r1.1.1.2.2.1
--- fs/ext3/xattr.c	13 Sep 2006 17:45:05 -0000	1.1.1.2
+++ fs/ext3/xattr.c	13 Sep 2006 18:15:43 -0000	1.1.1.2.2.1
@@ -1008,6 +1008,7 @@ ext3_xattr_set_handle(handle_t *handle, 
 	if (!error) {
 		ext3_xattr_update_super_block(handle, inode->i_sb);
 		inode->i_ctime = CURRENT_TIME_SEC;
+		inode->i_change_attribute++;
 		error = ext3_mark_iloc_dirty(handle, inode, &is.iloc);
 		/*
 		 * The bh is consumed by ext3_mark_iloc_dirty, even with
Index: include/asm-i386/stat.h
===================================================================
RCS file: /home/ratchova/cvs/linux/include/asm-i386/stat.h,v
retrieving revision 1.1.1.2
retrieving revision 1.1.1.2.6.1
diff -u -p -r1.1.1.2 -r1.1.1.2.6.1
--- include/asm-i386/stat.h	28 Jun 2006 18:42:09 -0000	1.1.1.2
+++ include/asm-i386/stat.h	13 Sep 2006 18:15:43 -0000	1.1.1.2.6.1
@@ -32,7 +32,7 @@ struct stat {
 	unsigned long  st_mtime_nsec;
 	unsigned long  st_ctime;
 	unsigned long  st_ctime_nsec;
-	unsigned long  __unused4;
+	unsigned long  st_change_attribute; 
 	unsigned long  __unused5;
 };
 
@@ -41,7 +41,7 @@ struct stat {
  */
 struct stat64 {
 	unsigned long long	st_dev;
-	unsigned char	__pad0[4];
+	unsigned long   st_change_attribute;
 
 #define STAT64_HAS_BROKEN_ST_INO	1
 	unsigned long	__st_ino;
Index: include/asm-x86_64/stat.h
===================================================================
RCS file: /home/ratchova/cvs/linux/include/asm-x86_64/stat.h,v
retrieving revision 1.1.1.1
retrieving revision 1.1.1.1.10.1
diff -u -p -r1.1.1.1 -r1.1.1.1.10.1
--- include/asm-x86_64/stat.h	28 Jun 2006 18:41:22 -0000	1.1.1.1
+++ include/asm-x86_64/stat.h	13 Sep 2006 18:15:43 -0000	1.1.1.1.10.1
@@ -23,7 +23,8 @@ struct stat {
 	unsigned long	st_mtime_nsec;
 	unsigned long	st_ctime;
 	unsigned long   st_ctime_nsec;
-  	long		__unused[3];
+	unsigned long	st_change_attribute;
+  	long		__unused[2];
 };
 
 /* For 32bit emulation */
Index: include/linux/ext3_fs.h
===================================================================
RCS file: /home/ratchova/cvs/linux/include/linux/ext3_fs.h,v
retrieving revision 1.1.1.3
retrieving revision 1.1.1.3.2.1
diff -u -p -r1.1.1.3 -r1.1.1.3.2.1
--- include/linux/ext3_fs.h	13 Sep 2006 17:45:20 -0000	1.1.1.3
+++ include/linux/ext3_fs.h	13 Sep 2006 18:15:43 -0000	1.1.1.3.2.1
@@ -286,7 +286,7 @@ struct ext3_inode {
 			__u16	i_pad1;
 			__le16	l_i_uid_high;	/* these 2 fields    */
 			__le16	l_i_gid_high;	/* were reserved2[0] */
-			__u32	l_i_reserved2;
+			__le32	l_i_change_attribute;
 		} linux2;
 		struct {
 			__u8	h_i_frag;	/* Fragment number */
@@ -317,7 +317,7 @@ struct ext3_inode {
 #define i_gid_low	i_gid
 #define i_uid_high	osd2.linux2.l_i_uid_high
 #define i_gid_high	osd2.linux2.l_i_gid_high
-#define i_reserved2	osd2.linux2.l_i_reserved2
+#define i_chattr	osd2.linux2.l_i_change_attribute
 
 #elif defined(__GNU__)
 
Index: include/linux/fs.h
===================================================================
RCS file: /home/ratchova/cvs/linux/include/linux/fs.h,v
retrieving revision 1.1.1.3
retrieving revision 1.1.1.3.2.1
diff -u -p -r1.1.1.3 -r1.1.1.3.2.1
--- include/linux/fs.h	13 Sep 2006 17:45:20 -0000	1.1.1.3
+++ include/linux/fs.h	13 Sep 2006 18:15:43 -0000	1.1.1.3.2.1
@@ -280,6 +280,7 @@ typedef void (dio_iodone_t)(struct kiocb
 #define ATTR_KILL_SUID	2048
 #define ATTR_KILL_SGID	4096
 #define ATTR_FILE	8192
+#define ATTR_CHANGE_ATTRIBUTE  16384
 
 /*
  * This is the Inode Attributes structure, used for notify_change().  It
@@ -299,6 +300,7 @@ struct iattr {
 	struct timespec	ia_atime;
 	struct timespec	ia_mtime;
 	struct timespec	ia_ctime;
+	unsigned long   ia_change_attribute;
 
 	/*
 	 * Not an attribute, but an auxilary info for filesystems wanting to
@@ -510,6 +512,7 @@ struct inode {
 	struct timespec		i_atime;
 	struct timespec		i_mtime;
 	struct timespec		i_ctime;
+	unsigned long           i_change_attribute;
 	unsigned int		i_blkbits;
 	unsigned long		i_blksize;
 	unsigned long		i_version;
Index: include/linux/stat.h
===================================================================
RCS file: /home/ratchova/cvs/linux/include/linux/stat.h,v
retrieving revision 1.1.1.2
retrieving revision 1.1.1.2.6.1
diff -u -p -r1.1.1.2 -r1.1.1.2.6.1
--- include/linux/stat.h	28 Jun 2006 18:42:11 -0000	1.1.1.2
+++ include/linux/stat.h	13 Sep 2006 18:15:43 -0000	1.1.1.2.6.1
@@ -68,6 +68,7 @@ struct kstat {
 	struct timespec  atime;
 	struct timespec	mtime;
 	struct timespec	ctime;
+	unsigned long   change_attribute;
 	unsigned long	blksize;
 	unsigned long long	blocks;
 };
