Return-Path: <SRS0=HQ1C=RE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E6ADC43381
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 14:06:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D6BE20850
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 14:06:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SX+uNue+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388715AbfCAOGD (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 1 Mar 2019 09:06:03 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40261 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387836AbfCAOGD (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Mar 2019 09:06:03 -0500
Received: by mail-pg1-f193.google.com with SMTP id u9so11500508pgo.7;
        Fri, 01 Mar 2019 06:06:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kiBqi2ro6Was0nH/4v7l9Y+bERxMStLUscG8eBAQsj0=;
        b=SX+uNue+3ebwSjAa8BHgXn7OCuuRd2C160dkvB2QZ2uv35fJB5FBoVHLB2LcgjC/IK
         cHVvC6reRpMh9h07ewIGOuvZjaCo2AJSnpWA42M/XJiNt1IdznUL7QeI1zAr9p5R1Qzp
         7/xfc1tzsww/vSdr9jPDUzx6LpM7OHiC7gVhL0kv7C49UpKcSHmE3r4XlZaZaazYrsuc
         TlyVZsHfpz/S2z/buBML3Po/SwNqyevjFPayjYVMYZIyMRixkwgzP8voMVACoWn8iDuU
         q96kMuMYcAxIGT6jgJkyM3+gFZUhMwvA94uVOXhOA7XaYLSd7IIfH9/x9O5DHX4wxbvZ
         UZqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kiBqi2ro6Was0nH/4v7l9Y+bERxMStLUscG8eBAQsj0=;
        b=TAXmB5q9tctpFFKPYpxo9sWhvvwkln6vDvHgYWutLaVwsHWGSfnOsAZUu5Tfz6+2hJ
         dbxLXUguQ7wp+S1U8c0/z/Y1A8Y087Dc3SzSC9gPXKolg7kncJy8CecIFk06CpqJFUW1
         Gkd82IZQU2WLriEDjV4U/mYFHdYtJH9a3ckWE7Lo+AWJc89Nv/hryZ7BIHs/OeiwlCG/
         fShglYdd51t6KN9SpIhx6R9wrRCy3YLzfpcxHrchSmbSrMqD6pIXVqb8KwzBu0SjbXyq
         BDiuuI+cn4I/6vs6sOGfZp4/BSNwpFOQXVhtr4L3Irx9VYceIsF/5nDi6P+hu1ZH9yP/
         6vdg==
X-Gm-Message-State: APjAAAXBBOifXW8A+qtFIpPRQ0fUsCz5CcH+51HsnB0r8TbvIbeA1dc1
        Lf5t6h4VAaqo428hgVKwlRHz9u5L
X-Google-Smtp-Source: APXvYqxs83m9fgN5dV2CJgXI6uEH5sRmWf0fOcCVY44WdZLR4d1IKMN20N8XkCRMTTljsoiAjTyYCQ==
X-Received: by 2002:a62:be08:: with SMTP id l8mr5659352pff.162.1551449161625;
        Fri, 01 Mar 2019 06:06:01 -0800 (PST)
Received: from localhost.localdomain (fs276ec80e.tkyc203.ap.nuro.jp. [39.110.200.14])
        by smtp.gmail.com with ESMTPSA id a184sm12458089pge.68.2019.03.01.06.05.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Mar 2019 06:06:00 -0800 (PST)
From:   Wang Shilong <wangshilong1991@gmail.com>
X-Google-Original-From: Wang Shilong <wshilong1991@gmail.com>
To:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Cc:     lixi@ddn.com, adilger@dilger.ca, Wang Shilong <wshilong@ddn.com>
Subject: [PATCH 4/8] xfs: support project ID in xfs_setattr()
Date:   Fri,  1 Mar 2019 23:05:37 +0900
Message-Id: <1551449141-7884-5-git-send-email-wshilong1991@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1551449141-7884-1-git-send-email-wshilong1991@gmail.com>
References: <1551449141-7884-1-git-send-email-wshilong1991@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Wang Shilong <wshilong@ddn.com>

From: Wang Shilong <wshilong@ddn.com>

Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
 fs/xfs/xfs_iops.c  | 51 +++++++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_linux.h | 10 +++++++++
 2 files changed, 51 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index f48ffd7a8d3e..c10466fe6ed4 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -589,7 +589,8 @@ xfs_vn_change_ok(
 	struct dentry	*dentry,
 	struct iattr	*iattr)
 {
-	struct xfs_mount	*mp = XFS_I(d_inode(dentry))->i_mount;
+	struct xfs_inode	*ip = XFS_I(d_inode(dentry));
+	struct xfs_mount	*mp = ip->i_mount;
 
 	if (mp->m_flags & XFS_MOUNT_RDONLY)
 		return -EROFS;
@@ -597,6 +598,13 @@ xfs_vn_change_ok(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
+	 if ((iattr->ia_valid & ATTR_PROJID) &&
+	     current_user_ns() != &init_user_ns) {
+		if (!projid_eq(xfs_projid_to_kprojid(xfs_get_projid(ip)),
+			       iattr->ia_projid))
+			return -EPERM;
+	}
+
 	return setattr_prepare(dentry, iattr);
 }
 
@@ -619,8 +627,10 @@ xfs_setattr_nonsize(
 	int			error;
 	kuid_t			uid = GLOBAL_ROOT_UID, iuid = GLOBAL_ROOT_UID;
 	kgid_t			gid = GLOBAL_ROOT_GID, igid = GLOBAL_ROOT_GID;
-	struct xfs_dquot	*udqp = NULL, *gdqp = NULL;
+	kprojid_t		projid, iprojid;
+	struct xfs_dquot	*udqp = NULL, *gdqp = NULL, *pdqp = NULL;
 	struct xfs_dquot	*olddquot1 = NULL, *olddquot2 = NULL;
+	struct xfs_dquot	*olddquot3 = NULL;
 
 	ASSERT((mask & ATTR_SIZE) == 0);
 
@@ -632,7 +642,7 @@ xfs_setattr_nonsize(
 	 * If the IDs do change before we take the ilock, we're covered
 	 * because the i_*dquot fields will get updated anyway.
 	 */
-	if (XFS_IS_QUOTA_ON(mp) && (mask & (ATTR_UID|ATTR_GID))) {
+	if (XFS_IS_QUOTA_ON(mp) && (mask & (ATTR_UID|ATTR_GID|ATTR_PROJID))) {
 		uint	qflags = 0;
 
 		if ((mask & ATTR_UID) && XFS_IS_UQUOTA_ON(mp)) {
@@ -647,18 +657,25 @@ xfs_setattr_nonsize(
 		}  else {
 			gid = inode->i_gid;
 		}
+		if ((mask & ATTR_PROJID) && XFS_IS_PQUOTA_ON(mp)) {
+			projid = iattr->ia_projid;
+			qflags |= XFS_QMOPT_PQUOTA;
+		}  else {
+			projid = xfs_projid_to_kprojid(xfs_get_projid(ip));
+		}
 
 		/*
-		 * We take a reference when we initialize udqp and gdqp,
+		 * We take a reference when we initialize udqp,gdqp and pdqp,
 		 * so it is important that we never blindly double trip on
 		 * the same variable. See xfs_create() for an example.
 		 */
 		ASSERT(udqp == NULL);
 		ASSERT(gdqp == NULL);
+		ASSERT(pdqp == NULL);
 		error = xfs_qm_vop_dqalloc(ip, xfs_kuid_to_uid(uid),
 					   xfs_kgid_to_gid(gid),
-					   xfs_get_projid(ip),
-					   qflags, &udqp, &gdqp, NULL);
+					   xfs_kprojid_to_projid(projid),
+					   qflags, &udqp, &gdqp, &pdqp);
 		if (error)
 			return error;
 	}
@@ -673,7 +690,7 @@ xfs_setattr_nonsize(
 	/*
 	 * Change file ownership.  Must be the owner or privileged.
 	 */
-	if (mask & (ATTR_UID|ATTR_GID)) {
+	if (mask & (ATTR_UID|ATTR_GID|ATTR_PROJID)) {
 		/*
 		 * These IDs could have changed since we last looked at them.
 		 * But, we're assured that if the ownership did change
@@ -682,8 +699,10 @@ xfs_setattr_nonsize(
 		 */
 		iuid = inode->i_uid;
 		igid = inode->i_gid;
+		iprojid = xfs_projid_to_kprojid(xfs_get_projid(ip));
 		gid = (mask & ATTR_GID) ? iattr->ia_gid : igid;
 		uid = (mask & ATTR_UID) ? iattr->ia_uid : iuid;
+		projid = (mask & ATTR_PROJID) ? iattr->ia_projid : iprojid;
 
 		/*
 		 * Do a quota reservation only if uid/gid is actually
@@ -691,10 +710,11 @@ xfs_setattr_nonsize(
 		 */
 		if (XFS_IS_QUOTA_RUNNING(mp) &&
 		    ((XFS_IS_UQUOTA_ON(mp) && !uid_eq(iuid, uid)) ||
-		     (XFS_IS_GQUOTA_ON(mp) && !gid_eq(igid, gid)))) {
+		     (XFS_IS_GQUOTA_ON(mp) && !gid_eq(igid, gid)) ||
+		     (XFS_IS_PQUOTA_ON(mp) && !projid_eq(iprojid, projid)))) {
 			ASSERT(tp);
 			error = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
-						NULL, capable(CAP_FOWNER) ?
+						pdqp, capable(CAP_FOWNER) ?
 						XFS_QMOPT_FORCE_RES : 0);
 			if (error)	/* out of quota */
 				goto out_cancel;
@@ -704,7 +724,7 @@ xfs_setattr_nonsize(
 	/*
 	 * Change file ownership.  Must be the owner or privileged.
 	 */
-	if (mask & (ATTR_UID|ATTR_GID)) {
+	if (mask & (ATTR_UID|ATTR_GID|ATTR_PROJID)) {
 		/*
 		 * CAP_FSETID overrides the following restrictions:
 		 *
@@ -741,6 +761,15 @@ xfs_setattr_nonsize(
 			ip->i_d.di_gid = xfs_kgid_to_gid(gid);
 			inode->i_gid = gid;
 		}
+		if (!projid_eq(iprojid, projid)) {
+			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp)) {
+				ASSERT(mask & ATTR_PROJID);
+				ASSERT(pdqp);
+				olddquot3 = xfs_qm_vop_chown(tp, ip,
+							&ip->i_pdquot, pdqp);
+			}
+			xfs_set_projid(ip, xfs_kprojid_to_projid(projid));
+		}
 	}
 
 	if (mask & ATTR_MODE)
@@ -763,8 +792,10 @@ xfs_setattr_nonsize(
 	 */
 	xfs_qm_dqrele(olddquot1);
 	xfs_qm_dqrele(olddquot2);
+	xfs_qm_dqrele(olddquot3);
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
+	xfs_qm_dqrele(pdqp);
 
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index edbd5a210df2..80f5ea32823d 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -191,6 +191,16 @@ static inline kgid_t xfs_gid_to_kgid(uint32_t gid)
 	return make_kgid(&init_user_ns, gid);
 }
 
+static inline uint32_t xfs_kprojid_to_projid(kprojid_t projid)
+{
+	return from_kprojid(&init_user_ns, projid);
+}
+
+static inline kprojid_t xfs_projid_to_kprojid(uint32_t projid)
+{
+	return make_kprojid(&init_user_ns, projid);
+}
+
 static inline dev_t xfs_to_linux_dev_t(xfs_dev_t dev)
 {
 	return MKDEV(sysv_major(dev) & 0x1ff, sysv_minor(dev));
-- 
2.19.1

