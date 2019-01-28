Return-Path: <SRS0=NyoO=QE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41323C282CD
	for <linux-ext4@archiver.kernel.org>; Mon, 28 Jan 2019 21:32:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B1542177E
	for <linux-ext4@archiver.kernel.org>; Mon, 28 Jan 2019 21:32:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbfA1Vcr (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 28 Jan 2019 16:32:47 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:58142 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbfA1Vcr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jan 2019 16:32:47 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 2635927FB7B
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     tytso@mit.edu
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        sfrench@samba.org, darrick.wong@oracle.com,
        samba-technical@lists.samba.org, jlayton@kernel.org,
        bfields@fieldses.org, paulus@samba.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH RFC v5 05/11] unicode: Implement higher level API for string handling
Date:   Mon, 28 Jan 2019 16:32:17 -0500
Message-Id: <20190128213223.31512-6-krisman@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190128213223.31512-1-krisman@collabora.com>
References: <20190128213223.31512-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>

This patch integrates the utf8n patches with some higher level API to
perform UTF-8 string comparison, normalization and casefolding
operations.  Implemented is a variation of NFD, and casefold is
performed by doing full casefold on top of NFD.  These algorithms are
based on the core implemented by Olaf Weber from SGI.

Changes since v4:
  - integrate in fs/unicode

Changes since RFC v1:
  - Change error return code from EIO to EINVAL. (Olaf Weber)
  - Fix issues with strncmp/strcmp.  (Olaf Weber)
  - Remove stack buffer in normalization/casefold. (Olaf Weber)
  - Include length parameter for second string on comparison functions.
  - Change length type to size_t.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 fs/unicode/Makefile     |   4 +-
 fs/unicode/utf8-core.c  | 183 ++++++++++++++++++++++++++++++++++++++++
 fs/unicode/utf8-norm.c  |   6 ++
 fs/unicode/utf8n.h      |   1 +
 include/linux/unicode.h |  30 +++++++
 5 files changed, 223 insertions(+), 1 deletion(-)
 create mode 100644 fs/unicode/utf8-core.c
 create mode 100644 include/linux/unicode.h

diff --git a/fs/unicode/Makefile b/fs/unicode/Makefile
index 1ed10e40c30d..9a9836fcf38b 100644
--- a/fs/unicode/Makefile
+++ b/fs/unicode/Makefile
@@ -2,7 +2,9 @@
 
 UNICODE_VERSION=11.0.0
 
