From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] zero_user_page conversion
Date: Wed, 20 Jun 2007 17:08:24 -0500
Message-ID: <4679A558.1010107@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ocfs2-devel@oss.oracle.com, cluster-devel@redhat.com,
	samba-technical@lists.samba.org,
	ext4 development <linux-ext4@vger.kernel.org>
To: linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332AbXFTWIW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Jun 2007 18:08:22 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Use zero_user_page() in cifs, ocfs2, ext4, and gfs2 where possible.

Compile tested, reviews welcome.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: linux-2.6.22-rc4-mm2/fs/cifs/inode.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/fs/cifs/inode.c
+++ linux-2.6.22-rc4-mm2/fs/cifs/inode.c
@@ -1334,17 +1334,13 @@ static int cifs_truncate_page(struct add
 	pgoff_t index = from >> PAGE_CACHE_SHIFT;
 	unsigned offset = from & (PAGE_CACHE_SIZE - 1);
 	struct page *page;
-	char *kaddr;
 	int rc = 0;
 
 	page = grab_cache_page(mapping, index);
 	if (!page)
 		return -ENOMEM;
 
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, PAGE_CACHE_SIZE - offset);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	zero_user_page(page, offset, PAGE_CACHE_SIZE - offset, KM_USER0);
 	unlock_page(page);
 	page_cache_release(page);
 	return rc;
Index: linux-2.6.22-rc4-mm2/fs/ext4/inode.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/fs/ext4/inode.c
+++ linux-2.6.22-rc4-mm2/fs/ext4/inode.c
@@ -1830,7 +1830,6 @@ int ext4_block_truncate_page(handle_t *h
 	struct inode *inode = mapping->host;
 	struct buffer_head *bh;
 	int err = 0;
-	void *kaddr;
 
 	if ((EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) &&
 			test_opt(inode->i_sb, EXTENTS) &&
@@ -1847,10 +1846,7 @@ int ext4_block_truncate_page(handle_t *h
 	 */
 	if (!page_has_buffers(page) && test_opt(inode->i_sb, NOBH) &&
 	     ext4_should_writeback_data(inode) && PageUptodate(page)) {
-		kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr + offset, 0, length);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_user_page(page, offset, length, KM_USER0);
 		set_page_dirty(page);
 		goto unlock;
 	}
@@ -1903,10 +1899,7 @@ int ext4_block_truncate_page(handle_t *h
 			goto unlock;
 	}
 
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, length);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	zero_user_page(page, offset, length, KM_USER0);
 
 	BUFFER_TRACE(bh, "zeroed end of block");
 
Index: linux-2.6.22-rc4-mm2/fs/gfs2/ops_address.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/fs/gfs2/ops_address.c
+++ linux-2.6.22-rc4-mm2/fs/gfs2/ops_address.c
@@ -207,10 +207,7 @@ static int stuffed_readpage(struct gfs2_
 	 * so we need to supply one here. It doesn't happen often.
 	 */
 	if (unlikely(page->index)) {
-		kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr, 0, PAGE_CACHE_SIZE);
-		kunmap_atomic(kaddr, KM_USER0);
-		flush_dcache_page(page);
+		zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
 		SetPageUptodate(page);
 		return 0;
 	}
Index: linux-2.6.22-rc4-mm2/fs/ocfs2/aops.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/fs/ocfs2/aops.c
+++ linux-2.6.22-rc4-mm2/fs/ocfs2/aops.c
@@ -739,18 +739,13 @@ int ocfs2_map_page_blocks(struct page *p
 	bh = head;
 	block_start = 0;
 	do {
-		void *kaddr;
-
 		block_end = block_start + bsize;
 		if (block_end <= from)
 			goto next_bh;
 		if (block_start >= to)
 			break;
 
-		kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr+block_start, 0, bh->b_size);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_user_page(page, block_start, bh->b_size, KM_USER0);
 		set_buffer_uptodate(bh);
 		mark_buffer_dirty(bh);
 
@@ -895,15 +890,11 @@ static void ocfs2_zero_new_buffers(struc
 			if (block_end > from && block_start < to) {
 				if (!PageUptodate(page)) {
 					unsigned start, end;
-					void *kaddr;
 
 					start = max(from, block_start);
 					end = min(to, block_end);
 
-					kaddr = kmap_atomic(page, KM_USER0);
-					memset(kaddr+start, 0, end - start);
-					flush_dcache_page(page);
-					kunmap_atomic(kaddr, KM_USER0);
+					zero_user_page(page, start, end - start, KM_USER0);
 					set_buffer_uptodate(bh);
 				}
 
