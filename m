From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH RFC 02/13] charsets: ascii: Wrap ascii functions to charsets library
Date: Fri, 12 Jan 2018 05:12:23 -0200
Message-ID: <20180112071234.29470-3-krisman@collabora.co.uk>
References: <20180112071234.29470-1-krisman@collabora.co.uk>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel@lists.collabora.co.uk, alvaro.soliverez@collabora.co.uk,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: tytso@mit.edu, david@fromorbit.com, bpm@sgi.com, olaf@sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:43018 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754273AbeALHNV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Jan 2018 02:13:21 -0500
In-Reply-To: <20180112071234.29470-1-krisman@collabora.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This allows filesystems to always use the charsets interfaces, even when
not caring about encoding.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 lib/charsets/Makefile |  2 ++
 lib/charsets/ascii.c  | 98 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 100 insertions(+)
 create mode 100644 lib/charsets/ascii.c

diff --git a/lib/charsets/Makefile b/lib/charsets/Makefile
index 01ff9fd09f98..2184e7ff25de 100644
--- a/lib/charsets/Makefile
+++ b/lib/charsets/Makefile
@@ -1,3 +1,5 @@
 charsets-y += core.o
 
 obj-$(CONFIG_CHARSETS) += charsets.o
+
+obj-$(CONFIG_CHARSETS) += ascii.o
diff --git a/lib/charsets/ascii.c b/lib/charsets/ascii.c
new file mode 100644
index 000000000000..d45b7f01ebd4
--- /dev/null
+++ b/lib/charsets/ascii.c
@@ -0,0 +1,98 @@
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
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/charsets.h>
+#include <linux/string.h>
+#include <linux/ctype.h>
+#include <linux/parser.h>
+
+static struct charset_info ascii_info;
+
+int ascii_strncmp(const struct charset *charset, const char *str1,
+		  const char *str2, int len)
+{
+	return strncmp(str1, str2, len);
+}
+
+int ascii_strncasecmp(const struct charset *charset, const char *str1,
+		      const char *str2, int len)
+{
+	return strncasecmp(str1, str2, len);
+}
+
+int ascii_normalize(const struct charset *charset, const char *str,
+		    int len, char **normalization)
+{
+	*normalization = kstrdup(str, GFP_NOFS);
+	return (*normalization) ? len : -ENOMEM;
+}
+
+int ascii_casefold(const struct charset *charset, const char *str,
+		   int len, char **folded_str)
+{
+	int i;
+	char *fold;
+
+	fold = kstrdup(str, GFP_NOFS);
+	if (!fold)
+		return -ENOMEM;
+
+	for (i = 0; i < len; i++)
+		fold[i] = tolower(fold[i]);
+
+	*folded_str = fold;
+	return len;
+}
+
+static const struct charset_ops ascii_ops = {
+	.strncmp = ascii_strncmp,
+	.strncasecmp = ascii_strncasecmp,
+	.casefold = ascii_casefold,
+	.normalize = ascii_normalize,
+};
+
+static struct charset ascii_charset = {
+	.version = 0,
+	.info = &ascii_info,
+	.ops = &ascii_ops
+};
+
+static struct charset *ascii_load_charset(void *pargs)
+{
+	return &ascii_charset;
+}
+
+static struct charset_info ascii_info = {
+	.name = "ascii",
+	.match_token = "ascii",
+	.load_charset = ascii_load_charset,
+};
+
+static int __init init_ascii(void)
+{
+	charset_register(&ascii_info);
+	return 0;
+}
+
+static void __exit exit_ascii(void)
+{
+}
+
+module_init(init_ascii);
+module_exit(exit_ascii);
+MODULE_AUTHOR("Gabriel Krisman Bertazi");
+MODULE_DESCRIPTION("ASCII charset for filesystems");
+MODULE_LICENSE("GPL");
+
-- 
2.15.1