-obj-$(CONFIG_UNICODE) += utf8-norm.o
+obj-$(CONFIG_UNICODE) += unicode.o
+
+unicode-y := utf8-norm.o utf8-core.o
 
 $(obj)/utf8-norm.o: $(obj)/utf8data.h
 $(obj)/utf8data.h: $(srctree)/$(src)/ucd/*.txt $(objtree)/scripts/mkutf8data FORCE
diff --git a/fs/unicode/utf8-core.c b/fs/unicode/utf8-core.c
new file mode 100644
index 000000000000..39f4b06dded6
--- /dev/null
+++ b/fs/unicode/utf8-core.c
@@ -0,0 +1,183 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/parser.h>
+#include <linux/errno.h>
+#include <linux/unicode.h>
+
+#include "utf8n.h"
+
+int utf8_validate(const struct unicode_map *um, const struct qstr *str)
+{
+	const struct utf8data *data = utf8nfdi(um->version);
+
+	if (utf8nlen(data, str->name, str->len) < 0)
+		return -1;
+	return 0;
+}
+EXPORT_SYMBOL(utf8_validate);
+
+int utf8_strncmp(const struct unicode_map *um,
+		 const struct qstr *s1, const struct qstr *s2)
+{
+	const struct utf8data *data = utf8nfdi(um->version);
+	struct utf8cursor cur1, cur2;
+	int c1, c2;
+
+	if (utf8ncursor(&cur1, data, s1->name, s1->len) < 0)
+		return -EINVAL;
+
+	if (utf8ncursor(&cur2, data, s2->name, s2->len) < 0)
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
+EXPORT_SYMBOL(utf8_strncmp);
+
+int utf8_strncasecmp(const struct unicode_map *um,
+		     const struct qstr *s1, const struct qstr *s2)
+{
+	const struct utf8data *data = utf8nfdicf(um->version);
+	struct utf8cursor cur1, cur2;
+	int c1, c2;
+
+	if (utf8ncursor(&cur1, data, s1->name, s1->len) < 0)
+		return -EINVAL;
+
+	if (utf8ncursor(&cur2, data, s2->name, s2->len) < 0)
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
+EXPORT_SYMBOL(utf8_strncasecmp);
+
+int utf8_casefold(const struct unicode_map *um, const struct qstr *str,
+		  unsigned char *dest, size_t dlen)
+{
+	const struct utf8data *data = utf8nfdicf(um->version);
+	struct utf8cursor cur;
+	size_t nlen = 0;
+
+	if (utf8ncursor(&cur, data, str->name, str->len) < 0)
+		return -EINVAL;
+
+	for (nlen = 0; nlen < dlen; nlen++) {
+		dest[nlen] = utf8byte(&cur);
+		if (!dest[nlen])
+			return nlen;
+		if (dest[nlen] == -1)
+			break;
+	}
+	return -EINVAL;
+}
+
+EXPORT_SYMBOL(utf8_casefold);
+
+int utf8_normalize(const struct unicode_map *um, const struct qstr *str,
+		   unsigned char *dest, size_t dlen)
+{
+	const struct utf8data *data = utf8nfdi(um->version);
+	struct utf8cursor cur;
+	ssize_t nlen = 0;
+
+	if (utf8ncursor(&cur, data, str->name, str->len) < 0)
+		return -EINVAL;
+
+	for (nlen = 0; nlen < dlen; nlen++) {
+		dest[nlen] = utf8byte(&cur);
+		if (!dest[nlen])
+			return nlen;
+		if (dest[nlen] == -1)
+			break;
+	}
+	return -EINVAL;
+}
+
+EXPORT_SYMBOL(utf8_normalize);
+
+static int utf8_parse_version(const char *version, unsigned int *maj,
+			      unsigned int *min, unsigned int *rev)
+{
+	substring_t args[3];
+	char version_string[12];
+	const struct match_token token[] = {
+		{1, "%d.%d.%d"},
+		{0, NULL}
+	};
+
+	strncpy(version_string, version, sizeof(version_string));
+
+	if (match_token(version_string, token, args) != 1)
+		return -EINVAL;
+
+	if (match_int(&args[0], maj) || match_int(&args[1], min) ||
+	    match_int(&args[2], rev))
+		return -EINVAL;
+
+	return 0;
+}
+
+struct unicode_map *utf8_load(const char *version)
+{
+	struct unicode_map *um = NULL;
+	int unicode_version;
+
+	if (version) {
+		unsigned int maj, min, rev;
+
+		if (utf8_parse_version(version, &maj, &min, &rev) < 0)
+			return ERR_PTR(-EINVAL);
+
+		if (!utf8version_is_supported(maj, min, rev))
+			return ERR_PTR(-EINVAL);
+
+		unicode_version = UNICODE_AGE(maj, min, rev);
+	} else {
+		unicode_version = utf8version_latest();
+		printk(KERN_WARNING"UTF-8 version not specified. "
+		       "Assuming latest supported version (%d.%d.%d).",
+		       (unicode_version >> 16) & 0xff,
+		       (unicode_version >> 8) & 0xff,
+		       (unicode_version & 0xff));
+	}
+
+	um = kzalloc(sizeof(struct unicode_map), GFP_KERNEL);
+	if (!um)
+		return ERR_PTR(-ENOMEM);
+
+	um->charset = "UTF-8";
+	um->version = unicode_version;
+
+	return um;
+}
+EXPORT_SYMBOL(utf8_load);
+
+void utf8_unload(struct unicode_map *um)
+{
+	kfree(um);
+}
+EXPORT_SYMBOL(utf8_unload);
+
+MODULE_LICENSE("GPL v2");
diff --git a/fs/unicode/utf8-norm.c b/fs/unicode/utf8-norm.c
index 845c0f300370..94e066be3ea6 100644
--- a/fs/unicode/utf8-norm.c
+++ b/fs/unicode/utf8-norm.c
@@ -38,6 +38,12 @@ int utf8version_is_supported(u8 maj, u8 min, u8 rev)
 }
 EXPORT_SYMBOL(utf8version_is_supported);
 
+int utf8version_latest()
+{
+	return utf8vers;
+}
+EXPORT_SYMBOL(utf8version_latest);
+
 /*
  * UTF-8 valid ranges.
  *
diff --git a/fs/unicode/utf8n.h b/fs/unicode/utf8n.h
index b63a9091dc39..a120638014c1 100644
--- a/fs/unicode/utf8n.h
+++ b/fs/unicode/utf8n.h
@@ -32,6 +32,7 @@
 
 /* Highest unicode version supported by the data tables. */
 extern int utf8version_is_supported(u8 maj, u8 min, u8 rev);
+extern int utf8version_latest(void);
 
 /*
  * Look for the correct const struct utf8data for a unicode version.
diff --git a/include/linux/unicode.h b/include/linux/unicode.h
new file mode 100644
index 000000000000..aec2c6d800aa
--- /dev/null
+++ b/include/linux/unicode.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_UNICODE_H
+#define _LINUX_UNICODE_H
+
+#include <linux/init.h>
+#include <linux/dcache.h>
+
+struct unicode_map {
+	const char *charset;
+	int version;
+};
+
+int utf8_validate(const struct unicode_map *um, const struct qstr *str);
+
+int utf8_strncmp(const struct unicode_map *um,
+		 const struct qstr *s1, const struct qstr *s2);
+
+int utf8_strncasecmp(const struct unicode_map *um,
+		 const struct qstr *s1, const struct qstr *s2);
+
+int utf8_normalize(const struct unicode_map *um, const struct qstr *str,
+		   unsigned char *dest, size_t dlen);
+
+int utf8_casefold(const struct unicode_map *um, const struct qstr *str,
+		  unsigned char *dest, size_t dlen);
+
+struct unicode_map *utf8_load(const char *version);
+void utf8_unload(struct unicode_map *um);
+
+#endif /* _LINUX_UNICODE_H */
-- 
2.20.1

