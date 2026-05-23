Received: from sender-pp-o92.zoho.in (sender-pp-o92.zoho.in [103.117.158.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44BE3939CE;
	Sat, 23 May 2026 12:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=103.117.158.92
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779538856; cv=pass; b=ivVl39CdpNuMblXWditwe7narU8u27ND+xz5xgHL9mp4TwlA/p86N84JZi111ACme9AIQIxtlm+8jwrtbdmRg+lsLCuSfPdFCZ8UBPFkIYulp8aTrQiebsQeXBH9eyowtzkwBfP2SeYWcyzroeFUf9RTkkutaw2vY/9TnxkKMg8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779538856; c=relaxed/simple;
	bh=6sa6hvP5mB9FaPXvxf1cnVW/QQHYY+xnUr47pFffrEc=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:Subject:MIME-Version:
	 Content-Type; b=p2Z7pUnVNTEnhrXQ/0wLI4xaAe8ZamCjv8q9BcIJUSPQtVRUQiDXeQkbCuv4Z2jnLFcbXy18Yv/aTPDk37vA/sZlZsauWuXuOyHXQqAn+2/QzgXicWaC9YlUebSag/IjY17L3tWkS10pn+5JIduTOQV9zkVaPE4zql9zKa1Ld7w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.in; spf=pass smtp.mailfrom=zohomail.in; dkim=pass (1024-bit key) header.d=zohomail.in header.i=linuxuser509@zohomail.in header.b=AwvYdPuk; arc=pass smtp.client-ip=103.117.158.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zohomail.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zohomail.in header.i=linuxuser509@zohomail.in header.b="AwvYdPuk"
ARC-Seal: i=1; a=rsa-sha256; t=1779538843; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=ZsemDNEZh3xwSj+rt8vc9PIvK4K3IokfNr7IGIIJ88in2pj72/ybHSV28gV9m8zQQdErP5FbpWHKSchYRF1yx0D2GTFefmQzbdYn/O/QmlDctQ3vN52AVKyefgi24qmLNG/ShlzjbfmZ5dwykKyFA0OwDVGSXTKAETNGTk+Oyb4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1779538843; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=6vn5x5LKevhZujfUTBiE7UjDldMFm57pdjv/p6MnZwg=; 
	b=Le1IXYoZfifBh2t17v/DTgK30XrWOKnp+1tBUbkUDkIHMnXQa/b49cRnjQws4dj3aTYUgX3WGwe7Rk27fSGmpWxWAYKeH3YYWPnYNSybSRsno7dUwHKFcaqCLI01CWJirXFhMo8LYGKuEiT8l0DKXaaG+2QlPMBOnYT6okI/ecE=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=linuxuser509@zohomail.in;
	dmarc=pass header.from=<linuxuser509@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1779538843;
	s=zoho; d=zohomail.in; i=linuxuser509@zohomail.in;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=6vn5x5LKevhZujfUTBiE7UjDldMFm57pdjv/p6MnZwg=;
	b=AwvYdPukgUXzC8pskjy4uvse2nImu8a0v0ez9kESNPEWsJWAX3nT/S1p5USRoIJz
	PTuzHpIO5+aW8ZdSql6ilaiwzmlNcFly9Y6LdGT+mXGaxLIAGPhwlIx7UhtHMtr/RNk
	m+oBKIVgWCzfKFpNLvgl5wUQlVguMJ1LTGtYzOM4=
Received: from mail.zoho.in by mx.zoho.in
	with SMTP id 1779538840491666.7853950239524; Sat, 23 May 2026 17:50:40 +0530 (IST)
Received: from  [106.219.5.223] by mail.zoho.in
	with HTTP;Sat, 23 May 2026 17:50:40 +0530 (IST)
Date: Sat, 23 May 2026 17:50:40 +0530
From: Ashwin Gundarapu <linuxuser509@zohomail.in>
To: "jack" <jack@suse.com>
Cc: "linux-ext4" <linux-ext4@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>
Message-ID: <19e54c7cba1.5355cb8650862.622752146451851140@zohomail.in>
In-Reply-To: 
Subject: [PATCH] ext2: Remove deprecated DAX support
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail

DAX support in ext2 was deprecated in commit d5a2693f93e4
("ext2: Deprecate DAX") with a removal deadline of end of 2025.
Remove all DAX code from ext2 as scheduled.

This removes the DAX mount option, IOMAP DAX support, DAX file
operations, DAX address_space_operations, and the DAX fault handler.

Signed-off-by: Ashwin Gundarapu <linuxuser509@zohomail.in>
---
 fs/ext2/ext2.h  |   5 +-
 fs/ext2/file.c  | 118 ++----------------------------------------------
 fs/ext2/inode.c |  60 ++----------------------
 fs/ext2/super.c |  45 +++---------------
 4 files changed, 16 insertions(+), 212 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 3eb1f342645c..3a26308ec841 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -114,8 +114,6 @@ struct ext2_sb_info {
 	 */
 	spinlock_t s_lock;
 	struct mb_cache *s_ea_block_cache;
-	struct dax_device *s_daxdev;
-	u64 s_dax_part_off;
 };

 static inline spinlock_t *
@@ -373,11 +371,10 @@ struct ext2_inode {
 #define EXT2_MOUNT_NO_UID32		0x000200  /* Disable 32-bit UIDs */
 #define EXT2_MOUNT_XATTR_USER		0x004000  /* Extended user attributes */
 #define EXT2_MOUNT_POSIX_ACL		0x008000  /* POSIX Access Control Lists */
-#define EXT2_MOUNT_XIP			0x010000  /* Obsolete, use DAX */
+#define EXT2_MOUNT_XIP			0x010000  /* Obsolete*/
 #define EXT2_MOUNT_USRQUOTA		0x020000  /* user quota */
 #define EXT2_MOUNT_GRPQUOTA		0x040000  /* group quota */
 #define EXT2_MOUNT_RESERVATION		0x080000  /* Preallocation */
-#define EXT2_MOUNT_DAX			0x100000  /* Direct Access */
 
 
 #define clear_opt(o, opt)		o &= ~EXT2_MOUNT_##opt
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index d9b1eb34694a..0fd9208af062 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -21,7 +21,6 @@

 #include <linux/time.h>
 #include <linux/pagemap.h>
-#include <linux/dax.h>
 #include <linux/filelock.h>
 #include <linux/quotaops.h>
 #include <linux/iomap.h>
@@ -32,111 +31,6 @@
 #include "acl.h"
 #include "trace.h"

-#ifdef CONFIG_FS_DAX
-static ssize_t ext2_dax_read_iter(struct kiocb *iocb, struct iov_iter *to)
-{
-	struct inode *inode = iocb->ki_filp->f_mapping->host;
-	ssize_t ret;
-
-	if (!iov_iter_count(to))
-		return 0; /* skip atime */
-
-	inode_lock_shared(inode);
-	ret = dax_iomap_rw(iocb, to, &ext2_iomap_ops);
-	inode_unlock_shared(inode);
-
-	file_accessed(iocb->ki_filp);
-	return ret;
-}
-
-static ssize_t ext2_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
-{
-	struct file *file = iocb->ki_filp;
-	struct inode *inode = file->f_mapping->host;
-	ssize_t ret;
-
-	inode_lock(inode);
-	ret = generic_write_checks(iocb, from);
-	if (ret <= 0)
-		goto out_unlock;
-	ret = file_remove_privs(file);
-	if (ret)
-		goto out_unlock;
-	ret = file_update_time(file);
-	if (ret)
-		goto out_unlock;
-
-	ret = dax_iomap_rw(iocb, from, &ext2_iomap_ops);
-	if (ret > 0 && iocb->ki_pos > i_size_read(inode)) {
-		i_size_write(inode, iocb->ki_pos);
-		mark_inode_dirty(inode);
-	}
-
-out_unlock:
-	inode_unlock(inode);
-	if (ret > 0)
-		ret = generic_write_sync(iocb, ret);
-	return ret;
-}
-
-/*
- * The lock ordering for ext2 DAX fault paths is:
- *
- * mmap_lock (MM)
- *   sb_start_pagefault (vfs, freeze)
- *     address_space->invalidate_lock
- *       address_space->i_mmap_rwsem or page_lock (mutually exclusive in DAX)
- *         ext2_inode_info->truncate_mutex
- *
- * The default page_lock and i_size verification done by non-DAX fault paths
- * is sufficient because ext2 doesn't support hole punching.
- */
-static vm_fault_t ext2_dax_fault(struct vm_fault *vmf)
-{
-	struct inode *inode = file_inode(vmf->vma->vm_file);
-	vm_fault_t ret;
-	bool write = (vmf->flags & FAULT_FLAG_WRITE) &&
-		(vmf->vma->vm_flags & VM_SHARED);
-
-	if (write) {
-		sb_start_pagefault(inode->i_sb);
-		file_update_time(vmf->vma->vm_file);
-	}
-	filemap_invalidate_lock_shared(inode->i_mapping);
-
-	ret = dax_iomap_fault(vmf, 0, NULL, NULL, &ext2_iomap_ops);
-
-	filemap_invalidate_unlock_shared(inode->i_mapping);
-	if (write)
-		sb_end_pagefault(inode->i_sb);
-	return ret;
-}
-
-static const struct vm_operations_struct ext2_dax_vm_ops = {
-	.fault		= ext2_dax_fault,
-	/*
-	 * .huge_fault is not supported for DAX because allocation in ext2
-	 * cannot be reliably aligned to huge page sizes and so pmd faults
-	 * will always fail and fail back to regular faults.
-	 */
-	.page_mkwrite	= ext2_dax_fault,
-	.pfn_mkwrite	= ext2_dax_fault,
-};
-
-static int ext2_file_mmap_prepare(struct vm_area_desc *desc)
-{
-	struct file *file = desc->file;
-
-	if (!IS_DAX(file_inode(file)))
-		return generic_file_mmap_prepare(desc);
-
-	file_accessed(file);
-	desc->vm_ops = &ext2_dax_vm_ops;
-	return 0;
-}
-#else
-#define ext2_file_mmap_prepare	generic_file_mmap_prepare
-#endif
 
 /*
  * Called when filp is released. This happens when all file descriptors
@@ -285,10 +179,7 @@ static ssize_t ext2_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 static ssize_t ext2_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
-#ifdef CONFIG_FS_DAX
-	if (IS_DAX(iocb->ki_filp->f_mapping->host))
-		return ext2_dax_read_iter(iocb, to);
-#endif
+
 	if (iocb->ki_flags & IOCB_DIRECT)
 		return ext2_dio_read_iter(iocb, to);

@@ -297,10 +188,7 @@ static ssize_t ext2_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 
 static ssize_t ext2_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
-#ifdef CONFIG_FS_DAX
-	if (IS_DAX(iocb->ki_filp->f_mapping->host))
-		return ext2_dax_write_iter(iocb, from);
-#endif
+
 	if (iocb->ki_flags & IOCB_DIRECT)
 		return ext2_dio_write_iter(iocb, from);

@@ -321,7 +209,7 @@ const struct file_operations ext2_file_operations = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext2_compat_ioctl,
 #endif
-	.mmap_prepare	= ext2_file_mmap_prepare,
+	.mmap_prepare = generic_file_mmap_prepare,
 	.open		= ext2_file_open,
 	.release	= ext2_release_file,
 	.fsync		= ext2_fsync,
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 74aca5eb572d..91fc4709836f 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -26,7 +26,6 @@
 #include <linux/time.h>
 #include <linux/highuid.h>
 #include <linux/pagemap.h>
-#include <linux/dax.h>
 #include <linux/blkdev.h>
 #include <linux/quotaops.h>
 #include <linux/writeback.h>
@@ -741,27 +740,6 @@ static int ext2_get_blocks(struct inode *inode,
 		goto cleanup;
 	}
 
-	if (IS_DAX(inode)) {
-		/*
-		 * We must unmap blocks before zeroing so that writeback cannot
-		 * overwrite zeros with stale data from block device page cache.
-		 */
-		clean_bdev_aliases(inode->i_sb->s_bdev,
-				   le32_to_cpu(chain[depth-1].key),
-				   count);
-		/*
-		 * block must be initialised before we put it in the tree
-		 * so that it's not found by another thread before it's
-		 * initialised
-		 */
-		err = sb_issue_zeroout(inode->i_sb,
-				le32_to_cpu(chain[depth-1].key), count,
-				GFP_KERNEL);
-		if (err) {
-			mutex_unlock(&ei->truncate_mutex);
-			goto cleanup;
-		}
-	}
 	*new = true;
 
 	ext2_splice_branch(inode, iblock, partial, indirect_blks, count);
@@ -841,10 +819,7 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 
 	iomap->flags = 0;
 	iomap->offset = (u64)first_block << blkbits;
-	if (flags & IOMAP_DAX)
-		iomap->dax_dev = sbi->s_daxdev;
-	else
-		iomap->bdev = inode->i_sb->s_bdev;
+        iomap->bdev = inode->i_sb->s_bdev;
 
 	if (ret == 0) {
 		/*
@@ -859,8 +834,6 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	} else {
 		iomap->type = IOMAP_MAPPED;
 		iomap->addr = (u64)bno << blkbits;
-		if (flags & IOMAP_DAX)
-			iomap->addr += sbi->s_dax_part_off;
 		iomap->length = (u64)ret << blkbits;
 		iomap->flags |= IOMAP_F_MERGED;
 	}
@@ -962,13 +935,6 @@ ext2_writepages(struct address_space *mapping, struct writeback_control *wbc)
 	return mpage_writepages(mapping, wbc, ext2_get_block);
 }
 
-static int
-ext2_dax_writepages(struct address_space *mapping, struct writeback_control *wbc)
-{
-	struct ext2_sb_info *sbi = EXT2_SB(mapping->host->i_sb);
-
-	return dax_writeback_mapping_range(mapping, sbi->s_daxdev, wbc);
-}

 const struct address_space_operations ext2_aops = {
 	.dirty_folio		= block_dirty_folio,
@@ -984,10 +950,6 @@ const struct address_space_operations ext2_aops = {
 	.error_remove_folio	= generic_error_remove_folio,
 };
 
-static const struct address_space_operations ext2_dax_aops = {
-	.writepages		= ext2_dax_writepages,
-	.dirty_folio		= noop_dirty_folio,
-};
 
 /*
  * Probably it should be a library function... search for first non-zero word
@@ -1186,9 +1148,6 @@ static void __ext2_truncate_blocks(struct inode *inode, loff_t offset)
 	blocksize = inode->i_sb->s_blocksize;
 	iblock = (offset + blocksize-1) >> EXT2_BLOCK_SIZE_BITS(inode->i_sb);

-#ifdef CONFIG_FS_DAX
-	WARN_ON(!rwsem_is_locked(&inode->i_mapping->invalidate_lock));
-#endif
 
 	n = ext2_block_to_path(inode, iblock, offsets, NULL);
 	if (n == 0)
@@ -1290,12 +1249,8 @@ static int ext2_setsize(struct inode *inode, loff_t newsize)
 
 	inode_dio_wait(inode);
 
-	if (IS_DAX(inode))
-		error = dax_truncate_page(inode, newsize, NULL,
-					  &ext2_iomap_ops);
-	else
-		error = block_truncate_page(inode->i_mapping,
-				newsize, ext2_get_block);
+        error = block_truncate_page(inode->i_mapping,
+                                newsize, ext2_get_block);
 	if (error)
 		return error;
 
@@ -1363,7 +1318,7 @@ void ext2_set_inode_flags(struct inode *inode)
 	unsigned int flags = EXT2_I(inode)->i_flags;

 	inode->i_flags &= ~(S_SYNC | S_APPEND | S_IMMUTABLE | S_NOATIME |
-				S_DIRSYNC | S_DAX);
+				S_DIRSYNC);
 	if (flags & EXT2_SYNC_FL)
 		inode->i_flags |= S_SYNC;
 	if (flags & EXT2_APPEND_FL)
@@ -1374,18 +1329,13 @@ void ext2_set_inode_flags(struct inode *inode)
 		inode->i_flags |= S_NOATIME;
 	if (flags & EXT2_DIRSYNC_FL)
 		inode->i_flags |= S_DIRSYNC;
-	if (test_opt(inode->i_sb, DAX) && S_ISREG(inode->i_mode))
-		inode->i_flags |= S_DAX;
 }
 
 void ext2_set_file_ops(struct inode *inode)
 {
 	inode->i_op = &ext2_file_inode_operations;
 	inode->i_fop = &ext2_file_operations;
-	if (IS_DAX(inode))
-		inode->i_mapping->a_ops = &ext2_dax_aops;
-	else
-		inode->i_mapping->a_ops = &ext2_aops;
+    inode->i_mapping->a_ops = &ext2_aops;
 }
 
 struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 19f76d8cb473..ede4ad84828c 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -34,7 +34,6 @@
 #include <linux/log2.h>
 #include <linux/quotaops.h>
 #include <linux/uaccess.h>
-#include <linux/dax.h>
 #include <linux/iversion.h>
 #include "ext2.h"
 #include "xattr.h"
@@ -198,7 +197,6 @@ static void ext2_put_super (struct super_block * sb)
 	brelse (sbi->s_sbh);
 	sb->s_fs_info = NULL;
 	kfree(sbi->s_blockgroup_lock);
-	fs_put_dax(sbi->s_daxdev, NULL);
 	kfree(sbi);
 }
 
@@ -332,8 +330,6 @@ static int ext2_show_options(struct seq_file *seq, struct dentry *root)
 	if (test_opt(sb, XIP))
 		seq_puts(seq, ",xip");
 
-	if (test_opt(sb, DAX))
-		seq_puts(seq, ",dax");
 
 	if (!test_opt(sb, RESERVATION))
 		seq_puts(seq, ",noreservation");
@@ -432,7 +428,7 @@ static const struct export_operations ext2_export_ops = {
 enum {
 	Opt_bsd_df, Opt_minix_df, Opt_grpid, Opt_nogrpid, Opt_resgid, Opt_resuid,
 	Opt_sb, Opt_errors, Opt_nouid32, Opt_debug, Opt_oldalloc, Opt_orlov,
-	Opt_nobh, Opt_user_xattr, Opt_acl, Opt_xip, Opt_dax, Opt_ignore,
+	Opt_nobh, Opt_user_xattr, Opt_acl, Opt_xip, Opt_ignore,
 	Opt_quota, Opt_usrquota, Opt_grpquota, Opt_reservation,
 };
 
@@ -462,7 +458,6 @@ static const struct fs_parameter_spec ext2_param_spec[] = {
 	fsparam_flag_no	("user_xattr", Opt_user_xattr),
 	fsparam_flag_no	("acl", Opt_acl),
 	fsparam_flag	("xip", Opt_xip),
-	fsparam_flag	("dax", Opt_dax),
 	fsparam_flag	("grpquota", Opt_grpquota),
 	fsparam_flag	("noquota", Opt_ignore),
 	fsparam_flag	("quota", Opt_quota),
@@ -595,20 +590,9 @@ static int ext2_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		ext2_msg_fc(fc, KERN_INFO, "(no)acl options not supported");
 		break;
 #endif
-	case Opt_xip:
-		ext2_msg_fc(fc, KERN_INFO, "use dax instead of xip");
-		ctx_set_mount_opt(ctx, EXT2_MOUNT_XIP);
-		fallthrough;
-	case Opt_dax:
-#ifdef CONFIG_FS_DAX
-		ext2_msg_fc(fc, KERN_WARNING,
-		    "DAX enabled. Warning: DAX support in ext2 driver is deprecated"
-		    " and will be removed at the end of 2025. Please use ext4 driver instead.");
-		ctx_set_mount_opt(ctx, EXT2_MOUNT_DAX);
-#else
-		ext2_msg_fc(fc, KERN_INFO, "dax option not supported");
-#endif
-		break;
+        case Opt_xip:
+                ext2_msg_fc(fc, KERN_ERR, "DAX support has been removed. Please use ext4 instead.");
+                return -EINVAL;
 
 #if defined(CONFIG_QUOTA)
 	case Opt_quota:
@@ -906,8 +890,6 @@ static int ext2_fill_super(struct super_block *sb, struct fs_context *fc)
 	}
 	sb->s_fs_info = sbi;
 	sbi->s_sb_block = sb_block;
-	sbi->s_daxdev = fs_dax_get_by_bdev(sb->s_bdev, &sbi->s_dax_part_off,
-					   NULL, NULL);
 
 	spin_lock_init(&sbi->s_lock);
 	ret = -EINVAL;
@@ -992,16 +974,8 @@ static int ext2_fill_super(struct super_block *sb, struct fs_context *fc)
 	}
 	blocksize = BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
 
-	if (test_opt(sb, DAX)) {
-		if (!sbi->s_daxdev) {
-			ext2_msg(sb, KERN_ERR,
-				"DAX unsupported by block device. Turning off DAX.");
-			clear_opt(sbi->s_mount_opt, DAX);
-		} else if (blocksize != PAGE_SIZE) {
-			ext2_msg(sb, KERN_ERR, "unsupported blocksize for DAX\n");
-			clear_opt(sbi->s_mount_opt, DAX);
-		}
-	}
+
+

 	/* If the blocksize doesn't match, re-read the thing.. */
 	if (sb->s_blocksize != blocksize) {
@@ -1252,7 +1226,6 @@ static int ext2_fill_super(struct super_block *sb, struct fs_context *fc)
 failed_mount:
 	brelse(bh);
 failed_sbi:
-	fs_put_dax(sbi->s_daxdev, NULL);
 	sb->s_fs_info = NULL;
 	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
@@ -1379,11 +1352,7 @@ static int ext2_reconfigure(struct fs_context *fc)

 	spin_lock(&sbi->s_lock);
 	es = sbi->s_es;
-	if ((sbi->s_mount_opt ^ new_opts.s_mount_opt) & EXT2_MOUNT_DAX) {
-		ext2_msg(sb, KERN_WARNING, "warning: refusing change of "
-			 "dax flag with busy inodes while remounting");
-		new_opts.s_mount_opt ^= EXT2_MOUNT_DAX;
-	}
+
 	if ((bool)(flags & SB_RDONLY) == sb_rdonly(sb))
 		goto out_set;
 	if (flags & SB_RDONLY) {
--
2.43.0

