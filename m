From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 06/11] quota: add generic subtree quota support
Date: Mon, 08 Feb 2010 16:28:08 +0300
Message-ID: <1265635693-12182-7-git-send-email-dmonakhov@openvz.org>
References: <1265635693-12182-1-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-2-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-3-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-4-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-5-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-6-git-send-email-dmonakhov@openvz.org>
Content-Transfer-Encoding: 7BIT
Cc: Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:33220 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295Ab0BHO23 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Feb 2010 09:28:29 -0500
Received: from localhost.localdomain ([unknown] [195.214.232.10])
 by mail.2ka.mipt.ru
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 with ESMTPA id <0KXI0097MZ0I9F10@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Mon, 08 Feb 2010 16:34:01 +0300 (MSK)
In-reply-to: <1265635693-12182-6-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Just introduce new and update macros.
It will be used later.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/quota/dquot.c      |    5 +++++
 fs/quota/quotaio_v2.h |    6 ++++--
 include/linux/quota.h |    6 ++++--
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 033c271..5483149 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1041,6 +1041,11 @@ static int need_print_warning(struct dquot *dquot)
 			return current_fsuid() == dquot->dq_id;
 		case GRPQUOTA:
 			return in_group_p(dquot->dq_id);
+		case SBTRQUOTA:
+			/* XXX: Currently there is no way to understand
+			   which subtree this task belonges to, So print
+			   a warn message unconditionally. -dmon */
+			return 1;
 	}
 	return 0;
 }
diff --git a/fs/quota/quotaio_v2.h b/fs/quota/quotaio_v2.h
index f1966b4..01e8203 100644
--- a/fs/quota/quotaio_v2.h
+++ b/fs/quota/quotaio_v2.h
@@ -13,12 +13,14 @@
  */
 #define V2_INITQMAGICS {\
 	0xd9c01f11,	/* USRQUOTA */\
-	0xd9c01927	/* GRPQUOTA */\
+	0xd9c01927,	/* GRPQUOTA */\
+	0xd9c03f14	/* SBTRQUOTA */\
 }
 
 #define V2_INITQVERSIONS {\
 	1,		/* USRQUOTA */\
-	1		/* GRPQUOTA */\
+	1,		/* GRPQUOTA */	\
+	1		/* SBTRPQUOTA */\
 }
 
 /* First generic header */
diff --git a/include/linux/quota.h b/include/linux/quota.h
index abf6a5a..0bcd295 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -36,11 +36,12 @@
 #include <linux/errno.h>
 #include <linux/types.h>
 
-#define __DQUOT_VERSION__	"dquot_6.5.2"
+#define __DQUOT_VERSION__	"dquot_6.6.0"
 
-#define MAXQUOTAS 2
+#define MAXQUOTAS 3
 #define USRQUOTA  0		/* element used for user quotas */
 #define GRPQUOTA  1		/* element used for group quotas */
+#define SBTRQUOTA   2		/* element used for directory tree quotas */
 
 /*
  * Definitions for the default names of the quotas files.
@@ -48,6 +49,7 @@
 #define INITQFNAMES { \
 	"user",    /* USRQUOTA */ \
 	"group",   /* GRPQUOTA */ \
+	"subtree",    /* SBTRQUOTA */ \
 	"undefined", \
 };
 
-- 
1.6.3.3

