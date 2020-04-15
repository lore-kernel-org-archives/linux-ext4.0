Return-Path: <SRS0=naN3=57=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31952C2BA19
	for <linux-ext4@archiver.kernel.org>; Wed, 15 Apr 2020 12:05:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 081FE206F9
	for <linux-ext4@archiver.kernel.org>; Wed, 15 Apr 2020 12:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586952352;
	bh=+KsFgRRbcx70Cyd3ib/fDZsP7Fe1mJWdVWiwh53kR7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=YM2Nf672Ft4050AluNws0lfCObD5e59JC3zsejtsK/gB+hWpxjuIC13UJAc9x0NAS
	 BZ/3Q1g31hYdtMzOb9tOKeOFvP3dvj/Tk7TUYpoRqJmLMisJESrVbnU2noExgWSXAG
	 xlRpfG5Q3lL1KwFoAfIkd/5zHKibdlki3EnnJ7rI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368392AbgDOMFt (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 15 Apr 2020 08:05:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406396AbgDOLrf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 15 Apr 2020 07:47:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 170EC21582;
        Wed, 15 Apr 2020 11:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951246;
        bh=+KsFgRRbcx70Cyd3ib/fDZsP7Fe1mJWdVWiwh53kR7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tIMVTpgImxCQyUb/PvkNFVvE7OWMEenWwpKbMJ/1bUh1VuQ3sACoBQZvuovEy48D4
         DSOAO6PJRDleELsljzxOyQ1RSk2KCintIBr5DTV88FiebxGRuFdkDBzLkl+yJSxuf5
         CyBnjBwhQByVL+0EeVurGw/aQuLpHD2MkIM250vI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josh Triplett <josh@joshtriplett.org>,
        Andreas Dilger <adilger@dilger.ca>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 13/30] ext4: fix incorrect inodes per group in error message
Date:   Wed, 15 Apr 2020 07:46:54 -0400
Message-Id: <20200415114711.15381-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114711.15381-1-sashal@kernel.org>
References: <20200415114711.15381-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Josh Triplett <josh@joshtriplett.org>

[ Upstream commit b9c538da4e52a7b79dfcf4cfa487c46125066dfb ]

If ext4_fill_super detects an invalid number of inodes per group, the
resulting error message printed the number of blocks per group, rather
than the number of inodes per group. Fix it to print the correct value.

Fixes: cd6bb35bf7f6d ("ext4: use more strict checks for inodes_per_block on mount")
Link: https://lore.kernel.org/r/8be03355983a08e5d4eed480944613454d7e2550.1585434649.git.josh@joshtriplett.org
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 47cbd51111739..96696015e4ef3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3970,7 +3970,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if (sbi->s_inodes_per_group < sbi->s_inodes_per_block ||
 	    sbi->s_inodes_per_group > blocksize * 8) {
 		ext4_msg(sb, KERN_ERR, "invalid inodes per group: %lu\n",
-			 sbi->s_blocks_per_group);
+			 sbi->s_inodes_per_group);
 		goto failed_mount;
 	}
 	sbi->s_itb_per_group = sbi->s_inodes_per_group /
-- 
2.20.1

