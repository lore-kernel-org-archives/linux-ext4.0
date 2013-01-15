From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 2/6] mm: Only enforce stable page writes if the backing device
 requires it
Date: Mon, 14 Jan 2013 21:42:50 -0800
Message-ID: <20130115054250.1563.40740.stgit@blackbox.djwong.org>
References: <20130115054235.1563.12967.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
	gnehzuil.liu@gmail.com, linux-kernel@vger.kernel.org,
	hch@infradead.org, linux-fsdevel@vger.kernel.org,
	adilger.kernel@dilger.ca, bharrosh@panasas.com, jlayton@samba.org,
	linux-ext4@vger.kernel.org, hirofumi@mail.parknet.co.jp
To: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz,
	darrick.wong@oracle.com, ericvh@gmail.com, tytso@mit.edu,
	viro@zeniv.linux.org.uk, rminnich@sandia.gov
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130115054235.1563.12967.stgit@blackbox.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Create a helper function to check if a backing device requires stable page
writes and, if so, performs the necessary wait.  Then, make it so that all
points in the memory manager that handle making pages writable use the helper
function.  This should provide stable page write support to most filesystems,
while eliminating unnecessary waiting for devices that don't require the
feature.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/buffer.c             |    2 +-
 fs/ext4/inode.c         |    2 +-
 fs/gfs2/file.c          |    2 +-
 fs/nilfs2/file.c        |    2 +-
 include/linux/pagemap.h |    1 +
 mm/filemap.c            |    3 ++-
 mm/page-writeback.c     |   20 ++++++++++++++++++++
 7 files changed, 27 insertions(+), 5 deletions(-)


diff --git a/fs/buffer.c b/fs/buffer.c
index c017a2d..2981449 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2359,7 +2359,7 @@ int __block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 	if (unlikely(ret < 0))
 		goto out_unlock;
 	set_page_dirty(page);
-	wait_on_page_writeback(page);
+	wait_for_stable_page(page);
 	return 0;
 out_unlock:
 	unlock_page(page);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cbfe13b..cd818d8b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4968,7 +4968,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 					    0, len, NULL,
 					    ext4_bh_unmapped)) {
 			/* Wait so that we don't change page under IO */
-			wait_on_page_writeback(page);
+			wait_for_stable_page(page);
 			ret = VM_FAULT_LOCKED;
 			goto out;
 		}
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 991ab2d..b9e0ca2 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -483,7 +483,7 @@ out:
 	gfs2_holder_uninit(&gh);
 	if (ret == 0) {
 		set_page_dirty(page);
-		wait_on_page_writeback(page);
+		wait_for_stable_page(page);
 	}
 	sb_end_pagefault(inode->i_sb);
 	return block_page_mkwrite_return(ret);
diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index 6194688..bec4af6 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -126,7 +126,7 @@ static int nilfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	nilfs_transaction_commit(inode->i_sb);
 
  mapped:
-	wait_on_page_writeback(page);
+	wait_for_stable_page(page);
  out:
 	sb_end_pagefault(inode->i_sb);
 	return block_page_mkwrite_return(ret);
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 6da609d..0e38e13 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -414,6 +414,7 @@ static inline void wait_on_page_writeback(struct page *page)
 }
 
 extern void end_page_writeback(struct page *page);
+void wait_for_stable_page(struct page *page);
 
 /*
  * Add an arbitrary waiter to a page's wait queue
diff --git a/mm/filemap.c b/mm/filemap.c
index 83efee7..5577dc8 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1728,6 +1728,7 @@ int filemap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	 * see the dirty page and writeprotect it again.
 	 */
 	set_page_dirty(page);
+	wait_for_stable_page(page);
 out:
 	sb_end_pagefault(inode->i_sb);
 	return ret;
@@ -2274,7 +2275,7 @@ repeat:
 		return NULL;
 	}
 found:
-	wait_on_page_writeback(page);
+	wait_for_stable_page(page);
 	return page;
 }
 EXPORT_SYMBOL(grab_cache_page_write_begin);
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 0713bfb..9c5af4d 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2289,3 +2289,23 @@ int mapping_tagged(struct address_space *mapping, int tag)
 	return radix_tree_tagged(&mapping->page_tree, tag);
 }
 EXPORT_SYMBOL(mapping_tagged);
+
+/**
+ * wait_for_stable_page() - wait for writeback to finish, if necessary.
+ * @page:	The page to wait on.
+ *
+ * This function determines if the given page is related to a backing device
+ * that requires page contents to be held stable during writeback.  If so, then
+ * it will wait for any pending writeback to complete.
+ */
+void wait_for_stable_page(struct page *page)
+{
+	struct address_space *mapping = page_mapping(page);
+	struct backing_dev_info *bdi = mapping->backing_dev_info;
+
+	if (!bdi_cap_stable_pages_required(bdi))
+		return;
+
+	wait_on_page_writeback(page);
+}
+EXPORT_SYMBOL_GPL(wait_for_stable_page);
