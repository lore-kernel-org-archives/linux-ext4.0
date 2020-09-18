Return-Path: <SRS0=ab0F=C3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83BECC43464
	for <linux-ext4@archiver.kernel.org>; Fri, 18 Sep 2020 02:45:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50C70214D8
	for <linux-ext4@archiver.kernel.org>; Fri, 18 Sep 2020 02:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600397143;
	bh=QJg12Q1/sQjz9SybGbCpVHykRlDULubY5Ryc9tLIlb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=UY0tvoRHuK7evEDlPYnMiz8MA3gIxtsvHRiR4Gya3DWaVr6N7mEEB860Q2HvpTqHm
	 6tE0UVYR56MXnsb4mLw9keyvuuVOroT0b1zU0/H+AFTOkxADlXZO0RrqOF3yAivnlB
	 6t+ybFUppWPLCmN2QYHLZ22ql54UpRBLRMcaoTZo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729199AbgIRCp1 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 17 Sep 2020 22:45:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727840AbgIRCKS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 17 Sep 2020 22:10:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9938D23A04;
        Fri, 18 Sep 2020 02:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395013;
        bh=QJg12Q1/sQjz9SybGbCpVHykRlDULubY5Ryc9tLIlb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=psm9Om7mn5GSA395SzzlTG3G/7i+NJYlAO7LAOhwFI5nLZe02ka90M5GwCWg7Ampq
         4wudrRfhs7UpzqQrQAaoSmsvLVIyaIGhQJcJhoje1/i/dlGaE0o8IuhGRmlMJJwjia
         gGHCvVxRHU+BkiMwKFrv/dCa8nyB+tXxyIjIZBag=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Monakhov <dmonakhov@gmail.com>,
        Andreas Dilger <adilger@dilger.ca>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 108/206] ext4: mark block bitmap corrupted when found instead of BUGON
Date:   Thu, 17 Sep 2020 22:06:24 -0400
Message-Id: <20200918020802.2065198-108-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Dmitry Monakhov <dmonakhov@gmail.com>

[ Upstream commit eb5760863fc28feab28b567ddcda7e667e638da0 ]

We already has similar code in ext4_mb_complex_scan_group(), but
ext4_mb_simple_scan_group() still affected.

Other reports: https://www.spinics.net/lists/linux-ext4/msg60231.html

Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: Dmitry Monakhov <dmonakhov@gmail.com>
Link: https://lore.kernel.org/r/20200310150156.641-1-dmonakhov@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 8dd54a8a03610..054cfdd007d69 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1901,8 +1901,15 @@ void ext4_mb_simple_scan_group(struct ext4_allocation_context *ac,
 		BUG_ON(buddy == NULL);
 
 		k = mb_find_next_zero_bit(buddy, max, 0);
-		BUG_ON(k >= max);
-
+		if (k >= max) {
+			ext4_grp_locked_error(ac->ac_sb, e4b->bd_group, 0, 0,
+				"%d free clusters of order %d. But found 0",
+				grp->bb_counters[i], i);
+			ext4_mark_group_bitmap_corrupted(ac->ac_sb,
+					 e4b->bd_group,
+					EXT4_GROUP_INFO_BBITMAP_CORRUPT);
+			break;
+		}
 		ac->ac_found++;
 
 		ac->ac_b_ex.fe_len = 1 << i;
-- 
2.25.1

