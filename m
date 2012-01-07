From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 1/2] libext2fs: Add ext2fs_file_get_inode_num call (for
	fuse2fs)
Date: Sat, 07 Jan 2012 00:55:29 -0800
Message-ID: <20120107085529.4325.17894.stgit@elm3c44.beaverton.ibm.com>
References: <20120107085523.4325.42183.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33033 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab2AGIzd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 Jan 2012 03:55:33 -0500
Received: from /spool/local
	by e2.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Sat, 7 Jan 2012 03:55:32 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q078tU69161972
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jan 2012 03:55:30 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q078tTU3022709
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jan 2012 06:55:30 -0200
In-Reply-To: <20120107085523.4325.42183.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add a function to return the inode number of an open file.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/ext2fs/ext2fs.h |    1 +
 lib/ext2fs/fileio.c |    8 ++++++++
 2 files changed, 9 insertions(+), 0 deletions(-)


diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 227ee58..0b4b285 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1094,6 +1094,7 @@ extern errcode_t ext2fs_file_open(ext2_filsys fs, ext2_ino_t ino,
 				  int flags, ext2_file_t *ret);
 extern ext2_filsys ext2fs_file_get_fs(ext2_file_t file);
 struct ext2_inode *ext2fs_file_get_inode(ext2_file_t file);
+extern ext2_ino_t ext2fs_file_get_inode_num(ext2_file_t file);
 extern errcode_t ext2fs_file_close(ext2_file_t file);
 extern errcode_t ext2fs_file_flush(ext2_file_t file);
 extern errcode_t ext2fs_file_read(ext2_file_t file, void *buf,
diff --git a/lib/ext2fs/fileio.c b/lib/ext2fs/fileio.c
index 8751635..1f7002c 100644
--- a/lib/ext2fs/fileio.c
+++ b/lib/ext2fs/fileio.c
@@ -106,6 +106,14 @@ struct ext2_inode *ext2fs_file_get_inode(ext2_file_t file)
 	return &file->inode;
 }
 
+/* This function returns the inode number from the structure */
+ext2_ino_t ext2fs_file_get_inode_num(ext2_file_t file)
+{
+	if (file->magic != EXT2_ET_MAGIC_EXT2_FILE)
+		return 0;
+	return file->ino;
+}
+
 /*
  * This function flushes the dirty block buffer out to disk if
  * necessary.

