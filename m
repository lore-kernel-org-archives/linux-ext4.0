Return-Path: <SRS0=X8xt=SS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 866C1C10F13
	for <linux-ext4@archiver.kernel.org>; Tue, 16 Apr 2019 19:44:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5433320663
	for <linux-ext4@archiver.kernel.org>; Tue, 16 Apr 2019 19:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbfDPToj (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 16 Apr 2019 15:44:39 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:51830 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727997AbfDPToj (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Apr 2019 15:44:39 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 75BE0281F5C
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     tytso@mit.edu
Cc:     linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH 1/2] unicode: Update unicode database unicode version 12.1.0
Date:   Tue, 16 Apr 2019 15:44:32 -0400
Message-Id: <20190416194433.8664-1-krisman@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190413192533.2549-1-krisman@collabora.com>
References: <20190413192533.2549-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Unicode 12.1.0 adds the character U+32FF (SQUARE ERA NAME REIWA),
only. It's decomposition in NFD is identity, so there isn't much change
here.  In fact, the only behavior alteration would be strict mode
allowing a file with this character.

Feel free to squash these two into the respective patches of the previous seriessubmitted it separately to make review easier.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 fs/unicode/README.utf8data | 49 +++++++++++++++++++-------------------
 fs/unicode/utf8-selftest.c |  4 ++--
 fs/unicode/utf8data.h      | 17 +++++++------
 3 files changed, 37 insertions(+), 33 deletions(-)

diff --git a/fs/unicode/README.utf8data b/fs/unicode/README.utf8data
index cbcdb56832ed..eeb7561526d9 100644
--- a/fs/unicode/README.utf8data
+++ b/fs/unicode/README.utf8data
@@ -1,39 +1,40 @@
 The utf8data.h file in this directory is generated from the Unicode
-Character Database for version 12.0.0 of the Unicode standard.
+Character Database for version 12.1.0 of the Unicode standard.
 
 The full set of files can be found here:
 
-  http://www.unicode.org/Public/12.0.0/ucd/
+  http://www.unicode.org/Public/12.1.0/ucd/
 
 Individual source links:
 
-  http://www.unicode.org/Public/12.0.0/ucd/CaseFolding.txt
-  http://www.unicode.org/Public/12.0.0/ucd/DerivedAge.txt
-  http://www.unicode.org/Public/12.0.0/ucd/extracted/DerivedCombiningClass.txt
-  http://www.unicode.org/Public/12.0.0/ucd/DerivedCoreProperties.txt
-  http://www.unicode.org/Public/12.0.0/ucd/NormalizationCorrections.txt
-  http://www.unicode.org/Public/12.0.0/ucd/NormalizationTest.txt
-  http://www.unicode.org/Public/12.0.0/ucd/UnicodeData.txt
+  https://www.unicode.org/Public/12.1.0/ucd/CaseFolding-12.1.0d2.txt
+  https://www.unicode.org/Public/12.1.0/ucd/DerivedAge-12.1.0d3.txt
+  https://www.unicode.org/Public/12.1.0/ucd/extracted/DerivedCombiningClass-12.1.0d2.txt
+  https://www.unicode.org/Public/12.1.0/ucd/DerivedCoreProperties-12.1.0d2.txt
+  https://www.unicode.org/Public/12.1.0/ucd/NormalizationCorrections-12.1.0d1.txt
+  https://www.unicode.org/Public/12.1.0/ucd/NormalizationTest-12.1.0d3.txt
+  https://www.unicode.org/Public/12.1.0/ucd/UnicodeData-12.1.0d2.txt
 
 md5sums (verify by running "md5sum -c README.utf8data"):
 
-  a794be08c28f90853003c9bdf8826509  CaseFolding.txt
-  6b4750a2ff1a19ce7f28b6a6528457e8  DerivedAge.txt
-  fae28c468eb7017785ecf21fdc6c5835  DerivedCombiningClass.txt
-  efb8b829abd2a0aaa617e3d66211440d  DerivedCoreProperties.txt
-  4c662a8f228506aea5e8a6e2e06e15d8  NormalizationCorrections.txt
-  35866dad08e10d658c344808b48ac01d  NormalizationTest.txt
-  6221effa1dd15524745a467f7366233d  UnicodeData.txt
+  900e76da1d822a160fd6b8c0b1d70094  CaseFolding-12.1.0d2.txt
+  131256380bff4fea8ad4a851616f2f10  DerivedAge-12.1.0d3.txt
+  e731a4089b30002144e107e3d6f8d1fa  DerivedCombiningClass-12.1.0d2.txt
+  a47c9fbd7ff92a9b261ba9831e68778a  DerivedCoreProperties-12.1.0d2.txt
+  fcab6dad15e440879d92f315978f93d3  NormalizationCorrections-12.1.0d1.txt
+  f9ff1c55a60decf436100f791b44aa98  NormalizationTest-12.1.0d3.txt
+  755f6af699f8c8d2d958da411f78f6c6  UnicodeData-12.1.0d2.txt
 
 sha1sums (verify by running "sha1sum -c README.utf8data"):
 
-  404fc6a0a80a64ecece059fa9a1e342152d58db3  CaseFolding.txt
-  cb18ee0677d6054b7e1b87946f6d566a8c0feebe  DerivedAge.txt
-  79226de6bf7d8fde525120634a9177d9b2a55e13  DerivedCombiningClass.txt
-  8cc194267f90d5c4ba4118236f9d6df28b4db425  DerivedCoreProperties.txt
-  48104614d353e9962fe5b074e4348cd0f95104df  NormalizationCorrections.txt
-  7e7806e4579f0a481b3677969675f63aec08feba  NormalizationTest.txt
-  0a309cf58fe2a5d0d904c9bf2c1a89b2666c413a  UnicodeData.txt
+  dc9245f6803c4ac99555c361f5052e0b13eb779b  CaseFolding-12.1.0d2.txt
+  3281104f237184cdb5d869e86eb8573678ada7da  DerivedAge-12.1.0d3.txt
+  2f5f995ccb96e0fa84b15151b35d5e2681535175  DerivedCombiningClass-12.1.0d2.txt
+  5b8698a3fcd5018e1987f296b02e2c17e696415e  DerivedCoreProperties-12.1.0d2.txt
+  cd83935fbc012345d8792d2c704f69497e753835  NormalizationCorrections-12.1.0d1.txt
+  ea419aae505b337b0d99a83fa83fe58ddff7c19f  NormalizationTest-12.1.0d3.txt
+  dc973c0fc93d6f09d9ab9f70d1c9f89c447f0526  UnicodeData-12.1.0d2.txt
+
 
 To update to the newer version of the Unicode standard, the latest
 released version of the UCD can be found here:
@@ -46,7 +47,7 @@ cd to this directory (fs/unicode) and run this command:
 	make C=../.. objdir=../.. utf8data.h.new
 
 After sanity checking the newly generated utf8data.h.new file (the
-version generated from the 12.0.0 UCD should be 4,106 lines long, and
+version generated from the 12.1.0 UCD should be 4,109 lines long, and
 have a total size of 324k) and/or comparing it with the older version
 of utf8data.h, rename it to utf8data.h.
 
diff --git a/fs/unicode/utf8-selftest.c b/fs/unicode/utf8-selftest.c
index 6964553c0132..80752013fce0 100644
--- a/fs/unicode/utf8-selftest.c
+++ b/fs/unicode/utf8-selftest.c
@@ -27,7 +27,7 @@ unsigned int total_tests;
 
 /* Tests will be based on this version. */
 #define latest_maj 12
-#define latest_min 0
+#define latest_min 1
 #define latest_rev 0
 
 #define _test(cond, func, line, fmt, ...) do {				\
@@ -243,7 +243,7 @@ static void check_utf8_nfdicf(void)
 static void check_utf8_comparisons(void)
 {
 	int i;
-	struct unicode_map *table = utf8_load("11.0.0");
+	struct unicode_map *table = utf8_load("12.1.0");
 
 	if (IS_ERR(table)) {
 		pr_err("%s: Unable to load utf8 %d.%d.%d. Skipping.\n",
diff --git a/fs/unicode/utf8data.h b/fs/unicode/utf8data.h
index 4d65c04e0786..76e4f0e1b089 100644
--- a/fs/unicode/utf8data.h
+++ b/fs/unicode/utf8data.h
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

