Return-Path: <SRS0=HZ/b=RV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11B9DC43381
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Mar 2019 20:28:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D718620989
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Mar 2019 20:28:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbfCRU2Y (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 18 Mar 2019 16:28:24 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33030 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727472AbfCRU2X (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Mar 2019 16:28:23 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id B286E28119D
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     tytso@mit.edu
Cc:     linux-ext4@vger.kernel.org, sfrench@samba.org,
        darrick.wong@oracle.com, jlayton@kernel.org, bfields@fieldses.org,
        paulus@samba.org, linux-fsdevel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH RFC v6 06/11] unicode: Introduce test module for normalized utf8 implementation
Date:   Mon, 18 Mar 2019 16:27:40 -0400
Message-Id: <20190318202745.5200-7-krisman@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190318202745.5200-1-krisman@collabora.com>
References: <20190318202745.5200-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>

This implements a in-kernel sanity test module for the utf8
normalization core.  At probe time, it will run basic sequences through
the utf8n core, to identify problems will equivalent sequences and
normalization/casefold code.  This is supposed to be useful for
regression testing when adding support for a new version of utf8 to
linux.

Changes since v4:
  - integrate with fs/unicode

Changes since RFC v1:
  - Include comparison tests for matching strings with different lengths.
  - Include tests for characters included in unicode 8.0.0, 9.0.0 and 10.0.0.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 fs/unicode/Kconfig         |   5 +
 fs/unicode/Makefile        |   1 +
 fs/unicode/utf8-selftest.c | 320 +++++++++++++++++++++++++++++++++++++
 3 files changed, 326 insertions(+)
 create mode 100644 fs/unicode/utf8-selftest.c

diff --git a/fs/unicode/Kconfig b/fs/unicode/Kconfig
index f41520f57dff..b560a879edf7 100644
--- a/fs/unicode/Kconfig
+++ b/fs/unicode/Kconfig
@@ -6,3 +6,8 @@ config UNICODE
 	help
 	  Say Y here to enable UTF-8 NFD normalization and NFD+CF casefolding
 	  support.
+
+config UNICODE_NORMALIZATION_SELFTEST
+	tristate "Test UTF-8 normalization support"
+	depends on UNICODE
+	default n
diff --git a/fs/unicode/Makefile b/fs/unicode/Makefile
index 9a9836fcf38b..b1560c4107bf 100644
--- a/fs/unicode/Makefile
+++ b/fs/unicode/Makefile
@@ -3,6 +3,7 @@
 UNICODE_VERSION=11.0.0
 
 obj-$(CONFIG_UNICODE) += unicode.o
+obj-$(CONFIG_UNICODE_NORMALIZATION_SELFTEST) += utf8-selftest.o
 
 unicode-y := utf8-norm.o utf8-core.o
 
diff --git a/fs/unicode/utf8-selftest.c b/fs/unicode/utf8-selftest.c
new file mode 100644
index 000000000000..492d934d5c1c
--- /dev/null
+++ b/fs/unicode/utf8-selftest.c
@@ -0,0 +1,320 @@
+/*
+ * Kernel module for testing utf-8 support.
+ *
+ * Copyright 2017 Collabora Ltd.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/printk.h>
+#include <linux/unicode.h>
+#include <linux/dcache.h>
+
+#include "utf8n.h"
+
+unsigned int failed_tests;
+unsigned int total_tests;
+
+/* Tests will be based on this version. */
+#define latest_maj 11
+#define latest_min 0
+#define latest_rev 0
+
+#define _test(cond, func, line, fmt, ...) do {				\
+		total_tests++;						\
+		if (!cond) {						\
+			failed_tests++;					\
+			pr_err("test %s:%d Failed: %s%s",		\
+			       func, line, #cond, (fmt?":":"."));	\
+			if (fmt)					\
+				pr_err(fmt, ##__VA_ARGS__);		\
+		}							\
+	} while (0)
+#define test_f(cond, fmt, ...) _test(cond, __func__, __LINE__, fmt, ##__VA_ARGS__)
+#define test(cond) _test(cond, __func__, __LINE__, "")
+
+const static struct {
+	/* UTF-8 strings in this vector _must_ be NULL-terminated. */
+	unsigned char str[10];
+	unsigned char dec[10];
+} nfdi_test_data[] = {
+	/* Trivial sequence */
+	{
+		/* "ABba" decomposes to itself */
+		.str = "aBba",
+		.dec = "aBba",
+	},
+	/* Simple equivalent sequences */
+	{
+               /* 'VULGAR FRACTION ONE QUARTER' cannot decompose to
+                  'NUMBER 1' + 'FRACTION SLASH' + 'NUMBER 4' on
+                  canonical decomposition */
+               .str = {0xc2, 0xbc, 0x00},
+	       .dec = {0xc2, 0xbc, 0x00},
+	},
+	{
+		/* 'LATIN SMALL LETTER A WITH DIAERESIS' decomposes to
+		   'LETTER A' + 'COMBINING DIAERESIS' */
+		.str = {0xc3, 0xa4, 0x00},
+		.dec = {0x61, 0xcc, 0x88, 0x00},
+	},
+	{
+		/* 'LATIN SMALL LETTER LJ' can't decompose to
+		   'LETTER L' + 'LETTER J' on canonical decomposition */
+		.str = {0xC7, 0x89, 0x00},
+		.dec = {0xC7, 0x89, 0x00},
+	},
+	{
+		/* GREEK ANO TELEIA decomposes to MIDDLE DOT */
+		.str = {0xCE, 0x87, 0x00},
+		.dec = {0xC2, 0xB7, 0x00}
+	},
+	/* Canonical ordering */
+	{
+		/* A + 'COMBINING ACUTE ACCENT' + 'COMBINING OGONEK' decomposes
+		   to A + 'COMBINING OGONEK' + 'COMBINING ACUTE ACCENT' */
+		.str = {0x41, 0xcc, 0x81, 0xcc, 0xa8, 0x0},
+		.dec = {0x41, 0xcc, 0xa8, 0xcc, 0x81, 0x0},
+	},
+	{
+		/* 'LATIN SMALL LETTER A WITH DIAERESIS' + 'COMBINING OGONEK'
+		   decomposes to
+		   'LETTER A' + 'COMBINING OGONEK' + 'COMBINING DIAERESIS' */
+		.str = {0xc3, 0xa4, 0xCC, 0xA8, 0x00},
+
+		.dec = {0x61, 0xCC, 0xA8, 0xcc, 0x88, 0x00},
+	},
+
+};
+
+const static struct {
+	/* UTF-8 strings in this vector _must_ be NULL-terminated. */
+	unsigned char str[30];
+	unsigned char ncf[30];
+} nfdicf_test_data[] = {
+	/* Trivial sequences */
+	{
+		/* "ABba" folds to lowercase */
+		.str = {0x41, 0x42, 0x62, 0x61, 0x00},
+		.ncf = {0x61, 0x62, 0x62, 0x61, 0x00},
+	},
+	{
+		/* All ASCII folds to lower-case */
+		.str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0.1",
+		.ncf = "abcdefghijklmnopqrstuvwxyz0.1",
+	},
+	{
+		/* LATIN SMALL LETTER SHARP S folds to
+		   LATIN SMALL LETTER S + LATIN SMALL LETTER S */
+		.str = {0xc3, 0x9f, 0x00},
+		.ncf = {0x73, 0x73, 0x00},
+	},
+	{
+		/* LATIN CAPITAL LETTER A WITH RING ABOVE folds to
+		   LATIN SMALL LETTER A + COMBINING RING ABOVE */
+		.str = {0xC3, 0x85, 0x00},
+		.ncf = {0x61, 0xcc, 0x8a, 0x00},
+	},
+	/* Introduced by UTF-8.0.0. */
+	/* Cherokee letters are interesting test-cases because they fold
+	   to upper-case.  Before 8.0.0, Cherokee lowercase were
+	   undefined, thus, the folding from LC is not stable between
+	   7.0.0 -> 8.0.0, but it is from UC. */
+	{
+		/* CHEROKEE SMALL LETTER A folds to CHEROKEE LETTER A */
+		.str = {0xea, 0xad, 0xb0, 0x00},
+		.ncf = {0xe1, 0x8e, 0xa0, 0x00},
+	},
+	{
+		/* CHEROKEE SMALL LETTER YE folds to CHEROKEE LETTER YE */
+		.str = {0xe1, 0x8f, 0xb8, 0x00},
+		.ncf = {0xe1, 0x8f, 0xb0, 0x00},
+	},
+	{
+		/* OLD HUNGARIAN CAPITAL LETTER AMB folds to
+		   OLD HUNGARIAN SMALL LETTER AMB */
+		.str = {0xf0, 0x90, 0xb2, 0x83, 0x00},
+		.ncf = {0xf0, 0x90, 0xb3, 0x83, 0x00},
+	},
+	/* Introduced by UTF-9.0.0. */
+	{
+		/* OSAGE CAPITAL LETTER CHA folds to
+		   OSAGE SMALL LETTER CHA */
+		.str = {0xf0, 0x90, 0x92, 0xb5, 0x00},
+		.ncf = {0xf0, 0x90, 0x93, 0x9d, 0x00},
+	},
+	{
+		/* LATIN CAPITAL LETTER SMALL CAPITAL I folds to
+		   LATIN LETTER SMALL CAPITAL I */
+		.str = {0xea, 0x9e, 0xae, 0x00},
+		.ncf = {0xc9, 0xaa, 0x00},
+	},
+	/* Introduced by UTF-11.0.0. */
+	{
+		/* GEORGIAN SMALL LETTER AN folds to GEORGIAN MTAVRULI
+		   CAPITAL LETTER AN */
+		.str = {0xe1, 0xb2, 0x90, 0x00},
+		.ncf = {0xe1, 0x83, 0x90, 0x00},
+	}
+};
+
+static void check_utf8_nfdi(void)
+{
+	int i;
+	struct utf8cursor u8c;
+	const struct utf8data *data;
+
+	data = utf8nfdi(UNICODE_AGE(latest_maj, latest_min, latest_rev));
+	if (!data) {
+		pr_err("%s: Unable to load utf8-%d.%d.%d. Skipping.\n",
+		       __func__, latest_maj, latest_min, latest_rev);
+		return;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(nfdi_test_data); i++) {
+		int len = strlen(nfdi_test_data[i].str);
+		int nlen = strlen(nfdi_test_data[i].dec);
+		int j = 0;
+		unsigned char c;
+
+		test((utf8len(data, nfdi_test_data[i].str) == nlen));
+		test((utf8nlen(data, nfdi_test_data[i].str, len) == nlen));
+
+		if (utf8cursor(&u8c, data, nfdi_test_data[i].str) < 0)
+			pr_err("can't create cursor\n");
+
+		while ((c = utf8byte(&u8c)) > 0) {
+			test_f((c == nfdi_test_data[i].dec[j]),
+			       "Unexpected byte 0x%x should be 0x%x\n",
+			       c, nfdi_test_data[i].dec[j]);
+			j++;
+		}
+
+		test((j == nlen));
+	}
+}
+
+static void check_utf8_nfdicf(void)
+{
+	int i;
+	struct utf8cursor u8c;
+	const struct utf8data *data;
+
+	data = utf8nfdicf(UNICODE_AGE(latest_maj, latest_min, latest_rev));
+	if (!data) {
+		pr_err("%s: Unable to load utf8-%d.%d.%d. Skipping.\n",
+		       __func__, latest_maj, latest_min, latest_rev);
+		return;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(nfdicf_test_data); i++) {
+		int len = strlen(nfdicf_test_data[i].str);
+		int nlen = strlen(nfdicf_test_data[i].ncf);
+		int j = 0;
+		unsigned char c;
+
+		test((utf8len(data, nfdicf_test_data[i].str) == nlen));
+		test((utf8nlen(data, nfdicf_test_data[i].str, len) == nlen));
+
+		if (utf8cursor(&u8c, data, nfdicf_test_data[i].str) < 0)
+			pr_err("can't create cursor\n");
+
+		while ((c = utf8byte(&u8c)) > 0) {
+			test_f((c == nfdicf_test_data[i].ncf[j]),
+			       "Unexpected byte 0x%x should be 0x%x\n",
+			       c, nfdicf_test_data[i].ncf[j]);
+			j++;
+		}
+
+		test((j == nlen));
+	}
+}
+
+static void check_utf8_comparisons(void)
+{
+	int i;
+	struct unicode_map *table = utf8_load("11.0.0");
+
+	if (IS_ERR(table)) {
+		pr_err("%s: Unable to load utf8 %d.%d.%d. Skipping.\n",
+		       __func__, latest_maj, latest_min, latest_rev);
+		return;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(nfdi_test_data); i++) {
+		const struct qstr s1 = {.name = nfdi_test_data[i].str,
+					.len = sizeof(nfdi_test_data[i].str)};
+		const struct qstr s2 = {.name = nfdi_test_data[i].dec,
+					.len = sizeof(nfdi_test_data[i].dec)};
+
+		test_f(!utf8_strncmp(table, &s1, &s2),
+		       "%s %s comparison mismatch\n", s1.name, s2.name);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(nfdicf_test_data); i++) {
+		const struct qstr s1 = {.name = nfdicf_test_data[i].str,
+					.len = sizeof(nfdicf_test_data[i].str)};
+		const struct qstr s2 = {.name = nfdicf_test_data[i].ncf,
+					.len = sizeof(nfdicf_test_data[i].ncf)};
+
+		test_f(!utf8_strncasecmp(table, &s1, &s2),
+		       "%s %s comparison mismatch\n", s1.name, s2.name);
+	}
+
+	utf8_unload(table);
+}
+
+static void check_supported_versions(void)
+{
+	/* Unicode 7.0.0 should be supported. */
+	test(utf8version_is_supported(7, 0, 0));
+
+	/* Unicode 9.0.0 should be supported. */
+	test(utf8version_is_supported(9, 0, 0));
+
+	/* Unicode 1x.0.0 (the latest version) should be supported. */
+	test(utf8version_is_supported(latest_maj, latest_min, latest_rev));
+
+	/* Next versions don't exist. */
+	test(!utf8version_is_supported(12, 0, 0));
+	test(!utf8version_is_supported(0, 0, 0));
+	test(!utf8version_is_supported(-1, -1, -1));
+}
+
+static int __init init_test_ucd(void)
+{
+	failed_tests = 0;
+	total_tests = 0;
+
+	check_supported_versions();
+	check_utf8_nfdi();
+	check_utf8_nfdicf();
+	check_utf8_comparisons();
+
+	if (!failed_tests)
+		pr_info("All %u tests passed\n", total_tests);
+	else
+		pr_err("%u out of %u tests failed\n", failed_tests,
+		       total_tests);
+	return 0;
+}
+
+static void __exit exit_test_ucd(void)
+{
+}
+
+module_init(init_test_ucd);
+module_exit(exit_test_ucd);
+
+MODULE_AUTHOR("Gabriel Krisman Bertazi <krisman@collabora.co.uk>");
+MODULE_LICENSE("GPL");
-- 
2.20.1

