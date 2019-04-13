Return-Path: <SRS0=R85w=SP=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73376C10F11
	for <linux-ext4@archiver.kernel.org>; Sat, 13 Apr 2019 05:43:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C8DF20850
	for <linux-ext4@archiver.kernel.org>; Sat, 13 Apr 2019 05:43:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfDMFnx (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 13 Apr 2019 01:43:53 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37506 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfDMFnw (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Apr 2019 01:43:52 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 057802823E1
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     tytso@mit.edu
Cc:     linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH e2fsprogs 08/10] ext2fs: nls: Drop normalization code
Date:   Sat, 13 Apr 2019 01:43:15 -0400
Message-Id: <20190413054317.7388-9-krisman@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190413054317.7388-1-krisman@collabora.com>
References: <20190413054317.7388-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

No longer necessary after +F design change.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 lib/e2p/encoding.c     |  3 +--
 lib/ext2fs/ext2_fs.h   |  2 --
 lib/ext2fs/nls.h       |  4 ----
 lib/ext2fs/nls_ascii.c | 20 --------------------
 lib/ext2fs/nls_utf8.c  | 31 -------------------------------
 5 files changed, 1 insertion(+), 59 deletions(-)

diff --git a/lib/e2p/encoding.c b/lib/e2p/encoding.c
index 23470bdf38a5..62e0aada92c2 100644
--- a/lib/e2p/encoding.c
+++ b/lib/e2p/encoding.c
@@ -36,8 +36,7 @@ static const struct {
 	{
 		.encoding_magic = EXT4_ENC_UTF8_12_0,
 		.name = "utf8",
-		.default_flags = (EXT4_UTF8_NORMALIZATION_TYPE_NFKD |
-				  EXT4_UTF8_CASEFOLD_TYPE_NFKDCF)
+		.default_flags = 0,
 	},
 };
 
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index a1edc54dfd52..80ff02265ee5 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -1132,7 +1132,5 @@ struct mmp_struct {
 #define EXT4_ENC_UTF8_12_0	1
 
 #define EXT4_ENC_STRICT_MODE_FL			(1 << 0) /* Reject invalid sequences */
-#define EXT4_UTF8_NORMALIZATION_TYPE_NFKD	(1 << 1)
-#define EXT4_UTF8_CASEFOLD_TYPE_NFKDCF		(1 << 4)
 
 #endif	/* _LINUX_EXT2_FS_H */
diff --git a/lib/ext2fs/nls.h b/lib/ext2fs/nls.h
index c4fcbcb32528..ae56aa9abc89 100644
--- a/lib/ext2fs/nls.h
+++ b/lib/ext2fs/nls.h
@@ -33,10 +33,6 @@ struct nls_table;
         (sizeof(array) / sizeof(array[0]))
 
 struct nls_ops {
-	int (*normalize)(const struct nls_table *charset,
-			 const unsigned char *str, size_t len,
-			 unsigned char *dest, size_t dlen);
-
 	int (*casefold)(const struct nls_table *charset,
 			const unsigned char *str, size_t len,
 			unsigned char *dest, size_t dlen);
diff --git a/lib/ext2fs/nls_ascii.c b/lib/ext2fs/nls_ascii.c
index 5d513df404c1..cc03fea97ec5 100644
--- a/lib/ext2fs/nls_ascii.c
+++ b/lib/ext2fs/nls_ascii.c
@@ -39,28 +39,8 @@ static int ascii_casefold(const struct nls_table *table,
 	return len;
 }
 
-static int ascii_normalize(const struct nls_table *table,
-			   const unsigned char *str, size_t len,
-			   unsigned char *dest, size_t dlen)
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
-		dest[i] = str[i];
-	}
-
-	return len;
-}
-
 const static struct nls_ops ascii_ops = {
 	.casefold = ascii_casefold,
-	.normalize = ascii_normalize,
 };
 
 const struct nls_table nls_ascii = {
diff --git a/lib/ext2fs/nls_utf8.c b/lib/ext2fs/nls_utf8.c
index 426657764fc6..b1698e3c409f 100644
--- a/lib/ext2fs/nls_utf8.c
+++ b/lib/ext2fs/nls_utf8.c
@@ -54,39 +54,8 @@ invalid_seq:
 	return -EINVAL;
 }
 
-static int utf8_normalize(const struct nls_table *table,
-			  const unsigned char *str, size_t len,
-			  unsigned char *dest, size_t dlen)
-{
-	const struct utf8data *data = utf8nfdi(table->version);
-	struct utf8cursor cur;
-	ssize_t nlen = 0;
-
-	if (utf8ncursor(&cur, data, str, len) < 0)
-		goto invalid_seq;
-
-	for (nlen = 0; nlen < dlen; nlen++) {
-		dest[nlen] = utf8byte(&cur);
-		if (!dest[nlen])
-			return nlen;
-		if (dest[nlen] == -1)
-			break;
-	}
-
-	return -ENAMETOOLONG;
-
-invalid_seq:
-	if (dlen < len)
-		return -ENAMETOOLONG;
-
-	/* Signal invalid sequence */
-	return -EINVAL;
-}
-
 const static struct nls_ops utf8_ops = {
 	.casefold = utf8_casefold,
-	.normalize = utf8_normalize,
-
 };
 
 const struct nls_table nls_utf8_12_0 = {
-- 
2.20.1

