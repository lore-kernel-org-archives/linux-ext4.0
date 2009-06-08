From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH -V2 1/2] ext4: Add inode to the orphan list during
	block allocation failure
Date: Mon, 8 Jun 2009 12:29:24 -0400
Message-ID: <20090608162924.GI23883@mit.edu>
References: <20090605234458.GG11650@duck.suse.cz> <1244435715-6807-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46286 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757334AbZFHQ3g (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Jun 2009 12:29:36 -0400
Content-Disposition: inline
In-Reply-To: <1244435715-6807-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh, thanks for working on a replacement patch, but I had already
added the call to ext4_orphan_del in the patch in the patch queue.
The difference is I added the call right after the call to
vmtruncate(), which avoids calling ext4_orphan_del() in a few cases
where it's not necessary.

This is what I have in the patch queue.

						- Ted

ext4: Avoid leaking blocks after a block allocation failure

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

We should add inode to the orphan list in the same transaction
as block allocation.  This ensures that if we crash after a failed
block allocation and before we do a vmtruncate we don't leak block
(ie block marked as used in bitmap but not claimed by the inode).

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
CC:  Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 95a3f45..036552a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1462,7 +1462,7 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
 				struct page **pagep, void **fsdata)
 {
 	struct inode *inode = mapping->host;
-	int ret, needed_blocks = ext4_writepage_trans_blocks(inode);
+	int ret, needed_blocks;
 	handle_t *handle;
 	int retries = 0;
 	struct page *page;
@@ -1473,6 +1473,11 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
 		   "dev %s ino %lu pos %llu len %u flags %u",
 		   inode->i_sb->s_id, inode->i_ino,
 		   (unsigned long long) pos, len, flags);
+	/*
+	 * Reserve one block more for addition to orphan list in case
+	 * we allocate blocks but write fails for some reason
+	 */
+	needed_blocks = ext4_writepage_trans_blocks(inode) + 1;
  	index = pos >> PAGE_CACHE_SHIFT;
 	from = pos & (PAGE_CACHE_SIZE - 1);
 	to = from + len;
@@ -1506,15 +1511,30 @@ retry:
 
 	if (ret) {
 		unlock_page(page);
-		ext4_journal_stop(handle);
 		page_cache_release(page);
 		/*
 		 * block_write_begin may have instantiated a few blocks
 		 * outside i_size.  Trim these off again. Don't need
 		 * i_size_read because we hold i_mutex.
+		 *
+		 * Add inode to orphan list in case we crash before
+		 * truncate finishes
 		 */
 		if (pos + len > inode->i_size)
+			ext4_orphan_add(handle, inode);
+
+		ext4_journal_stop(handle);
+		if (pos + len > inode->i_size) {
 			vmtruncate(inode, inode->i_size);
+			/* 
+			 * If vmtruncate failed early the inode might
+			 * still be on the orphan list; we need to
+			 * make sure the inode is removed from the
+			 * orphan list in that case.
+			 */
+			if (inode->i_nlink)
+				ext4_orphan_del(NULL, inode);
+		}
 	}
 
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
