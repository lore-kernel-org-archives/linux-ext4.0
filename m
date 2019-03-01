Return-Path: <SRS0=HQ1C=RE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F146C4360F
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 14:06:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E260620851
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 14:06:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="exlkfKaa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388710AbfCAOGB (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 1 Mar 2019 09:06:01 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40105 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387836AbfCAOGA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Mar 2019 09:06:00 -0500
Received: by mail-pf1-f195.google.com with SMTP id h1so11485495pfo.7;
        Fri, 01 Mar 2019 06:05:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dNvrqz8W2pGUfo3r5kGYI6TG6CApMjIeNboQwS8ZZkU=;
        b=exlkfKaa5sFT77GYbt5GRit2amWQuXjrWQmz3S0pewNX5P5YykB2fR5qLAi2JFZHLH
         YlIVYFkj9Ep6uPQwCc5HkVuPC3BE7wJ/huD3BmsKx7rf3CViH/GLz16pVhCIwKbeJUHx
         3uSROEfRI8d6PoAFLHe4+5w5CU/0AwlWGgQ1gqA1H4SE6Hoi1Q+SFm5ZYT18C6CGBjFE
         CmvMbR3iAcgtavS9n20AEwjyTeuVz5XTggnKGfAVseHuW0qybuPWL6IiUMOC0x/yFv/p
         egcqN6w9NqIgnM+yppLNv1/e4Yq5sy8pA57amWTFS1xRCaxW7hIlILMw1oqyjq+YdrpD
         Xupg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dNvrqz8W2pGUfo3r5kGYI6TG6CApMjIeNboQwS8ZZkU=;
        b=HuqQc+Zzj6+4tjWPJff8u/VDRINIjIh9Dm6orICsf3n21QKrCca3mOhzN9h7k3dtWQ
         246+ywOQrV4eh+B7pRc+8AjniV6W5KM+t4lIJv/VyKeBCuNzjAgN7qcdkcxrgy/DDSo5
         Kl6d6VmxzbGMhpnuiKwQfozK+C3Nm0bxuhItFKyjhbrj7nnZHTPZ1Qat9LmVpwzuyq2K
         NglS+f3+vpJQQiPLubxoT7P1aMfQ/Fcn5s5w+pOLpXG5/lqzyIjrnt/aq2U/zvvISSuo
         QHN36IreUSGRA39UrVKdCuuH4cEtfQub7e0BKD0SpOAoZa83Ad/Y9RUQIzTgKVkjBjFz
         ZuqA==
X-Gm-Message-State: APjAAAU9bXjAxrqFDSqtGw6eCtQ34pRab+jSDMmihLHrJtPupME+YKRC
        EHeDtYg6LsUVCMStttS3/oh/f9S6
X-Google-Smtp-Source: APXvYqyLaLAUDlXplLOzKyuqdb2QSgRnuNUsPEcmA9Ea68eiHEeuZosC1fFzJBjzU1uif5o8n944Qg==
X-Received: by 2002:a65:4243:: with SMTP id d3mr4986129pgq.56.1551449159212;
        Fri, 01 Mar 2019 06:05:59 -0800 (PST)
Received: from localhost.localdomain (fs276ec80e.tkyc203.ap.nuro.jp. [39.110.200.14])
        by smtp.gmail.com with ESMTPSA id a184sm12458089pge.68.2019.03.01.06.05.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Mar 2019 06:05:58 -0800 (PST)
From:   Wang Shilong <wangshilong1991@gmail.com>
X-Google-Original-From: Wang Shilong <wshilong1991@gmail.com>
To:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Cc:     lixi@ddn.com, adilger@dilger.ca, Wang Shilong <wshilong@ddn.com>
Subject: [PATCH 3/8] f2fs: support project ID in f2fs_setattr()
Date:   Fri,  1 Mar 2019 23:05:36 +0900
Message-Id: <1551449141-7884-4-git-send-email-wshilong1991@gmail.com>
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
 fs/f2fs/file.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index bba56b39dcc5..8eaca056e857 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -789,7 +789,9 @@ int f2fs_setattr(struct dentry *dentry, struct iattr *attr)
 	if ((attr->ia_valid & ATTR_UID &&
 		!uid_eq(attr->ia_uid, inode->i_uid)) ||
 		(attr->ia_valid & ATTR_GID &&
-		!gid_eq(attr->ia_gid, inode->i_gid))) {
+		!gid_eq(attr->ia_gid, inode->i_gid)) ||
+		(attr->ia_valid & ATTR_PROJID &&
+		!projid_eq(attr->ia_projid, F2FS_I(inode)->i_projid))) {
 		f2fs_lock_op(F2FS_I_SB(inode));
 		err = dquot_transfer(inode, attr);
 		if (err) {
@@ -806,6 +808,8 @@ int f2fs_setattr(struct dentry *dentry, struct iattr *attr)
 			inode->i_uid = attr->ia_uid;
 		if (attr->ia_valid & ATTR_GID)
 			inode->i_gid = attr->ia_gid;
+		if (attr->ia_valid & ATTR_PROJID)
+			F2FS_I(inode)->i_projid = attr->ia_projid;
 		f2fs_mark_inode_dirty_sync(inode, true);
 		f2fs_unlock_op(F2FS_I_SB(inode));
 	}
-- 
2.19.1

