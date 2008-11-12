From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [PATCH 2/3][RFC]  ext3: release block-device-mapping buffer_heads
 which have the filesystem private data for avoiding oom-killer
Date: Wed, 12 Nov 2008 16:53:17 +0900
Message-ID: <20081112165317.f0c86284.toshi.okajima@jp.fujitsu.com>
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
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50961 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbYKLICs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Nov 2008 03:02:48 -0500
In-Reply-To: <4913B35A.8080203@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[PATCH 2/3] ext3: release block-device-mapping buffer_heads which have the filesystem 
private data for avoiding oom-killer

Implement releasepage() of a client of a block device to release its private 
data (journal_heads) and the page. The client is an ext3 filesystem.

This function is called from releasepage() of the block-device mapping, 
blkdev_releasepage().

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 fs/ext3/inode.c         |   16 ++++++++++++++++
 fs/ext3/super.c         |    2 ++
 include/linux/ext3_fs.h |    2 ++
 3 files changed, 20 insertions(+)

diff -Nurp linux-2.6.28-rc4.orig/fs/ext3/inode.c linux-2.6.28-rc4/fs/ext3/inode.c
--- linux-2.6.28-rc4.orig/fs/ext3/inode.c	2008-11-10 09:36:15.000000000 +0900
+++ linux-2.6.28-rc4/fs/ext3/inode.c	2008-11-11 09:31:13.000000000 +0900
@@ -1680,6 +1680,28 @@ static int ext3_releasepage(struct page 
 }
 
 /*
+ * ext3_release_metadata: try to release own page.
+ * The mapping of this page is block device's. Therefore try_to_free_buffers()
+ * cannot release it. As a result, a function which releases own page is
+ * required.
+ */
+int ext3_release_metadata(void *client, struct page *page, gfp_t wait)
+{
+	struct super_block *sb = (struct super_block*)client;
+	journal_t *journal;
+
+	WARN_ON(PageChecked(page));
+	if (!page_has_buffers(page))
+		return 0;
+	BUG_ON(EXT3_SB(sb) == NULL);
+	journal = EXT3_SB(sb)->s_journal;
+	if (journal != NULL)
+		return journal_try_to_free_buffers(journal, page, wait);
+	else
+		return try_to_free_buffers(page);
+}
+
+/*
  * If the O_DIRECT write will extend the file then add this inode to the
  * orphan list.  So recovery will truncate it back to the original size
  * if the machine crashes during the write.
diff -Nurp linux-2.6.28-rc4.orig/fs/ext3/super.c linux-2.6.28-rc4/fs/ext3/super.c
--- linux-2.6.28-rc4.orig/fs/ext3/super.c	2008-11-10 09:36:15.000000000 +0900
+++ linux-2.6.28-rc4/fs/ext3/super.c	2008-11-11 09:01:53.000000000 +0900
@@ -2972,6 +2972,8 @@ static struct file_system_type ext3_fs_t
 	.name		= "ext3",
 	.get_sb		= ext3_get_sb,
 	.kill_sb	= kill_block_super,
+	.release_metadata 
+			= ext3_release_metadata,
 	.fs_flags	= FS_REQUIRES_DEV,
 };
 
diff -Nurp linux-2.6.28-rc4.orig/include/linux/ext3_fs.h linux-2.6.28-rc4/include/linux/ext3_fs.h
--- linux-2.6.28-rc4.orig/include/linux/ext3_fs.h	2008-11-10 09:36:15.000000000 +0900
+++ linux-2.6.28-rc4/include/linux/ext3_fs.h	2008-11-10 18:33:52.000000000 +0900
@@ -841,6 +841,8 @@ extern void ext3_get_inode_flags(struct 
 extern void ext3_set_aops(struct inode *inode);
 extern int ext3_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		       u64 start, u64 len);
+extern int ext3_release_metadata(void *client, struct page *page, 
+			gfp_t wait);
 
 /* ioctl.c */
 extern int ext3_ioctl (struct inode *, struct file *, unsigned int,
