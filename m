From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v3 26/30] e2fsck: check inline_data in pass3
Date: Fri,  6 Dec 2013 17:58:13 +0800
Message-ID: <1386323897-2354-27-git-send-email-wenqing.lz@taobao.com>
References: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:52494 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757739Ab3LFJ40 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Dec 2013 04:56:26 -0500
Received: by mail-pb0-f47.google.com with SMTP id um1so781274pbc.6
        for <linux-ext4@vger.kernel.org>; Fri, 06 Dec 2013 01:56:25 -0800 (PST)
In-Reply-To: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

In e2fsck_expand_directory() we don't handle a dir with inline data
because when this function is called the directory inode shouldn't
contains inline data.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 e2fsck/pass3.c   |   12 ++++++++++++
 e2fsck/problem.c |    5 +++++
 e2fsck/problem.h |    3 +++
 e2fsck/rehash.c  |    2 ++
 4 files changed, 22 insertions(+)

diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index 2dd414b..2cab41d 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -375,6 +375,17 @@ ext2_ino_t e2fsck_get_lost_and_found(e2fsck_t ctx, int fix)
 	if (retval && !fix)
 		return 0;
 	if (!retval) {
+		/* Lost+found shouldn't have inline data */
+		retval = ext2fs_read_inode(fs, ino, &inode);
+		if (fix && retval)
+			return 0;
+
+		if (fix && (inode.i_flags & EXT4_INLINE_DATA_FL)) {
+			if (!fix_problem(ctx, PR_3_LPF_INLINE_DATA, &pctx))
+				return 0;
+			goto unlink;
+		}
+
 		if (ext2fs_check_directory(fs, ino) == 0) {
 			ctx->lost_and_found = ino;
 			return ino;
@@ -387,6 +398,7 @@ ext2_ino_t e2fsck_get_lost_and_found(e2fsck_t ctx, int fix)
 		if (!fix_problem(ctx, PR_3_LPF_NOTDIR, &pctx))
 			return 0;
 
+unlink:
 		/* OK, unlink the old /lost+found file. */
 		pctx.errcode = ext2fs_unlink(fs, EXT2_ROOT_INO, name, ino, 0);
 		if (pctx.errcode) {
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index a4f7749..471cec7 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1597,6 +1597,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("/@l is not a @d (ino=%i)\n"),
 	  PROMPT_UNLINK, 0 },
 
+	/* Lost+found has inline data */
+	{ PR_3_LPF_INLINE_DATA,
+	  N_("/@l has inline data\n"),
+	  PROMPT_CLEAR, 0 },
+
 	/* Pass 3A Directory Optimization	*/
 
 	/* Pass 3A: Optimizing directories */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 9d41cea..8219b84 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -955,6 +955,9 @@ struct problem_context {
 /* Lost+found is not a directory */
 #define PR_3_LPF_NOTDIR			0x030017
 
+/* Lost+found has inline data */
+#define PR_3_LPF_INLINE_DATA		0x030018
+
 /*
  * Pass 3a --- rehashing diretories
  */
diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index 6ef3568..b254e81 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -814,6 +814,8 @@ retry_nohash:
 	/* Read in the entire directory into memory */
 	retval = ext2fs_block_iterate3(fs, ino, 0, 0,
 				       fill_dir_block, &fd);
+	if (retval == EXT2_ET_INLINE_DATA_CANT_ITERATE)
+		goto errout;
 	if (fd.err) {
 		retval = fd.err;
 		goto errout;
-- 
1.7.9.7

