Return-Path: <SRS0=bC55=OP=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55672 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbeLFWFd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Dec 2018 17:05:33 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: tytso@mit.edu
Cc: kernel@collabora.com, linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH v4 14/23] nls: utf8: Move nls-utf8{,-core}.c
Date: Thu,  6 Dec 2018 17:04:20 -0500
Message-Id: <20181206220429.10722-15-krisman@collabora.com>
In-Reply-To: <20181206220429.10722-1-krisman@collabora.com>
References: <20181206220429.10722-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>

nls_utf8 will be generated from multiple files, so lets move the
existing code to a -core suffix.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 fs/nls/Makefile                        | 3 +++
 fs/nls/{nls_utf8.c => nls_utf8-core.c} | 0
 2 files changed, 3 insertions(+)
 rename fs/nls/{nls_utf8.c => nls_utf8-core.c} (100%)

diff --git a/fs/nls/Makefile b/fs/nls/Makefile
index 840e06aefd47..c94221b6108d 100644
--- a/fs/nls/Makefile
+++ b/fs/nls/Makefile
@@ -43,7 +43,10 @@ obj-$(CONFIG_NLS_ISO8859_14)	+= nls_iso8859-14.o
 obj-$(CONFIG_NLS_ISO8859_15)	+= nls_iso8859-15.o
 obj-$(CONFIG_NLS_KOI8_R)	+= nls_koi8-r.o
 obj-$(CONFIG_NLS_KOI8_U)	+= nls_koi8-u.o nls_koi8-ru.o
+
 obj-$(CONFIG_NLS_UTF8)		+= nls_utf8.o
+nls_utf8-y			+= nls_utf8-core.o
+
 obj-$(CONFIG_NLS_MAC_CELTIC)    += mac-celtic.o
 obj-$(CONFIG_NLS_MAC_CENTEURO)  += mac-centeuro.o
 obj-$(CONFIG_NLS_MAC_CROATIAN)  += mac-croatian.o
diff --git a/fs/nls/nls_utf8.c b/fs/nls/nls_utf8-core.c
similarity index 100%
rename from fs/nls/nls_utf8.c
rename to fs/nls/nls_utf8-core.c
-- 
2.20.0.rc2
