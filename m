From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH RFC v2 01/13] charsets: Introduce middle-layer for character encoding
Date: Thu, 25 Jan 2018 00:53:37 -0200
Message-ID: <20180125025349.31494-2-krisman@collabora.co.uk>
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

This implements an abstraction for high-level encoding-wise string
manipulation functions.  It defines some hooks that encoding modules must
implement, which will be used by filesystem code to support lookups that
consider normalization and case-folding.

Changes since RFC v1:
  - Export charset_load symbol.
  - Include length parameter for second string on comparison functions.
  - Changed length type to size_t.
  - Fix bad memory access when trying to load invalid charset

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 include/linux/charsets.h | 75 ++++++++++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig              |  2 ++
 lib/Makefile             |  2 ++
 lib/charsets/Makefile    |  3 ++
 lib/charsets/core.c      | 69 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 151 insertions(+)
 create mode 100644 include/linux/charsets.h
 create mode 100644 lib/charsets/Makefile
 create mode 100644 lib/charsets/core.c

diff --git a/include/linux/charsets.h b/include/linux/charsets.h
new file mode 100644
index 000000000000..3abe92cc0bc6
--- /dev/null
+++ b/include/linux/charsets.h
@@ -0,0 +1,75 @@
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
+#ifndef _CHARSET_H
+#define _CHARSET_H
+
+#include <linux/types.h>
+
+struct charset_info;
+struct charset;
+
+struct charset_ops {
+	int (*strncmp)(const struct charset *charset, const char *str1,
+		       size_t len1, const char *str2, size_t len2);
+	int (*strncasecmp)(const struct charset *charset, const char *str1,
+			   size_t len1, const char *str2, size_t len2);
+	int (*casefold)(const struct charset *charset, const char *str,
+			int len, char **folded);
+	int (*normalize)(const struct charset *charset, const char *str,
+			 int len, char **normalization);
+};
+
+struct charset {
+	const struct charset_info *info;
+	unsigned int version;
+	const struct charset_ops *ops;
+};
+
+struct charset_info {
+	char *name;
+	char *match_token;
+	struct charset* (*load_charset)(void *args);
+};
+
+static inline int charset_strncmp(const struct charset *charset,
+				  const char *str1, size_t len1,
+				  const char *str2, size_t len2)
+{
+	return charset->ops->strncmp(charset, str1, len1, str2, len2);
+}
+
+static inline int charset_strncasecmp(const struct charset *charset,
+				      const char *str1, size_t len1,
+				      const char *str2, size_t len2)
+{
+	return charset->ops->strncasecmp(charset, str1, len1, str2, len2);
+}
+
+static inline int charset_casefold(const struct charset *charset,
+				   const char *str, int len, char **folded)
+{
+	return charset->ops->casefold(charset, str, len, folded);
+}
+
+static inline int charset_normalize(const struct charset *charset,
+				    const char *str, int len,
+				    char **normalization)
+{
+	return charset->ops->normalize(charset, str, len, normalization);
+}
+
+int charset_register(struct charset_info *charset);
+const struct charset *charset_load(char *charset);
+#endif
diff --git a/lib/Kconfig b/lib/Kconfig
index c5e84fbcb30b..bf5c751cfb8a 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -582,6 +582,8 @@ config PRIME_NUMBERS
 config STRING_SELFTEST
 	tristate "Test string functions"
 
+config CHARSETS
+       tristate "Character encoding sets"
 endmenu
 
 config GENERIC_ASHLDI3
diff --git a/lib/Makefile b/lib/Makefile
index d11c48ec8ffd..f6b2360fedfa 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -258,3 +258,5 @@ obj-$(CONFIG_GENERIC_LSHRDI3) += lshrdi3.o
 obj-$(CONFIG_GENERIC_MULDI3) += muldi3.o
 obj-$(CONFIG_GENERIC_CMPDI2) += cmpdi2.o
 obj-$(CONFIG_GENERIC_UCMPDI2) += ucmpdi2.o
+
+obj-$(CONFIG_CHARSETS) += charsets/
diff --git a/lib/charsets/Makefile b/lib/charsets/Makefile
new file mode 100644
index 000000000000..01ff9fd09f98
--- /dev/null
+++ b/lib/charsets/Makefile
@@ -0,0 +1,3 @@
+charsets-y += core.o
+
+obj-$(CONFIG_CHARSETS) += charsets.o
diff --git a/lib/charsets/core.c b/lib/charsets/core.c
new file mode 100644
index 000000000000..238088cbb641
--- /dev/null
+++ b/lib/charsets/core.c
@@ -0,0 +1,69 @@
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
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/charsets.h>
+#include <linux/parser.h>
+
+#define MAX_ENCODINGS 10
+
+static struct match_token encoding_tokens[MAX_ENCODINGS + 1];
+static struct charset_info *charsets[MAX_ENCODINGS];
+static int n_encodings;
+
+const struct charset *charset_load(char *charset)
+{
+	substring_t args[MAX_OPT_ARGS];
+	int token;
+
+	args[0].to = args[0].from = NULL;
+	token = match_token(charset, encoding_tokens, args);
+
+	if (!encoding_tokens[token].pattern)
+		return NULL;
+
+	return charsets[token]->load_charset(args);
+}
+EXPORT_SYMBOL(charset_load);
+
+int charset_register(struct charset_info *charset)
+{
+	encoding_tokens[n_encodings].token = n_encodings;
+	encoding_tokens[n_encodings].pattern = charset->match_token;
+
+	charsets[n_encodings] = charset;
+	n_encodings += 1;
+	return 0;
+}
+EXPORT_SYMBOL(charset_register);
+
+static int __init init_charset(void)
+{
+	memset(encoding_tokens, 0, sizeof(encoding_tokens));
+	n_encodings = 0;
+
+	return 0;
+}
+
+static void __exit exit_charset(void)
+{
+}
+
+module_init(init_charset);
+module_exit(exit_charset);
+
+MODULE_AUTHOR("Gabriel Krisman Bertazi");
+MODULE_DESCRIPTION("charset abstraction for filesystems");
+MODULE_LICENSE("GPL");
-- 
2.15.1
