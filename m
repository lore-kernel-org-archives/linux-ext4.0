From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/5] libquota: remove get_qf_path()
Date: Tue,  4 Oct 2011 12:16:34 -0400
Message-ID: <1317744998-8238-1-git-send-email-tytso@mit.edu>
Cc: Aditya Kali <adityakali@google.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43538 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932244Ab1JDQQq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Oct 2011 12:16:46 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This function isn't used anywhere, so remove it.  It also uses
PATH_MAX which is not portable.

Cc: Aditya Kali <adityakali@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/quota/mkquota.h |    2 --
 lib/quota/quotaio.c |   18 ------------------
 2 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/lib/quota/mkquota.h b/lib/quota/mkquota.h
index b4eba14..00d3c2f 100644
--- a/lib/quota/mkquota.h
+++ b/lib/quota/mkquota.h
@@ -60,7 +60,5 @@ void set_sb_quota_inum(ext2_filsys fs, ext2_ino_t ino, int qtype);
 
 /* in quotaio.c */
 const char *get_qf_name(int type, int fmt, char *buf);
-const char *get_qf_path(const char *mntpt, int qtype, int fmt,
-			char *path_buf, size_t path_buf_size);
 
 #endif  /* __QUOTA_QUOTAIO_H__ */
diff --git a/lib/quota/quotaio.c b/lib/quota/quotaio.c
index 7e080c8..cf13e35 100644
--- a/lib/quota/quotaio.c
+++ b/lib/quota/quotaio.c
@@ -61,24 +61,6 @@ const char *get_qf_name(int type, int fmt, char *buf)
 	return buf;
 }
 
-const char *get_qf_path(const char *mntpt, int qtype, int fmt,
-			char *path_buf, size_t path_buf_size)
-{
-	struct stat	qf_stat;
-	char qf_name[PATH_MAX] = {0};
-
-	BUG_ON(!mntpt);
-	BUG_ON(!path_buf);
-	BUG_ON(!path_buf_size);
-
-	strncpy(path_buf, mntpt, path_buf_size);
-	strncat(path_buf, "/", 1);
-	strncat(path_buf, get_qf_name(qtype, fmt, qf_name),
-		path_buf_size - strlen(path_buf));
-
-	return path_buf;
-}
