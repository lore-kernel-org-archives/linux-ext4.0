From: =?UTF-8?q?Rados=C5=82aw=20Smogura?= <mail@smogura.eu>
Subject: [PATCH 11/18] Basic support (faulting) for huge pages for shmfs
Date: Thu, 16 Feb 2012 15:31:38 +0100
Message-ID: <1329402705-25454-11-git-send-email-mail@smogura.eu>
References: <1329402705-25454-1-git-send-email-mail@smogura.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>, mail@smogura.eu,
	linux-ext4@vger.kernel.org
To: linux-mm@kvack.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from flawless.hostnac.com ([67.23.244.186]:40945 "EHLO
	flawless.hostnac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab2BPVRg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Feb 2012 16:17:36 -0500
In-Reply-To: <1329402705-25454-1-git-send-email-mail@smogura.eu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is basic support for shmfs, allowing bootstraping of huge pages
in user address space.

This patch is just one first setep, it breakes kernel, because of
missing other requirements for page cache, but establishing is
done :D. Yupi!

Signed-off-by: Rados=C5=82aw Smogura <mail@smogura.eu>
---
 include/linux/fs.h |    4 ++--
 include/linux/mm.h |    4 ++--
 mm/shmem.c         |   30 ++++++++++++++----------------
 3 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7288166..7afc38b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -595,7 +595,7 @@ struct address_space_operations {
=20
 	/** Same as \a set_page_dirty but for huge page */
 	int (*set_page_dirty_huge)(struct page *page);
-=09
+
 	int (*readpages)(struct file *filp, struct address_space *mapping,
 			struct list_head *pages, unsigned nr_pages);
=20
@@ -627,7 +627,7 @@ struct address_space_operations {
 	 */
 	int (*split_page) (struct file *file, struct address_space *mapping,
 		loff_t pos, struct page *hueg_page);
-=09
+
 	/* Unfortunately this kludge is needed for FIBMAP. Don't use it */
 	sector_t (*bmap)(struct address_space *, sector_t);
 	void (*invalidatepage) (struct page *, unsigned long);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 27a10c8..236a6be 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -210,7 +210,7 @@ struct vm_operations_struct {
 	 * If function fails, then caller may try again with fault.
 	 */
 	int (*fault_huge)(struct vm_area_struct *vma, struct vm_fault *vmf);
-=09
+
 	/* notification that a previously read-only page is about to become
 	 * writable, if an error is returned it will cause a SIGBUS */
 	int (*page_mkwrite)(struct vm_area_struct *vma, struct vm_fault *vmf)=
;
@@ -218,7 +218,7 @@ struct vm_operations_struct {
 	/** Same as \a page_mkwrite, but for huge page. */
 	int (*page_mkwrite_huge)(struct vm_area_struct *vma,
 				 struct vm_fault *vmf);
-=09
+
 	/* called by access_process_vm when get_user_pages() fails, typically
 	 * for use by special VMAs that can switch between memory and hardwar=
e
 	 */
diff --git a/mm/shmem.c b/mm/shmem.c
index a834488..97e76b9 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -67,6 +67,10 @@ static struct vfsmount *shm_mnt;
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
=20
+#ifdef CONFIG_HUGEPAGECACHE
+#include <linux/defrag-pagecache.h>
+#endif
+
 #define BLOCKS_PER_PAGE  (PAGE_CACHE_SIZE/512)
 #define VM_ACCT(size)    (PAGE_CACHE_ALIGN(size) >> PAGE_SHIFT)
=20
@@ -1119,24 +1123,12 @@ static int shmem_fault_huge(struct vm_area_stru=
ct *vma, struct vm_fault *vmf)
 		}
 	}
=20
-	/* XXX Page & compound lock ordering please... */
-=09
 	/* After standard fault page is getted. */
-	if (PageCompound(vmf->page)) {
-		compound_lock(vmf->page);
-		if (!PageHead(vmf->page)) {
-			compound_unlock(vmf->page);
-			goto no_hugepage;
-		}
-	}else {
+	if (!compound_get(vmf->page))
 		goto no_hugepage;
-	}
-=09
-	if (!(ret & VM_FAULT_LOCKED))
-		lock_page(vmf->page);
-=09
-	ret |=3D VM_FAULT_LOCKED;
-=09
+
+	get_page_tails_for_fmap(vmf->page);
+
 	if (ret & VM_FAULT_MAJOR) {
 		count_vm_event(PGMAJFAULT);
 		mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
@@ -2381,6 +2373,9 @@ static const struct address_space_operations shme=
m_aops =3D {
 #endif
 	.migratepage	=3D migrate_page,
 	.error_remove_page =3D generic_error_remove_page,
+#ifdef CONFIG_HUGEPAGECACHE
+	.defragpage =3D defrag_generic_shm,
+#endif
 };
=20
 static const struct file_operations shmem_file_operations =3D {
@@ -2458,6 +2453,9 @@ static const struct super_operations shmem_ops =3D=
 {
=20
 static const struct vm_operations_struct shmem_vm_ops =3D {
 	.fault		=3D shmem_fault,
+#ifdef CONFIG_SHMEM_HUGEPAGECACHE
+	.fault_huge	=3D shmem_fault_huge,
+#endif
 #ifdef CONFIG_NUMA
 	.set_policy     =3D shmem_set_policy,
 	.get_policy     =3D shmem_get_policy,
--=20
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
