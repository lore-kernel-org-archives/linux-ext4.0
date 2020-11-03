Return-Path: <SRS0=y36c=EJ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2649C00A89
	for <linux-ext4@archiver.kernel.org>; Tue,  3 Nov 2020 02:29:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AE262067C
	for <linux-ext4@archiver.kernel.org>; Tue,  3 Nov 2020 02:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725968AbgKCC3F (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 2 Nov 2020 21:29:05 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:45787 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725932AbgKCC3F (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Nov 2020 21:29:05 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R301e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UE2tfcu_1604370542;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0UE2tfcu_1604370542)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 03 Nov 2020 10:29:02 +0800
From:   Joseph Qi <joseph.qi@linux.alibaba.com>
To:     Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Cc:     linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Tao Ma <boyu.mt@taobao.com>
Subject: [PATCH] ext4: unlock xattr_sem properly in ext4_inline_data_truncate()
Date:   Tue,  3 Nov 2020 10:29:02 +0800
Message-Id: <1604370542-124630-1-git-send-email-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

It takes xattr_sem to check inline data again but without unlock it
in case not have. So unlock it before return.

Fixes: aef1c8513c1f ("ext4: let ext4_truncate handle inline data correctly")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Tao Ma <boyu.mt@taobao.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ext4/inline.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index caa5147..b41512d 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1880,6 +1880,7 @@ int ext4_inline_data_truncate(struct inode *inode, int *has_inline)
 
 	ext4_write_lock_xattr(inode, &no_expand);
 	if (!ext4_has_inline_data(inode)) {
+		ext4_write_unlock_xattr(inode, &no_expand);
 		*has_inline = 0;
 		ext4_journal_stop(handle);
 		return 0;
-- 
1.8.3.1

