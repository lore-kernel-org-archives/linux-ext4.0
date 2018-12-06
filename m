Return-Path: <SRS0=bC55=OP=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:56104 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbeLFXJq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Dec 2018 18:09:46 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: tytso@mit.edu
Cc: linux-fsdevel@vger.kernel.org, kernel@collabora.com,
        linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH v4 10/23] nls: Add optional normalization and casefold hooks
Date: Thu,  6 Dec 2018 18:08:50 -0500
Message-Id: <20181206230903.30011-11-krisman@collabora.com>
In-Reply-To: <20181206230903.30011-1-krisman@collabora.com>
References: <20181206230903.30011-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>

The Normalization operation applies a transformation to strings to
obtain the normalization form, which allow the user to determine whether
any two strings are equivalent to each other.  The NLS subsystem doesn't
impose any constraint on what means to be equivalent, for any charsets.
Unicode-based charsets, for instance, are free to support one, a few or
all kinds of Unicode equivalences.

The Casefold operation is similar to Normalization, in a sense that it
also allows the caller to identify equivalent strings, but it
disregards case, making it ideal for case insensitive comparisons.

Default implementation are provided by the nls core, such that existing
charsets can operate on the new interface. The Normalization default
operation is the format NLS_NORMALIZATION_TYPE_PLAIN, which returns the
identity of the string, which means no normalization.  The casefold
default is NLS_CASEFOLD_TYPE_TOUPPER, which returns the string with all
characters converted to uppercase.

Changes since V1:
  - Add default operations for casefold and normalization

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 fs/nls/nls_core.c   |  11 +++++
 include/linux/nls.h | 116 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 127 insertions(+)

diff --git a/fs/nls/nls_core.c b/fs/nls/nls_core.c
index 49a15bb2174f..c49088f36f4c 100644
--- a/fs/nls/nls_core.c
+++ b/fs/nls/nls_core.c
@@ -25,6 +25,17 @@ static int nls_validate_flags(struct nls_table *table, unsigned int flags)
 	if (flags & NLS_STRICT_MODE && !table->ops->validate)
 		return -1;
 
+	if ((flags & NLS_NORMALIZATION_TYPE_MASK) && !table->ops->normalize)
+		return -1;
+
+	if ((flags & NLS_CASEFOLD_TYPE_MASK) && !table->ops->casefold)
+		return -1;
+
+	/* Reject unused flags */
+	if (flags & ~(NLS_CASEFOLD_TYPE_MASK | NLS_NORMALIZATION_TYPE_MASK |
+		      NLS_STRICT_MODE))
+		return -1;
+
 	return 0;
 }
 
diff --git a/include/linux/nls.h b/include/linux/nls.h
index 980103d4c363..44a06a9c69e7 100644
--- a/include/linux/nls.h
+++ b/include/linux/nls.h
@@ -4,6 +4,7 @@
 
 #include <linux/init.h>
 #include <linux/string.h>
