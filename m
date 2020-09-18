Return-Path: <SRS0=ab0F=C3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA9C0C43465
	for <linux-ext4@archiver.kernel.org>; Fri, 18 Sep 2020 03:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C880206B7
	for <linux-ext4@archiver.kernel.org>; Fri, 18 Sep 2020 03:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600398281;
	bh=aZQ8kblRrgrsA6AI6PIohMYUWXqq5h+dYDdP2IxiZTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=BrVyXZfISW8VVEZL+3CgEzkEg4jNQlG8ROX95e8e3CP/EIb0FNrUlQr9n3cJCsQvl
	 29xKs7zNsYbJU8Ksna4s1+UTvO8urkhjQ5YQMB+f8ePIt4I4QUKbZKmlomtht8KXK1
	 ghvzKwm83i2DOcPoZp7ShaY5Ihq9elqWgzNKre3M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbgIRDEh (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 17 Sep 2020 23:04:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbgIRCEq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 17 Sep 2020 22:04:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41D952388E;
        Fri, 18 Sep 2020 02:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394684;
        bh=aZQ8kblRrgrsA6AI6PIohMYUWXqq5h+dYDdP2IxiZTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a3xAekheiJBkJSIcSyuo1UG1E4WPR81rQIsoxdOxD9AOJvmC1PIbFQoapivpPDRs9
         hj2kMdESmuitt8MtcGjIS/5bEgjatH/ZIxrra5ZAbkkEB9Bsu3Sq/kIzq7H78gMa5e
         Mw9EZgG00Qf8qdYiTVid9icW0ikl4+aso0kME+yU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Monakhov <dmonakhov@gmail.com>,
        Andreas Dilger <adilger@dilger.ca>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 173/330] ext4: mark block bitmap corrupted when found instead of BUGON
Date:   Thu, 17 Sep 2020 21:58:33 -0400
Message-Id: <20200918020110.2063155-173-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
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
index e1782b2e2e2dd..e5d43d2ee474d 100644
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

