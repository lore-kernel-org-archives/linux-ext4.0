From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH RFC 08/13] charsets: utf8: Introduce test module for kernel UTF-8 implementation
Date: Fri, 12 Jan 2018 05:12:29 -0200
Message-ID: <20180112071234.29470-9-krisman@collabora.co.uk>
References: <20180112071234.29470-1-krisman@collabora.co.uk>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel@lists.collabora.co.uk, alvaro.soliverez@collabora.co.uk,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: tytso@mit.edu, david@fromorbit.com, bpm@sgi.com, olaf@sgi.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20180112071234.29470-1-krisman@collabora.co.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 lib/Kconfig             |   5 ++
 lib/charsets/Makefile   |   1 +
 lib/charsets/test_ucd.c | 186 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 192 insertions(+)
 create mode 100644 lib/charsets/test_ucd.c

diff --git a/lib/Kconfig b/lib/Kconfig
index 9ca3bda7b2be..dd4552dae48b 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -593,6 +593,11 @@ config UTF8_NORMALIZATION
 	depends on CHARSETS
 	help
 	  Say Y here to enable utf8 normalization support.
+
+config UTF8_SELFTEST
+	tristate "Test UTF-8 normalization support"
+	default n
+	depends on UTF8_NORMALIZATION
 endmenu
 
 config GENERIC_ASHLDI3
diff --git a/lib/charsets/Makefile b/lib/charsets/Makefile
index 5e2fa7c20a47..73b16e54ab35 100644
--- a/lib/charsets/Makefile
+++ b/lib/charsets/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_CHARSETS) += ascii.o
 
 utf8-y += utf8_core.o utf8norm.o
 obj-$(CONFIG_UTF8_NORMALIZATION) +=  utf8.o
