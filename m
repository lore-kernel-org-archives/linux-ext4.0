From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] libquota: remove use of PATH_MAX and replace it with QUOTA_NAME_LEN
Date: Sun, 27 Nov 2011 20:46:19 -0500
Message-ID: <1322444779-2284-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48587 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755796Ab1K1BqW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 Nov 2011 20:46:22 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

PATH_MAX is not portable (for example, it doesn't exist on the Hurd).
So replace it with a new define, which defines the maximum length of
the base quota name.  As it turns out, this is substantially smaller
than PATH_MAX.

Also move the definitions relating to quotaio.c from mkquota.h to
quotaio.h, as a cleanup.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/quota/mkquota.h |    5 -----
 lib/quota/quotaio.c |    4 ++--
 lib/quota/quotaio.h |    8 ++++++++
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/lib/quota/mkquota.h b/lib/quota/mkquota.h
index 4fbaedd..a5fa74b 100644
--- a/lib/quota/mkquota.h
+++ b/lib/quota/mkquota.h
@@ -60,9 +60,4 @@ int quota_is_on(ext2_filsys fs, int type);
 int quota_file_exists(ext2_filsys fs, int qtype, int fmt);
 void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, int qtype);
 
-/* In quotaio.c */
-const char *quota_get_qf_name(int type, int fmt, char *buf);
-const char *quota_get_qf_path(const char *mntpt, int qtype, int fmt,
-			      char *path_buf, size_t path_buf_size);
-
 #endif  /* __QUOTA_QUOTAIO_H__ */
diff --git a/lib/quota/quotaio.c b/lib/quota/quotaio.c
index d0b5b9d..3f434ca 100644
--- a/lib/quota/quotaio.c
+++ b/lib/quota/quotaio.c
@@ -56,7 +56,7 @@ const char *quota_get_qf_name(int type, int fmt, char *buf)
 {
 	if (!buf)
 		return NULL;
-	snprintf(buf, PATH_MAX, "%s.%s",
+	snprintf(buf, QUOTA_NAME_LEN, "%s.%s",
 		 basenames[fmt], extensions[type]);
 
 	return buf;
@@ -66,7 +66,7 @@ const char *quota_get_qf_path(const char *mntpt, int qtype, int fmt,
 			      char *path_buf, size_t path_buf_size)
 {
 	struct stat	qf_stat;
-	char qf_name[PATH_MAX] = {0};
+	char qf_name[QUOTA_NAME_LEN];
 
 	if (!mntpt || !path_buf || !path_buf_size)
 		return NULL;
diff --git a/lib/quota/quotaio.h b/lib/quota/quotaio.h
index f8cc1f1..91a1ff2 100644
--- a/lib/quota/quotaio.h
+++ b/lib/quota/quotaio.h
@@ -159,4 +159,12 @@ const char *type2name(int type);
 
 void update_grace_times(struct dquot *q);
 
+/* size for the buffer returned by quota_get_qf_name(); must be greater
+   than maxlen of extensions[] and fmtnames[] (plus 2) found in quotaio.c */
+#define QUOTA_NAME_LEN 16
+
+const char *quota_get_qf_name(int type, int fmt, char *buf);
+const char *quota_get_qf_path(const char *mntpt, int qtype, int fmt,
+			      char *path_buf, size_t path_buf_size);
+
 #endif /* GUARD_QUOTAIO_H */
-- 
1.7.4.1.22.gec8e1.dirty

