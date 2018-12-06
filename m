Return-Path: <SRS0=bC55=OP=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:56074 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbeLFXJY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Dec 2018 18:09:24 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: tytso@mit.edu
Cc: linux-fsdevel@vger.kernel.org, kernel@collabora.com,
        linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH v4 04/23] nls: Split default charset from NLS core
Date: Thu,  6 Dec 2018 18:08:44 -0500
Message-Id: <20181206230903.30011-5-krisman@collabora.com>
In-Reply-To: <20181206230903.30011-1-krisman@collabora.com>
References: <20181206230903.30011-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 fs/nls/Makefile                      |  1 +
 fs/nls/nls_core.c                    | 94 ++++++++++++++++++++++++++++
 fs/nls/{nls_base.c => nls_default.c} | 93 +++------------------------
 3 files changed, 102 insertions(+), 86 deletions(-)
 create mode 100644 fs/nls/nls_core.c
 rename fs/nls/{nls_base.c => nls_default.c} (90%)

diff --git a/fs/nls/Makefile b/fs/nls/Makefile
index ac54db297128..5f42ceff9d15 100644
--- a/fs/nls/Makefile
+++ b/fs/nls/Makefile
@@ -3,6 +3,7 @@
 # Makefile for native language support
 #
 
+nls_base-y := nls_core.o nls_default.o
 obj-$(CONFIG_NLS)		+= nls_base.o
 
 obj-$(CONFIG_NLS_CODEPAGE_437)	+= nls_cp437.o
diff --git a/fs/nls/nls_core.c b/fs/nls/nls_core.c
new file mode 100644
index 000000000000..3f7de8f4c5b2
--- /dev/null
+++ b/fs/nls/nls_core.c
@@ -0,0 +1,94 @@
+/*
+ * linux/fs/nls/nls_core.c
+ *
+ * Native language support--charsets and unicode translations.
+ * By Gordon Chaffee 1996, 1997
+ *
+ * Unicode based case conversion 1999 by Wolfram Pienkoss
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/nls.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/kmod.h>
+#include <linux/spinlock.h>
+
+static struct nls_table default_table;
+static struct nls_table *tables = &default_table;
+static DEFINE_SPINLOCK(nls_lock);
+
+int __register_nls(struct nls_table *nls, struct module *owner)
+{
+	struct nls_table ** tmp = &tables;
+
+	if (nls->next)
+		return -EBUSY;
+
+	nls->owner = owner;
+	spin_lock(&nls_lock);
+	while (*tmp) {
+		if (nls == *tmp) {
+			spin_unlock(&nls_lock);
+			return -EBUSY;
+		}
+		tmp = &(*tmp)->next;
+	}
+	nls->next = tables;
+	tables = nls;
+	spin_unlock(&nls_lock);
+	return 0;
+}
+EXPORT_SYMBOL(__register_nls);
+
+int unregister_nls(struct nls_table * nls)
+{
+	struct nls_table ** tmp = &tables;
+
+	spin_lock(&nls_lock);
+	while (*tmp) {
+		if (nls == *tmp) {
+			*tmp = nls->next;
+			spin_unlock(&nls_lock);
+			return 0;
+		}
+		tmp = &(*tmp)->next;
+	}
+	spin_unlock(&nls_lock);
+	return -EINVAL;
+}
+
+static struct nls_table *find_nls(char *charset)
+{
+	struct nls_table *nls;
+	spin_lock(&nls_lock);
+	for (nls = tables; nls; nls = nls->next) {
+		if (!strcmp(nls_charset_name(nls), charset))
+			break;
+		if (nls->alias && !strcmp(nls->alias, charset))
+			break;
+	}
+	if (nls && !try_module_get(nls->owner))
+		nls = NULL;
+	spin_unlock(&nls_lock);
+	return nls;
+}
+
+struct nls_table *load_nls(char *charset)
+{
+	return try_then_request_module(find_nls(charset), "nls_%s", charset);
+}
+
+void unload_nls(struct nls_table *nls)
+{
+	if (nls)
+		module_put(nls->owner);
+}
+
+EXPORT_SYMBOL(unregister_nls);
+EXPORT_SYMBOL(unload_nls);
+EXPORT_SYMBOL(load_nls);
+
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_base.c b/fs/nls/nls_default.c
similarity index 90%
rename from fs/nls/nls_base.c
rename to fs/nls/nls_default.c
index 0bb0acf6893f..c5d7e8391b22 100644
--- a/fs/nls/nls_base.c
+++ b/fs/nls/nls_default.c
@@ -1,5 +1,5 @@
 /*
- * linux/fs/nls/nls_base.c
+ * linux/fs/nls/nls_default.c
  *
  * Native language support--charsets and unicode translations.
  * By Gordon Chaffee 1996, 1997
@@ -8,23 +8,17 @@
  *
  */
 
