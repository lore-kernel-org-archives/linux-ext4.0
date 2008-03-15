From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Fail migrate if we allocated new blocks via mmap
	write.
Date: Sat, 15 Mar 2008 13:21:07 +0530
Message-ID: <20080315075107.GA7248@skywalker>
References: <1205397487-16040-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1205449373.3642.14.camel@localhost.localdomain> <20080314070431.GB7266@skywalker> <1205521737.3683.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="+QahgC5+KEYLbs62"
Cc: tytso@mit.edu, adilger@sun.com, jack@suse.cz,
	linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:57570 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbYCOHvc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 15 Mar 2008 03:51:32 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m2F7pBE1008402
	for <linux-ext4@vger.kernel.org>; Sat, 15 Mar 2008 18:51:11 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2F7tCur276754
	for <linux-ext4@vger.kernel.org>; Sat, 15 Mar 2008 18:55:12 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2F7pSFj026156
	for <linux-ext4@vger.kernel.org>; Sat, 15 Mar 2008 18:51:29 +1100
Content-Disposition: inline
In-Reply-To: <1205521737.3683.15.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 14, 2008 at 12:08:57PM -0700, Mingming Cao wrote:
> On Fri, 2008-03-14 at 12:34 +0530, Aneesh Kumar K.V wrote:

....

> > > > +	if (retval > 0) {
> > > > +		/*
> > > > +		 * We allocated new blocks which will result in i_data
> > > > +		 * format to change.  Force the migrate to fail by
> > > > +		 * clearing migrate flags
> > > > +		 */
> > > > +		EXT4_I(inode)->i_flags = EXT4_I(inode)->i_flags &
> > > > +							~EXT4_EXT_MIGRATE;
> > > > +	}
> > > 
> > > We probably need to check buffer_new() for the resulting bh, as retval >
> > > 0 doesn't necessarily means ext4_ext_get_blocks() allocated new blocks.
> > 
> > 
> > Only if we request with create = 0 the API returns >0 and buffer head
> > unmapped.
> > 
> 
> But buffer_mapped(bh) doesn't necessarily mean buffer_new(bh) is true
> 
> In a race allocation case, it's possible that after re-grab the write
> lock of the i_data_sem, the blocks in range has already been allocated
> by other mmaped write to the same range. It's a minor optimization to
> avoid clearing the flag if there is no allocation, though, but it's more
> clear to check the buffer_new() flag here.



I added retval > 0 && buffer_new(bh). I also moved the check only for
ext3 inode type.

> 
> > > 
> > > And I think this check should only for ext3 type files, maybe checking
> > > the flag or move the "if" right after ext4_get_blocks_handle()?
> > > 
> > > >  	up_write((&EXT4_I(inode)->i_data_sem));
> > > >  	return retval;
> > > >  }
> > > > @@ -2962,7 +2972,8 @@ static int ext4_do_update_inode(handle_t *handle,
> > > >  	if (ext4_inode_blocks_set(handle, raw_inode, ei))
> > > >  		goto out_brelse;
> > > >  	raw_inode->i_dtime = cpu_to_le32(ei->i_dtime);
> > > > -	raw_inode->i_flags = cpu_to_le32(ei->i_flags);
> > > > +	/* clear the migrate flag in the raw_inode */
> > > > +	raw_inode->i_flags = cpu_to_le32(ei->i_flags & ~EXT4_EXT_MIGRATE);
> > > 
> > > Do we need to save this flag on-disk?
> > 
> > 
> > We don't need to. That's why i am clearing it in the raw_inode. We still
> > need to have it in ext4_inode_info so that an ongoing migrate doesn't
> > fail.
> > 
> Oh, I mean "clear" this flag...it seems to me that doing this update for
> every on-disk inode update is unnecessary. Probably just clearing this
> flag at read_inode() time when the inode first load() from disk and only
> keep this flag around in the in-core memory?
> 
> > > 
> > > >  	if (EXT4_SB(inode->i_sb)->s_es->s_creator_os !=
> > > >  	    cpu_to_le32(EXT4_OS_HURD))
> > > >  		raw_inode->i_file_acl_high =
> > > > @@ -3502,9 +3513,5 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page)
> > > >  	 * access and zero out the page. The journal handle get initialized
> > > >  	 * in ext4_get_block.
> > > >  	 */
> > > > -	/* FIXME!! should we take inode->i_mutex ? Currently we can't because
> > > > -	 * it has a circular locking dependency with DIO. But migrate expect
> > > > -	 * i_mutex to ensure no i_data changes
> > > > -	 */
> > > >  	return block_page_mkwrite(vma, page, ext4_get_block);
> > > 
> > > If you update this patch, how about split this part to a separate fix
> > > and merge that with it's parent ext4-page-mkwrite() patch? 
> > > 


