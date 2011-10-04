From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/5] libquota: remove get_qf_name()
Date: Tue,  4 Oct 2011 12:16:36 -0400
Message-ID: <1317744998-8238-3-git-send-email-tytso@mit.edu>
References: <1317744998-8238-1-git-send-email-tytso@mit.edu>
Cc: Aditya Kali <adityakali@google.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43532 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932151Ab1JDQQm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Oct 2011 12:16:42 -0400
In-Reply-To: <1317744998-8238-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The get_qf_name() function used PATH_MAX, which is non-portable.
Worse, it blindly assumed that PATH_MAX was the size of the buffer
passed to it --- which in the one and only place where it was used in
libquota, was a buffer declared to a fixed size 256 bytes.

Fix this by simply getting rid of the function altogether.

Cc: Aditya Kali <adityakali@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/quota/mkquota.c |    6 +++---
 lib/quota/mkquota.h |    5 +----
 lib/quota/quotaio.c |   12 ------------
 misc/tune2fs.c      |    4 ++--
 4 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/lib/quota/mkquota.c b/lib/quota/mkquota.c
index 263b62b..35cac66 100644
--- a/lib/quota/mkquota.c
+++ b/lib/quota/mkquota.c
@@ -65,16 +65,16 @@ int is_quota_on(ext2_filsys fs, int type)
  * Returns 0 if not able to find the quota file, otherwise returns its
  * inode number.
  */
-int quota_file_exists(ext2_filsys fs, int qtype, int fmt)
+int quota_file_exists(ext2_filsys fs, int qtype)
 {
 	char qf_name[256];
 	errcode_t ret;
 	ext2_ino_t ino;
 
-	if (qtype >= MAXQUOTAS || fmt > QFMT_VFS_V1)
+	if (qtype >= MAXQUOTAS)
 		return -EINVAL;
 
-	get_qf_name(qtype, fmt, qf_name);
+	snprintf(qf_name, sizeof(qf_name), "aquota.%s", type2name(qtype));
 
 	ret = ext2fs_lookup(fs, EXT2_ROOT_INO, qf_name, strlen(qf_name), 0,
 			    &ino);
diff --git a/lib/quota/mkquota.h b/lib/quota/mkquota.h
index 00d3c2f..e3ec8c2 100644
--- a/lib/quota/mkquota.h
+++ b/lib/quota/mkquota.h
@@ -55,10 +55,7 @@ void release_quota_context(quota_ctx_t *qctx);
 
 errcode_t remove_quota_inode(ext2_filsys fs, int qtype);
 int is_quota_on(ext2_filsys fs, int type);
-int quota_file_exists(ext2_filsys fs, int qtype, int fmt);
+int quota_file_exists(ext2_filsys fs, int qtype);
 void set_sb_quota_inum(ext2_filsys fs, ext2_ino_t ino, int qtype);
 
-/* in quotaio.c */
-const char *get_qf_name(int type, int fmt, char *buf);
-
 #endif  /* __QUOTA_QUOTAIO_H__ */
diff --git a/lib/quota/quotaio.c b/lib/quota/quotaio.c
index ef92f5a..f651353 100644
--- a/lib/quota/quotaio.c
+++ b/lib/quota/quotaio.c
@@ -49,18 +49,6 @@ const char *type2name(int type)
 	return extensions[type];
 }
 
-/**
- * Creates a quota file name for given type and format.
- */
-const char *get_qf_name(int type, int fmt, char *buf)
-{
-	BUG_ON(!buf);
-	snprintf(buf, PATH_MAX, "%s.%s",
-		 basenames[fmt], extensions[type]);
-
-	return buf;
-}
-
 /*
  * Set grace time if needed
  */
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index e2fdb4a..88e814b 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -710,7 +710,7 @@ void handle_quota_options(ext2_filsys fs)
 	init_quota_context(&qctx, fs, -1);
 
 	if (usrquota == QOPT_ENABLE && !fs->super->s_usr_quota_inum) {
-		if ((qf_ino = quota_file_exists(fs, USRQUOTA, QFMT_VFS_V1)) > 0)
+		if ((qf_ino = quota_file_exists(fs, USRQUOTA)) > 0)
 			set_sb_quota_inum(fs, qf_ino, USRQUOTA);
 		else
 			write_quota_inode(qctx, USRQUOTA);
@@ -719,7 +719,7 @@ void handle_quota_options(ext2_filsys fs)
 	}
 
 	if (grpquota == QOPT_ENABLE && !fs->super->s_grp_quota_inum) {
-		if ((qf_ino = quota_file_exists(fs, GRPQUOTA, QFMT_VFS_V1)) > 0)
+		if ((qf_ino = quota_file_exists(fs, GRPQUOTA)) > 0)
 			set_sb_quota_inum(fs, qf_ino, GRPQUOTA);
 		else
 			write_quota_inode(qctx, GRPQUOTA);
-- 
1.7.4.1.22.gec8e1.dirty

