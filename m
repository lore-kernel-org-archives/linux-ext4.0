Return-Path: <SRS0=X8xt=SS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4570FC10F13
	for <linux-ext4@archiver.kernel.org>; Tue, 16 Apr 2019 20:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 207D020684
	for <linux-ext4@archiver.kernel.org>; Tue, 16 Apr 2019 20:13:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbfDPUNv (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 16 Apr 2019 16:13:51 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:51888 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728000AbfDPUNv (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Apr 2019 16:13:51 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 7C2A92756DD
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     tytso@mit.edu
Cc:     linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH] nls: Update to Unicode 12.1.0
Date:   Tue, 16 Apr 2019 16:13:44 -0400
Message-Id: <20190416201344.27122-1-krisman@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190413054317.7388-7-krisman@collabora.com>
References: <20190413054317.7388-7-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi Ted,

Like the kernel version, here is the unicode 12.1 update I promissed.
Feel free to squash it into the Unicode 12.0 update.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 lib/e2p/encoding.c    |  2 +-
 lib/ext2fs/ext2_fs.h  |  2 +-
 lib/ext2fs/nls.h      |  4 ++--
 lib/ext2fs/nls_utf8.c |  4 ++--
 lib/ext2fs/utf8data.h | 17 ++++++++++-------
 5 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/lib/e2p/encoding.c b/lib/e2p/encoding.c
index 6a3c472b1b31..69fa6e4c7d26 100644
--- a/lib/e2p/encoding.c
+++ b/lib/e2p/encoding.c
@@ -29,7 +29,7 @@ static const struct {
 
 } ext4_encoding_map[] = {
 	{
-		.encoding_magic = EXT4_ENC_UTF8_12_0,
+		.encoding_magic = EXT4_ENC_UTF8_12_1,
 		.name = "utf8",
 		.default_flags = 0,
 	},
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index fc8a650a3aad..ffcacafe8296 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -1128,7 +1128,7 @@ struct mmp_struct {
  */
 #define EXT4_INLINE_DATA_DOTDOT_SIZE	(4)
 
-#define EXT4_ENC_UTF8_12_0	1
+#define EXT4_ENC_UTF8_12_1	1
 
 #define EXT4_ENC_STRICT_MODE_FL			(1 << 0) /* Reject invalid sequences */
 
diff --git a/lib/ext2fs/nls.h b/lib/ext2fs/nls.h
index f008bd167f36..1d55ee404d5c 100644
--- a/lib/ext2fs/nls.h
+++ b/lib/ext2fs/nls.h
@@ -43,13 +43,13 @@ struct nls_table {
 	const struct nls_ops *ops;
 };
 
-extern const struct nls_table nls_utf8_12_0;
+extern const struct nls_table nls_utf8_12_1;
 
 static const struct {
 	int encoding_magic;
 	const struct nls_table *tbl;
 } nls_map[] = {
-	{ EXT4_ENC_UTF8_12_0, &nls_utf8_12_0 },
+	{ EXT4_ENC_UTF8_12_1, &nls_utf8_12_1 },
 };
 
 static const struct nls_table *nls_load_table(int encoding)
diff --git a/lib/ext2fs/nls_utf8.c b/lib/ext2fs/nls_utf8.c
index b1698e3c409f..857754d645dd 100644
--- a/lib/ext2fs/nls_utf8.c
+++ b/lib/ext2fs/nls_utf8.c
@@ -58,7 +58,7 @@ const static struct nls_ops utf8_ops = {
 	.casefold = utf8_casefold,
 };
 
-const struct nls_table nls_utf8_12_0 = {
+const struct nls_table nls_utf8_12_1 = {
 	.ops = &utf8_ops,
-	.version = UNICODE_AGE(12, 0, 0),
+	.version = UNICODE_AGE(12, 1, 0),
 };
diff --git a/lib/ext2fs/utf8data.h b/lib/ext2fs/utf8data.h
index 4d65c04e0786..76e4f0e1b089 100644
--- a/lib/ext2fs/utf8data.h
+++ b/lib/ext2fs/utf8data.h
@@ -3,7 +3,7 @@
 #error Only nls_utf8-norm.c should include this file.
 #endif
 
-static const unsigned int utf8vers = 0xc0000;
+static const unsigned int utf8vers = 0xc0100;
 
 static const unsigned int utf8agetab[] = {
 	0,
@@ -27,7 +27,8 @@ static const unsigned int utf8agetab[] = {
 	0x90000,
 	0xa0000,
 	0xb0000,
-	0xc0000
+	0xc0000,
+	0xc0100
 };
 
 static const struct utf8data utf8nfdicfdata[] = {
@@ -52,7 +53,8 @@ static const struct utf8data utf8nfdicfdata[] = {
 	{ 0x90000, 3200 },
 	{ 0xa0000, 3200 },
 	{ 0xb0000, 3200 },
-	{ 0xc0000, 3200 }
+	{ 0xc0000, 3200 },
+	{ 0xc0100, 3200 }
 };
 
 static const struct utf8data utf8nfdidata[] = {
@@ -77,7 +79,8 @@ static const struct utf8data utf8nfdidata[] = {
 	{ 0x90000, 20736 },
 	{ 0xa0000, 20736 },
 	{ 0xb0000, 20736 },
-	{ 0xc0000, 20736 }
+	{ 0xc0000, 20736 },
+	{ 0xc0100, 20736 }
 };
 
 static const unsigned char utf8data[64256] = {
@@ -285,7 +288,7 @@ static const unsigned char utf8data[64256] = {
 	0xe8,0x9a,0x88,0x00,0x05,0xff,0xe8,0x9c,0x8e,0x00,0xd1,0x10,0x10,0x08,0x05,0xff,
 	0xe8,0x9c,0xa8,0x00,0x05,0xff,0xe8,0x9d,0xab,0x00,0x10,0x08,0x05,0xff,0xe8,0x9e,
 	0x86,0x00,0x05,0xff,0xe4,0xb5,0x97,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
-	/* nfdicf_c0000 */
+	/* nfdicf_c0100 */
 	0xd7,0xb0,0x56,0x04,0x01,0x00,0x95,0xa8,0xd4,0x5e,0xd3,0x2e,0xd2,0x16,0xd1,0x0a,
 	0x10,0x04,0x01,0x00,0x01,0xff,0x61,0x00,0x10,0x06,0x01,0xff,0x62,0x00,0x01,0xff,
 	0x63,0x00,0xd1,0x0c,0x10,0x06,0x01,0xff,0x64,0x00,0x01,0xff,0x65,0x00,0x10,0x06,
@@ -1382,7 +1385,7 @@ static const unsigned char utf8data[64256] = {
 	0x00,0x12,0x00,0x12,0x00,0x12,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
 	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
 	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
-	/* nfdi_c0000 */
+	/* nfdi_c0100 */
 	0x57,0x04,0x01,0x00,0xc6,0xe5,0xac,0x13,0xe4,0x41,0x0c,0xe3,0x7a,0x07,0xe2,0xf3,
 	0x01,0xc1,0xd0,0x1f,0xcf,0x86,0x55,0x04,0x01,0x00,0x94,0x15,0x53,0x04,0x01,0x00,
 	0x52,0x04,0x01,0x00,0x91,0x09,0x10,0x04,0x01,0x00,0x01,0xff,0x00,0x01,0x00,0x01,
@@ -2698,7 +2701,7 @@ static const unsigned char utf8data[64256] = {
 	0x04,0x01,0x00,0x54,0x04,0x01,0x00,0x93,0x10,0x92,0x0c,0x91,0x08,0x10,0x04,0x01,
 	0x00,0x06,0x00,0x06,0x00,0x06,0x00,0x06,0x00,0xcf,0x86,0xd5,0x10,0x94,0x0c,0x53,
 	0x04,0x01,0x00,0x12,0x04,0x01,0x00,0x07,0x00,0x01,0x00,0x54,0x04,0x01,0x00,0x53,
-	0x04,0x01,0x00,0x52,0x04,0x01,0x00,0x51,0x04,0x01,0x00,0x10,0x04,0x01,0x00,0x00,
+	0x04,0x01,0x00,0x52,0x04,0x01,0x00,0x51,0x04,0x01,0x00,0x10,0x04,0x01,0x00,0x16,
 	0x00,0xd1,0x30,0xd0,0x06,0xcf,0x06,0x01,0x00,0xcf,0x86,0x55,0x04,0x01,0x00,0x54,
 	0x04,0x01,0x00,0xd3,0x10,0x52,0x04,0x01,0x00,0x51,0x04,0x01,0x00,0x10,0x04,0x01,
 	0x00,0x07,0x00,0x92,0x0c,0x51,0x04,0x07,0x00,0x10,0x04,0x07,0x00,0x01,0x00,0x01,
-- 
2.20.1

