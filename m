From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [PATCH 2/4] quota: add project quota support
Date: Fri, 1 Aug 2014 09:07:15 +0800
Message-ID: <CAPTn0cBCiRD2s_76QeW0=Ai6DUJSjUERi6AOQeE5=yUrt6izQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:50479 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbaHABHQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jul 2014 21:07:16 -0400
Received: by mail-ie0-f176.google.com with SMTP id tr6so4956035ieb.35
        for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2014 18:07:15 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[PATCH 2/4] quota: add project quota support

Enforces project quota limites

This patch adds a new quota type PRJQUOTA for project quota
enforcement.

Signed-off-by: Li Xi <lixi <at> ddn.com>
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
Index: linux.git/fs/quota/dquot.c
===================================================================
--- linux.git.orig/fs/quota/dquot.c
+++ linux.git/fs/quota/dquot.c
@@ -1170,8 +1170,12 @@ static int need_print_warning(struct dqu
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
@@ -1418,6 +1422,10 @@ static void __dquot_initialize(struct in
         got[cnt] = NULL;
         if (type != -1 && cnt != type)
             continue;
+#ifndef CONFIG_QUOTA_PROJECT
+        if (cnt == PRJQUOTA)
+            continue;
+#endif
         switch (cnt) {
         case USRQUOTA:
             qid = make_kqid_uid(inode->i_uid);
@@ -1425,6 +1433,9 @@ static void __dquot_initialize(struct in
         case GRPQUOTA:
             qid = make_kqid_gid(inode->i_gid);
             break;
+        case PRJQUOTA:
+            qid = make_kqid_projid(inode->i_projid);
+            break;
         }
         got[cnt] = dqget(sb, qid);
     }
@@ -1954,6 +1965,8 @@ int dquot_transfer(struct inode *inode,
         transfer_to[USRQUOTA] = dqget(sb, make_kqid_uid(iattr->ia_uid));
     if (iattr->ia_valid & ATTR_GID && !gid_eq(iattr->ia_gid, inode->i_gid))
         transfer_to[GRPQUOTA] = dqget(sb, make_kqid_gid(iattr->ia_gid));
+    if (iattr->ia_valid & ATTR_PROJID && !projid_eq(iattr->ia_projid,
inode->i_projid))
+        transfer_to[PRJQUOTA] = dqget(sb, make_kqid_projid(iattr->ia_projid));

     ret = __dquot_transfer(inode, transfer_to);
     dqput_all(transfer_to);
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
@@ -50,6 +50,7 @@

 #undef USRQUOTA
 #undef GRPQUOTA
+#undef PRJQUOTA
 enum quota_type {
     USRQUOTA = 0,        /* element used for user quotas */
     GRPQUOTA = 1,        /* element used for group quotas */
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
