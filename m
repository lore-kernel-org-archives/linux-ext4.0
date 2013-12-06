From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v3 10/30] libext2fs: define new dirent_swab interfaces for inline data
Date: Fri,  6 Dec 2013 17:57:57 +0800
Message-ID: <1386323897-2354-11-git-send-email-wenqing.lz@taobao.com>
References: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:48998 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757597Ab3LFJzr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Dec 2013 04:55:47 -0500
Received: by mail-pb0-f53.google.com with SMTP id ma3so778654pbc.26
        for <linux-ext4@vger.kernel.org>; Fri, 06 Dec 2013 01:55:46 -0800 (PST)
In-Reply-To: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Later we will use ext2fs_dirent_swab_in/out to handle big-endian problem
for inline data.  Now interfaces assume that it handles a block, but it
is not true after adding inline data.  So this commit defines a new
interface for inline data.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/ext2fs.h |    4 ++++
 lib/ext2fs/swapfs.c |   16 ++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index e251435..1d5b80c 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1524,7 +1524,11 @@ extern errcode_t ext2fs_read_bb_FILE(ext2_filsys fs, FILE *f,
 extern errcode_t ext2fs_create_resize_inode(ext2_filsys fs);
 
 /* swapfs.c */
+extern errcode_t ext2fs_dirent_swab_in2(ext2_filsys fs, char *buf, size_t size,
+					int flags);
 extern errcode_t ext2fs_dirent_swab_in(ext2_filsys fs, char *buf, int flags);
+extern errcode_t ext2fs_dirent_swab_out2(ext2_filsys fs, char *buf, size_t size,
+					 int flags);
 extern errcode_t ext2fs_dirent_swab_out(ext2_filsys fs, char *buf, int flags);
 extern void ext2fs_swap_ext_attr(char *to, char *from, int bufsize,
 				 int has_header);
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index 1295e81..8dfdcc9 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -354,13 +354,19 @@ void ext2fs_swap_mmp(struct mmp_struct *mmp)
 
 errcode_t ext2fs_dirent_swab_in(ext2_filsys fs, char *buf, int flags)
 {
+	return ext2fs_dirent_swab_in(fs, buf, fs->blocksize, flags);
+}
+
+errcode_t ext2fs_dirent_swab_in2(ext2_filsys fs, char *buf,
+				 size_t size, int flags)
+{
 	errcode_t	retval;
 	char		*p, *end;
 	struct ext2_dir_entry *dirent;
 	unsigned int	name_len, rec_len;
 
 	p = (char *) buf;
-	end = (char *) buf + fs->blocksize;
+	end = (char *) buf + size;
 	while (p < end-8) {
 		dirent = (struct ext2_dir_entry *) p;
 		dirent->inode = ext2fs_swab32(dirent->inode);
@@ -385,13 +391,19 @@ errcode_t ext2fs_dirent_swab_in(ext2_filsys fs, char *buf, int flags)
 
 errcode_t ext2fs_dirent_swab_out(ext2_filsys fs, char *buf, int flags)
 {
+	return ext2fs_dirent_swab_out2(fs, buf, fs->blocksize, flags);
+}
+
+errcode_t ext2fs_dirent_swab_out2(ext2_filsys fs, char *buf,
+				  size_t size, int flags)
+{
 	errcode_t	retval;
 	char		*p, *end;
 	unsigned int	rec_len;
 	struct ext2_dir_entry *dirent;
 
 	p = buf;
-	end = buf + fs->blocksize;
+	end = buf + size;
 	while (p < end) {
 		dirent = (struct ext2_dir_entry *) p;
 		retval = ext2fs_get_rec_len(fs, dirent, &rec_len);
-- 
1.7.9.7