+obj-$(CONFIG_UTF8_SELFTEST) += test_ucd.o
 
 $(obj)/utf8norm.o: $(obj)/utf8data.h
 $(obj)/utf8data.h: $(srctree)/$(src)/ucd/*.txt $(objtree)/scripts/mkutf8data FORCE
diff --git a/lib/charsets/test_ucd.c b/lib/charsets/test_ucd.c
new file mode 100644
index 000000000000..51112ce488ac
--- /dev/null
+++ b/lib/charsets/test_ucd.c
@@ -0,0 +1,186 @@
+/*
+ * Kernel module for testing utf-8 support.
+ *
+ * Copyright 2017 Collabora Ltd. All Rights Reserved
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
+#include <linux/utf8norm.h>
+
+unsigned int failed_tests;
+unsigned int total_tests;
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
+#define test_f(cond, fmt, ...)  _test(cond, __func__, __LINE__, fmt, ##__VA_ARGS__)
+#define test(cond) _test(cond, __func__, __LINE__, "")
+
+const static struct {
+	/* UTF-8 strings in this vector _must_ be NULL-terminated. */
+	unsigned char str[10];
+	unsigned char dec[10];
+} nfkdi_test_data[] = {
+	/* Trivial sequence */
+	{
+		.str = {0x41, 0x42, 0x62, 0x61, 0x00},		/* "ABba" decomposes to itself */
+		.dec = {0x41, 0x42, 0x62, 0x61, 0x00}
+	},
+	/* Simple equivalent sequences */
+	{
+		.str = {0xc2, 0xbc, 0x00},			/* 'VULGAR FRACTION ONE QUARTER' decomposes to */
+		.dec = {0x31, 0xe2, 0x81, 0x84, 0x34, 0x00},	/* 'NUMBER 1' + 'FRACTION SLASH' + 'NUMBER 4' */
+	},
+	{
+		.str = {0xc3, 0xa4, 0x00},			/* 'LATIN SMALL LETTER A WITH DIAERESIS' decomposes to */
+		.dec = {0x61, 0xcc, 0x88, 0x00},		/* 'LETTER A' + 'COMBINING DIAERESIS' */
+	},
+	{
+		.str = {0xC7, 0x89, 0x00},			/* 'LATIN SMALL LETTER LJ' decomposes to */
+		.dec = {0x6c, 0x6a, 0x00},			/* 'LETTER L' + 'LETTER J' */
+	},
+	/* Canonical ordering */
+	{
+		.str = {0x41, 0xcc, 0x81, 0xcc, 0xa8, 0x0},	/* A + 'COMBINING ACUTE ACCENT' + 'COMBINING OGONEK' decomposes to */
+		.dec = {0x41, 0xcc, 0xa8, 0xcc, 0x81, 0x0},	/* A + 'COMBINING OGONEK' + 'COMBINING ACUTE ACCENT' */
+	}
+};
+
+const static struct {
+	/* UTF-8 strings in this vector _must_ be NULL-terminated. */
+	unsigned char str[30];
+	unsigned char ncf[30];
+} nfkdicf_test_data[] = {
+	/* Trivial sequences */
+	{
+		.str = {0x41, 0x42, 0x62, 0x61, 0x00},	/* "ABba" folds to lowercase */
+		.ncf = {0x61, 0x62, 0x62, 0x61, 0x00},
+	},
+	{
+		.str = "ABCDEFGHIJKLMNOPRSTUVWXYZ0.1",	/* All ASCII folds to lower-case */
+		.ncf = "abcdefghijklmnoprstuvwxyz0.1",
+	},
+	{
+		.str = {0xc3, 0x9f, 0x00}, 		/* LATIN SMALL LETTER SHARP S folds to */
+		.ncf = {0x73, 0x73, 0x00},		/* LATIN SMALL LETTER S + LATIN SMALL LETTER S */
+	},
+	{
+		.str = {0xC3, 0x85, 0x0},		/* LATIN CAPITAL LETTER A WITH RING ABOVE folds to */
+		.ncf = {0x61, 0xcc, 0x8a, 0x0},		/* LATIN SMALL LETTER A + COMBINING RING ABOVE */
+	}
+};
+
+static void check_utf8_nfkdi(void)
+{
+	int i;
+	struct utf8cursor u8c;
+	const struct utf8data *data = utf8nfkdi(UNICODE_AGE(7, 0, 0));
+
+	for (i = 0; i < ARRAY_SIZE(nfkdi_test_data); i++) {
+		int len = strlen(nfkdi_test_data[i].str);
+		int nlen = strlen(nfkdi_test_data[i].dec);
+		int j = 0;
+		unsigned char c;
+
+		test((utf8len(data, nfkdi_test_data[i].str) == nlen));
+		test((utf8nlen(data, nfkdi_test_data[i].str, len) == nlen));
+
+		if (utf8cursor(&u8c, data, nfkdi_test_data[i].str) < 0)
+			pr_err("can't create cursor\n");
+
+		while ((c = utf8byte(&u8c)) > 0) {
+			test_f((c == nfkdi_test_data[i].dec[j]),
+			       "%x %x\n", c, nfkdi_test_data[i].dec[j]);
+			j++;
+		}
+
+		test((j == nlen));
+	}
+}
+
+static void check_utf8_nfkdicf(void)
+{
+	int i;
+	struct utf8cursor u8c;
+	const struct utf8data *data = utf8nfkdicf(UNICODE_AGE(7, 0, 0));
+
+	for (i = 0; i < ARRAY_SIZE(nfkdicf_test_data); i++) {
+		int len = strlen(nfkdicf_test_data[i].str);
+		int nlen = strlen(nfkdicf_test_data[i].ncf);
+		int j = 0;
+		unsigned char c;
+
+		test((utf8len(data, nfkdicf_test_data[i].str) == nlen));
+		test((utf8nlen(data, nfkdicf_test_data[i].str, len) == nlen));
+
+		if (utf8cursor(&u8c, data, nfkdicf_test_data[i].str) < 0)
+			pr_err("can't create cursor\n");
+
+		while ((c = utf8byte(&u8c)) > 0) {
+			test_f((c == nfkdicf_test_data[i].ncf[j]),
+			       "0x%x 0x%x\n", c, nfkdicf_test_data[i].ncf[j]);
+			j++;
+		}
+
+		test((j == nlen));
+	}
+}
+
+static void check_supported_versions(void)
+{
+	/* Unicode 7.0.0 should be supported. */
+	test(utf8version_is_supported(UNICODE_AGE(7, 0, 0)));
+
+	/* Unicode 8.0.0 should not be supported. */
+	test(!utf8version_is_supported(UNICODE_AGE(8, 0, 0)));
+
+	/* Next values don't exist. */
+	test(!utf8version_is_supported(UNICODE_AGE(0, 0, 0)));
+	test(!utf8version_is_supported(UNICODE_AGE(-1, -1, -1)));
+}
+
+static int __init init_test_ucd(void)
+{
+	failed_tests = 0;
+	total_tests = 0;
+
+	check_supported_versions();
+	check_utf8_nfkdi();
+	check_utf8_nfkdicf();
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
2.15.1
