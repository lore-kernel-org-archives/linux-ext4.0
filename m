From: Mingming Cao <cmm@us.ibm.com>
Subject: [EXT4 set 9][PATCH 1/5]Morecleanups:ext4-zero_user_page
Date: Sun, 01 Jul 2007 03:38:32 -0400
Message-ID: <1183275512.4010.137.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Use zero_user_page() in ext4 where possible.


Signed-off-by: Eric Sandeen <sandeen@redhat.com>

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



