From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH 6/6] ext4: Simplify DAX fault path
Date: Thu, 24 Nov 2016 10:46:36 +0100
Message-ID: <1479980796-26161-7-git-send-email-jack@suse.cz>
References: <1479980796-26161-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org,
 Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1479980796-26161-1-git-send-email-jack-AlSwsSmVLrQ@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

Now that dax_iomap_fault() calls ->iomap_begin() without entry lock, we
can use transaction starting in ext4_iomap_begin() and thus simplify
ext4_dax_fault(). It also provides us proper retries in case of ENOSPC.

Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 fs/ext4/file.c | 48 ++++++++++--------------------------------------
 1 file changed, 10 insertions(+), 38 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index b5f184493c57..d663d3d7c81c 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -258,7 +258,6 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 static int ext4_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	int result;
-	handle_t *handle = NULL;
 	struct inode *inode = file_inode(vma->vm_file);
 	struct super_block *sb = inode->i_sb;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
@@ -266,24 +265,12 @@ static int ext4_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	if (write) {
 		sb_start_pagefault(sb);
 		file_update_time(vma->vm_file);
-		down_read(&EXT4_I(inode)->i_mmap_sem);
-		handle = ext4_journal_start_sb(sb, EXT4_HT_WRITE_PAGE,
-						EXT4_DATA_TRANS_BLOCKS(sb));
-	} else
-		down_read(&EXT4_I(inode)->i_mmap_sem);
-
-	if (IS_ERR(handle))
-		result = VM_FAULT_SIGBUS;
-	else
-		result = dax_iomap_fault(vma, vmf, &ext4_iomap_ops);
-
-	if (write) {
-		if (!IS_ERR(handle))
-			ext4_journal_stop(handle);
-		up_read(&EXT4_I(inode)->i_mmap_sem);
+	}
+	down_read(&EXT4_I(inode)->i_mmap_sem);
+	result = dax_iomap_fault(vma, vmf, &ext4_iomap_ops);
+	up_read(&EXT4_I(inode)->i_mmap_sem);
+	if (write)
 		sb_end_pagefault(sb);
-	} else
-		up_read(&EXT4_I(inode)->i_mmap_sem);
 
 	return result;
 }
@@ -292,7 +279,6 @@ static int ext4_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
 						pmd_t *pmd, unsigned int flags)
 {
 	int result;
-	handle_t *handle = NULL;
 	struct inode *inode = file_inode(vma->vm_file);
 	struct super_block *sb = inode->i_sb;
 	bool write = flags & FAULT_FLAG_WRITE;
@@ -300,27 +286,13 @@ static int ext4_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
 	if (write) {
 		sb_start_pagefault(sb);
 		file_update_time(vma->vm_file);
-		down_read(&EXT4_I(inode)->i_mmap_sem);
-		handle = ext4_journal_start_sb(sb, EXT4_HT_WRITE_PAGE,
-				ext4_chunk_trans_blocks(inode,
-							PMD_SIZE / PAGE_SIZE));
-	} else
-		down_read(&EXT4_I(inode)->i_mmap_sem);
-
-	if (IS_ERR(handle))
-		result = VM_FAULT_SIGBUS;
-	else {
-		result = dax_iomap_pmd_fault(vma, addr, pmd, flags,
-					     &ext4_iomap_ops);
 	}
-
-	if (write) {
-		if (!IS_ERR(handle))
-			ext4_journal_stop(handle);
-		up_read(&EXT4_I(inode)->i_mmap_sem);
+	down_read(&EXT4_I(inode)->i_mmap_sem);
+	result = dax_iomap_pmd_fault(vma, addr, pmd, flags,
+				     &ext4_iomap_ops);
+	up_read(&EXT4_I(inode)->i_mmap_sem);
+	if (write)
 		sb_end_pagefault(sb);
-	} else
-		up_read(&EXT4_I(inode)->i_mmap_sem);
 
 	return result;
 }
-- 
2.6.6
