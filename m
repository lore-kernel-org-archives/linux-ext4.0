Return-Path: <SRS0=CWHP=2Q=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01738C2D0DC
	for <linux-ext4@archiver.kernel.org>; Thu, 26 Dec 2019 16:11:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAEF3206CB
	for <linux-ext4@archiver.kernel.org>; Thu, 26 Dec 2019 16:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577376670;
	bh=Ak7xwED13xotGj6sPJ2By4BQDyrKhVvvWNR+j3/UrIk=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=VVAjWEYgaBTc6wOld5DBEVoIFJGkW+tLkwbNzInmvzX1ILawGLUsdxbSFEcTKTyYn
	 OsBv9syr4pyShMpe6+majqb+nO/yfDSXTKBZdwAyioAebWdXXzGaWldCC6y3gDI42A
	 HLugFra8GUln47qgE2uO+fWpHDJUqoAebjh8DptI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbfLZQLK (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 26 Dec 2019 11:11:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:39240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726236AbfLZQLK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 26 Dec 2019 11:11:10 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AFCA206CB;
        Thu, 26 Dec 2019 16:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577376669;
        bh=Ak7xwED13xotGj6sPJ2By4BQDyrKhVvvWNR+j3/UrIk=;
        h=From:To:Cc:Subject:Date:From;
        b=YQTSg56WO/RYoPk669hpjVdAxr/RT3HAvNrVxVV+cdVLYRRgzVYXQGXm6o+VRZiNm
         3uleUGOAlOp3ujU1dxxwh/weWo4X2tvvdtnS4AqpKCbAoraMUvEncnYpROiWO9+0AT
         7b+YvNA7T2Dy7MKHDbzPTd6Z3LXOsjOVM+2EFWV0=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH] ext4: only use fscrypt_zeroout_range() on regular files
Date:   Thu, 26 Dec 2019 10:10:22 -0600
Message-Id: <20191226161022.53490-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

fscrypt_zeroout_range() is only for encrypted regular files, not for
encrypted directories or symlinks.

Fortunately, currently it seems it's never called on non-regular files.
But to be safe ext4 should explicitly check S_ISREG() before calling it.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b8f8afd2e8b2..6586b29e9f2f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -402,7 +402,7 @@ int ext4_issue_zeroout(struct inode *inode, ext4_lblk_t lblk, ext4_fsblk_t pblk,
 {
 	int ret;
 
-	if (IS_ENCRYPTED(inode))
+	if (IS_ENCRYPTED(inode) && S_ISREG(inode->i_mode))
 		return fscrypt_zeroout_range(inode, lblk, pblk, len);
 
 	ret = sb_issue_zeroout(inode->i_sb, pblk, len, GFP_NOFS);
-- 
2.24.1

