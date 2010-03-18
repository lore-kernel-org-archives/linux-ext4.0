From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/5] quota: Implement project id support for generic quota
Date: Thu, 18 Mar 2010 17:02:47 +0300
Message-ID: <1268920970-9061-3-git-send-email-dmonakhov@openvz.org>
References: <1268920970-9061-1-git-send-email-dmonakhov@openvz.org>
 <1268920970-9061-2-git-send-email-dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, tytso@mit.edu, adilger@sun.com,
	hch@infradead.org, jack@suse.cz, david@fromorbit.com,
	viro@ZenIV.linux.org.uk, xemul@openvz.org,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:55608 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab0CRODC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Mar 2010 10:03:02 -0400
In-Reply-To: <1268920970-9061-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since all preparation code are already in quota-tree,
So this patch is really small.
---
 fs/quota/dquot.c      |   18 ++++++++++++++++++
 fs/quota/quotaio_v2.h |    6 ++++--
 include/linux/quota.h |   12 +++++++++++-
 3 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index e0b870f..3590888 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1091,6 +1091,11 @@ static int need_print_warning(struct dquot *dquot)
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
@@ -1327,6 +1332,13 @@ static void __dquot_initialize(struct inode *inode, int type)
 		case GRPQUOTA:
 			id = inode->i_gid;
 			break;
+		case PRJQUOTA:
+#ifdef CONFIG_PROJECT_ID
+			id = inode->i_prjid;
+#else
+			BUG_ON(sb_has_quota_loaded(inode->i_sb, PRJQUOTA));
+#endif
+			break;
 		}
 		got[cnt] = dqget(sb, id, cnt);
 	}
@@ -1792,6 +1804,12 @@ int dquot_transfer(struct inode *inode, struct iattr *iattr)
 		mask |= 1 << GRPQUOTA;
 		chid[GRPQUOTA] = iattr->ia_gid;
 	}
+#ifdef CONFIG_PROJECT_ID
+	if (iattr->ia_valid & ATTR_PRJID && iattr->ia_prjid != inode->i_prjid) {
+		mask |= 1 << PRJQUOTA;
+		chid[GRPQUOTA] = iattr->ia_prjid;
+	}
+#endif
 	if (sb_any_quota_active(inode->i_sb) && !IS_NOQUOTA(inode)) {
 		dquot_initialize(inode);
 		return __dquot_transfer(inode, chid, mask);
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
index b462916..73332c5 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -36,18 +36,28 @@
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
 
+#ifdef CONFIG_PROJECT_ID
+#define PRJQUOTA  2		/* element used for project quotas */
+#endif
+
 /*
  * Definitions for the default names of the quotas files.
  */
 #define INITQFNAMES { \
 	"user",    /* USRQUOTA */ \
 	"group",   /* GRPQUOTA */ \
+	"project",  /* RPJQUOTA */	\
 	"undefined", \
 };
 
-- 
1.6.6.1

