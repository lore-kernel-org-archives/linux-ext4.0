From: Roel Kluin <12o3l@tiscali.nl>
Subject: [PATCH] EXT: fix test ext_generic_write_end() copied return value
Date: Thu, 17 Apr 2008 05:21:35 +0200
Message-ID: <4806C23F.7080302@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, sct@redhat.com,
	akpm@linux-foundation.org, adilger@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:53336 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbYDQDVm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Apr 2008 23:21:42 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

'copied' is unsigned, whereas 'ret2' is not. The test (copied < 0) fails

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index eb95670..43daaae 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1261,10 +1261,11 @@ static int ext3_ordered_write_end(struct file *file,
 		new_i_size = pos + copied;
 		if (new_i_size > EXT3_I(inode)->i_disksize)
 			EXT3_I(inode)->i_disksize = new_i_size;
-		copied = ext3_generic_write_end(file, mapping, pos, len, copied,
+		ret2 = ext3_generic_write_end(file, mapping, pos, len, copied,
 							page, fsdata);
-		if (copied < 0)
-			ret = copied;
+		copied = ret2;
+		if (ret2 < 0)
+			ret = ret2;
 	}
 	ret2 = ext3_journal_stop(handle);
 	if (!ret)
@@ -1289,10 +1290,11 @@ static int ext3_writeback_write_end(struct file *file,
 	if (new_i_size > EXT3_I(inode)->i_disksize)
 		EXT3_I(inode)->i_disksize = new_i_size;
 
-	copied = ext3_generic_write_end(file, mapping, pos, len, copied,
+	ret2 = ext3_generic_write_end(file, mapping, pos, len, copied,
 							page, fsdata);
-	if (copied < 0)
-		ret = copied;
+	copied = ret2;
+	if (ret2 < 0)
+		ret = ret2;
 
 	ret2 = ext3_journal_stop(handle);
 	if (!ret)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 945cbf6..47d5d73 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1301,10 +1301,11 @@ static int ext4_ordered_write_end(struct file *file,
 		new_i_size = pos + copied;
 		if (new_i_size > EXT4_I(inode)->i_disksize)
 			EXT4_I(inode)->i_disksize = new_i_size;
-		copied = ext4_generic_write_end(file, mapping, pos, len, copied,
+		ret2 = ext4_generic_write_end(file, mapping, pos, len, copied,
 							page, fsdata);
-		if (copied < 0)
-			ret = copied;
+		copied = ret2;
+		if (ret2 < 0)
+			ret = ret2;
 	}
 	ret2 = ext4_journal_stop(handle);
 	if (!ret)
@@ -1329,10 +1330,11 @@ static int ext4_writeback_write_end(struct file *file,
 	if (new_i_size > EXT4_I(inode)->i_disksize)
 		EXT4_I(inode)->i_disksize = new_i_size;
 
-	copied = ext4_generic_write_end(file, mapping, pos, len, copied,
+	ret2 = ext4_generic_write_end(file, mapping, pos, len, copied,
 							page, fsdata);
-	if (copied < 0)
-		ret = copied;
+	copied = ret2;
+	if (ret2 < 0)
+		ret = ret2;
 
 	ret2 = ext4_journal_stop(handle);
 	if (!ret)