removed this comment from ext4-page-mkwrite patch



> > > >  }
> > > > diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> > > > index 5c1e27d..f4c9e78 100644
> > > > --- a/fs/ext4/migrate.c
> > > > +++ b/fs/ext4/migrate.c
> > > > @@ -327,7 +327,7 @@ static int free_ind_block(handle_t *handle, struct inode *inode, __le32 *i_data)
> > > >  }
> > > > 
> > > >  static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
> > > > -				struct inode *tmp_inode)
> > > > +						struct inode *tmp_inode)
> > > >  {
> > > >  	int retval;
> > > >  	__le32	i_data[3];
> > > > @@ -351,6 +351,18 @@ static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
> > > > 
> > > >  	down_write(&EXT4_I(inode)->i_data_sem);
> > > >  	/*
> > > > +	 * if EXT4_EXT_MIGRATE is cleared a block allocation
> > > > +	 * happened after we started the migrate. We need to
> > > > +	 * fail the migrate
> > > > +	 */
> > > > +	if (!(EXT4_I(inode)->i_flags & EXT4_EXT_MIGRATE)) {
> > > > +		retval = -EAGAIN;
> > > > +		up_write(&EXT4_I(inode)->i_data_sem);
> > > > +		goto err_out;
> > > > +	} else
> > > > +		EXT4_I(inode)->i_flags = EXT4_I(inode)->i_flags &
> > > > +							~EXT4_EXT_MIGRATE;
> > > > +	/*
> > > 
> > > I could not see the caller of ext4_ext_swap_inode_data():
> > > ext4_ext_mirgrate() checks the return value from
> > > ext4_ext_swap_inode_data(). We probably should free allocated blocks,
> > > rebuild the extents tree for the tmp inode and do the swap again in the
> > > EAGAIN case. And for other error case probably need proper error
> > > handling too.
> > 
> > The ioctl will return EAGAIN and the application can issue the ioctl
> > again.
> > 
> In that case, I assume a new tmp inode is created and new blocks will be
> allocated? What I am refereing is the old tmp inode and the allocated
> blocks for it should be freed in case of EAGAIN error...I don't see the
> code is handling that. Maybe I missed something?

I updated the patch to call free_ext_block if ext4_ext_swap_inode_data
failed. I also verified that we have block and inode accounting correct
by running e2fsck and debugfs:stats.

I am attaching the updated patch below.

--+QahgC5+KEYLbs62
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="ext4-page-mkwrite.patch"

ext4: Use page_mkwrite vma_operations to get mmap write notification.

From: \"Aneesh Kumar K.V\" <aneesh.kumar@linux.vnet.ibm.com>

We would like to get notified when we are doing a write on mmap section.
This is needed with respect to preallocated area. We split the preallocated
area into initialzed extent and uninitialzed extent in the call back. This
let us handle ENOSPC better. Otherwise we get ENOSPC in the writepage and
that would result in data loss. The changes are also needed to handle ENOSPC
when writing to an mmap section of files with holes.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---

 fs/ext4/file.c          |   19 ++++++++++++++++++-
 fs/ext4/inode.c         |   11 +++++++++++
 include/linux/ext4_fs.h |    1 +
 3 files changed, 30 insertions(+), 1 deletions(-)


diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 20507a2..77341c1 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -123,6 +123,23 @@ force_commit:
 	return ret;
 }
 
+static struct vm_operations_struct ext4_file_vm_ops = {
+	.fault		= filemap_fault,
+	.page_mkwrite   = ext4_page_mkwrite,
+};
+
+static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct address_space *mapping = file->f_mapping;
+
+	if (!mapping->a_ops->readpage)
+		return -ENOEXEC;
+	file_accessed(file);
+	vma->vm_ops = &ext4_file_vm_ops;
+	vma->vm_flags |= VM_CAN_NONLINEAR;
+	return 0;
+}
+
 const struct file_operations ext4_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
@@ -133,7 +150,7 @@ const struct file_operations ext4_file_operations = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext4_compat_ioctl,
 #endif
-	.mmap		= generic_file_mmap,
+	.mmap		= ext4_file_mmap,
 	.open		= generic_file_open,
 	.release	= ext4_release_file,
 	.fsync		= ext4_sync_file,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7cd5133..a52904b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3493,3 +3493,14 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 
 	return err;
 }
+
+int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page)
+{
+	/*
+	 * if ext4_get_block resulted in a split of an uninitialized extent,
+	 * in file system full case, we will have to take the journal write
+	 * access and zero out the page. The journal handle get initialized
+	 * in ext4_get_block.
+	 */
+	return block_page_mkwrite(vma, page, ext4_get_block);
+}
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 22810b1..8f5a563 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -1059,6 +1059,7 @@ extern void ext4_set_aops(struct inode *inode);
 extern int ext4_writepage_trans_blocks(struct inode *);
 extern int ext4_block_truncate_page(handle_t *handle, struct page *page,
 		struct address_space *mapping, loff_t from);
+extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page);
 
 /* ioctl.c */
 extern long ext4_ioctl(struct file *, unsigned int, unsigned long);

--+QahgC5+KEYLbs62
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="ext4-migration-locking-fix.patch"

ext4: Fix race between migration and mmap write

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Fail migrate if we allocated new blocks via mmap write.

If we write to holes in the file via mmap, we endup allocating
new blocks. This block allocation happens without taking inode->i_mutex.
Since migrate is protected by i_mutex and migrate expect no
new blocks get allocated during migrate, fail migrate if new blocks
get allocated.

We can't take inode->i_mutex in the mmap write path because that
would result in a locking order violation between i_mutex and mmap_sem.
Also adding a seprate rw_sempahore for protecion is really high overhead
for a rare operation such as migrate.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Jan Kara <jack@suse.cz>
---

 fs/ext4/inode.c         |   13 ++++++++++++-
 fs/ext4/migrate.c       |   39 ++++++++++++++++++++++++++++++++++-----
 include/linux/ext4_fs.h |    1 +
 3 files changed, 47 insertions(+), 6 deletions(-)


diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a52904b..9587226 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -985,6 +985,16 @@ int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
 	} else {
 		retval = ext4_get_blocks_handle(handle, inode, block,
 				max_blocks, bh, create, extend_disksize);
+
+		if (retval > 0 && buffer_new(bh)) {
+			/*
+			 * We allocated new blocks which will result in
+			 * i_data format to change.  Force the migrate
+			 * to fail by * clearing migrate flags
+			 */
+			EXT4_I(inode)->i_flags = EXT4_I(inode)->i_flags &
+							~EXT4_EXT_MIGRATE;
+		}
 	}
 	up_write((&EXT4_I(inode)->i_data_sem));
 	return retval;
