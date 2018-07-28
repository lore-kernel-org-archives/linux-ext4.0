From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: [PATCH] ext4: Convert int to vm_fault_t type
Date: Sat, 28 Jul 2018 14:20:00 +0530
Message-ID: <20180728085000.GA9136@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sabyasachi.linux@gmail.com, brajeswar.linux@gmail.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: willy@infradead.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        darrick.wong@oracle.com, axboe@kernel.dk, agruenba@redhat.com,
        ebiggers@google.com, gregkh@linuxfoundation.org,
        kemi.wang@intel.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Use new return type vm_fault_t for ext4_page_mkwrite
handler and block_page_mkwrite_return.

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
---
 fs/ext4/ext4.h              |  2 +-
 fs/ext4/inode.c             | 20 ++++++++++----------
 include/linux/buffer_head.h |  3 ++-
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index aec0010..1183773 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2469,7 +2469,7 @@ int do_journal_get_write_access(handle_t *handle,
 extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
 extern int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
 			     loff_t lstart, loff_t lend);
-extern int ext4_page_mkwrite(struct vm_fault *vmf);
+extern vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf);
 extern vm_fault_t ext4_filemap_fault(struct vm_fault *vmf);
 extern qsize_t *ext4_get_reserved_space(struct inode *inode);
 extern int ext4_get_projid(struct inode *inode, kprojid_t *projid);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 03ac322..b491fdb 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6108,27 +6108,27 @@ static int ext4_bh_unmapped(handle_t *handle, struct buffer_head *bh)
 	return !buffer_mapped(bh);
 }
 
-int ext4_page_mkwrite(struct vm_fault *vmf)
+vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct page *page = vmf->page;
 	loff_t size;
 	unsigned long len;
-	int ret;
+	vm_fault_t ret;
 	struct file *file = vma->vm_file;
 	struct inode *inode = file_inode(file);
 	struct address_space *mapping = inode->i_mapping;
 	handle_t *handle;
 	get_block_t *get_block;
-	int retries = 0;
+	int retries = 0, err;
 
 	sb_start_pagefault(inode->i_sb);
 	file_update_time(vma->vm_file);
 
 	down_read(&EXT4_I(inode)->i_mmap_sem);
 
-	ret = ext4_convert_inline_data(inode);
-	if (ret)
+	err = ext4_convert_inline_data(inode);
+	if (err)
 		goto out_ret;
 
 	/* Delalloc case is easy... */
@@ -6138,9 +6138,9 @@ int ext4_page_mkwrite(struct vm_fault *vmf)
 		do {
 			ret = block_page_mkwrite(vma, vmf,
 						   ext4_da_get_block_prep);
-		} while (ret == -ENOSPC &&
+		} while (ret == VM_FAULT_SIGBUS &&
 		       ext4_should_retry_alloc(inode->i_sb, &retries));
-		goto out_ret;
+		goto out;
 	}
 
 	lock_page(page);
@@ -6188,17 +6188,17 @@ int ext4_page_mkwrite(struct vm_fault *vmf)
 		if (ext4_walk_page_buffers(handle, page_buffers(page), 0,
 			  PAGE_SIZE, NULL, do_journal_get_write_access)) {
 			unlock_page(page);
-			ret = VM_FAULT_SIGBUS;
 			ext4_journal_stop(handle);
 			goto out;
 		}
 		ext4_set_inode_state(inode, EXT4_STATE_JDATA);
 	}
 	ext4_journal_stop(handle);
-	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
+	if (ret == VM_FAULT_SIGBUS &&
+		ext4_should_retry_alloc(inode->i_sb, &retries))
 		goto retry_alloc;
 out_ret:
-	ret = block_page_mkwrite_return(ret);
+	ret = block_page_mkwrite_return(err);
 out:
 	up_read(&EXT4_I(inode)->i_mmap_sem);
 	sb_end_pagefault(inode->i_sb);
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 96225a7..ed7a81b 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -14,6 +14,7 @@
 #include <linux/pagemap.h>
 #include <linux/wait.h>
 #include <linux/atomic.h>
+#include <linux/mm_types.h>
 
 #ifdef CONFIG_BLOCK
 
@@ -242,7 +243,7 @@ int cont_write_begin(struct file *, struct address_space *, loff_t,
 int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 				get_block_t get_block);
 /* Convert errno to return value from ->page_mkwrite() call */
-static inline int block_page_mkwrite_return(int err)
+static inline vm_fault_t block_page_mkwrite_return(int err)
 {
 	if (err == 0)
 		return VM_FAULT_LOCKED;
-- 
1.9.1
