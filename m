From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH REGRESSION FIX] ext4: fix mtime update in nodelalloc mode
Date: Sun, 30 Sep 2012 15:48:19 -0400
Message-ID: <1349034499-4731-1-git-send-email-tytso@mit.edu>
Cc: linux-nilfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>,
	KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>,
	stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53093 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349Ab2I3Ts3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 Sep 2012 15:48:29 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commits 41c4d25f78c0 and 41c4d25f78c0 introduced a regression into
3.6-rc1 for ext4 in nodealloc mode, such that mtime updates would not
take place for files modified via mmap if the page was already in the
page cache.

The problem was that ext4_page_mkwrite() had a shortcut which would
avoid calling __block_page_mkwrite() under some circumstances, and the
above two commit transferred the responsibility of calling
file_update_time() to __block_page_mkwrite --- which woudln't get
called in some circumstances.

Since __block_page_mkwrite() only has three years,
block_page_mkwrite(), ext4_page_mkwrite, and nilfs_page_mkwrite(), the
best way to solve this is to move the responsibility for calling
file_update_time() to its caller.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>
Cc: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
Cc: stable@vger.kernel.org
---

NOTE: Since this is a 3.6 regression, I may push this to Linus ahead of
the merge window, since it will also affect distibutions which use ext4
to mount ext3-formatted partitions.

 fs/buffer.c      | 13 +++++++------
 fs/ext4/inode.c  |  1 +
 fs/nilfs2/file.c |  1 +
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 9f6d2e4..1fe3968 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2318,12 +2318,6 @@ int __block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 	loff_t size;
 	int ret;
 
-	/*
-	 * Update file times before taking page lock. We may end up failing the
-	 * fault so this update may be superfluous but who really cares...
-	 */
-	file_update_time(vma->vm_file);
-
 	lock_page(page);
 	size = i_size_read(inode);
 	if ((page->mapping != inode->i_mapping) ||
@@ -2361,6 +2355,13 @@ int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 	struct super_block *sb = vma->vm_file->f_path.dentry->d_inode->i_sb;
 
 	sb_start_pagefault(sb);
+
+	/*
+	 * Update file times before taking page lock. We may end up failing the
+	 * fault so this update may be superfluous but who really cares...
+	 */
+	file_update_time(vma->vm_file);
+
 	ret = __block_page_mkwrite(vma, vmf, get_block);
 	sb_end_pagefault(sb);
 	return block_page_mkwrite_return(ret);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 09308ad..f18e786 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4788,6 +4788,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	int retries = 0;
 
 	sb_start_pagefault(inode->i_sb);
+	file_update_time(vma->vm_file);
 	/* Delalloc case is easy... */
 	if (test_opt(inode->i_sb, DELALLOC) &&
 	    !ext4_should_journal_data(inode) &&
diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index a4d56ac..5b387a4 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -116,6 +116,7 @@ static int nilfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	if (unlikely(ret))
 		goto out;
 
+	file_update_time(vma->vm_file);
 	ret = __block_page_mkwrite(vma, vmf, nilfs_get_block);
 	if (ret) {
 		nilfs_transaction_abort(inode->i_sb);
-- 
1.7.12.rc0.22.gcdd159b