+#include <linux/errno.h>
 
 /* Unicode has changed over the years.  Unicode code points no longer
  * fit into 16 bits; as of Unicode 5 valid code points range from 0
@@ -65,6 +66,51 @@ struct nls_ops {
 	int (*strncasecmp)(const struct nls_table *charset,
 			   const unsigned char *str1, size_t len1,
 			   const unsigned char *str2, size_t len2);
+	/**
+	 * @normalize:
+	 *
+	 * Obtain the normalized form of a string, which can be used to
+	 * determine whether any two strings are equivalent.  The NLS
+	 * subsystem doesn't impose any constraint on the charsets
+	 * regarding what it means to be equivalent.  Unicode-based
+	 * charsets, for instance, are free to support one, a few or all
+	 * kinds of Unicode equivalences.  Different kinds of
+	 * normalizations can be specified using the nls_table flags.
+	 *
+	 * This hook is responsible for performing string validation if
+	 * the strict mode flag is set.  The only case where it is not
+	 * called by nls_core is when strict mode and normalization are
+	 * disabled, because in this case the normalization is
+	 * guaranteed to be the string identity.
+	 *
+	 * Not every charset implements this hook.  It is only required
+	 * if the charset supports strict mode or some kind of
+	 * normalization.
+	 *
+	 * If this operation cannot be executed for this charset,
+	 * -ENOTSUPP is returned.  If the sequence is invalid, -EINVAL
+	 * is returned.  Otherwise, this function returns the size of the
+	 * new string.
+	 **/
+	int (*normalize)(const struct nls_table *charset,
+			 const unsigned char *str, size_t len,
+			 unsigned char *dest, size_t dlen);
+	/**
+	 * @casefold:
+	 *
+	 * Casefold returns a version of the string that can be used to
+	 * perform case-insensitive comparisons.  The kind of casefold
+	 * algorithm that will be used is charset dependent, and can be
+	 * configured using the nls_table flags field.
+	 *
+	 * If this operation cannot be executed for this charset,
+	 * -ENOTSUPP is returned.  If the sequence fails, -EINVAL is
+	 * returned.  Otherwise, this function returns the size of the
+	 * new string.
+	 **/
+	int (*casefold)(const struct nls_table *charset,
+			const unsigned char *str, size_t len,
+			unsigned char *dest, size_t dlen);
 	unsigned char (*lowercase)(const struct nls_table *charset,
 				   unsigned int c);
 	unsigned char (*uppercase)(const struct nls_table *charset,
@@ -101,13 +147,37 @@ enum utf16_endian {
 	UTF16_BIG_ENDIAN
 };
 
+#define NLS_NORMALIZATION_TYPE(i)	((i & 0x7) << 1)
+#define NLS_CASEFOLD_TYPE(i)		((i & 0x7) << 4)
+
 #define NLS_STRICT_MODE			0x00000001
+#define NLS_NORMALIZATION_TYPE_PLAIN	NLS_NORMALIZATION_TYPE(0)
+#define NLS_NORMALIZATION_TYPE_MASK	0x0000000E
+#define NLS_CASEFOLD_TYPE_TOUPPER	NLS_CASEFOLD_TYPE(0)
+#define NLS_CASEFOLD_TYPE_MASK		0x00000070
 
 static inline int IS_STRICT_MODE(const struct nls_table *charset)
 {
 	return (charset->flags & NLS_STRICT_MODE);
 }
 
+#define NLS_NORMALIZATION_FUNCS(charset, type, i)			\
+static inline int							\
+IS_NORMALIZATION_TYPE_##charset##_##type(const struct nls_table *c)	\
+{									\
+	return ((c->flags & NLS_NORMALIZATION_TYPE_MASK) == i);		\
+}
+
+#define NLS_CASEFOLD_FUNCS(charset, type, i)			    	\
+static inline int							\
+IS_CASEFOLD_TYPE_##charset##_##type(const struct nls_table *c)		\
+{									\
+	return ((c->flags & NLS_CASEFOLD_TYPE_MASK) == i);		\
+}
+
+NLS_NORMALIZATION_FUNCS(ALL, PLAIN, NLS_NORMALIZATION_TYPE_PLAIN)
+NLS_CASEFOLD_FUNCS(ALL, TOUPPER, NLS_CASEFOLD_TYPE_TOUPPER)
+
 /* nls_base.c */
 extern int __register_nls(struct nls_charset *, struct module *);
 extern int unregister_nls(struct nls_charset *);
@@ -213,6 +283,52 @@ static inline int nls_strnicmp(struct nls_table *t, const unsigned char *s1,
 	return nls_strncasecmp(t, s1, len, s2, len);
 }
 
+static inline int nls_casefold(const struct nls_table *t,
+			       const unsigned char *str, size_t len,
+			       unsigned char *dest, size_t dlen)
+{
+	int i;
+
+	if (t->ops->casefold)
+		return t->ops->casefold(t, str, len, dest, dlen);
+
+	if (!IS_CASEFOLD_TYPE_ALL_TOUPPER(t))
+		return -ENOTSUPP;
+
+	if (IS_STRICT_MODE(t) && nls_validate(t, str, len))
+		return -EINVAL;
+
+	if (len > dlen)
+		return -EINVAL;
+
+	for (i = 0 ; i < len; i++)
+		dest[i] = nls_toupper(t, str[i]);
+
+	return len;
+}
+
+static inline int nls_normalize(const struct nls_table *t,
+				const unsigned char *str, size_t len,
+				unsigned char *dest, size_t dlen)
+{
+	if (t->ops->normalize)
+		return t->ops->normalize(t, str, len, dest, dlen);
+
+	if (!IS_NORMALIZATION_TYPE_ALL_PLAIN(t))
+		return -ENOTSUPP;
+
+	if (IS_STRICT_MODE(t) && nls_validate(t, str, len))
+		return -EINVAL;
+
+	if (len > dlen)
+		return -EINVAL;
+
+	/* If normalization are disabled, normalization is the
+	 * identity. */
+	strncpy(dest, str, len);
+	return len;
+}
+
 /*
  * nls_nullsize - return length of null character for codepage
  * @codepage - codepage for which to return length of NULL terminator
-- 
2.20.0.rc2
