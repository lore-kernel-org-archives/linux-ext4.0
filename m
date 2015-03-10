From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH RFC v2 3/6] quota: generic project quota
Date: Tue, 10 Mar 2015 20:22:08 +0300
Message-ID: <20150310172208.23081.41784.stgit@buzz>
References: <20150310171133.23081.49616.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	Andy Lutomirski <luto@amacapital.net>,
	linux-kernel@vger.kernel.org, Li Xi <pkuelelixi@gmail.com>
To: linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150310171133.23081.49616.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch adds infrastructure for project quotas in generic vfs quota.

User can query current usage and limits for all projects mapped into current
user-namespace. Changing limits requires CAP_SYS_ADMIN in init user-namespace.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 fs/quota/dquot.c           |   33 +++++++++++++++++++++++++++++++--
 fs/quota/quota.c           |    8 ++++++--
 fs/quota/quotaio_v2.h      |    6 ++++--
 include/linux/quota.h      |    1 +
 include/linux/quotaops.h   |    1 +
 include/uapi/linux/quota.h |    6 ++++--
 6 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 0ccd4ba3a246..04c27cdeca05 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1159,8 +1159,8 @@ static int need_print_warning(struct dquot_warn *warn)
 			return uid_eq(current_fsuid(), warn->w_dq_id.uid);
 		case GRPQUOTA:
 			return in_group_p(warn->w_dq_id.gid);
-		case PRJQUOTA:	/* Never taken... Just make gcc happy */
-			return 0;
+		case PRJQUOTA:
+			return 1;
 	}
 	return 0;
 }
@@ -1418,6 +1418,13 @@ static void __dquot_initialize(struct inode *inode, int type)
 		case GRPQUOTA:
 			qid = make_kqid_gid(inode->i_gid);
 			break;
+		case PRJQUOTA:
+			if (sb->s_op->get_project)
+				qid = make_kqid_projid(sb->s_op->
+						get_project(inode));
+			else
+				qid = make_kqid_invalid(PRJQUOTA);
+			break;
 		}
 		got[cnt] = dqget(sb, qid);
 	}
@@ -1951,6 +1958,24 @@ int dquot_transfer(struct inode *inode, struct iattr *iattr)
 EXPORT_SYMBOL(dquot_transfer);
 
 /*
+ * Helper function for transferring inode into another project.
+ */
+int dquot_transfer_project(struct inode *inode, kprojid_t projid)
+{
+	struct dquot *transfer_to[MAXQUOTAS] = {};
+	struct super_block *sb = inode->i_sb;
+	int ret;
+
+	if (!sb_has_quota_active(sb, PRJQUOTA))
+		return 0;
+	transfer_to[PRJQUOTA] = dqget(sb, make_kqid_projid(projid));
+	ret = __dquot_transfer(inode, transfer_to);
+	dqput_all(transfer_to);
+	return ret;
+}
+EXPORT_SYMBOL(dquot_transfer_project);
+
+/*
  * Write info of quota file to disk
  */
 int dquot_commit_info(struct super_block *sb, int type)
@@ -2165,6 +2190,10 @@ static int vfs_load_quota_inode(struct inode *inode, int type, int format_id,
 		error = -EINVAL;
 		goto out_fmt;
 	}
+	if (type == PRJQUOTA && !sb->s_op->get_project) {
+		error = -EINVAL;
+		goto out_fmt;
+	}
 	/* Usage always has to be set... */
 	if (!(flags & DQUOT_USAGE_ENABLED)) {
 		error = -EINVAL;
diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index d14a799c7785..0acd1bb4bafd 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -30,11 +30,15 @@ static int check_quotactl_permission(struct super_block *sb, int type, int cmd,
 	case Q_XGETQSTATV:
 	case Q_XQUOTASYNC:
 		break;
-	/* allow to query information for dquots we "own" */
+	/*
+	 * Allow to query information for user/group dquots we "own".
+	 * Allow querying project quota present in our user-namespace.
+	 */
 	case Q_GETQUOTA:
 	case Q_XGETQUOTA:
 		if ((type == USRQUOTA && uid_eq(current_euid(), make_kuid(current_user_ns(), id))) ||
-		    (type == GRPQUOTA && in_egroup_p(make_kgid(current_user_ns(), id))))
+		    (type == GRPQUOTA && in_egroup_p(make_kgid(current_user_ns(), id))) ||
+		    (type == PRJQUOTA && projid_valid(make_kprojid(current_user_ns(), id))))
 			break;
 		/*FALLTHROUGH*/
 	default:
diff --git a/fs/quota/quotaio_v2.h b/fs/quota/quotaio_v2.h
index f1966b42c2fd..4e95430093d9 100644
--- a/fs/quota/quotaio_v2.h
+++ b/fs/quota/quotaio_v2.h
@@ -13,12 +13,14 @@
  */
 #define V2_INITQMAGICS {\
 	0xd9c01f11,	/* USRQUOTA */\
-	0xd9c01927	/* GRPQUOTA */\
+	0xd9c01927,	/* GRPQUOTA */\
+	0xd9c03f14,	/* PRJQUOTA */\
 }
 
 #define V2_INITQVERSIONS {\
 	1,		/* USRQUOTA */\
-	1		/* GRPQUOTA */\
+	1,		/* GRPQUOTA */\
+	1,		/* PRJQUOTA */\
 }
 
 /* First generic header */
diff --git a/include/linux/quota.h b/include/linux/quota.h
index d534e8ed308a..8bad159a268b 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -50,6 +50,7 @@
 
 #undef USRQUOTA
 #undef GRPQUOTA
+#undef PRJQUOTA
 enum quota_type {
 	USRQUOTA = 0,		/* element used for user quotas */
 	GRPQUOTA = 1,		/* element used for group quotas */
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index df73258cca47..ba54745fe408 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -104,6 +104,7 @@ int dquot_set_dqblk(struct super_block *sb, struct kqid id,
 
 int __dquot_transfer(struct inode *inode, struct dquot **transfer_to);
 int dquot_transfer(struct inode *inode, struct iattr *iattr);
+int dquot_transfer_project(struct inode *inode, kprojid_t projid);
 
 static inline struct mem_dqinfo *sb_dqinfo(struct super_block *sb, int type)
 {
diff --git a/include/uapi/linux/quota.h b/include/uapi/linux/quota.h
index 1f49b8341c99..9c95b2c1c88a 100644
--- a/include/uapi/linux/quota.h
+++ b/include/uapi/linux/quota.h
@@ -36,11 +36,12 @@
 #include <linux/errno.h>
 #include <linux/types.h>
 
-#define __DQUOT_VERSION__	"dquot_6.5.2"
+#define __DQUOT_VERSION__	"dquot_6.6.0"
 
-#define MAXQUOTAS 2
+#define MAXQUOTAS 3
 #define USRQUOTA  0		/* element used for user quotas */
 #define GRPQUOTA  1		/* element used for group quotas */
+#define PRJQUOTA  2		/* element used for project quotas */
 
 /*
  * Definitions for the default names of the quotas files.
@@ -48,6 +49,7 @@
 #define INITQFNAMES { \
 	"user",    /* USRQUOTA */ \
 	"group",   /* GRPQUOTA */ \
+	"project", /* PRJQUOTA */ \
 	"undefined", \
 };
 
