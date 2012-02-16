From: =?UTF-8?q?Rados=C5=82aw=20Smogura?= <mail@smogura.eu>
Subject: [PATCH 17/18] [Experimental] Support for huge pages in EXT 4
Date: Thu, 16 Feb 2012 15:31:44 +0100
Message-ID: <1329402705-25454-17-git-send-email-mail@smogura.eu>
References: <1329402705-25454-1-git-send-email-mail@smogura.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>, mail@smogura.eu,
	linux-ext4@vger.kernel.org
To: linux-mm@kvack.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from flawless.hostnac.com ([67.23.244.186]:40874 "EHLO
	flawless.hostnac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab2BPVQc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Feb 2012 16:16:32 -0500
In-Reply-To: <1329402705-25454-1-git-send-email-mail@smogura.eu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It's rather experimental to uncover all leaks in adding huge page cache
support for shm, not for giving any real support for huge pages for
EXT4 file system. This will test if some concepts was good or bad.

In any case target is that some segments of glibc may be mapped as huge
pages, only if it will be aligned to huge page boundaries.

Signed-off-by: Rados=C5=82aw Smogura <mail@smogura.eu>
---
 fs/ext4/Kconfig                  |    9 ++++
 fs/ext4/file.c                   |    3 +
 fs/ext4/inode.c                  |   15 +++++++
 include/linux/defrag-pagecache.h |    4 ++
 include/linux/mm.h               |    4 ++
 mm/defrag-pagecache.c            |   19 +++++++++
 mm/filemap.c                     |   82 ++++++++++++++++++++++++++++++=
++++++++
 7 files changed, 136 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index 9ed1bb1..1a33bb0 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -83,3 +83,12 @@ config EXT4_DEBUG
=20
 	  If you select Y here, then you will be able to turn on debugging
 	  with a command such as "echo 1 > /sys/kernel/debug/ext4/mballoc-deb=
ug"
+
+config EXT4_HUGEPAGECACHE
+	bool "EXT4 Huge Page Cache Support [Danegerous]"
+	depends on EXT4_FS
+	depends on HUGEPAGECACHE
+	help
+	  It's rather experimental to uncover all leaks in adding huge page c=
ache
+	  support for shm, not for giving any real support for huge pages for
+	  EXT4 file system. This will test if some concepts was quite good.
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index cb70f18..57698df 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -143,6 +143,9 @@ ext4_file_write(struct kiocb *iocb, const struct io=
vec *iov,
=20
 static const struct vm_operations_struct ext4_file_vm_ops =3D {
 	.fault		=3D filemap_fault,
+#ifdef CONFIG_EXT4_HUGEPAGECACHE
+	.fault_huge	=3D filemap_fault_huge,
+#endif
 	.page_mkwrite   =3D ext4_page_mkwrite,
 };
=20
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index feaa82f..8bbda5a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -45,6 +45,9 @@
=20
 #include <trace/events/ext4.h>
=20
+#ifdef CONFIG_EXT4_HUGEPAGECACHE
+#include <linux/defrag-pagecache.h>
+#endif
 #define MPAGE_DA_EXTENT_TAIL 0x01
=20
 static inline int ext4_begin_ordered_truncate(struct inode *inode,
@@ -3036,6 +3039,9 @@ static const struct address_space_operations ext4=
_ordered_aops =3D {
 	.migratepage		=3D buffer_migrate_page,
 	.is_partially_uptodate  =3D block_is_partially_uptodate,
 	.error_remove_page	=3D generic_error_remove_page,
+#ifdef CONFIG_EXT4_HUGEPAGECACHE
+	.defragpage		=3D defrag_generic_file,
+#endif
 };
=20
 static const struct address_space_operations ext4_writeback_aops =3D {
@@ -3051,6 +3057,9 @@ static const struct address_space_operations ext4=
_writeback_aops =3D {
 	.migratepage		=3D buffer_migrate_page,
 	.is_partially_uptodate  =3D block_is_partially_uptodate,
 	.error_remove_page	=3D generic_error_remove_page,
+#ifdef CONFIG_EXT4_HUGEPAGECACHE
+	.defragpage		=3D defrag_generic_file,
+#endif
 };
=20
 static const struct address_space_operations ext4_journalled_aops =3D =
{
@@ -3066,6 +3075,9 @@ static const struct address_space_operations ext4=
_journalled_aops =3D {
 	.direct_IO		=3D ext4_direct_IO,
 	.is_partially_uptodate  =3D block_is_partially_uptodate,
 	.error_remove_page	=3D generic_error_remove_page,
+#ifdef CONFIG_EXT4_HUGEPAGECACHE
+	.defragpage		=3D defrag_generic_file,
+#endif
 };
=20
 static const struct address_space_operations ext4_da_aops =3D {
@@ -3082,6 +3094,9 @@ static const struct address_space_operations ext4=
_da_aops =3D {
 	.migratepage		=3D buffer_migrate_page,
 	.is_partially_uptodate  =3D block_is_partially_uptodate,
 	.error_remove_page	=3D generic_error_remove_page,
+#ifdef CONFIG_EXT4_HUGEPAGECACHE
+	.defragpage		=3D defrag_generic_file,
+#endif
 };
=20
 void ext4_set_aops(struct inode *inode)
diff --git a/include/linux/defrag-pagecache.h b/include/linux/defrag-pa=
gecache.h
index 4ca3468..fb305c8 100644
--- a/include/linux/defrag-pagecache.h
+++ b/include/linux/defrag-pagecache.h
@@ -42,5 +42,9 @@ extern int defrag_generic_shm(struct file *file, stru=
ct address_space *mapping,
 			   loff_t pos,
 			   struct page **pagep,
 			   struct defrag_pagecache_ctl *ctl);
+extern int defrag_generic_file(struct file *file, struct address_space=
 *mapping,
+			   loff_t pos,
+			   struct page **pagep,
+			   struct defrag_pagecache_ctl *ctl);
 #endif	/* DEFRAG_PAGECACHE_H */
=20
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 4c67555..24c2c6c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1620,6 +1620,10 @@ extern void truncate_inode_pages_range(struct ad=
dress_space *,
 /* generic vm_area_ops exported for stackable file systems */
 extern int filemap_fault(struct vm_area_struct *, struct vm_fault *);
=20
+#ifdef CONFIG_HUGEPAGECACHE
+extern int filemap_fault_huge(struct vm_area_struct *vma, struct vm_fa=
ult *vmf);
+#endif
+
 /* mm/page-writeback.c */
 int write_one_page(struct page *page, int wait);
 void task_dirty_inc(struct task_struct *tsk);
diff --git a/mm/defrag-pagecache.c b/mm/defrag-pagecache.c
index 5a14fe8..6a87814 100644
--- a/mm/defrag-pagecache.c
+++ b/mm/defrag-pagecache.c
@@ -104,6 +104,16 @@ struct page *shmem_defrag_get_page(const struct de=
frag_pagecache_ctl *ctl,
 				mapping_gfp_mask(inode->i_mapping));
 }
=20
+/** Callback for getting page for tmpfs.
+ * Tmpfs uses {@link shmem_read_mapping_page_gfp} function to read
+ * page from page cache.
+ */
+struct page *file_defrag_get_page(const struct defrag_pagecache_ctl *c=
tl,
+	struct inode *inode, pgoff_t pageIndex)
+{
+	return read_mapping_page(inode->i_mapping, pageIndex, NULL);
+}
+
 static void defrag_generic_mig_result(struct page *oldPage,
 	struct page *newPage, struct migration_ctl *ctl, int result)
 {
@@ -258,6 +268,15 @@ int defrag_generic_shm(struct file *file, struct a=
ddress_space *mapping,
 }
 EXPORT_SYMBOL(defrag_generic_shm);
=20
+int defrag_generic_file(struct file *file, struct address_space *mappi=
ng,
+			   loff_t pos,
+			   struct page **pagep,
+			   struct defrag_pagecache_ctl *ctl)
+{
+	return defrageOneHugePage(file, pos, pagep, ctl, file_defrag_get_page=
);
+}
+EXPORT_SYMBOL(defrag_generic_file);
+
 int defrag_generic_pagecache(struct file *file,
 			struct address_space *mapping,
 			loff_t pos,
diff --git a/mm/filemap.c b/mm/filemap.c
index 8363cd9..f050209 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -43,6 +43,9 @@
=20
 #include <asm/mman.h>
=20
+#ifdef CONFIG_HUGEPAGECACHE
+#include <linux/defrag-pagecache.h>
+#endif
 /*
  * Shared mappings implemented 30.11.1994. It's not fully working yet,
  * though.
@@ -1771,6 +1774,85 @@ page_not_uptodate:
 }
 EXPORT_SYMBOL(filemap_fault);
=20
+#ifdef CONFIG_HUGEPAGECACHE
+/** DO NOT USE THIS METHOD IS STILL EXPERIMENTAL. */
+int filemap_fault_huge(struct vm_area_struct *vma, struct vm_fault *vm=
f)
+{
+	struct inode *inode =3D vma->vm_file->f_path.dentry->d_inode;
+	int error;
+	int ret =3D VM_FAULT_LOCKED;
+
+	error =3D vma->vm_ops->fault(vma, vmf);
+	/* XXX Repeatable flags in __do fault etc. */
+	if (error & (VM_FAULT_ERROR | VM_FAULT_NOPAGE
+		| VM_FAULT_RETRY | VM_FAULT_NOHUGE)) {
+		return error;
+	}
+
+	/* Just portion of developer code, to force defragmentation, as we ha=
ve
+	 * no external interface to make defragmentation (or daemon to do it)=
=2E
+	 */
+	if ((vma->vm_flags & VM_HUGEPAGE) && !PageCompound(vmf->page)) {
+		/* Force defrag - mainly devo code */
+		int defragResult;
+		const loff_t hugeChunkSize =3D 1 << (PMD_SHIFT - PAGE_SHIFT);
+
+		const loff_t vmaSizeToMap =3D (vma->vm_start
+				+ ((vmf->pgoff + vma->vm_pgoff + hugeChunkSize)
+				<< PAGE_SHIFT) <=3D vma->vm_end) ?
+					hugeChunkSize : 0;
+
+		const loff_t inodeSizeToMap =3D
+				(vmf->pgoff + vma->vm_pgoff + hugeChunkSize <
+				inode->i_size) ? hugeChunkSize : 0;
+
+		const struct defrag_pagecache_ctl defragControl =3D {
+			.fillPages =3D 1,
+			.requireFillPages =3D 1,
+			.force =3D 1
+		};
+
+		if (ret & VM_FAULT_LOCKED) {
+			unlock_page(vmf->page);
+		}
+		put_page(vmf->page);
+
+		defragResult =3D defragPageCache(vma->vm_file,
+			vmf->pgoff,
+			min(vmaSizeToMap, min(inodeSizeToMap, hugeChunkSize)),
+			&defragControl);
+		printk(KERN_INFO "Page defragmented with result %d\n",
+			defragResult);
+
+		/* Retake page. */
+		error =3D vma->vm_ops->fault(vma, vmf);
+		if (error & (VM_FAULT_ERROR | VM_FAULT_NOPAGE
+			| VM_FAULT_RETRY | VM_FAULT_NOHUGE)) {
+			return error;
+		}
+	}
+
+	/* After standard fault page is getted. */
+	if (!compound_get(vmf->page))
+		goto no_hugepage;
+
+	get_page_tails_for_fmap(vmf->page);
+
+	if (ret & VM_FAULT_MAJOR) {
+		count_vm_event(PGMAJFAULT);
+		mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
+	}
+	return ret;
+no_hugepage:
+	if (ret & VM_FAULT_LOCKED)
+		unlock_page(vmf->page);
+	page_cache_release(vmf->page);
+	vmf->page =3D NULL;
+	return VM_FAULT_NOHUGE;
+}
+EXPORT_SYMBOL(filemap_fault_huge);
+#endif
+
 const struct vm_operations_struct generic_file_vm_ops =3D {
 	.fault		=3D filemap_fault,
 };
--=20
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
