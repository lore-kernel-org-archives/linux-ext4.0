Return-Path: <SRS0=VTDm=MG=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:45530 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbeIYECD (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2018 00:02:03 -0400
From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH RESEND v2 09/25] nls: Add new interface for string comparisons
Date: Mon, 24 Sep 2018 17:56:39 -0400
Message-Id: <20180924215655.3676-10-krisman@collabora.co.uk>
In-Reply-To: <20180924215655.3676-1-krisman@collabora.co.uk>
References: <20180924215655.3676-1-krisman@collabora.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The existing stricmp() interface is limited by not accepting separated
length parameters for each string being compared.  This is a problem for
charsets doing normalization or full casefold comparison, since
different sized strings can still be matched.  To resolve this problem,
this patch implements a new interface, allowing charsets to do the
comparison, if needed.

The original stricmp is left in the code, until we convert all caller to
the new interface.  Nevertheless, it was reimplemented using the new
interface.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 include/linux/nls.h | 69 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 66 insertions(+), 3 deletions(-)

diff --git a/include/linux/nls.h b/include/linux/nls.h
index c43746bd390e..980103d4c363 100644
--- a/include/linux/nls.h
+++ b/include/linux/nls.h
@@ -3,6 +3,7 @@
 #define _LINUX_NLS_H
 
 #include <linux/init.h>
+#include <linux/string.h>
 
 /* Unicode has changed over the years.  Unicode code points no longer
  * fit into 16 bits; as of Unicode 5 valid code points range from 0
@@ -38,6 +39,32 @@ struct nls_ops {
 	 **/
 	int (*validate)(const struct nls_table *charset,
 			const unsigned char *str, size_t len);
+	/**
+	 * @strncmp:
+	 *
+	 * strncmp is the function for case-sensitive string comparison.
+	 * It only needs to be implemented by charsets that want to do
+	 * some fancy comparisons, like normalization-insensitive.
+	 *
+	 * Returns 0 if str1 and str2 are equal, otherwise return
+	 * non-zero.
+	 **/
+	int (*strncmp)(const struct nls_table *charset,
+		       const unsigned char *str1, size_t len1,
+		       const unsigned char *str2, size_t len2);
+
+	/**
+	 * @strncasecmp:
+	 *
+	 * strncasecmp is the function for case-insensitive string
+	 * comparison.
+	 *
+	 * Returns 0 if str1 and str2 are equal, otherwise return
+	 * non-zero.
+	 **/
+	int (*strncasecmp)(const struct nls_table *charset,
+			   const unsigned char *str1, size_t len1,
+			   const unsigned char *str2, size_t len2);
 	unsigned char (*lowercase)(const struct nls_table *charset,
 				   unsigned int c);
 	unsigned char (*uppercase)(const struct nls_table *charset,
@@ -139,10 +166,21 @@ static inline unsigned char nls_toupper(const struct nls_table *t,
 	return nc ? nc : c;
 }
 
-static inline int nls_strnicmp(struct nls_table *t, const unsigned char *s1,
-		const unsigned char *s2, int len)
+static inline int nls_strncasecmp(struct nls_table *t,
+				  const unsigned char *s1, size_t len1,
+				  const unsigned char *s2, size_t len2)
 {
-	while (len--) {
+	if (t->ops->strncasecmp)
+		return t->ops->strncasecmp(t, s1, len1, s2, len2);
+
+	if (IS_STRICT_MODE(t) &&
+	    (nls_validate(t, s1, len1) || nls_validate(t, s1, len1)))
+		return -EINVAL;
+
+	if (len1 != len2)
+		return 1;
+
+	while (len1--) {
 		if (nls_tolower(t, *s1++) != nls_tolower(t, *s2++))
 			return 1;
 	}
@@ -150,6 +188,31 @@ static inline int nls_strnicmp(struct nls_table *t, const unsigned char *s1,
 	return 0;
 }
 
+static inline int nls_strncmp(struct nls_table *t,
+			      const unsigned char *s1, size_t len1,
+			      const unsigned char *s2, size_t len2)
+{
+	if (t->ops->strncmp)
+		return t->ops->strncmp(t, s1, len1, s2, len2);
+
+	if (IS_STRICT_MODE(t) &&
+	    (nls_validate(t, s1, len1) || nls_validate(t, s1, len1)))
+		return -EINVAL;
+
+	if (len1 != len2)
+		return 1;
+
+	/* strnicmp did not return negative values. So let's keep the
+	 * abi for now */
+	return !!memcmp(s1, s2, len1);
+}
+
+static inline int nls_strnicmp(struct nls_table *t, const unsigned char *s1,
+		const unsigned char *s2, int len)
+{
+	return nls_strncasecmp(t, s1, len, s2, len);
+}
+
 /*
  * nls_nullsize - return length of null character for codepage
  * @codepage - codepage for which to return length of NULL terminator
-- 
2.19.0
