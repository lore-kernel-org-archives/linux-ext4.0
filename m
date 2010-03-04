From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/5] quota: Implement project id support for generic quota
Date: Thu,  4 Mar 2010 21:34:34 +0300
Message-ID: <1267727677-11956-3-git-send-email-dmonakhov@openvz.org>
References: <1267727677-11956-1-git-send-email-dmonakhov@openvz.org>
 <1267727677-11956-2-git-send-email-dmonakhov@openvz.org>
Cc: linux-ext4@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1267727677-11956-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Since all preparation code are already in quota-tree,
So this patch is really small.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/quota/dquot.c      |   12 ++++++++++++
 fs/quota/quotaio_v2.h |    6 ++++--
 include/linux/quota.h |   12 +++++++++++-
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 10d021d..3c4838f 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1090,6 +1090,11 @@ static int need_print_warning(struct dquot *dquot)
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
@@ -1322,6 +1327,13 @@ int dquot_initialize(struct inode *inode, int type)
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
index edf34f2..514435f 100644
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
1.6.6

