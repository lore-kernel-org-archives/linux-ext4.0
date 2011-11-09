From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 9/9 bigalloc] ext4: make cluster works for mmap
Date: Wed,  9 Nov 2011 19:17:08 +0800
Message-ID: <1320837428-8516-10-git-send-email-hao.bigrat@gmail.com>
References: <1320837428-8516-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41263 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab1KILRp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Nov 2011 06:17:45 -0500
Received: by gyc15 with SMTP id 15so1610256gyc.19
        for <linux-ext4@vger.kernel.org>; Wed, 09 Nov 2011 03:17:44 -0800 (PST)
In-Reply-To: <1320837428-8516-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

When users write a page in mmap regioin, it need to zero out other
pages around it.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/inode.c |   69 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 68 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 69d0031..4a25767 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4649,13 +4649,17 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	struct page *page = vmf->page;
 	loff_t size;
 	unsigned long len;
-	int ret;
+	int ret, i, uninit = 0;
 	struct file *file = vma->vm_file;
 	struct inode *inode = file->f_path.dentry->d_inode;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	struct address_space *mapping = inode->i_mapping;
+	struct ext4_write_cluster_ctxt *ewcc = NULL;
 	handle_t *handle;
 	get_block_t *get_block;
 	int retries = 0;
+	unsigned int flags = AOP_FLAG_NOFS;
+	unsigned long from, to;
 
 	/*
 	 * This check is racy but catches the common case. We rely on
@@ -4712,7 +4716,47 @@ retry_alloc:
 		ret = VM_FAULT_SIGBUS;
 		goto out;
 	}
+
+	ewcc = ext4_alloc_write_cluster_ctxt();
+	if (!ewcc) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (sbi->s_cluster_ratio > 1) {
+		/* We need to know whether the block is allocated already
+		 */
+		struct ext4_map_blocks map;
+		map.m_lblk = page->index;
+		map.m_len = 1;
+		ret = ext4_map_blocks(handle, inode, &map, 0);
+		uninit = map.m_flags & EXT4_MAP_UNWRITTEN;
+		if (ret <= 0 || uninit) {
+			ret = ext4_prepare_cluster_left_pages(inode,
+					page->index, ewcc, flags);
+			if (ret)
+				goto err_out;
+		}
+	}
+
 	ret = __block_page_mkwrite(vma, vmf, get_block);
+	if (ret)
+		goto err_out;
+
+	if (sbi->s_cluster_ratio > 1 && uninit) {
+		ret = ext4_prepare_cluster_right_pages(inode, page->index,
+				ewcc, flags);
+		if (ret)
+			goto err_out;
+		for (i = 0; i < ewcc->w_num_pages; i++) {
+			if (!ewcc->w_pages[i] ||
+					!page_buffers(ewcc->w_pages[i]))
+				break;
+			block_commit_write(ewcc->w_pages[i],
+					0, PAGE_CACHE_SIZE);
+		}
+	}
+
 	if (!ret && ext4_should_journal_data(inode)) {
 		if (walk_page_buffers(handle, page_buffers(page), 0,
 			  PAGE_CACHE_SIZE, NULL, do_journal_get_write_access)) {
@@ -4720,13 +4764,36 @@ retry_alloc:
 			ret = VM_FAULT_SIGBUS;
 			goto out;
 		}
+
+		for (i = 0; i < ewcc->w_num_pages; i++) {
+			page = ewcc->w_pages[i];
+			if (!page || !page_buffers(page))
+				continue;
+			from = page->index << PAGE_CACHE_SHIFT;
+			to = from + PAGE_CACHE_SIZE;
+			ret = walk_page_buffers(handle, page_buffers(page),
+				from, to, NULL, do_journal_get_write_access);
+			if (ret) {
+				ret = VM_FAULT_SIGBUS;
+				goto out;
+			}
+		}
 		ext4_set_inode_state(inode, EXT4_STATE_JDATA);
 	}
+
+err_out:
+	if (ewcc) {
+		ext4_free_write_cluster_ctxt(ewcc);
+		ewcc = NULL;
+	}
 	ext4_journal_stop(handle);
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
 		goto retry_alloc;
 out_ret:
 	ret = block_page_mkwrite_return(ret);
+
 out:
+	if (ewcc)
+		ext4_free_write_cluster_ctxt(ewcc);
 	return ret;
 }
-- 
1.7.3.2

