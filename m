Return-Path: <SRS0=HQ1C=RE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E34CFC43381
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 14:06:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B09FF20851
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 14:06:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tU1wb65W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388701AbfCAOF7 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 1 Mar 2019 09:05:59 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40254 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387836AbfCAOF6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Mar 2019 09:05:58 -0500
Received: by mail-pg1-f194.google.com with SMTP id u9so11500378pgo.7;
        Fri, 01 Mar 2019 06:05:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dWZB+q6W6k3q14qYvq1GaOP2EZmB/ZM9cMIANHKAgk4=;
        b=tU1wb65WuMD5wE6rWsc4MLw2R8YQOYYFA+oB2PqQe0NyxIoIbz8WaxKiJAnBm9TS0L
         Cho4VAqqbXD0b28VBKrLFlbF93CHV5HU8YJOCGFr2pFX9n87t/5ctxI7U6wGxS7dkSF9
         xcdKDzdRyjPClqjF07+CSg/VnhhMnUzzrPTB50ojMXNjIzVyJ+Naepw0jEiQ2641Z9ic
         iMIuij6ddMhn+BHMwAE9/kC3TwpNK6XemFavDRZ/D65YF1ycyLTEx+3VU1+dUHI/OiG2
         yDPCm4feJ/lWaAsDBLAkoOoipVsbbdqkAH/jDTCHi1URM/xWktp0+lJE9Kfhs4FuIa6+
         DVDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dWZB+q6W6k3q14qYvq1GaOP2EZmB/ZM9cMIANHKAgk4=;
        b=mPYeOSH0NazLECYdmK39hYq+gSvsirQyazLixoQrbWjWd6w/T0mZookh/5xbft9yJM
         nthNLrwH0gjGqzafnYGLXG+kbviNQvO4lj3hfVeZgkNHAiBy45bPRfG3+hf8LCR36xV5
         ksBSO3eoAKZ/b/iuC49WBPHOE8VA7PDZOjn82xFw7Kw7xxBt1ip4QtVjvd0jJjf/MoH0
         aYf6jecdFBG9PGgB6hMi1riBdrkceaANK88s4/wXFZl3nbOUZFxld0M3w5RCU0x9wOtQ
         be5E7Z6vLwCcBo0CXr3FHjCS3Sx0xBPASKYsuKKstu6ORRNevgdOP44ghpRwDQ0tSkHm
         TSVw==
X-Gm-Message-State: APjAAAW2UUzHppoVZhobV9UoiKAGpkV3UkANqfWJiJPO1hqgpBsV4KWz
        r7wZ4PdPS2M1oKNZU0R1w7Wqq4ZH
X-Google-Smtp-Source: APXvYqzNd1nxNy+yoPlwDYHBTnB0/p0OgCiyliUIihR1WzV7iQQL36ZDA0RNmEucWkhz8XzfHj4+/g==
X-Received: by 2002:a63:6985:: with SMTP id e127mr4978637pgc.101.1551449156746;
        Fri, 01 Mar 2019 06:05:56 -0800 (PST)
Received: from localhost.localdomain (fs276ec80e.tkyc203.ap.nuro.jp. [39.110.200.14])
        by smtp.gmail.com with ESMTPSA id a184sm12458089pge.68.2019.03.01.06.05.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Mar 2019 06:05:55 -0800 (PST)
From:   Wang Shilong <wangshilong1991@gmail.com>
X-Google-Original-From: Wang Shilong <wshilong1991@gmail.com>
To:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Cc:     lixi@ddn.com, adilger@dilger.ca, Wang Shilong <wshilong@ddn.com>
Subject: [PATCH 2/8] ext4: support project ID in ext4_setattr()
Date:   Fri,  1 Mar 2019 23:05:35 +0900
Message-Id: <1551449141-7884-3-git-send-email-wshilong1991@gmail.com>
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
 fs/ext4/inode.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 34d7e0703cc6..b6c451407dcd 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5537,10 +5537,12 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 			return error;
 	}
 	if ((ia_valid & ATTR_UID && !uid_eq(attr->ia_uid, inode->i_uid)) ||
-	    (ia_valid & ATTR_GID && !gid_eq(attr->ia_gid, inode->i_gid))) {
+	    (ia_valid & ATTR_GID && !gid_eq(attr->ia_gid, inode->i_gid)) ||
+	    (ia_valid & ATTR_PROJID && !projid_eq(attr->ia_projid,
+						  EXT4_I(inode)->i_projid))) {
 		handle_t *handle;
 
-		/* (user+group)*(old+new) structure, inode write (sb,
+		/* (user+group+project)*(old+new) structure, inode write (sb,
 		 * inode block, ? - but truncate inode update has it) */
 		handle = ext4_journal_start(inode, EXT4_HT_QUOTA,
 			(EXT4_MAXQUOTAS_INIT_BLOCKS(inode->i_sb) +
@@ -5567,6 +5569,8 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 			inode->i_uid = attr->ia_uid;
 		if (attr->ia_valid & ATTR_GID)
 			inode->i_gid = attr->ia_gid;
+		if (attr->ia_valid & ATTR_PROJID)
+			EXT4_I(inode)->i_projid = attr->ia_projid;
 		error = ext4_mark_inode_dirty(handle, inode);
 		ext4_journal_stop(handle);
 	}
-- 
2.19.1

