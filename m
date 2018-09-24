Return-Path: <SRS0=VTDm=MG=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:45554 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbeIYECU (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2018 00:02:20 -0400
From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH RESEND v2 14/25] nls: utf8: Move nls-utf8{,-core}.c
Date: Mon, 24 Sep 2018 17:56:44 -0400
Message-Id: <20180924215655.3676-15-krisman@collabora.co.uk>
In-Reply-To: <20180924215655.3676-1-krisman@collabora.co.uk>
References: <20180924215655.3676-1-krisman@collabora.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

nls_utf8 will be generated from multiple files, so lets move the
existing code to a -core suffix.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 fs/nls/Makefile                        | 3 +++
 fs/nls/{nls_utf8.c => nls_utf8-core.c} | 0
 2 files changed, 3 insertions(+)
 rename fs/nls/{nls_utf8.c => nls_utf8-core.c} (100%)

diff --git a/fs/nls/Makefile b/fs/nls/Makefile
index 9eff2f058c7a..2e092668fcd8 100644
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
2.19.0
