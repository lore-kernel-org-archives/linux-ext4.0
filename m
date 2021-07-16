Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AB43C07E95
	for <linux-ext4@archiver.kernel.org>; Fri, 16 Jul 2021 06:19:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D0D861004
	for <linux-ext4@archiver.kernel.org>; Fri, 16 Jul 2021 06:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234686AbhGPGWr (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 16 Jul 2021 02:22:47 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:35080 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234429AbhGPGWr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 16 Jul 2021 02:22:47 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UfwkYU._1626416391;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UfwkYU._1626416391)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 16 Jul 2021 14:19:51 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     viro@zeniv.linux.org.uk
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: [PATCH] vfs: only allow SETFLAGS to set DAX flag on files and dirs
Date:   Fri, 16 Jul 2021 14:19:51 +0800
Message-Id: <20210716061951.81529-1-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This is similar to commit dbc77f31e58b ("vfs: only allow FSSETXATTR to
set DAX flag on files and dirs").

Though the underlying filesystems may have filtered invalid flags, e.g.,
ext4_mask_flags() called in ext4_fileattr_set(), also check it in VFS
layer.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 fs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 1e2204fa9963..1fe73e148e2d 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -835,7 +835,7 @@ static int fileattr_set_prepare(struct inode *inode,
 	 * It is only valid to set the DAX flag on regular files and
 	 * directories on filesystems.
 	 */
-	if ((fa->fsx_xflags & FS_XFLAG_DAX) &&
+	if ((fa->fsx_xflags & FS_XFLAG_DAX || fa->flags & FS_DAX_FL) &&
 	    !(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
 		return -EINVAL;
 
-- 
2.27.0

