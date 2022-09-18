Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A4C3C32771
	for <linux-ext4@archiver.kernel.org>; Sun, 18 Sep 2022 11:52:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbiIRLwc (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 18 Sep 2022 07:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiIRLwa (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Sep 2022 07:52:30 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15F02716B
        for <linux-ext4@vger.kernel.org>; Sun, 18 Sep 2022 04:52:28 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663501947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=oVBZfho8PdQ5yA76guiErK3yYPbS35fkQsCtJXulPpk=;
        b=qGV0ipi+KqIDXHkE/ASDNaeg8/QvY0osojQP2jsv2mBgOBWjpJwKaMaWjn7KbR4C/LuzqR
        F+eRTqn7WRZxkefbcjeeruTIMOHLKgmm5G/fGqkCWheZnZgSK6TMiNF9NXJZ42v/M9m18Z
        6aJeJBbLO9p1A0v8G7U5k/oQYKHXOfU=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     tytso@mit.edu, adilger.kernel@dilger.ca
Cc:     linux-ext4@vger.kernel.org
Subject: [PATCH] ext4: remove redundant checking in ext4_ioctl_checkpoint
Date:   Sun, 18 Sep 2022 19:52:19 +0800
Message-Id: <20220918115219.12407-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

It is already checked after comment "check for invalid bits set",
so let's remove this one.

Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
---
 fs/ext4/ioctl.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 3cf3ec4b1c21..80678af1fa7c 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1060,9 +1060,6 @@ static int ext4_ioctl_checkpoint(struct file *filp, unsigned long arg)
 	if (!EXT4_SB(sb)->s_journal)
 		return -ENODEV;
 
-	if (flags & ~EXT4_IOC_CHECKPOINT_FLAG_VALID)
-		return -EINVAL;
-
 	if ((flags & JBD2_JOURNAL_FLUSH_DISCARD) &&
 	    !bdev_max_discard_sectors(EXT4_SB(sb)->s_journal->j_dev))
 		return -EOPNOTSUPP;
-- 
2.31.1

