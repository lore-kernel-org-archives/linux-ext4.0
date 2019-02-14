Return-Path: <SRS0=5TFS=QV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EF54C10F04
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Feb 2019 10:01:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D98D222A4
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Feb 2019 10:01:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="B5qmejP/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437879AbfBNKBB (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Feb 2019 05:01:01 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35981 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393589AbfBNKBB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Feb 2019 05:01:01 -0500
Received: by mail-pg1-f195.google.com with SMTP id r124so2819171pgr.3
        for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2019 02:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EVYMogBI4jH/67Zve0CCKF3qzn61yTaO8kNdGkw2lp0=;
        b=B5qmejP/7w2oWJWv/oV+8ZrB5ZN6/sze+t3hgFWrfkCM7axsOBafeMe9/ZeE1Vejqe
         oOkE46QjKxER2iUcnFlonsqAt94w6CKsARtz/U4VeGPISvM2VP9V24Y3CvUtwX2PnOhl
         RSUeuGmLajavqOBDi5ZRXL+RM8q/MtTyWdkzZSNc/+X7/1j5rn/J8Hdfw0H9Oh6Ca8z2
         jOJLTa/fgDTVhff6K2+G1uIaRXXtvgbZivToTzeGOKfn1/UBdwK2jTYDDV8z+ycyDnh+
         ASYhZfS4R0LMXt4O2vy9CyoSxtW9WhXeiwwwSyGC0BhavoWWNu8nMKSENkYpf9IXVwIV
         mIpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EVYMogBI4jH/67Zve0CCKF3qzn61yTaO8kNdGkw2lp0=;
        b=rcYZ+oYHS72JYorP1YRnz47fMVu0l7NDTFUTaeGJh2IrLCNxCM5kHMdn0cODDTV4jE
         yEjTebq/GksRfPvS3YwX8h12C9lHq0ykWVCv+Ff8uQE/GWwsZjCdUr0op6PBVuxXJFHj
         MNMhmWj5rqrou6lV71vBrJcoxC/tBgQmuH3T4XHd1S/cGbaqrZCkELh/sGYjxPn1PvOd
         YrGDnBmkGMttJ38hz4xcpsX2IvNWvN5IjVyyW0S93OLRj92ExveXBn2e21OmJRTTancm
         epFMX7bIyxRa7q+FkSf2JoZ75snfsDl6uMIZ9gBhAwhZGz+nAyRtYYe3hTe+3abXnSC+
         9jCw==
X-Gm-Message-State: AHQUAuZ9k4S1cc9jv1XueF467fzLekdnuJkJQCbmwQNvWdsp9y3zf2KV
        IsAZZacyxd67XiS+OGFoWLGEfw==
X-Google-Smtp-Source: AHgI3IYIKRGtWY+ZPKyvM7X4BGw9YR0Xss1EIlbxjpL9e1+gb7kdRN23yFkXwhVxYi1FPJUsq1SPHw==
X-Received: by 2002:a63:7044:: with SMTP id a4mr2852696pgn.359.1550138459914;
        Thu, 14 Feb 2019 02:00:59 -0800 (PST)
Received: from vader.thefacebook.com ([2620:10d:c090:180::1:5849])
        by smtp.gmail.com with ESMTPSA id i184sm2686952pfc.41.2019.02.14.02.00.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 02:00:59 -0800 (PST)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Cc:     kernel-team@fb.com, linux-api@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org
Subject: [RFC PATCH 1/6] fs: add btime to struct iattr
Date:   Thu, 14 Feb 2019 02:00:08 -0800
Message-Id: <338b960e32ae2bebcf45c738af42a979af112e12.1550136164.git.osandov@fb.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1550136164.git.osandov@fb.com>
References: <cover.1550136164.git.osandov@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

Add btime as an attribute that can be updated through notify_change() if
the filesystem supports it, which is indicated by FS_HAS_BTIME in
file_system_type->fs_flags.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/attr.c          | 6 ++++++
 include/linux/fs.h | 4 ++++
 2 files changed, 10 insertions(+)

diff --git a/fs/attr.c b/fs/attr.c
index d22e8187477f..4831ef479951 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -233,6 +233,10 @@ int notify_change(struct dentry * dentry, struct iattr * attr, struct inode **de
 
 	WARN_ON_ONCE(!inode_is_locked(inode));
 
+	if ((ia_valid & ATTR_BTIME) &&
+	    !(inode->i_sb->s_type->fs_flags & FS_HAS_BTIME))
+		return -EOPNOTSUPP;
+
 	if (ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID | ATTR_TIMES_SET)) {
 		if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 			return -EPERM;
@@ -267,6 +271,8 @@ int notify_change(struct dentry * dentry, struct iattr * attr, struct inode **de
 		attr->ia_atime = now;
 	if (!(ia_valid & ATTR_MTIME_SET))
 		attr->ia_mtime = now;
+	if (!(ia_valid & ATTR_BTIME_SET))
+		attr->ia_btime = now;
 	if (ia_valid & ATTR_KILL_PRIV) {
 		error = security_inode_need_killpriv(dentry);
 		if (error < 0)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 29d8e2cfed0e..d66040f7740b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -191,6 +191,8 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 #define ATTR_OPEN	(1 << 15) /* Truncating from open(O_TRUNC) */
 #define ATTR_TIMES_SET	(1 << 16)
 #define ATTR_TOUCH	(1 << 17)
+#define ATTR_BTIME	(1 << 18)
+#define ATTR_BTIME_SET	(1 << 19)
 
 /*
  * Whiteout is represented by a char device.  The following constants define the
@@ -217,6 +219,7 @@ struct iattr {
 	struct timespec64 ia_atime;
 	struct timespec64 ia_mtime;
 	struct timespec64 ia_ctime;
+	struct timespec64 ia_btime;
 
 	/*
 	 * Not an attribute, but an auxiliary info for filesystems wanting to
@@ -2172,6 +2175,7 @@ struct file_system_type {
 #define FS_BINARY_MOUNTDATA	2
 #define FS_HAS_SUBTYPE		4
 #define FS_USERNS_MOUNT		8	/* Can be mounted by userns root */
+#define FS_HAS_BTIME		16	/* Supports getting/setting btime. */
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move() during rename() internally. */
 	struct dentry *(*mount) (struct file_system_type *, int,
 		       const char *, void *);
-- 
2.20.1

