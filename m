From: Miao Xie <miaoxie1984@gmail.com>
Subject: [PATCH 1/4] vfs: introduce try_to_writeback_inodes_sb(_nr)
Date: Thu, 26 Apr 2012 10:57:43 +0800
Message-ID: <4F98B9A7.8060209@gmail.com>
Reply-To: miaoxie1984@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
	Linux FSDevel <linux-fsdevel@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	miaox@cn.fujitsu.com, Kamal Mostafa <kamal@canonical.com>,
	Linux Ext4 <linux-ext4@vger.kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f51.google.com ([209.85.210.51]:65426 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab2DZC56 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Apr 2012 22:57:58 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

writeback_inodes_sb(_nr) grabs s_umount lock when it want to start writeback,
it may bring us deadlock problem when doing umount. So we introduce new
functions -- try_to_writeback_inodes_sb(_nr) -- which use down_read_trylock()
instead of down_read() to avoid that deadlock problem.

This idea came from Christoph Hellwig.
Some code is from the patch of Kamal Mostafa.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/fs-writeback.c         |   39 +++++++++++++++++++++++++++++++++++++++
 include/linux/writeback.h |    3 +++
 2 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 539f36c..b0c35c3 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1291,6 +1291,45 @@ int writeback_inodes_sb_nr_if_idle(struct super_block *sb,
 EXPORT_SYMBOL(writeback_inodes_sb_nr_if_idle);
 
 /**
+ * try_to_writeback_inodes_sb_nr - try to start writeback if none underway
+ * @sb: the superblock
+ * @nr: the number of pages to write
+ * @reason: the reason of writeback
+ *
+ * Invoke writeback_inodes_sb_nr if no writeback is currently underway.
+ * Returns 1 if writeback was started, 0 if not.
+ */
+int try_to_writeback_inodes_sb_nr(struct super_block *sb,
+				  unsigned long nr,
+				  enum wb_reason reason)
+{
+	if (writeback_in_progress(sb->s_bdi))
+		return 1;
+
+	if (!down_read_trylock(&sb->s_umount))
+		return 0;
+
+	writeback_inodes_sb_nr(sb, nr, reason);
+	up_read(&sb->s_umount);
+	return 1;
+}
+EXPORT_SYMBOL(try_to_writeback_inodes_sb_nr);
+
+/**
+ * try_to_writeback_inodes_sb - try to start writeback if none underway
+ * @sb: the superblock
+ * @reason: reason why some writeback work was initiated
+ *
+ * Implement by try_to_writeback_inodes_sb_nr()
+ * Returns 1 if writeback was started, 0 if not.
+ */
+int try_to_writeback_inodes_sb(struct super_block *sb, enum wb_reason reason)
+{
+	return try_to_writeback_inodes_sb_nr(sb, get_nr_dirty_pages(), reason);
+}
+EXPORT_SYMBOL(try_to_writeback_inodes_sb);
+
+/**
  * sync_inodes_sb	-	sync sb inode pages
  * @sb: the superblock
  *
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index a2b84f5..d8e2a99 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -89,6 +89,9 @@ void writeback_inodes_sb_nr(struct super_block *, unsigned long nr,
 int writeback_inodes_sb_if_idle(struct super_block *, enum wb_reason reason);
 int writeback_inodes_sb_nr_if_idle(struct super_block *, unsigned long nr,
 							enum wb_reason reason);
+int try_to_writeback_inodes_sb(struct super_block *, enum wb_reason reason);
+int try_to_writeback_inodes_sb_nr(struct super_block *, unsigned long nr,
+				  enum wb_reason reason);
 void sync_inodes_sb(struct super_block *);
 long writeback_inodes_wb(struct bdi_writeback *wb, long nr_pages,
 				enum wb_reason reason);
-- 
1.7.6.5
