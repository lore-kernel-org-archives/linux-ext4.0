From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [PATCH v2 1/4] quota: add project quota support
Date: Sat, 9 Aug 2014 00:42:25 +0800
Message-ID: <CAPTn0cArMbcbfdOdmg3oXyDYT+OYPHsB64uXYc1JAKiP67FGuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	viro@zeniv.linux.org.uk, hch@infradead.org, Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:50165 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756435AbaHHQm0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Aug 2014 12:42:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Adds general codes to enforces project quota limites

This patch adds support for a new quota type PRJQUOTA for project quota
enforcement. Also a new method get_projid() is added into dquot_operations
structure.

Signed-off-by: Li Xi <lixi <at> ddn.com>
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
Index: linux.git/fs/quota/dquot.c
===================================================================
--- linux.git.orig/fs/quota/dquot.c
+++ linux.git/fs/quota/dquot.c
@@ -161,6 +161,19 @@ static struct quota_module_name module_n
 /* SLAB cache for dquot structures */
 static struct kmem_cache *dquot_cachep;

+static inline unsigned long compat_qtype2bits(int type)
+{
+#ifdef CONFIG_QUOTA_PROJECT
+    unsigned long qtype_bits = QUOTA_ALL_BIT;
+#else
+    unsigned long qtype_bits = QUOTA_USR_BIT | QUOTA_GRP_BIT;
+#endif
+    if (type != -1) {
+        qtype_bits = 1 << type;
+    }
+    return qtype_bits;
+}
+
 int register_quota_format(struct quota_format_type *fmt)
 {
     spin_lock(&dq_list_lock);
@@ -250,7 +263,8 @@ struct dqstats dqstats;
 EXPORT_SYMBOL(dqstats);

 static qsize_t inode_get_rsv_space(struct inode *inode);
-static void __dquot_initialize(struct inode *inode, int type);
+static void __dquot_initialize(struct inode *inode,
+                   unsigned long qtype_bits);

 static inline unsigned int
 hashfn(const struct super_block *sb, struct kqid qid)
@@ -513,7 +527,8 @@ static inline void do_destroy_dquot(stru
  * just deleted or pruned by prune_icache() (those are not attached to any
  * list) or parallel quotactl call. We have to wait for such users.
  */
-static void invalidate_dquots(struct super_block *sb, int type)
+static void invalidate_dquots(struct super_block *sb,
+                  unsigned long qtype_bits)
 {
     struct dquot *dquot, *tmp;

@@ -522,7 +537,7 @@ restart:
     list_for_each_entry_safe(dquot, tmp, &inuse_list, dq_inuse) {
         if (dquot->dq_sb != sb)
             continue;
-        if (dquot->dq_id.type != type)
+        if (((1 << dquot->dq_id.type) & qtype_bits) == 0)
             continue;
         /* Wait for dquot users */
         if (atomic_read(&dquot->dq_count)) {
@@ -605,7 +620,8 @@ out:
 EXPORT_SYMBOL(dquot_scan_active);

 /* Write all dquot structures to quota files */
-int dquot_writeback_dquots(struct super_block *sb, int type)
+static int __dquot_writeback_dquots(struct super_block *sb,
+                    unsigned long qtype_bits)
 {
     struct list_head *dirty;
     struct dquot *dquot;
@@ -615,7 +631,7 @@ int dquot_writeback_dquots(struct super_

     mutex_lock(&dqopt->dqonoff_mutex);
     for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-        if (type != -1 && cnt != type)
+        if (((1 << cnt) & qtype_bits) == 0)
             continue;
         if (!sb_has_quota_active(sb, cnt))
             continue;
@@ -645,7 +661,7 @@ int dquot_writeback_dquots(struct super_
     }

     for (cnt = 0; cnt < MAXQUOTAS; cnt++)
-        if ((cnt == type || type == -1) && sb_has_quota_active(sb, cnt)
+        if (((1 << cnt) & qtype_bits) && sb_has_quota_active(sb, cnt)
             && info_dirty(&dqopt->info[cnt]))
             sb->dq_op->write_info(sb, cnt);
     dqstats_inc(DQST_SYNCS);
@@ -653,16 +669,23 @@ int dquot_writeback_dquots(struct super_

     return ret;
 }
+
+int dquot_writeback_dquots(struct super_block *sb, int type)
+{
+    unsigned long qtype_bits = compat_qtype2bits(type);
+    return __dquot_writeback_dquots(sb, qtype_bits);
+}
 EXPORT_SYMBOL(dquot_writeback_dquots);

 /* Write all dquot structures to disk and make them visible from userspace */
-int dquot_quota_sync(struct super_block *sb, int type)
+static int __dquot_quota_sync(struct super_block *sb,
+                  unsigned long qtype_bits)
 {
     struct quota_info *dqopt = sb_dqopt(sb);
     int cnt;
     int ret;

-    ret = dquot_writeback_dquots(sb, type);
+    ret = dquot_writeback_dquots(sb, qtype_bits);
     if (ret)
         return ret;
     if (dqopt->flags & DQUOT_QUOTA_SYS_FILE)
@@ -681,7 +704,7 @@ int dquot_quota_sync(struct super_block
      */
     mutex_lock(&dqopt->dqonoff_mutex);
     for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-        if (type != -1 && cnt != type)
+        if (((1 << cnt) & qtype_bits) == 0)
             continue;
         if (!sb_has_quota_active(sb, cnt))
             continue;
@@ -693,6 +716,12 @@ int dquot_quota_sync(struct super_block

     return 0;
 }
+
+int dquot_quota_sync(struct super_block *sb, int type)
+{
+    unsigned long qtype_bits = compat_qtype2bits(type);
+    return __dquot_quota_sync(sb, qtype_bits);
+}
 EXPORT_SYMBOL(dquot_quota_sync);

 static unsigned long
@@ -897,17 +926,18 @@ out:
 }
 EXPORT_SYMBOL(dqget);

-static int dqinit_needed(struct inode *inode, int type)
+static int dqinit_needed(struct inode *inode, unsigned long qtype_bits)
 {
     int cnt;

     if (IS_NOQUOTA(inode))
         return 0;
-    if (type != -1)
-        return !inode->i_dquot[type];
-    for (cnt = 0; cnt < MAXQUOTAS; cnt++)
+    for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
+        if (((1 << cnt) & qtype_bits) == 0)
+            continue;
         if (!inode->i_dquot[cnt])
             return 1;
+    }
     return 0;
 }

@@ -924,7 +954,7 @@ static void add_dquot_ref(struct super_b
         spin_lock(&inode->i_lock);
         if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
             !atomic_read(&inode->i_writecount) ||
-            !dqinit_needed(inode, type)) {
+            !dqinit_needed(inode, 1 << type)) {
             spin_unlock(&inode->i_lock);
             continue;
         }
@@ -937,7 +967,7 @@ static void add_dquot_ref(struct super_b
             reserved = 1;
 #endif
         iput(old_inode);
-        __dquot_initialize(inode, type);
+        __dquot_initialize(inode, 1 << type);

         /*
          * We hold a reference to 'inode' so it couldn't have been
@@ -1170,8 +1200,12 @@ static int need_print_warning(struct dqu
             return uid_eq(current_fsuid(), warn->w_dq_id.uid);
         case GRPQUOTA:
             return in_group_p(warn->w_dq_id.gid);
-        case PRJQUOTA:    /* Never taken... Just make gcc happy */
+        case PRJQUOTA:
+#ifdef CONFIG_QUOTA_PROJECT
+            return 1;
+#else
             return 0;
+#endif
     }
     return 0;
 }
@@ -1400,7 +1434,7 @@ static int dquot_active(const struct ino
  * It is better to call this function outside of any transaction as it
  * might need a lot of space in journal for dquot structure allocation.
  */
-static void __dquot_initialize(struct inode *inode, int type)
+static void __dquot_initialize(struct inode *inode, unsigned long qtype_bits)
 {
     int cnt;
     struct dquot *got[MAXQUOTAS];
@@ -1415,8 +1449,13 @@ static void __dquot_initialize(struct in
     /* First get references to structures we might need. */
     for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
         struct kqid qid;
+#ifdef CONFIG_QUOTA_PROJECT
+        kprojid_t projid;
+        int rc;
+#endif
+
         got[cnt] = NULL;
-        if (type != -1 && cnt != type)
+        if (((1 << cnt) & qtype_bits) == 0)
             continue;
         switch (cnt) {
         case USRQUOTA:
@@ -1425,6 +1464,19 @@ static void __dquot_initialize(struct in
         case GRPQUOTA:
             qid = make_kqid_gid(inode->i_gid);
             break;
+        case PRJQUOTA:
+#ifdef CONFIG_QUOTA_PROJECT
+            /* Project ID is not supported */
+            if (!inode->i_sb->dq_op->get_projid)
+                continue;
+            rc = inode->i_sb->dq_op->get_projid(inode, &projid);
+            if (rc)
+                continue;
+            qid = make_kqid_projid(projid);
+#else
+            continue;
+#endif
+            break;
         }
         got[cnt] = dqget(sb, qid);
     }
@@ -1433,7 +1485,7 @@ static void __dquot_initialize(struct in
     if (IS_NOQUOTA(inode))
         goto out_err;
     for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-        if (type != -1 && cnt != type)
+        if (((1 << cnt) & qtype_bits) == 0)
             continue;
         /* Avoid races with quotaoff() */
         if (!sb_has_quota_active(sb, cnt))
@@ -1464,7 +1516,12 @@ out_err:

 void dquot_initialize(struct inode *inode)
 {
-    __dquot_initialize(inode, -1);
+#ifdef CONFIG_QUOTA_PROJECT
+    unsigned long qtype_bits = QUOTA_ALL_BIT;
+#else
+    unsigned long qtype_bits = QUOTA_USR_BIT | QUOTA_GRP_BIT;
+#endif
+    __dquot_initialize(inode, qtype_bits);
 }
 EXPORT_SYMBOL(dquot_initialize);

@@ -2005,9 +2062,10 @@ int dquot_file_open(struct inode *inode,
 EXPORT_SYMBOL(dquot_file_open);

 /*
- * Turn quota off on a device. type == -1 ==> quotaoff for all types (umount)
+ * Turn quota off on a device. (umount)
  */
-int dquot_disable(struct super_block *sb, int type, unsigned int flags)
+static int __dquot_disable(struct super_block *sb, unsigned long qtype_bits,
+               unsigned int flags)
 {
     int cnt, ret = 0;
     struct quota_info *dqopt = sb_dqopt(sb);
@@ -2034,7 +2092,7 @@ int dquot_disable(struct super_block *sb
     }
     for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
         toputinode[cnt] = NULL;
-        if (type != -1 && cnt != type)
+        if (((1 << cnt) & qtype_bits) == 0)
             continue;
         if (!sb_has_quota_loaded(sb, cnt))
             continue;
@@ -2066,7 +2124,7 @@ int dquot_disable(struct super_block *sb

         /* Note: these are blocking operations */
         drop_dquot_ref(sb, cnt);
-        invalidate_dquots(sb, cnt);
+        invalidate_dquots(sb, 1 << cnt);
         /*
          * Now all dquots should be invalidated, all writes done so we
          * should be only users of the info. No locks needed.
@@ -2136,6 +2194,13 @@ put_inodes:
         }
     return ret;
 }
+int dquot_disable(struct super_block *sb, int type,
+          unsigned int flags)
+{
+    unsigned long qtype_bits = compat_qtype2bits(type);
+    return __dquot_disable(sb, qtype_bits, flags);
+}
+
 EXPORT_SYMBOL(dquot_disable);

 int dquot_quota_off(struct super_block *sb, int type)
@@ -2264,7 +2329,7 @@ out_fmt:
 }

 /* Reenable quotas on remount RW */
-int dquot_resume(struct super_block *sb, int type)
+static int __dquot_resume(struct super_block *sb, unsigned long qtype_bits)
 {
     struct quota_info *dqopt = sb_dqopt(sb);
     struct inode *inode;
@@ -2272,7 +2337,7 @@ int dquot_resume(struct super_block *sb,
     unsigned int flags;

     for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-        if (type != -1 && cnt != type)
+        if (((1 << cnt) & qtype_bits) == 0)
             continue;

         mutex_lock(&dqopt->dqonoff_mutex);
@@ -2298,6 +2363,12 @@ int dquot_resume(struct super_block *sb,

     return ret;
 }
+
+int dquot_resume(struct super_block *sb, int type)
+{
+    unsigned long qtype_bits = compat_qtype2bits(type);
+    return __dquot_resume(sb, qtype_bits);
+}
 EXPORT_SYMBOL(dquot_resume);

 int dquot_quota_on(struct super_block *sb, int type, int format_id,
Index: linux.git/fs/quota/quotaio_v2.h
===================================================================
--- linux.git.orig/fs/quota/quotaio_v2.h
+++ linux.git/fs/quota/quotaio_v2.h
@@ -13,12 +13,14 @@
  */
 #define V2_INITQMAGICS {\
     0xd9c01f11,    /* USRQUOTA */\
-    0xd9c01927    /* GRPQUOTA */\
+    0xd9c01927,    /* GRPQUOTA */\
+    0xd9c03f14    /* PRJQUOTA */\
 }

 #define V2_INITQVERSIONS {\
     1,        /* USRQUOTA */\
-    1        /* GRPQUOTA */\
+    1,        /* GRPQUOTA */\
+    1        /* PRJQUOTA */\
 }

 /* First generic header */
Index: linux.git/include/linux/quota.h
===================================================================
--- linux.git.orig/include/linux/quota.h
+++ linux.git/include/linux/quota.h
@@ -50,12 +50,18 @@

 #undef USRQUOTA
 #undef GRPQUOTA
+#undef PRJQUOTA
 enum quota_type {
     USRQUOTA = 0,        /* element used for user quotas */
     GRPQUOTA = 1,        /* element used for group quotas */
     PRJQUOTA = 2,        /* element used for project quotas */
 };

+#define QUOTA_USR_BIT (1 << USRQUOTA)
+#define QUOTA_GRP_BIT (1 << GRPQUOTA)
+#define QUOTA_PRJ_BIT (1 << PRJQUOTA)
+#define QUOTA_ALL_BIT (QUOTA_USR_BIT | QUOTA_GRP_BIT | QUOTA_PRJ_BIT)
+
 typedef __kernel_uid32_t qid_t; /* Type in which we store ids in memory */
 typedef long long qsize_t;    /* Type in which we store sizes */

@@ -312,6 +318,9 @@ struct dquot_operations {
     /* get reserved quota for delayed alloc, value returned is managed by
      * quota code only */
     qsize_t *(*get_reserved_space) (struct inode *);
+#ifdef CONFIG_QUOTA_PROJECT
+    int (*get_projid) (struct inode *, kprojid_t *);/* Get project ID */
+#endif
 };

 struct path;
Index: linux.git/include/uapi/linux/quota.h
===================================================================
--- linux.git.orig/include/uapi/linux/quota.h
+++ linux.git/include/uapi/linux/quota.h
@@ -36,11 +36,12 @@
 #include <linux/errno.h>
 #include <linux/types.h>

-#define __DQUOT_VERSION__    "dquot_6.5.2"
+#define __DQUOT_VERSION__    "dquot_6.6.0"

-#define MAXQUOTAS 2
+#define MAXQUOTAS 3
 #define USRQUOTA  0        /* element used for user quotas */
 #define GRPQUOTA  1        /* element used for group quotas */
+#define PRJQUOTA  2        /* element used for project quotas */

 /*
  * Definitions for the default names of the quotas files.
@@ -48,6 +49,7 @@
 #define INITQFNAMES { \
     "user",    /* USRQUOTA */ \
     "group",   /* GRPQUOTA */ \
+    "project", /* PRJQUOTA */ \
     "undefined", \
 };

Index: linux.git/fs/quota/Kconfig
===================================================================
--- linux.git.orig/fs/quota/Kconfig
+++ linux.git/fs/quota/Kconfig
@@ -17,6 +17,15 @@ config QUOTA
       with the quota tools. Probably the quota support is only useful for
       multi user systems. If unsure, say N.

+config QUOTA_PROJECT
+    bool "Enable project quota"
+    depends on QUOTA
+    default y
+    help
+      This option enables project inode identifier. Project id
+      may be used as auxiliary owner specifier in addition to
+      standard uid/gid.
+
 config QUOTA_NETLINK_INTERFACE
     bool "Report quota messages through netlink interface"
     depends on QUOTACTL && NET
Index: linux.git/fs/quota/quota.c
===================================================================
--- linux.git.orig/fs/quota/quota.c
+++ linux.git/fs/quota/quota.c
@@ -30,7 +30,10 @@ static int check_quotactl_permission(str
     case Q_XGETQSTATV:
     case Q_XQUOTASYNC:
         break;
-    /* allow to query information for dquots we "own" */
+    /*
+     * allow to query information for dquots we "own"
+     * always allow quota check for project quota
+     */
     case Q_GETQUOTA:
     case Q_XGETQUOTA:
         if ((type == USRQUOTA && uid_eq(current_euid(),
make_kuid(current_user_ns(), id))) ||
