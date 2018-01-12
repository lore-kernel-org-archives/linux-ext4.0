From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH RFC 07/13] charsets: utf8: Hook-up utf-8 code to charsets library
Date: Fri, 12 Jan 2018 05:12:28 -0200
Message-ID: <20180112071234.29470-8-krisman@collabora.co.uk>
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
 lib/charsets/Makefile    |   2 +-
 lib/charsets/utf8_core.c | 178 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 179 insertions(+), 1 deletion(-)
 create mode 100644 lib/charsets/utf8_core.c

diff --git a/lib/charsets/Makefile b/lib/charsets/Makefile
index 95389c4193b0..5e2fa7c20a47 100644
--- a/lib/charsets/Makefile
+++ b/lib/charsets/Makefile
@@ -4,7 +4,7 @@ obj-$(CONFIG_CHARSETS) += charsets.o
 
 obj-$(CONFIG_CHARSETS) += ascii.o
 
-utf8-y += utf8norm.o
+utf8-y += utf8_core.o utf8norm.o
 obj-$(CONFIG_UTF8_NORMALIZATION) +=  utf8.o
 
 $(obj)/utf8norm.o: $(obj)/utf8data.h
diff --git a/lib/charsets/utf8_core.c b/lib/charsets/utf8_core.c
new file mode 100644
index 000000000000..94427670e96e
--- /dev/null
+++ b/lib/charsets/utf8_core.c
@@ -0,0 +1,178 @@
+/*
+ * Copyright (c) 2017 Collabora Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/charsets.h>
+#include <linux/utf8norm.h>
+#include <linux/slab.h>
+#include <linux/parser.h>
+#include <linux/string.h>
+
+static int utf8_strncmp(const struct charset *charset, const char *str1,
+			const char *str2, int len)
+{
+	const struct utf8data *data = utf8nfkdi(charset->version);
+	struct utf8cursor cur1, cur2;
+	unsigned char c1, c2;
+	int r, i;
+
+	r = utf8cursor(&cur1, data, str1);
+	if (r < 0)
+		return -EIO;
+	r = utf8cursor(&cur2, data, str2);
+	if (r < 0)
+		return -EIO;
+
+	for (i = 0 ; i < len ; i++) {
+		c1 = utf8byte(&cur1);
+		c2 = utf8byte(&cur2);
+
+		if (!c1 || !c2 || c1 != c2)
+			return 1;
+
+	}
+
+	return 0;
+}
+
+static int utf8_strncasecmp(const struct charset *charset, const char *str1,
+			    const char *str2, int len)
+{
+	const struct utf8data *data = utf8nfkdicf(charset->version);
+	struct utf8cursor cur1, cur2;
+	unsigned char c1, c2;
+	int r, i;
+
+	r = utf8cursor(&cur1, data, str1);
+	if (r < 0)
+		return -EIO;
+
+	r = utf8cursor(&cur2, data, str2);
+	if (r < 0)
+		return -EIO;
+
+	for (i = 0 ; i < len ; i++) {
+		c1 = utf8byte(&cur1);
+		c2 = utf8byte(&cur2);
+
+		if (!c1 || !c2 || c1 != c2)
+			return 1;
+	}
+
+	return 0;
+}
+
+int utf8_casefold(const struct charset *charset, const char *str, int len,
+		  char **folded_str)
+{
+	const struct utf8data *data = utf8nfkdicf(charset->version);
+	struct utf8cursor cur;
+	int i;
+	char buffer[1024];
+
+	if (utf8cursor(&cur, data, str))
+		return -EIO;
+
+	for (i = 0; i < (1024-1); i++) {
+		buffer[i] = utf8byte(&cur);
+		if (!buffer[i])
+			break;
+	}
+	buffer[i] = '\0';
+	*folded_str = kstrdup(buffer, GFP_NOFS);
+	if (!*folded_str)
+		return -ENOMEM;
+
+	return i;
+}
+
+int utf8_normalize(const struct charset *charset, const char *str, int len,
+		   char **normalization)
+{
+	const struct utf8data *data = utf8nfkdi(charset->version);
+	struct utf8cursor cur;
+	int i;
+	char buffer[1024];
+
+	if (utf8cursor(&cur, data, str))
+		return -EIO;
+
+	for (i = 0; i < (1024-1); i++) {
+		buffer[i] = utf8byte(&cur);
+		if (!buffer[i])
+			break;
+	}
+	buffer[i] = '\0';
+	*normalization = kstrdup(buffer, GFP_NOFS);
+	if (!*normalization)
+		return -ENOMEM;
+
+	return i;
+}
+
+static const struct charset_ops utf8_ops = {
+	.strncmp = utf8_strncmp,
+	.strncasecmp = utf8_strncasecmp,
+	.casefold = utf8_casefold,
+	.normalize = utf8_normalize,
+};
+
+static struct charset *utf8_load_charset(void *pargs)
+{
+	int maj, min, rev;
+	unsigned int age;
+	struct charset *charset;
+	substring_t *args = pargs;
+
+	if (match_int(&args[0], &maj) || match_int(&args[1], &min) ||
+	    match_int(&args[2], &rev))
+		return NULL;
+
+	age = UNICODE_AGE(maj, min, rev);
+
+	if (!utf8version_is_supported(age))
+		return NULL;
+
+	charset = kmalloc(sizeof(struct charset), GFP_KERNEL);
+	if (!charset)
+		return NULL;
+
+	charset->info = NULL;
+	charset->version = age;
+	charset->ops = &utf8_ops;
+
+	return charset;
+}
+
+static struct charset_info utf8_info = {
+	.name = "utf8",
+	.match_token = "utf8-%d.%d.%d",
+	.load_charset = utf8_load_charset,
+};
+
+static int __init init_utf8(void)
+{
+	charset_register(&utf8_info);
+	return 0;
+}
+
+static void __exit exit_utf8(void)
+{
+}
+
+module_init(init_utf8);
+module_exit(exit_utf8);
+MODULE_AUTHOR("Gabriel Krisman Bertazi");
+MODULE_DESCRIPTION("UTF-8 charset operations for filesystems");
+MODULE_LICENSE("GPL");
+
-- 
2.15.1