+/*
+ * Sample implementation from Unicode home page.
+ * http://www.stonehand.com/unicode/standard/fss-utf.html
+ */
+
 #include <linux/module.h>
-#include <linux/string.h>
-#include <linux/nls.h>
-#include <linux/kernel.h>
-#include <linux/errno.h>
-#include <linux/kmod.h>
-#include <linux/spinlock.h>
 #include <asm/byteorder.h>
+#include <linux/nls.h>
 
 static struct nls_table default_table;
-static struct nls_table *tables = &default_table;
-static DEFINE_SPINLOCK(nls_lock);
 
-/*
- * Sample implementation from Unicode home page.
- * http://www.stonehand.com/unicode/standard/fss-utf.html
- */
 struct utf8_table {
 	int     cmask;
 	int     cval;
@@ -232,73 +226,6 @@ int utf16s_to_utf8s(const wchar_t *pwcs, int inlen, enum utf16_endian endian,
 }
 EXPORT_SYMBOL(utf16s_to_utf8s);
 
-int __register_nls(struct nls_table *nls, struct module *owner)
-{
-	struct nls_table ** tmp = &tables;
-
-	if (nls->next)
-		return -EBUSY;
-
-	nls->owner = owner;
-	spin_lock(&nls_lock);
-	while (*tmp) {
-		if (nls == *tmp) {
-			spin_unlock(&nls_lock);
-			return -EBUSY;
-		}
-		tmp = &(*tmp)->next;
-	}
-	nls->next = tables;
-	tables = nls;
-	spin_unlock(&nls_lock);
-	return 0;	
-}
-EXPORT_SYMBOL(__register_nls);
-
-int unregister_nls(struct nls_table * nls)
-{
-	struct nls_table ** tmp = &tables;
-
-	spin_lock(&nls_lock);
-	while (*tmp) {
-		if (nls == *tmp) {
-			*tmp = nls->next;
-			spin_unlock(&nls_lock);
-			return 0;
-		}
-		tmp = &(*tmp)->next;
-	}
-	spin_unlock(&nls_lock);
-	return -EINVAL;
-}
-
-static struct nls_table *find_nls(char *charset)
-{
-	struct nls_table *nls;
-	spin_lock(&nls_lock);
-	for (nls = tables; nls; nls = nls->next) {
-		if (!strcmp(nls_charset_name(nls), charset))
-			break;
-		if (nls->alias && !strcmp(nls->alias, charset))
-			break;
-	}
-	if (nls && !try_module_get(nls->owner))
-		nls = NULL;
-	spin_unlock(&nls_lock);
-	return nls;
-}
-
-struct nls_table *load_nls(char *charset)
-{
-	return try_then_request_module(find_nls(charset), "nls_%s", charset);
-}
-
-void unload_nls(struct nls_table *nls)
-{
-	if (nls)
-		module_put(nls->owner);
-}
-
 static const wchar_t charset2uni[256] = {
 	/* 0x00*/
 	0x0000, 0x0001, 0x0002, 0x0003,
@@ -543,10 +470,4 @@ struct nls_table *load_nls_default(void)
 	else
 		return &default_table;
 }
-
-EXPORT_SYMBOL(unregister_nls);
-EXPORT_SYMBOL(unload_nls);
-EXPORT_SYMBOL(load_nls);
 EXPORT_SYMBOL(load_nls_default);
-
-MODULE_LICENSE("Dual BSD/GPL");
-- 
2.20.0.rc2
