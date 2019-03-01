Return-Path: <SRS0=HQ1C=RE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 523B8C10F03
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 14:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 148F020851
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 14:05:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yk+uK0pT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388694AbfCAOF4 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 1 Mar 2019 09:05:56 -0500
Received: from mail-pl1-f169.google.com ([209.85.214.169]:40143 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387836AbfCAOFz (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Mar 2019 09:05:55 -0500
Received: by mail-pl1-f169.google.com with SMTP id bj4so11545795plb.7;
        Fri, 01 Mar 2019 06:05:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=P8HiS/pwCG1KcatP0SEN1rNRrqBk76IDlUChEDsg63o=;
        b=Yk+uK0pTvlJIIl/MleohfN48KSduy/e9/cYC0gRUiLy4+YEseEYJSRChF7dMnhvFEu
         XjnUwXgkv7WTQTGdR++5NuB75OAUpviDhsnYbe8lEYebGLH7Ka5nmWAhD3Ha7ylZsqs5
         +ruR6bPl7rQCcVUPLHDjQ1h0x9ezSS2HtudijXB5PRVZYRR7BhGlP/yw0hSNuH2wWIgl
         +pJW/dfnPYm0TsOjdBd6DodkU3mBhlvNxkMcmg1dWX9LOgHvGuo5ottbuWFsuOoWqGQE
         ZqF8c7bPbDvBFWYcmh+TU8tDCc3ci37Z8jRe/FFj0Wviv/XIjH+fR4k2zxn16+kHnMff
         E1bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=P8HiS/pwCG1KcatP0SEN1rNRrqBk76IDlUChEDsg63o=;
        b=HjKx1a1xX+b16ZZLG9Cm4gOp5Qz9wEdFy+IN+U4hTMYtlIBxS/a2We/8qjADiLGS+B
         rk7jQeB1aNMVwTgk7krcENrtT6zZsPYc6FvRKpOduMZembzKdzbveUhkLOeTXFLvhAHp
         dhcqbziK6xBqwvpe27XbrV2IwaKci41pUK77vwJrHlje4yogiRP+b1IyUiUqFDvV/oWf
         71MCU1YlCPjjyQaNmMC8ZcFoOaI5jMPRxlBdlXaCOH636uN0bcQviB/a4EiShEsGAIrF
         RLa2Kb7BFqDXB214cjBmo9zFZKHR5qdGXJWi/elJa0KVNTpJyVP+KTB91FpPtPlsVp3/
         TDHg==
X-Gm-Message-State: APjAAAVwrG8meFeKVd+mzp113gstEi6D6Foea+XdI+foN3CIUR7RX8eV
        HT4G4w+Hhvc6lEuskt5Kkn+uVtie
X-Google-Smtp-Source: APXvYqwxX4RmpRe2mCMR7O+yQFtL20x8oKLZTnZ1XLx6Pkz+UlxfFKw0EElxTFz7bYGy056Qyu8hfQ==
X-Received: by 2002:a17:902:1101:: with SMTP id d1mr5464458pla.19.1551449154126;
        Fri, 01 Mar 2019 06:05:54 -0800 (PST)
Received: from localhost.localdomain (fs276ec80e.tkyc203.ap.nuro.jp. [39.110.200.14])
        by smtp.gmail.com with ESMTPSA id a184sm12458089pge.68.2019.03.01.06.05.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Mar 2019 06:05:52 -0800 (PST)
From:   Wang Shilong <wangshilong1991@gmail.com>
X-Google-Original-From: Wang Shilong <wshilong1991@gmail.com>
To:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Cc:     lixi@ddn.com, adilger@dilger.ca, Wang Shilong <wshilong@ddn.com>
Subject: [PATCH 1/8] fs: add support to change project ID
Date:   Fri,  1 Mar 2019 23:05:34 +0900
Message-Id: <1551449141-7884-2-git-send-email-wshilong1991@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1551449141-7884-1-git-send-email-wshilong1991@gmail.com>
References: <1551449141-7884-1-git-send-email-wshilong1991@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Wang Shilong <wshilong@ddn.com>

From: Wang Shilong <wshilong@ddn.com>

Currently, Filesystem use FS_IOC_FS_SETXATTR ioctl
to change project ID of file. However we don't
support ioctl on symlink files, and it is desirable
to change symlink files' project ID just like uid/gid.

This patch try to reuse existed interface fchownat(),
use group id to set project ID if flag AT_FCHOWN_PROJID
passed in.

Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
 fs/attr.c                        | 26 ++++++++++++++++++++++++--
 fs/open.c                        | 29 +++++++++++++++++++++++------
 fs/quota/dquot.c                 | 23 +++++++++++++++++++++++
 include/linux/fs.h               |  3 +++
 include/linux/quotaops.h         |  9 +++++++++
 include/uapi/linux/fcntl.h       |  1 +
 tools/include/uapi/linux/fcntl.h |  1 +
 7 files changed, 84 insertions(+), 8 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index d22e8187477f..c6b1c1132c8f 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -85,6 +85,28 @@ int setattr_prepare(struct dentry *dentry, struct iattr *attr)
 	if ((ia_valid & ATTR_GID) && !chgrp_ok(inode, attr->ia_gid))
 		return -EPERM;
 
+	/*
+	 * Project Quota ID state is only allowed to change from within the init
+	 * namespace. Enforce that restriction only if we are trying to change
+	 * the quota ID state. Everything else is allowed in user namespaces.
+	 */
+	if ((ia_valid & ATTR_PROJID) && current_user_ns() != &init_user_ns) {
+		kprojid_t projid;
+		int rc;
+
+		/*
+		 * Filesystem like xfs does't have ->get_projid hook
+		 * should check permission by themselves.
+		 */
+		if (inode->i_sb->dq_op->get_projid) {
+			rc = inode->i_sb->dq_op->get_projid(inode, &projid);
+			if (rc)
+				return rc;
+			if (!projid_eq(projid, attr->ia_projid))
+				return -EPERM;
+		}
+	}
+
 	/* Make sure a caller can chmod. */
 	if (ia_valid & ATTR_MODE) {
 		if (!inode_owner_or_capable(inode))
@@ -232,8 +254,8 @@ int notify_change(struct dentry * dentry, struct iattr * attr, struct inode **de
 	unsigned int ia_valid = attr->ia_valid;
 
 	WARN_ON_ONCE(!inode_is_locked(inode));
-
-	if (ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID | ATTR_TIMES_SET)) {
+	if (ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID | ATTR_PROJID |
+			ATTR_TIMES_SET)) {
 		if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 			return -EPERM;
 	}
diff --git a/fs/open.c b/fs/open.c
index 0285ce7dbd51..4e58c6ee23b3 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -597,7 +597,8 @@ SYSCALL_DEFINE2(chmod, const char __user *, filename, umode_t, mode)
 	return do_fchmodat(AT_FDCWD, filename, mode);
 }
 
-static int chown_common(const struct path *path, uid_t user, gid_t group)
+static int chown_common(const struct path *path, uid_t user, gid_t group,
+			bool set_project)
 {
 	struct inode *inode = path->dentry->d_inode;
 	struct inode *delegated_inode = NULL;
@@ -605,9 +606,11 @@ static int chown_common(const struct path *path, uid_t user, gid_t group)
 	struct iattr newattrs;
 	kuid_t uid;
 	kgid_t gid;
+	kprojid_t projid;
 
 	uid = make_kuid(current_user_ns(), user);
 	gid = make_kgid(current_user_ns(), group);
+	projid = make_kprojid(current_user_ns(), (projid_t)group);
 
 retry_deleg:
 	newattrs.ia_valid =  ATTR_CTIME;
@@ -620,13 +623,22 @@ static int chown_common(const struct path *path, uid_t user, gid_t group)
 	if (group != (gid_t) -1) {
 		if (!gid_valid(gid))
 			return -EINVAL;
-		newattrs.ia_valid |= ATTR_GID;
-		newattrs.ia_gid = gid;
+		if (!set_project) {
+			newattrs.ia_valid |= ATTR_GID;
+			newattrs.ia_gid = gid;
+		} else {
+			newattrs.ia_valid |= ATTR_PROJID;
+			newattrs.ia_projid = projid;
+		}
+	} else if (set_project) {
+		return -EINVAL;
 	}
 	if (!S_ISDIR(inode->i_mode))
 		newattrs.ia_valid |=
 			ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_KILL_PRIV;
 	inode_lock(inode);
+	if (set_project)
+		gid = make_kgid(current_user_ns(), (gid_t) -1);
 	error = security_path_chown(path, uid, gid);
 	if (!error)
 		error = notify_change(path->dentry, &newattrs, &delegated_inode);
@@ -645,10 +657,15 @@ int do_fchownat(int dfd, const char __user *filename, uid_t user, gid_t group,
 	struct path path;
 	int error = -EINVAL;
 	int lookup_flags;
+	bool set_project = false;
 
-	if ((flag & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH)) != 0)
+	if ((flag & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH |
+		      AT_FCHOWN_PROJID)) != 0)
 		goto out;
 
+	if (flag & AT_FCHOWN_PROJID)
+		set_project = true;
+
 	lookup_flags = (flag & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW;
 	if (flag & AT_EMPTY_PATH)
 		lookup_flags |= LOOKUP_EMPTY;
@@ -659,7 +676,7 @@ int do_fchownat(int dfd, const char __user *filename, uid_t user, gid_t group,
 	error = mnt_want_write(path.mnt);
 	if (error)
 		goto out_release;
-	error = chown_common(&path, user, group);
+	error = chown_common(&path, user, group, set_project);
 	mnt_drop_write(path.mnt);
 out_release:
 	path_put(&path);
@@ -700,7 +717,7 @@ int ksys_fchown(unsigned int fd, uid_t user, gid_t group)
 	if (error)
 		goto out_fput;
 	audit_file(f.file);
-	error = chown_common(&f.file->f_path, user, group);
+	error = chown_common(&f.file->f_path, user, group, false);
 	mnt_drop_write_file(f.file);
 out_fput:
 	fdput(f);
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index fc20e06c56ba..46f39ee87312 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2095,6 +2095,29 @@ int dquot_transfer(struct inode *inode, struct iattr *iattr)
 		}
 		transfer_to[GRPQUOTA] = dquot;
 	}
+
+	if (iattr->ia_valid & ATTR_PROJID) {
+		kprojid_t projid;
+
+		if (!inode->i_sb->dq_op->get_projid)
+			return -ENOTSUPP;
+
+		ret = inode->i_sb->dq_op->get_projid(inode, &projid);
+		if (ret)
+			return ret;
+		if (!projid_eq(iattr->ia_projid, projid)) {
+			dquot = dqget(sb, make_kqid_projid(iattr->ia_projid));
+			if (IS_ERR(dquot)) {
+				if (PTR_ERR(dquot) != -ESRCH) {
+					ret = PTR_ERR(dquot);
+					goto out_put;
+				}
+				dquot = NULL;
+			}
+			transfer_to[PRJQUOTA] = dquot;
+		}
+	}
+
 	ret = __dquot_transfer(inode, transfer_to);
 out_put:
 	dqput_all(transfer_to);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 29d8e2cfed0e..2a878a2b90e3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -37,6 +37,7 @@
 #include <linux/uuid.h>
 #include <linux/errseq.h>
 #include <linux/ioprio.h>
+#include <linux/projid.h>
 
 #include <asm/byteorder.h>
 #include <uapi/linux/fs.h>
@@ -191,6 +192,7 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 #define ATTR_OPEN	(1 << 15) /* Truncating from open(O_TRUNC) */
 #define ATTR_TIMES_SET	(1 << 16)
 #define ATTR_TOUCH	(1 << 17)
+#define ATTR_PROJID	(1 << 18)
 
 /*
  * Whiteout is represented by a char device.  The following constants define the
@@ -213,6 +215,7 @@ struct iattr {
 	umode_t		ia_mode;
 	kuid_t		ia_uid;
 	kgid_t		ia_gid;
+	kprojid_t	ia_projid;
 	loff_t		ia_size;
 	struct timespec64 ia_atime;
 	struct timespec64 ia_mtime;
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index dc905a4ff8d7..84d3aeb43e2c 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -22,6 +22,15 @@ static inline struct quota_info *sb_dqopt(struct super_block *sb)
 /* i_mutex must being held */
 static inline bool is_quota_modification(struct inode *inode, struct iattr *ia)
 {
+	if (ia->ia_valid & ATTR_PROJID && inode->i_sb->dq_op->get_projid) {
+		kprojid_t projid;
+		int rc;
+
+		rc = inode->i_sb->dq_op->get_projid(inode, &projid);
+		if (!rc && !projid_eq(projid, ia->ia_projid))
+			return true;
+	}
+
 	return (ia->ia_valid & ATTR_SIZE && ia->ia_size != inode->i_size) ||
 		(ia->ia_valid & ATTR_UID && !uid_eq(ia->ia_uid, inode->i_uid)) ||
 		(ia->ia_valid & ATTR_GID && !gid_eq(ia->ia_gid, inode->i_gid));
diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
index 6448cdd9a350..712c60d7f727 100644
--- a/include/uapi/linux/fcntl.h
+++ b/include/uapi/linux/fcntl.h
@@ -90,5 +90,6 @@
 #define AT_STATX_FORCE_SYNC	0x2000	/* - Force the attributes to be sync'd with the server */
 #define AT_STATX_DONT_SYNC	0x4000	/* - Don't sync attributes with the server */
 
+#define AT_FCHOWN_PROJID	0x40000000 /* Change project ID instead of group id */
 
 #endif /* _UAPI_LINUX_FCNTL_H */
diff --git a/tools/include/uapi/linux/fcntl.h b/tools/include/uapi/linux/fcntl.h
index 6448cdd9a350..712c60d7f727 100644
--- a/tools/include/uapi/linux/fcntl.h
+++ b/tools/include/uapi/linux/fcntl.h
@@ -90,5 +90,6 @@
 #define AT_STATX_FORCE_SYNC	0x2000	/* - Force the attributes to be sync'd with the server */
 #define AT_STATX_DONT_SYNC	0x4000	/* - Don't sync attributes with the server */
 
+#define AT_FCHOWN_PROJID	0x40000000 /* Change project ID instead of group id */
 
 #endif /* _UAPI_LINUX_FCNTL_H */
-- 
2.19.1

