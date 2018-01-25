From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH RFC v2 07/13] charsets: utf8: Hook-up utf-8 code to charsets library
Date: Thu, 25 Jan 2018 00:53:43 -0200
Message-ID: <20180125025349.31494-8-krisman@collabora.co.uk>
References: <20180125025349.31494-1-krisman@collabora.co.uk>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        alvaro.soliverez@collabora.co.uk, kernel@lists.collabora.co.uk,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: tytso@mit.edu, david@fromorbit.com, olaf@sgi.com,
        viro@zeniv.linux.org.uk
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:52070 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933290AbeAYCzK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Jan 2018 21:55:10 -0500
In-Reply-To: <20180125025349.31494-1-krisman@collabora.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Changes since RFC v1:
  - Change error return code from EIO to EINVAL. (Olaf Weber)
  - Fix issues with strncmp/strcmp.  (Olaf Weber)
  - Remove stack buffer in normalization/casefold. (Olaf Weber)
  - Include length parameter for second string on comparison functions.
  - Change length type to size_t.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 lib/charsets/Makefile    |   2 +-
 lib/charsets/utf8_core.c | 180 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 181 insertions(+), 1 deletion(-)
 create mode 100644 lib/charsets/utf8_core.c

diff --git a/lib/charsets/Makefile b/lib/charsets/Makefile
index d33ac8643ef9..004d0e5d6ac4 100644
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
index 000000000000..f1c4fcc249fb
--- /dev/null
+++ b/lib/charsets/utf8_core.c
@@ -0,0 +1,180 @@
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
+			size_t len1, const char *str2, size_t len2)
+{
+	const struct utf8data *data = utf8nfkdi(charset->version);
+	struct utf8cursor cur1, cur2;
+	int c1, c2;
+	int r;
+
+	r = utf8ncursor(&cur1, data, str1, len1);
+	if (r < 0)
+		return -EINVAL;
+	r = utf8ncursor(&cur2, data, str2, len2);
+	if (r < 0)
+		return -EINVAL;
+
+	do {
+		c1 = utf8byte(&cur1);
+		c2 = utf8byte(&cur2);
+
+		if (c1 < 0 || c2 < 0)
+			return -EINVAL;
+		if (c1 != c2)
+			return 1;
+	} while (c1);
+
+	return 0;
+}
+
+static int utf8_strncasecmp(const struct charset *charset, const char *str1,
+			    size_t len1, const char *str2, size_t len2)
+{
+	const struct utf8data *data = utf8nfkdicf(charset->version);
+	struct utf8cursor cur1, cur2;
+	unsigned char c1, c2;
+	int r;
+
+	r = utf8ncursor(&cur1, data, str1, len1);
+	if (r < 0)
+		return -EINVAL;
+
+	r = utf8ncursor(&cur2, data, str2, len2);
+	if (r < 0)
+		return -EINVAL;
+
+	do {
+		c1 = utf8byte(&cur1);
+		c2 = utf8byte(&cur2);
+
+		if (c1 < 0 || c2 < 0)
+			return -EINVAL;
+		if (c1 != c2)
+			return 1;
+	} while (c1);
+
+	return 0;
+}
+
+int utf8_casefold(const struct charset *charset, const char *str, int len,
+		  char **folded)
+{
+	const struct utf8data *data = utf8nfkdicf(charset->version);
+	struct utf8cursor cur;
+	char *s;
+	ssize_t nlen;
+
+	nlen = utf8nlen(data, str, len);
+	if (nlen < 0)
+		return -EINVAL;
+
+	s = kmalloc(nlen + 1, GFP_NOFS);
+	if (!s)
+		return -ENOMEM;
+	*folded = s;
+
+	utf8ncursor(&cur, data, str, len);
+	do {
+		*s = utf8byte(&cur);
+	} while (*s++);
+
+	return nlen;
+}
+
+int utf8_normalize(const struct charset *charset, const char *str, int len,
+		   char **normalization)
+{
+	const struct utf8data *data = utf8nfkdi(charset->version);
+	struct utf8cursor cur;
+	char *s;
+	ssize_t nlen;
+
+	nlen = utf8nlen(data, str, len);
+	if (nlen < 0)
+		return -EINVAL;
+
+	s = kmalloc(nlen + 1, GFP_NOFS);
+	if (!s)
+		return -ENOMEM;
+	*normalization = s;
+
+	utf8ncursor(&cur, data, str, len);
+	do {
+		*s = utf8byte(&cur);
+	} while (*s++);
+
+	return nlen;
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
+	struct charset *charset;
+	substring_t *args = pargs;
+
+	if (match_int(&args[0], &maj) || match_int(&args[1], &min) ||
+	    match_int(&args[2], &rev))
+		return NULL;
+
+	if (!utf8version_is_supported(maj, min, rev))
+		return NULL;
+
+	charset = kmalloc(sizeof(struct charset), GFP_KERNEL);
+	if (!charset)
+		return NULL;
+
+	charset->info = NULL;
+	charset->version = UNICODE_AGE(maj, min, rev);
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
