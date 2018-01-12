From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH RFC 01/13] charsets: Introduce middle-layer for character encoding
Date: Fri, 12 Jan 2018 05:12:22 -0200
Message-ID: <20180112071234.29470-2-krisman@collabora.co.uk>
References: <20180112071234.29470-1-krisman@collabora.co.uk>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel@lists.collabora.co.uk, alvaro.soliverez@collabora.co.uk,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: tytso@mit.edu, david@fromorbit.com, bpm@sgi.com, olaf@sgi.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20180112071234.29470-1-krisman@collabora.co.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This implements an abstraction for high-level encoding-wise string
manipulation functions.  It defines some hooks that encoding modules must
implement, which will be used by filesystem code to support lookups that
consider normalization and case-folding.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 include/linux/charsets.h | 73 ++++++++++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig              |  2 ++
 lib/Makefile             |  2 ++
 lib/charsets/Makefile    |  3 ++
 lib/charsets/core.c      | 68 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 148 insertions(+)
 create mode 100644 include/linux/charsets.h
 create mode 100644 lib/charsets/Makefile
 create mode 100644 lib/charsets/core.c

diff --git a/include/linux/charsets.h b/include/linux/charsets.h
new file mode 100644
index 000000000000..8465e93c9d9f
--- /dev/null
+++ b/include/linux/charsets.h
@@ -0,0 +1,73 @@
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
+struct charset_info;
+struct charset;
+
+struct charset_ops {
+	int (*strncmp)(const struct charset *charset, const char *str1,
+		       const char *str2, int len);
+	int (*strncasecmp)(const struct charset *charset, const char *str1,
+			   const char *str2, int len);
+	int (*casefold)(const struct charset *charset, const char *str,
+			int len, char **folded_str);
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
+				  const char *str1, const char *str2,
+				  int len)
+{
+	return charset->ops->strncmp(charset, str1, str2, len);
+}
+
+static inline int charset_strncasecmp(const struct charset *charset,
+				      const char *str1, const char *str2,
+				      int len)
+{
+	return charset->ops->strncasecmp(charset, str1, str2, len);
+}
+
+static inline int charset_casefold(const struct charset *charset,
+				   const char *str, int len, char **folded_str)
+{
+	return charset->ops->casefold(charset, str, len, folded_str);
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
index 000000000000..fb7b297b978e
--- /dev/null
+++ b/lib/charsets/core.c
@@ -0,0 +1,68 @@
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
+	encoding_tokens[0].token = 0;
+	encoding_tokens[0].pattern = NULL;
+	n_encodings = 0;
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
