From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [Q] ext4: the max file size of each case is correct?
Date: Tue, 10 Aug 2010 23:23:21 +0900
Message-ID: <20100810232321.0eb72247.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48668 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab0HJFl5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Aug 2010 01:41:57 -0400
Received: from m6.gw.fujitsu.co.jp ([10.0.50.76])
	by fgwmail7.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id o7A5fskA016270
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Tue, 10 Aug 2010 14:41:54 +0900
Received: from smail (m6 [127.0.0.1])
	by outgoing.m6.gw.fujitsu.co.jp (Postfix) with ESMTP id 3AAB945DE4E
	for <linux-ext4@vger.kernel.org>; Tue, 10 Aug 2010 14:41:54 +0900 (JST)
Received: from s6.gw.fujitsu.co.jp (s6.gw.fujitsu.co.jp [10.0.50.96])
	by m6.gw.fujitsu.co.jp (Postfix) with ESMTP id 1B7B145DE4C
	for <linux-ext4@vger.kernel.org>; Tue, 10 Aug 2010 14:41:54 +0900 (JST)
Received: from s6.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s6.gw.fujitsu.co.jp (Postfix) with ESMTP id 056271DB8013
	for <linux-ext4@vger.kernel.org>; Tue, 10 Aug 2010 14:41:54 +0900 (JST)
Received: from m108.s.css.fujitsu.com (m108.s.css.fujitsu.com [10.249.87.108])
	by s6.gw.fujitsu.co.jp (Postfix) with ESMTP id AF76C1DB8012
	for <linux-ext4@vger.kernel.org>; Tue, 10 Aug 2010 14:41:50 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi.

I have tested the following cases in order to confirm the maximum file size.
For the tests, I selected two parameters:
(These parameters relate to the max file size.)
1) Filesystem Feature
  "extent"
2) File(Inode) Flag
  "EXT4_EXTENTS_FL"
 (This parameter corresponds to the case where people shifts from ext3 into ext4.
  (Files which are created with ext3 have no "EXT4_EXTENTS_FL" flag.))

Table. the max file size which we can write or seek
       at each filesystem feature tuning and file flag setting
+============+===============================+===============================+
| \ File flag|                               |                               |
|      \     |     !EXT4_EXTENTS_FL          |        EXT4_EXTETNS_FL        |
|Fs Features\|                               |                               |
+------------+-------------------------------+-------------------------------+
| !extent    |   write:      2194719883264   | write:       --------------   |
|            |   seek:       2199023251456   | seek:        --------------   |
+------------+-------------------------------+-------------------------------+
|  extent    |   write:      4402345721856   | write:       17592186044415   |
|            |   seek:      17592186044415   | seek:        17592186044415   |
+------------+-------------------------------+-------------------------------+
(
The symbols (!extent, extent) mean: 
 !extent: The filesystem feature "extent" is not set.
	ex.  mkfs.ext3 <dev>; mount -t ext4 <dev>
  extent: The filesystem feature "extent" is set.
	ex.  mkfs.ext3 <dev>; tune2fs -Oextent,huge_file <dev>; mount -t ext4 <dev>
The symbols ("!EXT4_EXTENTS_FL","EXT4_EXTENTS_FL") mean:
 !EXT4_EXTENS_FL: The file flag, "EXT4_EXTENTS_FL" is not set.
  EXT4_EXTENS_FL: The file flag, "EXT4_EXTENTS_FL" is set. 
)

According to the table, if EXT4_EXTETNS_FL flag is not set, the max file
size of write() is different from the one of seek().

These differences don't include in the ext4-specification, do they?
I think the differences are not the ext4-specification.

So, I made a fix patch of the differences. 
================================================================================
Subject: [PATCH] ext4: create own llseek function to handle the max file size correctly.
From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

If the file has no EXT4_EXTENTS_FL flag, the maximum size which can be written
(write systemcall) is different from the maximum size which can be seeked 
(lseek systemcall).

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

The differences exist because ext4 has 2 max-file-size (sb->s_maxbytes, 
EXT4_SB(sb)->s_bitmap_maxbytes) although generic_file_llseek uses only 
sb->s_maxbytes.  (llseek of ext4_file_operations is generic_file_llseek.)
Therefore we create own llseek function which uses 2 max-file-size.

The new own function originates from generic_file_llseek_nolocked().
If the file flag, "EXT4_EXTENTS_FL" is not set, the function alters 
inode->i_sb->s_maxbytes into EXT4_SB(inode->i_sb)->s_bitmap_maxbytes.

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 fs/ext4/dir.c  |    2 +-
 fs/ext4/ext4.h |    1 +
 fs/ext4/file.c |   39 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index ea5e6cb..62c9bba 100644
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
index 19a4de5..e7050cd 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1870,6 +1870,7 @@ extern const struct file_operations ext4_dir_operations;
 /* file.c */
 extern const struct inode_operations ext4_file_inode_operations;
 extern const struct file_operations ext4_file_operations;
+extern loff_t ext4_llseek(struct file *file, loff_t offset, int origin);
 
 /* namei.c */
 extern const struct inode_operations ext4_dir_inode_operations;
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 5313ae4..f2e2d57 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -129,8 +129,45 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
 	return dquot_file_open(inode, filp);
 }
 
+loff_t ext4_llseek(struct file *file, loff_t offset, int origin)
+{
+	struct inode *inode = file->f_mapping->host;
+	loff_t maxbytes;
+
+	mutex_lock(&inode->i_mutex);
+	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
+		maxbytes = EXT4_SB(inode->i_sb)->s_bitmap_maxbytes;
+	else
+		maxbytes = inode->i_sb->s_maxbytes;
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
+       	}
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
