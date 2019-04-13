Return-Path: <SRS0=R85w=SP=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA36EC10F14
	for <linux-ext4@archiver.kernel.org>; Sat, 13 Apr 2019 05:43:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86EA920850
	for <linux-ext4@archiver.kernel.org>; Sat, 13 Apr 2019 05:43:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfDMFn4 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 13 Apr 2019 01:43:56 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37510 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfDMFn4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Apr 2019 01:43:56 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 26AE02823E4
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     tytso@mit.edu
Cc:     linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH e2fsprogs 09/10] ext2fs: nls: Drop ascii NLS support
Date:   Sat, 13 Apr 2019 01:43:16 -0400
Message-Id: <20190413054317.7388-10-krisman@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190413054317.7388-1-krisman@collabora.com>
References: <20190413054317.7388-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

As agreed on the kernel side, ext4 will only support utf8 for now, and
not plain ascii, so we don't need this anymore.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 lib/e2p/encoding.c     |  5 -----
 lib/ext2fs/Makefile.in |  5 ++---
 lib/ext2fs/ext2_fs.h   |  1 -
 lib/ext2fs/nls.h       |  2 --
 lib/ext2fs/nls_ascii.c | 48 ------------------------------------------
 5 files changed, 2 insertions(+), 59 deletions(-)
 delete mode 100644 lib/ext2fs/nls_ascii.c

diff --git a/lib/e2p/encoding.c b/lib/e2p/encoding.c
index 62e0aada92c2..6a3c472b1b31 100644
--- a/lib/e2p/encoding.c
+++ b/lib/e2p/encoding.c
@@ -28,11 +28,6 @@ static const struct {
 	__u16 default_flags;
 
 } ext4_encoding_map[] = {
-	{
-		.encoding_magic = EXT4_ENC_ASCII,
-		.name = "ascii",
-		.default_flags = 0
-	},
 	{
 		.encoding_magic = EXT4_ENC_UTF8_12_0,
 		.name = "utf8",
diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 06c2394b34b8..4b3fc1881cff 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -20,8 +20,8 @@ COMPILE_ET=	_ET_DIR_OVERRIDE=$(srcdir)/../et ../et/compile_et
 @TEST_IO_CMT@TEST_IO_LIB_OBJS = test_io.o
 @IMAGER_CMT@E2IMAGE_LIB_OBJS = imager.o
 
-NLS_OBJS=nls_ascii.o nls_utf8-norm.o nls_utf8.o
-NLS_SRCS=$(srcdir)/nls_ascii.c $(srcdir)/nls_utf8-norm.c $(srcdir)/nls_utf8.c
+NLS_OBJS=nls_utf8-norm.o nls_utf8.o
+NLS_SRCS=$(srcdir)/nls_utf8-norm.c $(srcdir)/nls_utf8.c
 
 DEBUG_OBJS= debug_cmds.o extent_cmds.o tst_cmds.o debugfs.o util.o \
 	ncheck.o icheck.o ls.o lsdel.o dump.o set_fields.o logdump.o \
@@ -1328,7 +1328,6 @@ do_journal.o: $(top_srcdir)/debugfs/do_journal.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/support/quotaio_tree.h $(srcdir)/kernel-jbd.h \
  $(srcdir)/jfs_compat.h $(srcdir)/kernel-list.h \
  $(top_srcdir)/debugfs/journal.h $(srcdir)/../../e2fsck/jfs_user.h
-nls_ascii.o: $(srcdir)/nls_ascii.c $(srcdir)/nls.h $(srcdir)/ext2_fs.h
 nls_utf8-norm.o: $(srcdir)/nls_utf8-norm.c $(srcdir)/utf8n.h \
  $(srcdir)/utf8data.h
 nls_utf8.o: $(srcdir)/nls_utf8.c $(srcdir)/nls.h $(srcdir)/ext2_fs.h \
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 80ff02265ee5..fc8a650a3aad 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -1128,7 +1128,6 @@ struct mmp_struct {
  */
 #define EXT4_INLINE_DATA_DOTDOT_SIZE	(4)
 
-#define EXT4_ENC_ASCII		0
 #define EXT4_ENC_UTF8_12_0	1
 
 #define EXT4_ENC_STRICT_MODE_FL			(1 << 0) /* Reject invalid sequences */
diff --git a/lib/ext2fs/nls.h b/lib/ext2fs/nls.h
index ae56aa9abc89..f008bd167f36 100644
--- a/lib/ext2fs/nls.h
+++ b/lib/ext2fs/nls.h
@@ -43,14 +43,12 @@ struct nls_table {
 	const struct nls_ops *ops;
 };
 
-extern const struct nls_table nls_ascii;
 extern const struct nls_table nls_utf8_12_0;
 
 static const struct {
 	int encoding_magic;
 	const struct nls_table *tbl;
 } nls_map[] = {
-	{ EXT4_ENC_ASCII, &nls_ascii },
 	{ EXT4_ENC_UTF8_12_0, &nls_utf8_12_0 },
 };
 
diff --git a/lib/ext2fs/nls_ascii.c b/lib/ext2fs/nls_ascii.c
deleted file mode 100644
index cc03fea97ec5..000000000000
--- a/lib/ext2fs/nls_ascii.c
+++ /dev/null
@@ -1,48 +0,0 @@
-#include "nls.h"
-
-#include <errno.h>
-#include <string.h>
-
-
-static unsigned char charset_tolower(const struct nls_table *table,
-				     unsigned int c)
-{
-	if (c >= 'A' && c <= 'Z')
-		return (c | 0x20);
-	return c;
-}
-
-static unsigned char charset_toupper(const struct nls_table *table,
-				     unsigned int c)
-{
-	if (c >= 'a' && c <= 'z')
-		return (c & ~0x20);
-	return c;
-}
-
-static int ascii_casefold(const struct nls_table *table,
-			  const unsigned char *str, size_t len,
-			  unsigned char *dest, size_t dlen)
-{
-	int i;
-
-	if (dlen < len)
-		return -ENAMETOOLONG;
-
-	for (i = 0; i < len; i++) {
-		if (str[i] & 0x80)
-			return -EINVAL;
-
-		dest[i] = charset_toupper(table, str[i]);
-	}
-
-	return len;
-}
-
-const static struct nls_ops ascii_ops = {
-	.casefold = ascii_casefold,
-};
-
-const struct nls_table nls_ascii = {
-	.ops = &ascii_ops,
-};
-- 
2.20.1

