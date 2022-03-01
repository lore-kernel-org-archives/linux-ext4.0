Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8731C433F5
	for <linux-ext4@archiver.kernel.org>; Tue,  1 Mar 2022 09:21:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233653AbiCAJWb (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 1 Mar 2022 04:22:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233644AbiCAJW1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Mar 2022 04:22:27 -0500
Received: from out199-7.us.a.mail.aliyun.com (out199-7.us.a.mail.aliyun.com [47.90.199.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C3080233;
        Tue,  1 Mar 2022 01:21:45 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R471e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V5w9va4_1646126501;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0V5w9va4_1646126501)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 01 Mar 2022 17:21:41 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     tytso@mit.edu
Cc:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] ext4: Fix ext4_mb_clear_bb() kernel-doc comment
Date:   Tue,  1 Mar 2022 17:21:36 +0800
Message-Id: <20220301092136.34764-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Remove the excess description of @bh in ext4_mb_clear_bb() kernel-doc
comment to remove warnings found by running scripts/kernel-doc, which
is caused by using 'make W=1'.

fs/ext4/mballoc.c:5895: warning: Excess function parameter 'bh'
description in 'ext4_mb_clear_bb'

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 fs/ext4/mballoc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 5f0bc6d0aabe..3546fa27d003 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5884,7 +5884,6 @@ static void ext4_free_blocks_simple(struct inode *inode, ext4_fsblk_t block,
  *			Used by ext4_free_blocks()
  * @handle:		handle for this transaction
  * @inode:		inode
- * @bh:			optional buffer of the block to be freed
  * @block:		starting physical block to be freed
  * @count:		number of blocks to be freed
  * @flags:		flags used by ext4_free_blocks
-- 
2.20.1.7.g153144c

