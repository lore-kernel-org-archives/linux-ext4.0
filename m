Return-Path: <SRS0=5TFS=QV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9D0CC43381
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Feb 2019 10:01:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76C31222A1
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Feb 2019 10:01:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="ndqUsyCP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438148AbfBNKBG (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Feb 2019 05:01:06 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35994 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438126AbfBNKBG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Feb 2019 05:01:06 -0500
Received: by mail-pg1-f194.google.com with SMTP id r124so2819312pgr.3
        for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2019 02:01:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jgcWZgJ1s++4IqkbKKFPdm3Je4rg2/ot9AJodUrt5Dw=;
        b=ndqUsyCPjvFocNdflivCZ4Wr3PJ1duzo3UXDuOmetIZ3nvAAp1R56QH3Hm76rEt2p6
         rtyU1witWlyDxDG3r2zg5/+sfQ9BSTZwCT0WlhzRYXpviNBenLUW2ADuSw5T+W/G5k5l
         FFX6mrPFKUv9mGsqfu1NOyUKsnkz8Uo2z4eYv9NGTpioOoWI1LS6rbWcW382TlaLBpjr
         FSLTe7gJl0E3XPpqb5BOlK/V/ZsEWxYx5WBNQojxn5mgdJGxqDaGYIk2zIhhds5x6bfb
         N1iTTcCL2kmsAtUZ5+/SrDH15J78MWo5TQve/AvU4K3YSZODeqlcuJfNac7GQyRWGJ4c
         l+Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jgcWZgJ1s++4IqkbKKFPdm3Je4rg2/ot9AJodUrt5Dw=;
        b=uMaUBMirC8jfYx6wAjvD1kMfbGXZLEC+Dlo+1vwNEVE3QbIkdI75D3qWgC+r8xDBR6
         +PjvROYqMmS+m66uFOxhW8MmhDq2Y6HI3eDGPL6hB+D2KaBqvr9SERP7H3+//ZzAmeDB
         ORv02A88LE6Iaptic7L39X6PqksVjnCIg4HRrjUIofmvNC7Yn42DE/YyCwBtkHsmun9m
         3DqF9ZtobxiaMzW5qmTbp3nsmzLazm37TZlBWOM/A72qnRWZrMqg+DOsrYswSF93mtXI
         qd/QUGo8PAh1fqmimsxGaFeWtzq8aqwh+NzqMAsAYBYS+wU6UPzBaKwry9zXgaOcb9HU
         feww==
X-Gm-Message-State: AHQUAua/gRqXSjNcF98u98P4VCCbgy/RUZVXW750TWDzPLgkGZCRRCkt
        un2jgbeoeBRGjZdp5CIGALmqtQ==
X-Google-Smtp-Source: AHgI3IZW5aU5aO4ZI8ZDs3ZrKqLPsD9EB4vbxqf6ZbgyCQpgUZc33Rsa9YSKgmB9R7kLoSyhnn3T4g==
X-Received: by 2002:a65:620c:: with SMTP id d12mr2935714pgv.328.1550138465568;
        Thu, 14 Feb 2019 02:01:05 -0800 (PST)
Received: from vader.thefacebook.com ([2620:10d:c090:180::1:5849])
        by smtp.gmail.com with ESMTPSA id i184sm2686952pfc.41.2019.02.14.02.01.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 02:01:04 -0800 (PST)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Cc:     kernel-team@fb.com, linux-api@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org
Subject: [RFC PATCH 5/6] f2fs: add support for setting btime
Date:   Thu, 14 Feb 2019 02:00:12 -0800
Message-Id: <a1e3edfb36b1cc732aa1f6159343ce2562d118d3.1550136164.git.osandov@fb.com>
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

The f2fs inode format includes btime (under the name crtime) if the
feature was enabled at mkfs time.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/f2fs/file.c  | 19 +++++++++++++++----
 fs/f2fs/super.c |  2 +-
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index bba56b39dcc5..6064d3e42987 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -690,17 +690,23 @@ int f2fs_truncate(struct inode *inode)
 	return 0;
 }
 
+static bool f2fs_inode_has_crtime(struct inode *inode)
+{
+	struct f2fs_inode *ri;
+
+	return (f2fs_has_extra_attr(inode) &&
+		f2fs_sb_has_inode_crtime(F2FS_I_SB(inode)) &&
+		F2FS_FITS_IN_INODE(ri, F2FS_I(inode)->i_extra_isize, i_crtime));
+}
+
 int f2fs_getattr(const struct path *path, struct kstat *stat,
 		 u32 request_mask, unsigned int query_flags)
 {
 	struct inode *inode = d_inode(path->dentry);
 	struct f2fs_inode_info *fi = F2FS_I(inode);
-	struct f2fs_inode *ri;
 	unsigned int flags;
 
-	if (f2fs_has_extra_attr(inode) &&
-			f2fs_sb_has_inode_crtime(F2FS_I_SB(inode)) &&
-			F2FS_FITS_IN_INODE(ri, fi->i_extra_isize, i_crtime)) {
+	if (f2fs_inode_has_crtime(inode)) {
 		stat->result_mask |= STATX_BTIME;
 		stat->btime.tv_sec = fi->i_crtime.tv_sec;
 		stat->btime.tv_nsec = fi->i_crtime.tv_nsec;
@@ -770,6 +776,9 @@ int f2fs_setattr(struct dentry *dentry, struct iattr *attr)
 	int err;
 	bool size_changed = false;
 
+	if ((attr->ia_valid & ATTR_BTIME) && !f2fs_inode_has_crtime(inode))
+		return -EOPNOTSUPP;
+
 	if (unlikely(f2fs_cp_error(F2FS_I_SB(inode))))
 		return -EIO;
 
@@ -848,6 +857,8 @@ int f2fs_setattr(struct dentry *dentry, struct iattr *attr)
 	}
 
 	__setattr_copy(inode, attr);
+	if (attr->ia_valid & ATTR_BTIME)
+		F2FS_I(inode)->i_crtime = attr->ia_btime;
 
 	if (attr->ia_valid & ATTR_MODE) {
 		err = posix_acl_chmod(inode, f2fs_get_inode_mode(inode));
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index c46a1d4318d4..e32070c8cb27 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3485,7 +3485,7 @@ static struct file_system_type f2fs_fs_type = {
 	.name		= "f2fs",
 	.mount		= f2fs_mount,
 	.kill_sb	= kill_f2fs_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.fs_flags	= FS_REQUIRES_DEV | FS_HAS_BTIME,
 };
 MODULE_ALIAS_FS("f2fs");
 
-- 
2.20.1

