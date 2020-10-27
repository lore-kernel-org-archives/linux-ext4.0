Return-Path: <SRS0=Q+OU=EC=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 176FFC5DF9E
	for <linux-ext4@archiver.kernel.org>; Tue, 27 Oct 2020 00:15:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6B6220754
	for <linux-ext4@archiver.kernel.org>; Tue, 27 Oct 2020 00:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603757752;
	bh=xadHOvUM6AV7MwITR3FveOrcKHcXyN6POTwTa7wG0IM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=g2bEA2Oo3HRp0HuZ9ngvciue+t+W/fkfNOa/LBUfTjweWyx4hi7r9c1lragq58dVA
	 0p+jXw4NKMwb2r+fxWXBhTizQyZv9VU8fUdWP+EynOqnP2RanztXHEPakE4YhmEbYk
	 yDAVoOaEz6KXuAjwcU/ilqk/0/mhrmIi6uBB0STg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440506AbgJ0APu (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 26 Oct 2020 20:15:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411700AbgJ0ALO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 26 Oct 2020 20:11:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EE502087C;
        Tue, 27 Oct 2020 00:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603757474;
        bh=xadHOvUM6AV7MwITR3FveOrcKHcXyN6POTwTa7wG0IM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fr3eiYBt5cpMotXr+fiCLIVQqoOxLjnrL2Ye6JZowfgOYDFTsqtWeZuc/1jeT5KCI
         XSR/TSy7Hltxcf/iq1BErOigTBre6roEEUfQY1cLJ4rhIoPvb3zBFmf4IqH3JYNY12
         nqDDY4xCT0EZPIBhsvEjYqb1Kan0y+VHHt00riHQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 25/30] ext4: Detect already used quota file early
Date:   Mon, 26 Oct 2020 20:10:39 -0400
Message-Id: <20201027001044.1027349-25-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201027001044.1027349-1-sashal@kernel.org>
References: <20201027001044.1027349-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit e0770e91424f694b461141cbc99adf6b23006b60 ]

When we try to use file already used as a quota file again (for the same
or different quota type), strange things can happen. At the very least
lockdep annotations may be wrong but also inode flags may be wrongly set
/ reset. When the file is used for two quota types at once we can even
corrupt the file and likely crash the kernel. Catch all these cases by
checking whether passed file is already used as quota file and bail
early in that case.

This fixes occasional generic/219 failure due to lockdep complaint.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Reported-by: Ritesh Harjani <riteshh@linux.ibm.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20201015110330.28716-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 472fa29c6f604..2527eb3049494 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5412,6 +5412,11 @@ static int ext4_quota_on(struct super_block *sb, int type, int format_id,
 	/* Quotafile not on the same filesystem? */
 	if (path->dentry->d_sb != sb)
 		return -EXDEV;
+
+	/* Quota already enabled for this file? */
+	if (IS_NOQUOTA(d_inode(path->dentry)))
+		return -EBUSY;
+
 	/* Journaling quota? */
 	if (EXT4_SB(sb)->s_qf_names[type]) {
 		/* Quotafile not in fs root? */
-- 
2.25.1

