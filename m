From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 3/6] Implement project id support for generic quota
Date: Sun,  2 Oct 2011 23:44:38 +0400
Message-ID: <1317584681-29967-3-git-send-email-dmonakhov@openvz.org>
References: <1317584681-29967-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, viro@ZenIV.linux.org.uk,
	adityakali@google.com, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48569 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973Ab1JBTlQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Oct 2011 15:41:16 -0400
In-Reply-To: <1317584681-29967-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since all preparation code are already in quota-tree,
So this patch is really small.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/quota/dquot.c      |   10 ++++++++++
 fs/quota/quotaio_v2.h |    6 ++++--
 include/linux/quota.h |    9 ++++++++-
 3 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 5b572c8..aca0430 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1135,6 +1135,11 @@ static int need_print_warning(struct dquot *dquot)
 			return current_fsuid() == dquot->dq_id;
 		case GRPQUOTA:
 			return in_group_p(dquot->dq_id);
+		case PRJQUOTA:
+			/* XXX: Currently there is no way to understand
+			   which project_id this task belonges to, So print
+			   a warn message unconditionally. -dmon */
+			return 1;
 	}
 	return 0;
 }
@@ -1380,6 +1385,11 @@ static void __dquot_initialize(struct inode *inode, int type)
 		case GRPQUOTA:
 			id = inode->i_gid;
 			break;
+		case PRJQUOTA:
+			if (!inode->i_sb->s_op->get_prjid)
+				continue;
+			id = inode->i_sb->s_op->get_prjid(inode);
+			break;
 		}
 		got[cnt] = dqget(sb, id, cnt);
 	}
diff --git a/fs/quota/quotaio_v2.h b/fs/quota/quotaio_v2.h
index f1966b4..bfab9df 100644
--- a/fs/quota/quotaio_v2.h
+++ b/fs/quota/quotaio_v2.h
@@ -13,12 +13,14 @@
  */
 #define V2_INITQMAGICS {\
 	0xd9c01f11,	/* USRQUOTA */\
-	0xd9c01927	/* GRPQUOTA */\
+	0xd9c01927,	/* GRPQUOTA */\
+	0xd9c03f14	/* PRJQUOTA */\
 }
 
 #define V2_INITQVERSIONS {\
 	1,		/* USRQUOTA */\
-	1		/* GRPQUOTA */\
+	1,		/* GRPQUOTA */	\
+	1		/* PRJQUOTA */\
 }
 
 /* First generic header */
diff --git a/include/linux/quota.h b/include/linux/quota.h
index cb78556..f8696cd 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -36,11 +36,17 @@
 #include <linux/errno.h>
 #include <linux/types.h>
 
-#define __DQUOT_VERSION__	"dquot_6.5.2"
+#define __DQUOT_VERSION__	"dquot_6.6.0"
 
+#ifdef CONFIG_PROJECT_ID
+#define MAXQUOTAS 3
+#else
 #define MAXQUOTAS 2
+#endif
+
 #define USRQUOTA  0		/* element used for user quotas */
 #define GRPQUOTA  1		/* element used for group quotas */
+#define PRJQUOTA  2		/* element used for project quotas */
 
 /*
  * Definitions for the default names of the quotas files.
@@ -48,6 +54,7 @@
 #define INITQFNAMES { \
 	"user",    /* USRQUOTA */ \
 	"group",   /* GRPQUOTA */ \
+	"project",  /* RPJQUOTA */	\
 	"undefined", \
 };
 
-- 
1.7.1

