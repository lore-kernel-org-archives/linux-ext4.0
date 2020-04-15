Return-Path: <SRS0=naN3=57=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2625C2BB55
	for <linux-ext4@archiver.kernel.org>; Wed, 15 Apr 2020 12:14:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDC89206F9
	for <linux-ext4@archiver.kernel.org>; Wed, 15 Apr 2020 12:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586952893;
	bh=8cioEMxGlVBS2D5jBG2vIaBCCZ7jXNt/fTMNhmKQspw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=m75ZGe1dCW5BebQvg74IpGC5QIdnVkX6Sd5Tci2A3sNQBO0Q69JONsSbrCAhaCsA0
	 e3RmvBlcGtvqSVpCpg6PqBK0bbuOduzznxv9RxzsoHIZT2kooKBVfxwxniDC8DkLwa
	 a5M4Ii5QQI7YDckzGMyHUVmKyMaYoCwhxRYeO4ao=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368703AbgDOMOw (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 15 Apr 2020 08:14:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409294AbgDOLqj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 15 Apr 2020 07:46:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E59E520732;
        Wed, 15 Apr 2020 11:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951198;
        bh=8cioEMxGlVBS2D5jBG2vIaBCCZ7jXNt/fTMNhmKQspw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qxKzjTRRPKLdhXBmKe/Not9NrQR7PgjZMcu8liy402KA5UhKUdMJc5Iik51TbZSxo
         2lx2JEWv+HlbDbwVLuuDvU5HALM/8KjemT3WXURGlYZ2vwooaZiHZ3krvZHdnbuwXs
         C+ejGpZ9MVhA/yCjjNc6O6P12zdiJznDvABGbJfo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josh Triplett <josh@joshtriplett.org>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 13/40] ext4: fix incorrect group count in ext4_fill_super error message
Date:   Wed, 15 Apr 2020 07:45:56 -0400
Message-Id: <20200415114623.14972-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114623.14972-1-sashal@kernel.org>
References: <20200415114623.14972-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Josh Triplett <josh@joshtriplett.org>

[ Upstream commit df41460a21b06a76437af040d90ccee03888e8e5 ]

ext4_fill_super doublechecks the number of groups before mounting; if
that check fails, the resulting error message prints the group count
from the ext4_sb_info sbi, which hasn't been set yet. Print the freshly
computed group count instead (which at that point has just been computed
in "blocks_count").

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Fixes: 4ec1102813798 ("ext4: Add sanity checks for the superblock before mounting the filesystem")
Link: https://lore.kernel.org/r/8b957cd1513fcc4550fe675c10bcce2175c33a49.1585431964.git.josh@joshtriplett.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6e7f055af828c..3c2990116f8a6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4163,9 +4163,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 			EXT4_BLOCKS_PER_GROUP(sb) - 1);
 	do_div(blocks_count, EXT4_BLOCKS_PER_GROUP(sb));
 	if (blocks_count > ((uint64_t)1<<32) - EXT4_DESC_PER_BLOCK(sb)) {
-		ext4_msg(sb, KERN_WARNING, "groups count too large: %u "
+		ext4_msg(sb, KERN_WARNING, "groups count too large: %llu "
 		       "(block count %llu, first data block %u, "
-		       "blocks per group %lu)", sbi->s_groups_count,
+		       "blocks per group %lu)", blocks_count,
 		       ext4_blocks_count(es),
 		       le32_to_cpu(es->s_first_data_block),
 		       EXT4_BLOCKS_PER_GROUP(sb));
-- 
2.20.1

