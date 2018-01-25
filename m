From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH RFC v2 02/13] charsets: ascii: Wrap ascii functions to charsets library
Date: Thu, 25 Jan 2018 00:53:38 -0200
Message-ID: <20180125025349.31494-3-krisman@collabora.co.uk>
References: <20180125025349.31494-1-krisman@collabora.co.uk>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        alvaro.soliverez@collabora.co.uk, kernel@lists.collabora.co.uk,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: tytso@mit.edu, david@fromorbit.com, olaf@sgi.com,
        viro@zeniv.linux.org.uk
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20180125025349.31494-1-krisman@collabora.co.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This allows filesystems to always use the charsets interfaces, even when
not caring about encoding.

Changes since RFC v1:
  - Include length parameter for second string on comparison functions.
  - Cast length type to size_t.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 lib/charsets/Makefile |   2 +
 lib/charsets/ascii.c  | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 104 insertions(+)
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
index 000000000000..42f3ec00e41c
--- /dev/null
+++ b/lib/charsets/ascii.c
@@ -0,0 +1,102 @@
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
+		  size_t len1, const char *str2, size_t len2)
+{
+	size_t len = (len1 < len2)? len1:len2;
+
+	return strncmp(str1, str2, len);
+}
+
+int ascii_strncasecmp(const struct charset *charset, const char *str1,
+		      size_t len1, const char *str2, size_t len2)
+{
+	size_t len = (len1 < len2)? len1:len2;
+
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
