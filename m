From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [PATCH 3/3][RFC] ext4: release block-device-mapping buffer_heads
 which have the filesystem private data for avoiding oom-killer
Date: Wed, 12 Nov 2008 16:55:59 +0900
Message-ID: <20081112165559.c6664449.toshi.okajima@jp.fujitsu.com>
References: <20081017.223716.147444348.00960188@stratos.soft.fujitsu.com>
	<20081020160249.ff41f762.akpm@linux-foundation.org>
	<20081023174101.85b59177.toshi.okajima@jp.fujitsu.com>
	<20081027142657.2120aa3f.akpm@linux-foundation.org>
	<49067D03.6080609@jp.fujitsu.com>
	<20081105131140.7689f048.toshi.okajima@jp.fujitsu.com>
	<20081105135349.GA22998@mit.edu>
	<4913B35A.8080203@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: akpm@linux-foundation.org, tytso@mit.edu, viro@zeniv.linux.org.uk,
	sct@redhat.com, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51098 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbYKLIFa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Nov 2008 03:05:30 -0500
In-Reply-To: <4913B35A.8080203@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[PATCH 3/3] ext4: release block-device-mapping buffer_heads which have the filesystem
private data for avoiding oom-killer

Implement releasepage() of a client of a block device to release its private 
data (journal_heads) and the page. The client is an ext4 filesystem.

This function is called from releasepage() of the block-device mapping, 
blkdev_releasepage().

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 fs/ext4/ext4.h  |    2 ++
 fs/ext4/inode.c |   22 ++++++++++++++++++++++
 fs/ext4/super.c |    4 ++++
 3 files changed, 28 insertions(+)

diff -Nurp linux-2.6.28-rc4.orig/fs/ext4/ext4.h linux-2.6.28-rc4/fs/ext4/ext4.h
--- linux-2.6.28-rc4.orig/fs/ext4/ext4.h	2008-11-10 09:36:15.000000000 +0900
+++ linux-2.6.28-rc4/fs/ext4/ext4.h	2008-11-12 10:44:25.000000000 +0900
@@ -1095,6 +1095,8 @@ extern int ext4_chunk_trans_blocks(struc
 extern int ext4_block_truncate_page(handle_t *handle,
 		struct address_space *mapping, loff_t from);
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page);
+extern int ext4_release_metadata(void *client, struct page *page,
+		gfp_t wait);
 
 /* ioctl.c */
 extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
diff -Nurp linux-2.6.28-rc4.orig/fs/ext4/inode.c linux-2.6.28-rc4/fs/ext4/inode.c
--- linux-2.6.28-rc4.orig/fs/ext4/inode.c	2008-11-10 09:36:15.000000000 +0900
+++ linux-2.6.28-rc4/fs/ext4/inode.c	2008-11-12 10:42:55.000000000 +0900
@@ -3002,6 +3002,28 @@ static int ext4_releasepage(struct page 
 }
 
 /*
+ * ext4_release_metadata: try to release own page.
+ * The mapping of this page is block device's. Therefore try_to_free_buffers()
+ * cannot release it. As a result, a function which releases own page is
+ * required.
+ */
+int ext4_release_metadata(void *client, struct page *page, gfp_t wait)
+{
+	struct super_block *sb = (struct super_block*)client;
+	journal_t *journal;
+
+	WARN_ON(PageChecked(page));
+	if (!page_has_buffers(page))
+		return 0;
+	BUG_ON(EXT4_SB(sb) == NULL);
+	journal = EXT4_SB(sb)->s_journal;
+	if (journal != NULL)
+		return jbd2_journal_try_to_free_buffers(journal, page, wait);
+        else
+		return try_to_free_buffers(page);
+}
+
+/*
  * If the O_DIRECT write will extend the file then add this inode to the
  * orphan list.  So recovery will truncate it back to the original size
  * if the machine crashes during the write.
diff -Nurp linux-2.6.28-rc4.orig/fs/ext4/super.c linux-2.6.28-rc4/fs/ext4/super.c
--- linux-2.6.28-rc4.orig/fs/ext4/super.c	2008-11-10 09:36:15.000000000 +0900
+++ linux-2.6.28-rc4/fs/ext4/super.c	2008-11-12 12:04:58.000000000 +0900
@@ -3543,6 +3543,8 @@ static struct file_system_type ext4_fs_t
 	.name		= "ext4",
 	.get_sb		= ext4_get_sb,
 	.kill_sb	= kill_block_super,
+	.release_metadata
+			= ext4_release_metadata,
 	.fs_flags	= FS_REQUIRES_DEV,
 };
 
@@ -3562,6 +3564,8 @@ static struct file_system_type ext4dev_f
 	.name		= "ext4dev",
 	.get_sb		= ext4dev_get_sb,
 	.kill_sb	= kill_block_super,
+	.release_metadata
+			= ext4_release_metadata,
 	.fs_flags	= FS_REQUIRES_DEV,
 };
 MODULE_ALIAS("ext4dev");