@@ -2962,7 +2972,8 @@ static int ext4_do_update_inode(handle_t *handle,
 	if (ext4_inode_blocks_set(handle, raw_inode, ei))
 		goto out_brelse;
 	raw_inode->i_dtime = cpu_to_le32(ei->i_dtime);
-	raw_inode->i_flags = cpu_to_le32(ei->i_flags);
+	/* clear the migrate flag in the raw_inode */
+	raw_inode->i_flags = cpu_to_le32(ei->i_flags & ~EXT4_EXT_MIGRATE);
 	if (EXT4_SB(inode->i_sb)->s_es->s_creator_os !=
 	    cpu_to_le32(EXT4_OS_HURD))
 		raw_inode->i_file_acl_high =
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 5c1e27d..6285ce1 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -327,7 +327,7 @@ static int free_ind_block(handle_t *handle, struct inode *inode, __le32 *i_data)
 }
 
 static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
-				struct inode *tmp_inode)
+						struct inode *tmp_inode)
 {
 	int retval;
 	__le32	i_data[3];
@@ -339,7 +339,7 @@ static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
 	 * i_data field of the original inode
 	 */
 	retval = ext4_journal_extend(handle, 1);
-	if (retval != 0) {
+	if (retval) {
 		retval = ext4_journal_restart(handle, 1);
 		if (retval)
 			goto err_out;
@@ -351,6 +351,18 @@ static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
 
 	down_write(&EXT4_I(inode)->i_data_sem);
 	/*
+	 * if EXT4_EXT_MIGRATE is cleared a block allocation
+	 * happened after we started the migrate. We need to
+	 * fail the migrate
+	 */
+	if (!(EXT4_I(inode)->i_flags & EXT4_EXT_MIGRATE)) {
+		retval = -EAGAIN;
+		up_write(&EXT4_I(inode)->i_data_sem);
+		goto err_out;
+	} else
+		EXT4_I(inode)->i_flags = EXT4_I(inode)->i_flags &
+							~EXT4_EXT_MIGRATE;
+	/*
 	 * We have the extent map build with the tmp inode.
 	 * Now copy the i_data across
 	 */
@@ -508,6 +520,17 @@ int ext4_ext_migrate(struct inode *inode, struct file *filp,
 	 * switch the inode format to prevent read.
 	 */
 	mutex_lock(&(inode->i_mutex));
+	/*
+	 * Even though we take i_mutex we can still cause block allocation
+	 * via mmap write to holes. If we have allocated new blocks we fail
+	 * migrate. New block allocation will clear EXT4_EXT_MIGRATE flag
+	 * The flag is updated with i_data_sem held to prevent racing with
+	 * block allocation.
+	 */
+	down_read((&EXT4_I(inode)->i_data_sem));
+	EXT4_I(inode)->i_flags = EXT4_I(inode)->i_flags | EXT4_EXT_MIGRATE;
+	up_read((&EXT4_I(inode)->i_data_sem));
+
 	handle = ext4_journal_start(inode, 1);
 
 	ei = EXT4_I(inode);
@@ -559,9 +582,15 @@ err_out:
 		 * tmp_inode
 		 */
 		free_ext_block(handle, tmp_inode);
-	else
-		retval = ext4_ext_swap_inode_data(handle, inode,
-							tmp_inode);
+	else {
+		retval = ext4_ext_swap_inode_data(handle, inode, tmp_inode);
+		if (retval)
+			/*
+			 * if we fail to swap inode data free the extent
+			 * details of the tmp inode
+			 */
+			free_ext_block(handle, tmp_inode);
+	}
 
 	/* We mark the tmp_inode dirty via ext4_ext_tree_init. */
 	if (ext4_journal_extend(handle, 1) != 0)
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 8f5a563..2d15f16 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -240,6 +240,7 @@ struct flex_groups {
 #define EXT4_TOPDIR_FL			0x00020000 /* Top of directory hierarchies*/
 #define EXT4_HUGE_FILE_FL               0x00040000 /* Set to each huge file */
 #define EXT4_EXTENTS_FL			0x00080000 /* Inode uses extents */
+#define EXT4_EXT_MIGRATE		0x00100000 /* Inode is migrating */
 #define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
 
 #define EXT4_FL_USER_VISIBLE		0x000BDFFF /* User visible flags */

--+QahgC5+KEYLbs62--
