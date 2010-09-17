From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [RESEND][PATCH] ext4: create own llseek function to handle 2
 maxbytes
Date: Fri, 17 Sep 2010 14:32:25 +0900
Message-ID: <20100917143225.3e0d856a.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46845 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab0IQFuc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Sep 2010 01:50:32 -0400
Received: from m6.gw.fujitsu.co.jp ([10.0.50.76])
	by fgwmail5.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id o8H5oUMW004283
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Fri, 17 Sep 2010 14:50:31 +0900
Received: from smail (m6 [127.0.0.1])
	by outgoing.m6.gw.fujitsu.co.jp (Postfix) with ESMTP id 6FE0545DE53
	for <linux-ext4@vger.kernel.org>; Fri, 17 Sep 2010 14:50:30 +0900 (JST)
Received: from s6.gw.fujitsu.co.jp (s6.gw.fujitsu.co.jp [10.0.50.96])
	by m6.gw.fujitsu.co.jp (Postfix) with ESMTP id 1890345DE4E
	for <linux-ext4@vger.kernel.org>; Fri, 17 Sep 2010 14:50:30 +0900 (JST)
Received: from s6.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s6.gw.fujitsu.co.jp (Postfix) with ESMTP id 794A81DB8019
	for <linux-ext4@vger.kernel.org>; Fri, 17 Sep 2010 14:50:29 +0900 (JST)
Received: from m107.s.css.fujitsu.com (m107.s.css.fujitsu.com [10.249.87.107])
	by s6.gw.fujitsu.co.jp (Postfix) with ESMTP id 0177D1DB8016
	for <linux-ext4@vger.kernel.org>; Fri, 17 Sep 2010 14:50:29 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

If the file has no "EXT4_EXTENTS_FL" flag, the maximum size which can be 
written (write systemcall) is different from the maximum size which can be 
sought (lseek systemcall).

For example, the following 2 cases show us the differences:
#1: mkfs.ext3 <dev>; mount -t ext4 <dev>
#2: mkfs.ext3 <dev>; tune2fs -Oextent,huge_file <dev>; mount -t ext4 <dev>

Table. the max file size which we can write or seek
       at each filesystem feature tuning and file flag setting
+============+===============================+===============================+
| \ File flag|                               |                               |
|      \     |     !EXT4_EXTENTS_FL          |        EXT4_EXTETNS_FL        |
|case       \|                               |                               |
+------------+-------------------------------+-------------------------------+
| #1         |   write:      2194719883264   | write:       --------------   |
|            |   seek:       2199023251456   | seek:        --------------   |
+------------+-------------------------------+-------------------------------+
| #2         |   write:      4402345721856   | write:       17592186044415   |
|            |   seek:      17592186044415   | seek:        17592186044415   |
+------------+-------------------------------+-------------------------------+

The differences exist because ext4 has 2 maxbytes which are sb->s_maxbytes
(= extent-mapped maxbytes) and EXT4_SB(sb)->s_bitmap_maxbytes (= block-mapped 
maxbytes).  Although generic_file_llseek uses only extent-mapped maxbytes.
(llseek of ext4_file_operations is generic_file_llseek which uses
sb->s_maxbytes.)
Therefore we create ext4 llseek function which uses 2 maxbytes.

The new own function originates from generic_file_llseek().
If the file flag, "EXT4_EXTENTS_FL" is not set, the function alters 
inode->i_sb->s_maxbytes into EXT4_SB(inode->i_sb)->s_bitmap_maxbytes.

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
---
 fs/ext4/dir.c  |    2 +-
 fs/ext4/ext4.h |    1 +
 fs/ext4/file.c |   44 +++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 374510f..ece76fb 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -39,7 +39,7 @@ static int ext4_release_dir(struct inode *inode,
 				struct file *filp);
 
 const struct file_operations ext4_dir_operations = {
-	.llseek		= generic_file_llseek,
+	.llseek		= ext4_llseek,
 	.read		= generic_read_dir,
 	.readdir	= ext4_readdir,		/* we take BKL. needed?*/
 	.unlocked_ioctl = ext4_ioctl,
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 889ec9d..603f8d2 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1960,6 +1960,7 @@ extern const struct file_operations ext4_dir_operations;
 /* file.c */
 extern const struct inode_operations ext4_file_inode_operations;
 extern const struct file_operations ext4_file_operations;
+extern loff_t ext4_llseek(struct file *file, loff_t offset, int origin);
 
 /* namei.c */
 extern const struct inode_operations ext4_dir_inode_operations;
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index ee92b66..4efa6ba 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -130,8 +130,50 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
 	return dquot_file_open(inode, filp);
 }
 
+/* 
+ * ext4_llseek() copied from generic_file_llseek() to handle both 
+ * block-mapped and extent-mapped maxbytes values. This should otherwise be 
+ * identical with generic_file_llseek(). 
+ */
+loff_t ext4_llseek(struct file *file, loff_t offset, int origin)
+{
+	struct inode *inode = file->f_mapping->host;
+	loff_t maxbytes;
+
+	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
+		maxbytes = EXT4_SB(inode->i_sb)->s_bitmap_maxbytes;
+	else
+		maxbytes = inode->i_sb->s_maxbytes;
+	mutex_lock(&inode->i_mutex);
+	switch (origin) {
+	case SEEK_END:
+		offset += inode->i_size;
+		break;
+	case SEEK_CUR:
+		if (offset == 0) {
+			mutex_unlock(&inode->i_mutex);
+			return file->f_pos;
+		}
+		offset += file->f_pos;
+		break;
+	}
+
+	if (offset < 0 || offset > maxbytes) {
+		mutex_unlock(&inode->i_mutex);
+		return -EINVAL;
+	}
+
+	if (offset != file->f_pos) {
+		file->f_pos = offset;
+		file->f_version = 0;
+	}
+	mutex_unlock(&inode->i_mutex);
+ 
+	return offset;
+}
+
 const struct file_operations ext4_file_operations = {
-	.llseek		= generic_file_llseek,
+	.llseek		= ext4_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
 	.aio_read	= generic_file_aio_read,
-- 
1.5.5.6
