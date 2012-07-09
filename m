From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/3] Add additional owner identifier
Date: Mon,  9 Jul 2012 19:28:43 +0400
Message-ID: <1341847725-26114-2-git-send-email-dmonakhov@openvz.org>
References: <1341847725-26114-1-git-send-email-dmonakhov@openvz.org>
Cc: jack@suse.cz, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1341847725-26114-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch add subtree inode identifier. Subtree ID may be used as
auxiliary owner specifier in addition to standard uid/gid.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/Kconfig            |    7 +++++++
 fs/quota/dquot.c      |   10 ++++++++++
 fs/quota/quotaio_v2.h |    6 ++++--
 include/linux/fs.h    |    1 +
 include/linux/quota.h |    9 ++++++++-
 include/linux/xattr.h |    3 +++
 6 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index c8554b5..54fc23a 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -60,6 +60,13 @@ config FILE_LOCKING
 	  This option enables standard file locking support, required
           for filesystems like NFS and for the flock() system
           call. Disabling this option saves about 11k.
+config SUBTREE
+	bool "Enable subtree inode identifier"
+	default y
+	help
+	  This option enables subtree inode identifier. Subtree id
+	  may be used as auxiliary owner specifier in addition to
+	  standard uid/gid.
 
 source "fs/notify/Kconfig"
 
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 10cbe84..ebc96c9 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1141,6 +1141,11 @@ static int need_print_warning(struct dquot_warn *warn)
 			return current_fsuid() == warn->w_dq_id;
 		case GRPQUOTA:
 			return in_group_p(warn->w_dq_id);
+		case SBTRQUOTA:
+			/* XXX: Currently there is no way to understand
+			   which subtree this task belonges to, So print
+			   a warn message unconditionally. -dmon */
+			return 1;
 	}
 	return 0;
 }
@@ -1395,6 +1400,11 @@ static void __dquot_initialize(struct inode *inode, int type)
 		case GRPQUOTA:
 			id = inode->i_gid;
 			break;
+		case SBTRQUOTA:
+			if (!inode->i_sb->s_op->get_subtree)
+				continue;
+			id = inode->i_sb->s_op->get_subtree(inode);
+			break;
 		}
 		got[cnt] = dqget(sb, id, cnt);
 	}
diff --git a/fs/quota/quotaio_v2.h b/fs/quota/quotaio_v2.h
index f1966b4..a90bd18 100644
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
+	1		/* SBTRQUOTA */\
 }
 
 /* First generic header */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b0a6d44..2eececc 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1739,6 +1739,7 @@ struct super_operations {
 	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
 	int (*nr_cached_objects)(struct super_block *);
 	void (*free_cached_objects)(struct super_block *, int);
+	u32 (*get_subtree)(const struct inode *inode);
 };
 
 /*
diff --git a/include/linux/quota.h b/include/linux/quota.h
index c09fa04..042f45a 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -36,11 +36,17 @@
 #include <linux/errno.h>
 #include <linux/types.h>
 
-#define __DQUOT_VERSION__	"dquot_6.5.2"
+#define __DQUOT_VERSION__	"dquot_6.6.0"
 
+#ifdef CONFIG_SUBTREE
+#define MAXQUOTAS 3
+#else
 #define MAXQUOTAS 2
+#endif
+
 #define USRQUOTA  0		/* element used for user quotas */
 #define GRPQUOTA  1		/* element used for group quotas */
+#define SBTRQUOTA 2		/* element used for subtree quotas */
 
 /*
  * Definitions for the default names of the quotas files.
@@ -48,6 +54,7 @@
 #define INITQFNAMES { \
 	"user",    /* USRQUOTA */ \
 	"group",   /* GRPQUOTA */ \
+	"subtree", /* SBTRQUOTA */ \
 	"undefined", \
 };
 
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index e5d1220..b0a4d78 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -61,6 +61,9 @@
 
 #include <linux/types.h>
 
+#define XATTR_SUBTREE "system.subtree"
+#define XATTR_SUBTREE_LEN (sizeof(XATTR_SUBTREE))
+
 struct inode;
 struct dentry;
 
-- 
1.7.1

